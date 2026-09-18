import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../widgets/category_label.dart';
import '../widgets/featured_products_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String userName = "Daniel";

  final List<CategoryItem> categories = const [
    CategoryItem(
      title: 'Asus Tuf ',
      briefDesc: 'Core i7 12th Gen, 16GB RAM, 512GB SSD',
      img: 'assets/img/p1.png',
      price: '1200',
    ),
    CategoryItem(
      title: 'Asus Tuf ',
      briefDesc: 'Core i7 12th Gen, 16GB RAM, 512GB SSD',
      img: 'assets/img/p2.png',
      price: '1500',
    ),
  ];

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
                        onTap: () {},
                        label: 'لابتوبات',
                        img: 'assets/img/laptop.png',
                      ),
                      CategoryLabel(
                        onTap: () {},
                        label: 'بطاريات',
                        img: 'assets/img/laptop.png',
                      ),
                      CategoryLabel(
                        onTap: () {},
                        label: 'ألواح شمسية',
                        img: 'assets/img/laptop.png',
                      ),
                      CategoryLabel(
                        onTap: () {},
                        label: 'إكسسوارات',
                        img: 'assets/img/laptop.png',
                      ),
                      CategoryLabel(
                        onTap: () {},
                        label: 'المزيد',
                        img: 'assets/img/laptop.png',
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
                        onPressed: () {},
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

            //Featured products section
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 15.r),
              sliver: SliverGrid.builder(
                itemCount: categories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15.h,
                  crossAxisSpacing: 15.w,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return FadeInUp(
                    delay: Duration(milliseconds: 1000),
                    child: FeaturedProCard(
                      category: category,
                      textTheme: textTheme,
                      onTap: () {},
                    ),
                  );
                  // CategoryCard(
                  //   category: category,
                  //   onTap: () {
                  //     // Handle card tap
                  //   },
                  // );
                },
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 50.h)),
          ],
        ),
      ),
    );
  }
}

class CategoryItem {
  const CategoryItem({
    required this.title,
    required this.briefDesc,
    required this.img,
    required this.price,
  });

  final String title;
  final String briefDesc;
  final String img;
  final String price;
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({required this.category, this.onTap, super.key});

  final CategoryItem category;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      // color: AppColors.surface,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.fromLTRB(12.w, 25.h, 12.w, 25.h),
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
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.blue50,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                    Center(
                      child: Image.asset(
                        category.img,
                        width: 150.w,
                        height: 150.h,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                // textDirection: TextDirection.rtl,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          // textDirection: TextDirection.rtl,
                          style: textTheme.titleSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          category.briefDesc,
                          // overflow: TextOverflow.ellipsis,
                          // textDirection: TextDirection.rtl,
                          style: textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
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
