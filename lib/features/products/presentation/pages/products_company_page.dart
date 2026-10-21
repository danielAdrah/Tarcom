import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/routes/nav_paths.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/company_entity.dart';
import '../bloc/bloc/get_companies_bloc.dart';
import '../widgets/company_cell.dart';
import '../widgets/company_shimmer_cell.dart';
import 'products_page.dart';

class ProductsCompanyPage extends StatelessWidget {
  const ProductsCompanyPage({
    super.key,
    this.category,
    this.categoryTitle,
    this.categoryInternalName,
  });

  /// الفئة المختارة، وتُمرَّر كمعامل `category` في طلب الشركات.
  final CategoryEntity? category;

  /// بديل عند تمرير اسم الفئة فقط (من شريط الفئات في الصفحة الرئيسية).
  final String? categoryTitle;

  /// الاسم الداخلي للفئة، يُستخدم لفلترة الشركات عبر `category_internal_name`.
  final String? categoryInternalName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_)
          => sl<GetCompaniesBloc>()
            ..add(
              GetCompaniesRequested(
                categoryId: category?.id,
                categoryInternalName: categoryInternalName,
              ),
            ),
      child: _ProductsCompanyView(
        category: category,
        categoryTitle: categoryTitle,
        categoryInternalName: categoryInternalName,
      ),
    );
  }
}

/// معطيات التنقل إلى صفحة الشركات عندما تُمرَّر الفئة بالاسم الداخلي فقط
/// (مثل اختصارات الوصول السريع في الصفحة الرئيسية).
class ProductsCompanyArgs {
  const ProductsCompanyArgs({
    this.categoryTitle,
    this.categoryInternalName,
  });

  /// اسم العرض للفئة.
  final String? categoryTitle;

  /// الاسم الداخلي للفئة المستخدم لجلب الشركات.
  final String? categoryInternalName;
}

class _ProductsCompanyView extends StatelessWidget {
  const _ProductsCompanyView({
    this.category,
    this.categoryTitle,
    this.categoryInternalName,
  });

  final CategoryEntity? category;
  final String? categoryTitle;
  final String? categoryInternalName;

  String get _categoryName {
    if (category != null) {
      return category!.nameAr.isNotEmpty ? category!.nameAr : category!.name;
    }
    return categoryTitle ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<GetCompaniesBloc>().add(
              GetCompaniesRefreshRequested(
                categoryId: category?.id,
                categoryInternalName: categoryInternalName,
              ),
            );
          },
          child: FadeInUp(
            delay: const Duration(milliseconds: 400),
            child: CustomScrollView(
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
                    'الشركات المتاحة',
                    style: textTheme.titleLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  centerTitle: true,
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 18.h),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            blurRadius: 18.r,
                            offset: Offset(0, 8.h),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'اختَر الشركة التي تناسبك',
                                  textDirection: TextDirection.rtl,
                                  style: textTheme.headlineSmall?.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  _categoryName.isEmpty
                                      ? 'تقنية موثوقة تناسب يومك'
                                      : _categoryName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
                  ),
                ),

                // Companies: Loading / Success / Failure / Empty
                BlocBuilder<GetCompaniesBloc, GetCompaniesState>(
                  builder: (context, state) {
                    if (state is GetCompaniesInitial ||
                        state is GetCompaniesLoading) {
                      return _buildLoadingGrid();
                    }

                    if (state is GetCompaniesFailure) {
                      return _buildFailure(context, state.message);
                    }

                    if (state is GetCompaniesSuccess) {
                      final companies = state.companies;

                      if (companies.isEmpty) {
                        return _buildEmptyState();
                      }

                      return _buildCompaniesGrid(companies);
                    }

                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  },
                ),
              ],
            ),
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
        itemBuilder: (_, _) => const CompanyShimmerCell(),
      ),
    );
  }

  Widget _buildCompaniesGrid(List<CompanyEntity> companies) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 20.r),
      sliver: SliverGrid.builder(
        itemCount: companies.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 15.h,
          crossAxisSpacing: 15.w,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final company = companies[index];

          return CompanyCell(
            company: company,
            onTap: () {
              context.push(
                NavPaths.withinBranch(context, NavPaths.products),
                extra: ProductsPageArgs(
                  categoryId: category?.id,
                  categoryName: _categoryName,
                  companyId: company.id,
                  companyName: company.name,
                ),
              );
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
                'تعذّر تحميل الشركات',
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
                  context.read<GetCompaniesBloc>().add(
                    GetCompaniesRequested(
                      categoryId: category?.id,
                      categoryInternalName: categoryInternalName,
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
                Icons.business_outlined,
                size: 100.w,
                color: AppColors.primary,
              ),
              SizedBox(height: 16.h),
              Text(
                'لا توجد شركات متاحة حالياً',
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
