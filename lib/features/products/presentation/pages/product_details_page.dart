import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/routes/route_imports.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: FadeInUp(
          delay: Duration(milliseconds: 400),
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
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
                        icon: const Icon(Icons.favorite_border),
                        color: AppColors.primary,
                        iconSize: 21.r,
                      ),
                    ),
                  ),
                ],
              ),
              //Product image
              SliverToBoxAdapter(
                child: Container(
                  height: 250.h,
                  margin: EdgeInsets.symmetric(vertical: 5.r, horizontal: 15.r),
                  padding: EdgeInsets.all(16.r),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: AppColors.surface.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Image.asset(
                      //later we will fetch the image from the api
                      'assets/img/p1.png',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.image_not_supported_outlined,
                          size: 42.r,
                          color: AppColors.textSecondary,
                        );
                      },
                    ),
                  ),
                ),
              ),

              //product title ,category and price
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 15.h,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //product title
                      Text(
                        'Asus Tuf A15',
                        style: textTheme.displaySmall?.copyWith(
                          color: const Color.fromARGB(255, 82, 90, 105),
                        ),
                      ),
                      //product category
                      Text(
                        'لابتوبات',
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      //product price
                      Text(
                        '800\$',
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // container with key-value specs for the product
              SliverPadding(
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                sliver: SliverToBoxAdapter(
                  child: Container(
                    // margin: ,
                    // height: 250.h,
                    padding: EdgeInsets.all(5.r),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Padding(
                      padding: EdgeInsetsGeometry.symmetric(
                        horizontal: 15.w,
                        vertical: 5.h,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('المعالج:', style: textTheme.bodyLarge),
                              Text('Core i5 13 H', style: textTheme.bodyMedium),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 3.h),
                            child: Divider(
                              endIndent: 3,
                              indent: 3,
                              color: AppColors.primary.withOpacity(0.5),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('الرام:', style: textTheme.bodyLarge),
                              Text('16G DDR5', style: textTheme.bodyMedium),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 3.h),
                            child: Divider(
                              endIndent: 3,
                              indent: 3,
                              color: AppColors.primary.withOpacity(0.5),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('كرت الشاشة :', style: textTheme.bodyLarge),
                              Text('RTX 4050 6G', style: textTheme.bodyMedium),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 3.h),
                            child: Divider(
                              endIndent: 3,
                              indent: 3,
                              color: AppColors.primary.withOpacity(0.5),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('الهارد:', style: textTheme.bodyLarge),
                              Text('SSD 512', style: textTheme.bodyMedium),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 3.h),
                            child: Divider(
                              endIndent: 3,
                              indent: 3,
                              color: AppColors.primary.withOpacity(0.5),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('الشاشة:', style: textTheme.bodyLarge),
                              Text('16.5 FHD', style: textTheme.bodyMedium),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              //product description
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الوصف:',
                        style: textTheme.titleLarge?.copyWith(
                          color: const Color.fromARGB(255, 82, 90, 105),
                          // fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'لابتوب غيمينغ قوي ممتاز للألعاب الثقيلة و البرامج الهندسية المتطلبة , يأتي بمعالج Core i5',
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),

              // contact us button
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 15.h,
                  ),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.chat_outlined),
                    label: const Text('تواصل معنا '),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
