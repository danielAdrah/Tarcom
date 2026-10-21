import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/custom_indecator.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/routes/nav_paths.dart';
import '../../../favorites/presentation/bloc/favorites/favorites_bloc.dart';
import '../../../products/domain/entities/material_entity.dart';
import '../../../products/presentation/bloc/bloc/get_materials_bloc.dart';
import '../../../products/presentation/pages/product_details_page.dart';
import '../../../products/presentation/widgets/product_cell.dart';
import '../../../products/presentation/widgets/product_shimmer_cell.dart';

/// صفحة نتائج البحث الكاملة (المسار المختصر عند الضغط على Enter أو "عرض الكل").
///
/// تعرض كل المنتجات النشطة المطابقة لـ [query] عبر [GetMaterialsBloc] القائم
/// (بدون فلترة فئة/شركة)، مع بحث تصفّحي وتحميل غير منتهي ومفضّلة، وتفتح
/// التفاصيل عند الضغط على أي منتج.
class SearchResultsPage extends StatelessWidget {
  const SearchResultsPage({super.key, required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    // [FavoritesBloc] مشترك على مستوى الـ shell (انظر `route_main.dart`)،
    // فنتفادى إنشاء نسخة محلية هنا لتبقى حالة القلب متزامنة مع بقية الصفحات.
    return BlocProvider(
      create: (_) => sl<GetMaterialsBloc>()
        ..add(
          GetMaterialsRequested(
            isActive: true,
            search: query,
            ordering: '-created_at',
          ),
        ),
      child: _SearchResultsView(query: query),
    );
  }
}

class _SearchResultsView extends StatefulWidget {
  const _SearchResultsView({required this.query});

  final String query;

  @override
  State<_SearchResultsView> createState() => _SearchResultsViewState();
}

class _SearchResultsViewState extends State<_SearchResultsView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.query;
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

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

  void _onSearchChanged(String term) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      context.read<GetMaterialsBloc>().add(
        GetMaterialsRequested(
          isActive: true,
          search: term.trim(),
          ordering: '-created_at',
        ),
      );
    });
  }

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
                          onPressed: () => context.pop(),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          color: AppColors.primary,
                          iconSize: 19.r,
                        ),
                      ),
                    ),
                    title: Text(
                      'نتائج البحث',
                      style: textTheme.titleLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    centerTitle: true,
                  ),

                  // شريط البحث القابل للتعديل + عدّاد النتائج.
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 12.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
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
                          SizedBox(height: 14.h),
                          Row(
                            textDirection: TextDirection.rtl,
                            children: [
                              Expanded(
                                child: Text(
                                  'النتائج',
                                  style: textTheme.headlineSmall?.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
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

  SliverGridDelegate _gridDelegate() =>
      SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 0.64,
      );

  Widget _buildLoading() {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 8.h),
      sliver: SliverGrid(
        gridDelegate: _gridDelegate(),
        delegate: SliverChildBuilderDelegate(
          (context, index) => const ProductShimmerCell(),
          childCount: 6,
        ),
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
            gridDelegate: _gridDelegate(),
            delegate: SliverChildBuilderDelegate((context, index) {
              return _ResultCell(material: state.materials[index]);
            }, childCount: state.materials.length),
          ),
        ),
        _buildFooter(context, state),
        SliverToBoxAdapter(child: SizedBox(height: 28.h)),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, GetMaterialsSuccess state) {
    if (state.isLoadingMore) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: const Center(child: CustomIndecator(size: 26)),
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
                onPressed: () => context.read<GetMaterialsBloc>().add(
                  const GetMaterialsLoadMoreRequested(),
                ),
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
                'تعذّر تحميل النتائج',
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
                onPressed: () => context.read<GetMaterialsBloc>().add(
                  GetMaterialsRequested(
                    isActive: true,
                    search: _searchController.text.trim(),
                    ordering: '-created_at',
                  ),
                ),
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
                Icons.search_off_rounded,
                size: 80.w,
                color: AppColors.primary,
              ),
              SizedBox(height: 16.h),
              Text(
                'لا توجد منتجات مطابقة لبحثك',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// خلية نتيجة بحث مع مفضّلة، تعزل اشتراك [FavoritesBloc] داخل `build` الخاص بها
/// (لأن أبناء الـ Sliver يُنشَؤون أثناء الـ layout).
class _ResultCell extends StatelessWidget {
  const _ResultCell({required this.material});

  final MaterialEntity material;

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.select<FavoritesBloc, bool>(
      (bloc) =>
          bloc.state is FavoritesSuccess &&
          (bloc.state as FavoritesSuccess).isFavorite(material.id),
    );
    final isFavoriteLoading = context.select<FavoritesBloc, bool>(
      (bloc) =>
          bloc.state is FavoritesSuccess &&
          (bloc.state as FavoritesSuccess).isToggling(material.id),
    );

    return ProductCell(
      onTap: () => context.push(
        NavPaths.withinBranch(context, NavPaths.details),
        extra: ProductDetailsArgs(
          name: material.displayTitle,
          price: material.consumerPriceLabel,
          image: material.image ?? '',
          desc: material.displayDescription,
          category: material.categoryName,
          materialId: material.id,
          specifications: material.specifications,
        ),
      ),
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
