import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/custom_indecator.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../favorites/presentation/bloc/favorites/favorites_bloc.dart';
import '../../domain/entities/material_entity.dart';
import '../bloc/bloc/get_materials_bloc.dart';
import '../widgets/product_cell.dart';
import '../widgets/product_shimmer_cell.dart';
import 'product_details_page.dart';

/// بيانات صفحة المنتجات التي تمرَّر عبر الـ route extra من صفحة الشركات.
/// [categoryId] و[companyId] يُستخدمان لفلترة المواد من الـ API.
class ProductsPageArgs {
  const ProductsPageArgs({
    this.categoryId,
    this.categoryName = '',
    this.companyId,
    this.companyName,
  });

  final int? categoryId;
  final String categoryName;
  final int? companyId;
  final String? companyName;
}

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key, required this.args});

  final ProductsPageArgs args;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<GetMaterialsBloc>()
            ..add(
              GetMaterialsRequested(
                category: args.categoryId,
                company: args.companyId,
                companyName: args.companyName,
              ),
            ),
        ),
        // مفضّلات المستخدم: تُجلب عند فتح الصفحة لتعبئة معرّفات المفضلة،
        // فتظهر القلوب ممتلئة للمنتجات المحفوظة مسبقاً.
        BlocProvider(
          create: (_) => sl<FavoritesBloc>()..add(const FavoritesRequested()),
        ),
      ],
      child: _ProductsView(args: args),
    );
  }
}

class _ProductsView extends StatefulWidget {
  const _ProductsView({required this.args});

  final ProductsPageArgs args;

