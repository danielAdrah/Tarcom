import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../products/presentation/pages/product_details_page.dart';
import '../bloc/get_featured_materials/get_featured_materials_bloc.dart';
import '../widgets/featured_products_card.dart';
import '../widgets/featured_product_shimmer_card.dart';

class FeaturedProductsPage extends StatelessWidget {
  const FeaturedProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<GetFeaturedMaterialsBloc>()
            ..add(const GetFeaturedMaterialsRequested()),
      child: const _FeaturedProductsView(),
    );
  }
}

class _FeaturedProductsView extends StatefulWidget {
  const _FeaturedProductsView();

  @override
  State<_FeaturedProductsView> createState() => _FeaturedProductsViewState();
}

class _FeaturedProductsViewState extends State<_FeaturedProductsView> {
  final ScrollController _scrollController = ScrollController();

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
    super.dispose();
  }

  // التحميل غير المنتهي: عند الاقتراب من نهاية القائمة نجلب الصفحة التالية.
  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (maxScroll - currentScroll <= 240.h) {
      context.read<GetFeaturedMaterialsBloc>().add(
        const GetFeaturedMaterialsLoadMoreRequested(),
      );
    }
  }

  // السحب للتحديث: ننتهي من المؤشر عند انتهاء حالة التحميل.
  Future<void> _onRefresh() async {
    final bloc = context.read<GetFeaturedMaterialsBloc>();
    final completer = Completer<void>();

    final subscription = bloc.stream.listen((state) {
      if (state is! GetFeaturedMaterialsLoading && !completer.isCompleted) {
        completer.complete();
      }
    });

    bloc.add(const GetFeaturedMaterialsRefreshRequested());

    // فترة أطول قليلاً لإظهار مؤشر التحديث بشكل مريح.
    await Future.delayed(const Duration(milliseconds: 600));
    await completer.future.timeout(
      const Duration(seconds: 30),
      onTimeout: () {},
    );
    await subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: AppColors.primary,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [_buildHeader(context), _buildBody(context)],
          ),
        ),
      ),
    );
  }

  //==-=-=-=-=-=-=-=-=-=-==
  // Gradient header
  //==-=-=-=-=-=-=-=-=-=-==

  Widget _buildHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SliverAppBar(
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          color: Colors.white,
          size: 24.w,
        ),
      ),
      centerTitle: true,
      pinned: true,
      stretch: true,
      expandedHeight: 190.h,
      backgroundColor: AppColors.primary,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: FadeInDown(
          delay: const Duration(milliseconds: 200),
          child: Text(
            'المنتجات المميزة',
            style: textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        titlePadding: EdgeInsetsDirectional.only(start: 56.w, bottom: 16.h),
        background: Stack(
          fit: StackFit.expand,
          children: [
            // تدرّج لوني متوافق مع هوية التطبيق
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [AppColors.blue700, AppColors.blue500],
                ),
              ),
            ),
            // دوائر زخرفية شفافة
            PositionedDirectional(
              top: -30.h,
              start: -30.w,
              child: _DecoCircle(size: 130, opacity: 0.10),
            ),
            PositionedDirectional(
              bottom: -45.h,
              end: -25.w,
              child: _DecoCircle(size: 160, opacity: 0.08),
            ),
            PositionedDirectional(
              top: 40.h,
              end: 60.w,
              child: _DecoCircle(size: 60, opacity: 0.12),
            ),
            // عنوان القسم داخل المساحة الموسّعة
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FadeInRight(
                      delay: const Duration(milliseconds: 300),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.workspace_premium_rounded,
                            color: AppColors.orange400,
                            size: 30.w,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'تشكيلة مختارة بعناية',
                            textDirection: TextDirection.rtl,
                            style: textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 6.h),
                    // شارة عدد المنتجات تظهر بعد النجاح
                    BlocBuilder<
                      GetFeaturedMaterialsBloc,
                      GetFeaturedMaterialsState
                    >(
                      builder: (context, state) {
                        if (state is! GetFeaturedMaterialsSuccess) {
                          return const SizedBox.shrink();
                        }

                        return FadeInUp(
                          delay: const Duration(milliseconds: 450),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.25),
                              ),
                            ),
                            child: Text(
                              '${state.count} منتج مميز',
                              textDirection: TextDirection.rtl,
                              style: textTheme.labelMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //==-=-=-=-=-=-=-=-=-=-==
  // Body: Loading / Failure / Success (+ infinite scroll footer)
  //==-=-=-=-=-=-=-=-=-=-==

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<GetFeaturedMaterialsBloc, GetFeaturedMaterialsState>(
      builder: (context, state) {
        if (state is GetFeaturedMaterialsInitial ||
            state is GetFeaturedMaterialsLoading) {
          return _buildLoadingGrid();
        }

        if (state is GetFeaturedMaterialsFailure) {
          return _buildFailure(context, state.message);
        }

        if (state is GetFeaturedMaterialsSuccess) {
          if (state.materials.isEmpty) {
            return _buildEmpty(context);
          }

          return _buildMaterialsSlivers(context, state);
        }

        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }

  Widget _buildLoadingGrid() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 20.r),
      sliver: SliverGrid.builder(
        itemCount: 6,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 15.h,
          crossAxisSpacing: 15.w,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (_, _) => const FeaturedProductShimmerCard(),
      ),
    );
  }

  Widget _buildMaterialsSlivers(
    BuildContext context,
    GetFeaturedMaterialsSuccess state,
  ) {
    return SliverMainAxisGroup(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 20.r),
          sliver: SliverGrid.builder(
            itemCount: state.materials.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 15.h,
              crossAxisSpacing: 15.w,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              final material = state.materials[index];

              return FadeInUp(
                // حركة دخول متدرجة للدفعات الأخيرة أثناء التحميل المستمر
                delay: Duration(
                  milliseconds: 90 * (index % 10) + (index >= 10 ? 600 : 0),
                ),
                child: FeaturedProCard(
                  material: material,
                  onTap: () {
                    context.pushNamed(
                      'productDetailsPage',
                      extra: ProductDetailsArgs(
                        name: material.name,
                        price: material.consumerPriceLabel,
                        image: material.image ?? '',
                        desc: material.description,
                        category: material.categoryName,
                        specifications: material.specifications,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        _buildFooter(context, state),
        SliverToBoxAdapter(child: SizedBox(height: 30.h)),
      ],
    );
  }

  // التذييل: تحميل أكثر / خطأ عند جلب المزيد / نهاية القائمة
  Widget _buildFooter(BuildContext context, GetFeaturedMaterialsSuccess state) {
    if (state.isLoadingMore) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: const Center(
            child: SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      );
    }

    if (state.loadMoreError != null) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 8.h),
          child: Column(
            children: [
              Text(
                state.loadMoreError!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              SizedBox(height: 8.h),
              OutlinedButton.icon(
                onPressed: () {
                  context.read<GetFeaturedMaterialsBloc>().add(
                    const GetFeaturedMaterialsLoadMoreRequested(),
                  );
                },
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('محاولة مرة أخرى'),
              ),
            ],
          ),
        ),
      );
    }

    if (!state.hasMore && state.materials.isNotEmpty) {
      return SliverToBoxAdapter(
        child: FadeInUp(
          delay: const Duration(milliseconds: 300),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  size: 16.w,
                  color: AppColors.secondary,
                ),
                SizedBox(width: 6.w),
                Text(
                  'لقد وصلت إلى نهاية القائمة',
                  textDirection: TextDirection.rtl,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(width: 6.w),
                Icon(
                  Icons.auto_awesome_rounded,
                  size: 16.w,
                  color: AppColors.secondary,
                ),
              ],
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
              ZoomIn(
                child: Icon(
                  Icons.cloud_off_rounded,
                  size: 64.w,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'تعذّر تحميل المنتجات المميزة',
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
                  context.read<GetFeaturedMaterialsBloc>().add(
                    const GetFeaturedMaterialsRequested(),
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

  Widget _buildEmpty(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: BounceIn(
            delay: const Duration(milliseconds: 200),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star_border_rounded,
                  size: 72.w,
                  color: AppColors.primary,
                ),
                SizedBox(height: 16.h),
                Text(
                  'لا توجد منتجات مميزة حالياً',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 8.h),
                Text(
                  'تصفّح أقسام المنتجات أو اسحب للتحديث لاحقاً',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// دائرة زخرفية شبه شفافة لخلفية الهيدر.
class _DecoCircle extends StatelessWidget {
  const _DecoCircle({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacity),
      ),
    );
  }
}
