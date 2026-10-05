import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/routes/route_imports.dart';
import '../widgets/product_cell.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key, required this.productsCatTitle});
  final String productsCatTitle;

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  // final List<String> _filters = ['الكل', 'الأكثر مبيعاً', 'الأحدث', 'العروض'];
  // int _selectedFilter = 0;
  final List<Map<String, String>> _dummyProducts = [
    {
      'title': 'Asus',
      'description': 'Tuf Gaming Core 5 16G Ram',
      'image': 'assets/img/p1.png',
    },
    {
      'title': 'Lenovo',
      'description': 'IdeaPad Slim 3 8G Ram',
      'image': 'assets/img/p1.png',
    },
    {
      'title': 'HP',
      'description': 'Victus Gaming 16G Ram',
      'image': 'assets/img/p1.png',
    },
    {
      'title': 'Dell',
      'description': 'Inspiron 15 Core i5',
      'image': 'assets/img/p1.png',
    },
    {
      'title': 'Acer',
      'description': 'Aspire 5 512G SSD',
      'image': 'assets/img/p1.png',
    },
    {
      'title': 'MSI',
      'description': 'Modern 14 Work Edition',
      'image': 'assets/img/p1.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: FadeInUp(
          delay: Duration(milliseconds: 400),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
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
                                    'اختَر جهازك القادم',
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

                      SizedBox(height: 18.h),

                      //search field
                      Container(
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
                      SizedBox(height: 20.h),
                      Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Text(
                            //the name of the product category we selected.
                            widget.productsCatTitle,
                            style: textTheme.headlineSmall?.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            //the number of the products of this category.
                            '${_dummyProducts.length} منتجات',
                            style: textTheme.labelMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      //maybe we will add a filter choice card.
                      // SizedBox(
                      //   height: 38.h,
                      //   child: ListView.separated(
                      //     scrollDirection: Axis.horizontal,
                      //     itemCount: _filters.length,
                      //     separatorBuilder: (_, index) => SizedBox(width: 8.w),
                      //     itemBuilder: (context, index) {
                      //       final isSelected = index == _selectedFilter;
                      //       return ChoiceChip(
                      //         label: Text(_filters[index]),
                      //         selected: isSelected,
                      //         onSelected: (_) =>
                      //             setState(() => _selectedFilter = index),
                      //         labelStyle: textTheme.labelMedium?.copyWith(
                      //           color: isSelected
                      //               ? AppColors.white
                      //               : AppColors.primary,
                      //           fontWeight: FontWeight.w600,
                      //         ),
                      //         selectedColor: AppColors.primary,
                      //         backgroundColor: AppColors.surface,
                      //         side: BorderSide(
                      //           color: isSelected
                      //               ? AppColors.primary
                      //               : AppColors.border,
                      //         ),
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(12.r),
                      //         ),
                      //         showCheckmark: false,
                      //       );
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),

              //the actuall list of the products.
              SliverPadding(
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 28.h),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14.h,
                    crossAxisSpacing: 12.w,
                    childAspectRatio: 0.64,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final product = _dummyProducts[index];
                    return ProductCell(
                      onTap: () {
                        context.pushNamed(
                          'productDetailsPage',
                          extra: <MapEntry<String, String>>[
                            MapEntry('السعة', '12V 100Ah'),
                            MapEntry('النوع', 'AGM'),
                            MapEntry('النوع', 'AGM'),
                            MapEntry('النوع', 'AGM'),
                            MapEntry('النوع', 'AGM'),
                            MapEntry('النوع', 'AGM'),
                          ],
                        );
                      },
                      proTitle: product['title']!,
                      proDesc: product['description']!,
                      proImg: product['image']!,
                    );
                  }, childCount: _dummyProducts.length),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
