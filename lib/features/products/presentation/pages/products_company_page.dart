import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarcom/core/routes/route_imports.dart';

import '../../../../core/constants/colors.dart';

class ProductsCompanyPage extends StatefulWidget {
  const ProductsCompanyPage({super.key, required this.catagoryTitle});

  final String catagoryTitle;

  @override
  State<ProductsCompanyPage> createState() => _ProductsCompanyPageState();
}

class _ProductsCompanyPageState extends State<ProductsCompanyPage> {
  final List<CategoryLabel> categories = [
    CategoryLabel(title: 'Marvel', img: 'assets/img/marlogo.png', count: '6'),
    CategoryLabel(title: 'lenovo', img: 'assets/img/lenlogo.png', count: '15'),
    CategoryLabel(title: 'lenovo', img: 'assets/img/lenlogo.png', count: '15'),
    CategoryLabel(title: 'lenovo', img: 'assets/img/lenlogo.png', count: '15'),
  ];
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: FadeInUp(
          delay: Duration(milliseconds: 400),
          child: CustomScrollView(
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
                                'تقنية موثوقة تناسب يومك',
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
              SliverPadding(
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
                    return CompanyCell(
                      onTap: () {
                        // context.pushNamed('productsCompanyPage');
                        context.pushNamed(
                          'productsPage',
                          extra: widget.catagoryTitle,
                        );
                      },
                      category: categories[index],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CompanyCell extends StatelessWidget {
  const CompanyCell({required this.category, this.onTap, super.key});

  final CategoryLabel category;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.06),
                blurRadius: 12.r,
                offset: Offset(0, 5.h),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: Image.asset(category.img, width: 140.w, height: 140.h),
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textDirection: TextDirection.rtl,
                          style: textTheme.titleSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '${category.count} منتج',
                          textDirection: TextDirection.rtl,
                          style: textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 30.w,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
