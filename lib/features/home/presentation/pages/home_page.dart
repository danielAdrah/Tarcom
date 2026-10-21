import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/routes/nav_paths.dart';
import '../../../../core/di/injection_container.dart';
import '../../../profile/presentation/bloc/get_user_profile/get_user_profile_bloc.dart';
import '../../../products/presentation/pages/product_details_page.dart';
import '../../../products/presentation/pages/products_company_page.dart';
import '../../domain/entities/featured_material_entity.dart';
import '../../../search/presentation/cubit/search_cubit.dart';
import '../../../search/presentation/widgets/home_search_bar.dart';
import '../bloc/get_banners/get_banners_bloc.dart';
import '../bloc/get_featured_materials/get_featured_materials_bloc.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/category_label.dart';
import '../widgets/featured_products_card.dart';
import '../widgets/featured_product_shimmer_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              sl<GetFeaturedMaterialsBloc>()
                ..add(const GetFeaturedMaterialsRequested(pageSize: 2)),
        ),
        BlocProvider(
          create: (_) => sl<GetBannersBloc>()..add(const GetBannersRequested()),
        ),
        BlocProvider(create: (_) => sl<SearchCubit>()),
        BlocProvider(
          create: (_) =>
              sl<GetUserProfileBloc>()..add(const GetUserProfileRequested()),
        ),
      ],
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

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
                            // اسم المستخدم من BLoC الملف الشخصي (مع shimmer أثناء التحميل)
                            BlocBuilder<
                              GetUserProfileBloc,
                              GetUserProfileState
                            >(
                              builder: (context, state) {
                                if (state is GetUserProfileInitial ||
                                    state is GetUserProfileLoading) {
                                  return const _WelcomeNameShimmer();
                                }
                                final name = state is GetUserProfileSuccess
                                    ? state.userProfile.firstName.trim()
                                    : '';
                                return Text(
                                  name.isEmpty ? 'مرحبا 👋' : 'مرحبا $name 👋',
                                  style: textTheme.titleLarge,
                                );
                              },
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              "اكتشف أفضل المنتجات",
                              style: textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      //profile
                      FadeInLeft(
                        delay: Duration(milliseconds: 500),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                context.push(
                                  NavPaths.withinBranch(
                                    context,
                                    NavPaths.userProfile,
                                  ),
                                );
                              },
                              customBorder: const CircleBorder(),
                              child: Padding(
                                padding: EdgeInsets.all(4.r),
                                child: Container(
                                  width: 46.w,
                                  height: 46.w,
                                  padding: EdgeInsets.all(2.5.r),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF6EC1F5),
                                        Color.fromARGB(255, 70, 148, 218),
                                        Color(0xFF2F6FB0),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                          255,
                                          70,
                                          148,
                                          218,
                                        ).withValues(alpha: 0.35),
                                        blurRadius: 10,
                                        spreadRadius: 0.5,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(3.r),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/img/user.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
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
                  child: const HomeSearchBar(),
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
                        // onTap: () {
                        //   context.pushNamed(
                        //     'productsCompanyPage',
                        //     extra: 'لابتوبات',
                        //   );
                        // },
                        onTap: () {
                          context.push(
                            NavPaths.withinBranch(
                              context,
                              NavPaths.companies,
                            ),
                            extra: const ProductsCompanyArgs(
                              categoryTitle: 'لابتوبات',
                              categoryInternalName: 'laptops',
                            ),
                          );
                        },
                        label: 'لابتوبات',
                        img: 'assets/img/laptop.png',
                      ),
                      CategoryLabel(
                        onTap: () {
                          context.push(
                            NavPaths.withinBranch(
                              context,
                              NavPaths.companies,
                            ),
                            extra: const ProductsCompanyArgs(
                              categoryTitle: 'بطاريات',
                              categoryInternalName: 'batteries',
                            ),
                          );
                        },
                        label: 'بطاريات',
                        img: 'assets/img/battery.png',
                      ),
                      CategoryLabel(
                        onTap: () {
                          context.push(
                            NavPaths.withinBranch(
                              context,
                              NavPaths.companies,
                            ),
                            extra: const ProductsCompanyArgs(
                              categoryTitle: 'ألواح شمسية',
                              categoryInternalName: 'solar_boards',
                            ),
                          );
                        },
                        label: 'ألواح شمسية',
                        img: 'assets/img/solar-system.png',
                      ),
                      CategoryLabel(
                        onTap: () {
                          context.push(
                            NavPaths.withinBranch(
                              context,
                              NavPaths.companies,
                            ),
                            extra: const ProductsCompanyArgs(
                              categoryTitle: 'كابلات',
                              categoryInternalName: 'cables',
                            ),
                          );
                        },
                        label: 'كابلات',
                        img: 'assets/img/usb-connector.png',
                      ),
                      CategoryLabel(
                        onTap: () {
                          context.push(
                            NavPaths.withinBranch(
                              context,
                              NavPaths.companies,
                            ),
                            extra: const ProductsCompanyArgs(
                              categoryTitle: 'أدوات منزلية',
                              categoryInternalName: 'home_tech',
                            ),
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
                  padding: EdgeInsets.fromLTRB(4.r, 20.h, 4.r, 20.h),
                  child: BannerCarousel(height: 180.h),
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
                          context.push(
                            NavPaths.withinBranch(context, NavPaths.featured),
                          );
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
              context.push(
                NavPaths.withinBranch(context, NavPaths.details),
                extra: ProductDetailsArgs(
                  name: material.name,
                  price: material.consumerPriceLabel,
                  image: material.image ?? '',
                  desc: material.description,
                  category: material.categoryName,
                  materialId: material.id,
                  specifications: material.specifications,
                ),
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

/// هيكل shimmer للاسم أثناء تحميل الملف الشخصي،
/// بمقاس مطابق لسطر الترحيب (titleLarge) لتفادي القفزة عند ظهور الاسم.
class _WelcomeNameShimmer extends StatelessWidget {
  const _WelcomeNameShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.skeletonBase,
      highlightColor: AppColors.skeletonHighlight,
      child: Container(
        width: 150.w,
        height: 24.h,
        decoration: BoxDecoration(
          color: AppColors.skeletonBase,
          borderRadius: BorderRadius.circular(6.r),
        ),
      ),
    );
  }
}
