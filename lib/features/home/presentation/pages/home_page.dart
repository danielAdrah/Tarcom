import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/featured_material_entity.dart';
import '../bloc/get_featured_materials/get_featured_materials_bloc.dart';
import '../widgets/category_label.dart';
import '../widgets/featured_products_card.dart';
import '../widgets/featured_product_shimmer_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<GetFeaturedMaterialsBloc>()
            ..add(const GetFeaturedMaterialsRequested(pageSize: 2)),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  final String userName = "Daniel";

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            //App bar
            SliverAppBar(
              automaticallyImplyLeading: false,
              stretch: true,
              expandedHeight: 100.h,
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.r,
                    // vertical: 10.r,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //welcome text & name
                      FadeInRight(
                        delay: Duration(milliseconds: 500),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "مرحبا $userName 👋",
                              style: textTheme.titleLarge,
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              "اكتشف أفضل المنتجات",
                              style: textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      //profile and notifications icons
                      FadeInLeft(
                        delay: Duration(milliseconds: 500),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {},
                              child: Container(
                                padding: EdgeInsets.all(3.r),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                                child: Icon(
                                  Icons.notifications,
                                  size: 30.w,
                                  color: const Color.fromARGB(
                                    255,
                                    70,
                                    148,
                                    218,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 5.w),
                            InkWell(
                              onTap: () {},
                              child: Container(
                                padding: EdgeInsets.all(3.r),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                                child: Icon(
                                  Icons.person,
                                  size: 30.w,
                                  color: const Color.fromARGB(
                                    255,
                                    70,
                                    148,
                                    218,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            //search section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(15.r, 14.h, 15.r, 20.h),
                child: FadeInUp(
                  delay: Duration(milliseconds: 600),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(18.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.12),
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
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
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
                            color: AppColors.blue100.withValues(alpha: 0.7),
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
                ),
              ),
            ),

            //Categories Section
            SliverToBoxAdapter(
              child: FadeInUp(
                delay: Duration(milliseconds: 700),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Category Item
                      CategoryLabel(
                        onTap: () {
                          context.pushNamed(
                            'productsCompanyPage',
                            extra: 'لابتوبات',
                          );
                        },
                        label: 'لابتوبات',
                        img: 'assets/img/laptop.png',
                      ),
                      CategoryLabel(
                        onTap: () {
                          context.pushNamed(
                            'productsCompanyPage',
                            extra: 'بطاريات',
                          );
                        },
                        label: 'بطاريات',
                        img: 'assets/img/battery.png',
                      ),
                      CategoryLabel(
                        onTap: () {
                          context.pushNamed(
                            'productsCompanyPage',
                            extra: 'ألواح شمسية',
                          );
                        },
                        label: 'ألواح شمسية',
                        img: 'assets/img/solar-system.png',
                      ),
                      CategoryLabel(
                        onTap: () {
                          context.pushNamed(
                            'productsCompanyPage',
                            extra: 'أكبال',
                          );
                        },
                        label: 'أكبال',
                        img: 'assets/img/usb-connector.png',
                      ),
                      CategoryLabel(
                        onTap: () {
                          context.pushNamed(
                            'productsCompanyPage',
                            extra: 'أدوات منزلية',
                          );
                        },
                        label: 'أدوات منزلية',
                        img: 'assets/img/home.png',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            //banner section
            SliverToBoxAdapter(
              child: FadeInUp(
                delay: Duration(milliseconds: 800),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10.r, 20.h, 10.r, 20.h),
                  child: Container(
                    height: 220.h,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          blurRadius: 18.r,
                          offset: Offset(0, 7.h),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 4.r,
                          offset: Offset(0, 2.h),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(15.r),
                      image: const DecorationImage(
                        image: AssetImage('assets/img/homeBanner.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            //Featured products header
            SliverToBoxAdapter(
              child: FadeInUp(
                delay: Duration(milliseconds: 900),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15.r, 0, 15.r, 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'المنتجات المميزة',
                        style: textTheme.titleMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          context.pushNamed('featuredProductsPage');
                        },
                        icon: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20.w,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            //Featured products section: Loading / Success / Failure
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 15.r),
              sliver:
                  BlocBuilder<
                    GetFeaturedMaterialsBloc,
                    GetFeaturedMaterialsState
                  >(
                    builder: (context, state) {
                      if (state is GetFeaturedMaterialsInitial ||
                          state is GetFeaturedMaterialsLoading) {
                        return _buildFeaturedLoadingGrid();
                      }

                      if (state is GetFeaturedMaterialsFailure) {
                        return _buildFeaturedFailure(context, state.message);
                      }

                      if (state is GetFeaturedMaterialsSuccess) {
                        // عرض أول منتجين فقط في الرئيسية.
                        final materials = state.materials.take(2).toList();

                        if (materials.isEmpty) {
                          return _buildFeaturedEmpty(context);
                        }

                        return _buildFeaturedGrid(materials);
                      }

                      return const SliverToBoxAdapter(child: SizedBox.shrink());
                    },
                  ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 50.h)),
          ],
        ),
      ),
    );
  }

  //==-=-=-=-=-=-=-=-=-=-==
  // Featured products states
  //==-=-=-=-=-=-=-=-=-=-==

  Widget _buildFeaturedLoadingGrid() {
    return SliverGrid.builder(
      itemCount: 2,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 15.h,
        crossAxisSpacing: 15.w,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (_, _) => const FeaturedProductShimmerCard(),
    );
  }

  Widget _buildFeaturedGrid(List<FeaturedMaterialEntity> materials) {
    return SliverGrid.builder(
      itemCount: materials.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 15.h,
        crossAxisSpacing: 15.w,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        final material = materials[index];

        return FadeInUp(
          delay: Duration(milliseconds: 100 * (index + 1)),
          child: FeaturedProCard(
            material: material,
            onTap: () {
              context.pushNamed(
                'productDetailsPage',
                extra: material.specifications,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFeaturedFailure(BuildContext context, String message) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
        child: Column(
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 40.w,
              color: Theme.of(context).colorScheme.error,
            ),
            SizedBox(height: 10.h),
            Text(
              'تعذّر تحميل المنتجات المميزة',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(height: 6.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SizedBox(height: 12.h),
            FilledButton.icon(
              onPressed: () {
                context.read<GetFeaturedMaterialsBloc>().add(
                  const GetFeaturedMaterialsRequested(pageSize: 2),
                );
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedEmpty(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 24.h),
        child: Column(
          children: [
            Icon(
              Icons.star_border_rounded,
              size: 48.w,
              color: AppColors.primary,
            ),
            SizedBox(height: 10.h),
            Text(
              'لا توجد منتجات مميزة حالياً',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}
