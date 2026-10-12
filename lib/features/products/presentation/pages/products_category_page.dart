import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/category_entity.dart';

import '../bloc/bloc/get_categories_bloc.dart';
import '../widgets/category_cell.dart';
import '../widgets/category_shimmer_cell.dart';

class ProductsCategoryPage extends StatelessWidget {
  const ProductsCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<GetCategoriesBloc>()..add(const GetCategoriesRequested()),
      child: const _ProductsCategoryView(),
    );
  }
}

class _ProductsCategoryView extends StatelessWidget {
  const _ProductsCategoryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FadeInUp(
          delay: const Duration(milliseconds: 300),
          child: CustomScrollView(
            slivers: [
              // Banner
              SliverAppBar(
                automaticallyImplyLeading: false,
                stretch: true,
                expandedHeight: 200.h,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: ZoomIn(
                    delay: const Duration(milliseconds: 350),
                    child: Image.asset(
                      'assets/img/products_banner.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // Categories: Loading / Success / Failure
              BlocBuilder<GetCategoriesBloc, GetCategoriesState>(
                builder: (context, state) {
                  if (state is GetCategoriesInitial ||
                      state is GetCategoriesLoading) {
                    return _buildLoadingGrid();
                  }

                  if (state is GetCategoriesFailure) {
                    return _buildFailure(context, state.message);
                  }

                  if (state is GetCategoriesSuccess) {
                    final categories = state.response.results;

                    if (categories.isEmpty) {
                      return _buildEmptyState();
                    }

                    return _buildCategoriesGrid(categories);
                  }

                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
            ],
          ),
        ),
      ),
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
          childAspectRatio: 1,
        ),
        itemBuilder: (_, _) => const CategoryShimmerCell(),
      ),
    );
  }

  Widget _buildCategoriesGrid(List<CategoryEntity> categories) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 20.r),
      sliver: SliverGrid.builder(
        itemCount: categories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 15.h,
          crossAxisSpacing: 15.w,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final category = categories[index];

          return CategoryCell(
            category: category,
            onTap: () {
              //we need to change the product company page later so it takes the category object not just a string
              context.pushNamed('productsCompanyPage', extra: category);
            },
          );
        },
      ),
    );
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
                'تعذّر تحميل الفئات',
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
                  context.read<GetCategoriesBloc>().add(
                    const GetCategoriesRequested(),
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
                Icons.category_outlined,
                size: 100.w,
                color: AppColors.primary,
              ),
              SizedBox(height: 16.h),
              Text(
                'لا توجد فئات متاحة حالياً',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 19.sp),
                // style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
