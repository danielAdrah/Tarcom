import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/routes/route_imports.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({
    super.key,
    this.specifications = const [
      MapEntry('المعالج', 'Core i5 13 H'),
      MapEntry('الرام', '16G DDR5'),
      MapEntry('كرت الشاشة', 'RTX 4050 6G'),
      MapEntry('الهارد', 'SSD 512'),
      MapEntry('الشاشة', '16.5 FHD'),
    ],
  });

  final List<MapEntry<String, String>> specifications;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  static const int _initialSpecificationCount = 4;
  bool _isFavorite = false;
  bool _showAllSpecifications = false;

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
                        onPressed: () =>
                            setState(() => _isFavorite = !_isFavorite),
                        tooltip: _isFavorite
                            ? 'إزالة من المفضلة'
                            : 'إضافة إلى المفضلة',
                        icon: Icon(
                          _isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                        ),
                        color: _isFavorite
                            ? AppColors.secondary
                            : AppColors.primary,
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
                  child: _buildSpecifications(context),
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

  Widget _buildSpecifications(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final visibleSpecifications = widget.specifications
        .take(
          _showAllSpecifications
              ? widget.specifications.length
              : _initialSpecificationCount,
        )
        .toList();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 16.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Container(
                width: 38.w,
                height: 38.h,
                decoration: BoxDecoration(
                  color: AppColors.blue50,
                  borderRadius: BorderRadius.circular(11.r),
                ),
                child: Icon(
                  Icons.tune_rounded,
                  color: AppColors.primary,
                  size: 20.r,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  'المواصفات',
                  textDirection: TextDirection.rtl,
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: AppColors.orange50,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '${widget.specifications.length} تفاصيل',
                  style: textTheme.labelSmall?.copyWith(
                    color: AppColors.orange800,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          if (widget.specifications.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Text(
                'لا توجد مواصفات متاحة',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            )
          else
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: Column(
                children: [
                  for (
                    var index = 0;
                    index < visibleSpecifications.length;
                    index++
                  ) ...[
                    if (index > 0)
                      Divider(height: 1.h, color: AppColors.divider),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        textDirection: TextDirection.rtl,
                        children: [
                          Expanded(
                            child: Text(
                              visibleSpecifications[index].key,
                              textDirection: TextDirection.rtl,
                              style: textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Flexible(
                            child: Text(
                              visibleSpecifications[index].value,
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.start,
                              style: textTheme.bodyMedium?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          if (widget.specifications.length > _initialSpecificationCount)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                onPressed: () => setState(
                  () => _showAllSpecifications = !_showAllSpecifications,
                ),
                icon: Icon(
                  _showAllSpecifications
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 20.r,
                ),
                label: Text(_showAllSpecifications ? 'عرض أقل' : 'عرض الكل'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