  @override
  State<_ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<_ProductsView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  String get _categoryName => widget.args.categoryName;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  // التحميل غير المنتهي: عند الاقتراب من نهاية القائمة نجلب الصفحة التالية.
  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (maxScroll - currentScroll <= 240.h) {
      context.read<GetMaterialsBloc>().add(
        const GetMaterialsLoadMoreRequested(),
      );
    }
  }

  // البحث: يعيد الطلب بنفس الفلاتر مع مصطلح البحث.
  void _onSearchChanged(String term) {
    final bloc = context.read<GetMaterialsBloc>();
    // إلغاء الطلبات القديمة عبر debounce بسيطة.
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      bloc.add(
        GetMaterialsRequested(
          category: widget.args.categoryId,
          company: widget.args.companyId,
          companyName: widget.args.companyName,
          search: term.trim(),
        ),
      );
    });
  }

  Timer? _debounce;

  // السحب للتحديث: ننتظر انتهاء حالة التحميل لإخفاء المؤشر.
  Future<void> _onRefresh() async {
    final bloc = context.read<GetMaterialsBloc>();
    final completer = Completer<void>();

    final subscription = bloc.stream.listen((state) {
      if (state is! GetMaterialsLoading && !completer.isCompleted) {
        completer.complete();
      }
    });

    bloc.add(const GetMaterialsRefreshRequested());

    await Future.delayed(const Duration(milliseconds: 600));
    await completer.future.timeout(
      const Duration(seconds: 30),
      onTimeout: () {},
    );
    await subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: BlocListener<FavoritesBloc, FavoritesState>(
          // نعرض رسالة لمرة واحدة عند تغيّرها فقط (نجاح/فشل التبديل).
          listenWhen: (previous, current) =>
              current is FavoritesSuccess &&
              previous is FavoritesSuccess &&
              (current.lastMessage != previous.lastMessage ||
                  current.lastError != previous.lastError),
          listener: (context, state) {
            final success = state as FavoritesSuccess;
            final message = success.lastError ?? success.lastMessage;
            if (message == null || message.isEmpty) return;

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: success.lastError != null
                      ? AppColors.error
                      : AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.all(12.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              );
          },
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            color: AppColors.primary,
            child: FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  //app bar with the title ,the cart and back button.
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    pinned: true,
                    toolbarHeight: 64.h,
                    backgroundColor: AppColors.background,
                    elevation: 0,
                    surfaceTintColor: Colors.transparent,
                    leading: Padding(
                      padding: EdgeInsetsDirectional.only(start: 16.w),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: IconButton(
                          onPressed: () {
                            context.pop();
                          },
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          color: AppColors.primary,
                          iconSize: 19.r,
                        ),
                      ),
                    ),
                    title: Text(
                      'منتجاتنا',
                      style: textTheme.titleLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    centerTitle: true,
                    actions: [
                      Padding(
                        padding: EdgeInsetsDirectional.only(end: 16.w),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: IconButton(
                            onPressed: () {
                              //maybe we will add a cart page.
                            },
                            icon: const Icon(Icons.shopping_bag_outlined),
                            color: AppColors.primary,
                            iconSize: 21.r,
                          ),
                        ),
                      ),
                    ],
                  ),

                  //blue section header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(
                              20.w,
                              18.h,
                              20.w,
                              18.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(24.r),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.2,
                                  ),
                                  blurRadius: 18.r,
                                  offset: Offset(0, 8.h),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'اختَر جهازك القادم',
                                        textDirection: TextDirection.rtl,
                                        style: textTheme.headlineSmall
                                            ?.copyWith(
                                              color: AppColors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        widget.args.companyName?.isNotEmpty ==
                                                true
                                            ? widget.args.companyName!
                                            : 'تقنية موثوقة تناسب يومك',
                                        textDirection: TextDirection.rtl,
                                        style: textTheme.bodySmall?.copyWith(
                                          color: AppColors.blue100,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 52.r,
                                  height: 52.r,
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                    borderRadius: BorderRadius.circular(18.r),
                                  ),
                                  child: Icon(
                                    Icons.devices_other_rounded,
                                    color: AppColors.white,
                                    size: 28.r,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 18.h),

                          //search field
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(18.r),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.12,
                                  ),
                                  blurRadius: 18.r,
                                  offset: Offset(0, 7.h),
                                ),
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 4.r,
                                  offset: Offset(0, 2.h),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _searchController,
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                              textInputAction: TextInputAction.search,
                              onChanged: _onSearchChanged,
                              onSubmitted: _onSearchChanged,
                              style: textTheme.bodyMedium?.copyWith(
                                color: AppColors.textPrimary,
                              ),
                              decoration: InputDecoration(
                                hintText: 'ابحث عن منتج...',
                                hintStyle: textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                prefixIcon: Icon(
                                  Icons.search_rounded,
                                  size: 24.w,
                                  color: AppColors.primary,
                                ),
                                suffixIcon: ValueListenableBuilder(
                                  valueListenable: _searchController,
                                  builder: (context, value, _) {
                                    if (value.text.isEmpty) {
                                      return const SizedBox.shrink();
                                    }
                                    return IconButton(
                                      onPressed: () {
                                        _searchController.clear();
                                        _onSearchChanged('');
                                      },
                                      icon: const Icon(Icons.close_rounded),
                                      color: AppColors.textSecondary,
                                    );
                                  },
                                ),
                                filled: true,
                                fillColor: AppColors.surface,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 18.w,
                                  vertical: 16.h,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18.r),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18.r),
                                  borderSide: BorderSide(
                                    color: AppColors.blue100.withValues(
                                      alpha: 0.7,
                                    ),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18.r),
                                  borderSide: BorderSide(
                                    color: AppColors.primary,
                                    width: 1.4.w,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            textDirection: TextDirection.rtl,
                            children: [
                              Text(
                                //the name of the product category we selected.
                                _categoryName,
                                style: textTheme.headlineSmall?.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const Spacer(),
                              //the number of the products of this category.
                              BlocBuilder<GetMaterialsBloc, GetMaterialsState>(
                                builder: (context, state) {
                                  final count = state is GetMaterialsSuccess
                                      ? state.count
                                      : 0;
                                  return Text(
                                    '$count منتجات',
                                    style: textTheme.labelMedium?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                        ],
                      ),
                    ),
                  ),

                  //the actuall list of the materials from the BLoC.
                  BlocBuilder<GetMaterialsBloc, GetMaterialsState>(
                    builder: (context, state) {
                      if (state is GetMaterialsInitial ||
                          state is GetMaterialsLoading) {
                        return _buildLoading();
                      }

                      if (state is GetMaterialsFailure) {
                        return _buildFailure(context, state.message);
                      }

                      if (state is GetMaterialsSuccess) {
                        if (state.materials.isEmpty) {
                          return _buildEmptyState();
                        }
                        return _buildMaterialsSlivers(context, state);
                      }

                      return const SliverToBoxAdapter(child: SizedBox.shrink());
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //==-=-=-=-=-=-=-=-=-=-==
  // States
  //==-=-=-=-=-=-=-=-=-=-==

  // التحميل: شبكة هياكل shimmer مطابقة لشبكة المنتجات الحقيقية.
  Widget _buildLoading() {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 8.h),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14.h,
          crossAxisSpacing: 12.w,
          childAspectRatio: 0.64,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          return const ProductShimmerCell();
        }, childCount: 6),
      ),
    );
  }

  Widget _buildMaterialsSlivers(
    BuildContext context,
    GetMaterialsSuccess state,
  ) {
    return SliverMainAxisGroup(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 8.h),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14.h,
              crossAxisSpacing: 12.w,
              childAspectRatio: 0.64,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final material = state.materials[index];
              return _buildCell(material);
            }, childCount: state.materials.length),
          ),
        ),
        _buildFooter(context, state),
        SliverToBoxAdapter(child: SizedBox(height: 28.h)),
      ],
    );
  }

  Widget _buildCell(MaterialEntity material) {
    // نبني خلية المنتج كـ Widget مستقل، لأن أبناء الـ Sliver يُنشَؤون أثناء
    // مرحلة الـ layout حيث لا يُسمح بالاشتراك في Provider عبر `context.select`.
    // منطق الاشتراك يعيش داخل `build` الخاص بالخلدة أدناه.
    return _ProductCellWithFavorite(
      material: material,
      categoryNameFallback: _categoryName,
    );
  }

  // التذييل: تحميل أكثر / خطأ عند جلب المزيد / نهاية القائمة
  Widget _buildFooter(BuildContext context, GetMaterialsSuccess state) {
    if (state.isLoadingMore) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: const Center(
            child: CustomIndecator(size: 26),
            //  SizedBox(
            //   width: 26,
            //   height: 26,
            //   child: CircularProgressIndicator(
            //     strokeWidth: 2.5,
            //     color: AppColors.primary,
            //   ),
            // ),
          ),
        ),
      );
    }

    if (state.loadMoreError != null) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Column(
            children: [
              Text(
                state.loadMoreError!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(height: 8.h),
              TextButton.icon(
                onPressed: () {
                  context.read<GetMaterialsBloc>().add(
                    const GetMaterialsLoadMoreRequested(),
                  );
                },
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      );
    }

    if (!state.hasMore) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Center(
            child: Text(
              'نهاية القائمة',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ),
      );
    }

    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }

  Widget _buildFailure(BuildContext context, String message) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cloud_off_rounded,
                size: 52.w,
                color: Theme.of(context).colorScheme.error,
              ),
              SizedBox(height: 16.h),
              Text(
                'تعذّر تحميل المنتجات',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 8.h),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 20.h),
              FilledButton.icon(
                onPressed: () {
                  context.read<GetMaterialsBloc>().add(
                    GetMaterialsRequested(
                      category: widget.args.categoryId,
                      company: widget.args.companyId,
                      companyName: widget.args.companyName,
                      search: _searchController.text.trim(),
                    ),
                  );
                },
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 100.w,
                color: AppColors.primary,
              ),
              SizedBox(height: 16.h),
              Text(
                'لا توجد منتجات حالياً',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 19.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// خلية منتج تراقب حالة المفضلة/التبديل لها من [FavoritesBloc].
///
/// تُبقي استدعاءات `context.select` داخل `build` الخاص بها، لأن بناء أبناء
/// الـ Sliver يتم أثناء الـ layout حيث لا يُسمح بالاشتراك في Provider مباشرة.
class _ProductCellWithFavorite extends StatelessWidget {
  const _ProductCellWithFavorite({
    required this.material,
    required this.categoryNameFallback,
  });

  final MaterialEntity material;
  final String categoryNameFallback;

  @override
  Widget build(BuildContext context) {
    // حالة القلب لهذا المنتج فقط (تقليل إعادة البناء عبر الاشتراك الانتقائي).
    final isFavorite = context.select<FavoritesBloc, bool>((bloc) {
      final state = bloc.state;
      return state is FavoritesSuccess && state.isFavorite(material.id);
    });

    // هل هذا المنتج قيد طلب التبديل الآن؟ (لعرض مؤشر التحميل على القلب).
    final isFavoriteLoading = context.select<FavoritesBloc, bool>((bloc) {
      final state = bloc.state;
      return state is FavoritesSuccess && state.isToggling(material.id);
    });

    return ProductCell(
      onTap: () {
        context.pushNamed(
          'productDetailsPage',
          extra: ProductDetailsArgs(
            name: material.displayTitle,
            price: material.consumerPriceLabel,
            image: material.image ?? '',
            desc: material.displayDescription,
            category: material.categoryName.isNotEmpty
                ? material.categoryName
                : categoryNameFallback,
            specifications: material.specifications,
          ),
        );
      },
      // التبديل يرسل FavoriteToggled بمعرّف المادة؛ يحدّث الـ Bloc القلب حسب
      // `is_favourite` ويُظهر SnackBar عبر BlocListener (يتراجع Bloc عند الفشل).
      favToggle: () => context.read<FavoritesBloc>().add(
        FavoriteToggled(materialId: material.id),
      ),
      isFavorite: isFavorite,
      isFavoriteLoading: isFavoriteLoading,
      proTitle: material.displayTitle,
      proDesc: material.displayDescription,
      proImg: material.image ?? '',
      proPrice: material.consumerPriceLabel,
      isAvailable: material.isActive,
    );
  }
}
