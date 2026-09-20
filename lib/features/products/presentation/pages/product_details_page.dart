import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  static const _background = Color(0xFFF7F9FC);
  static const _ink = Color(0xFF17202A);

  final List<String> _productImages = [
    'assets/img/battery.png',
    'assets/img/batterylabel.png',
  ];
  final List<MapEntry<String, String>> _specifications = const [
    MapEntry('النوع', 'ليثيوم'),
    MapEntry('السعة', '100 Ah'),
    MapEntry('الجهد', '12 V'),
    MapEntry('الوزن', '28 kg'),
  ];
  final List<String> _capacities = ['100 Ah', '150 Ah', '200 Ah'];
  int _selectedImage = 0;
  int _selectedCapacity = 0;
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // backgroundColor: _background,
        appBar: AppBar(
          // backgroundColor: AppColors.white,
          // surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          titleSpacing: 24.w,
          title: Text(
            'تفاصيل المنتج',
            style: TextStyle(
              color: _ink,
              fontFamily: 'IBMPlexSansArabic',
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            IconButton(
              tooltip: 'رجوع',
              onPressed: () => Navigator.maybePop(context),
              icon: const Icon(Icons.arrow_forward_rounded),
              color: _ink,
            ),
          ],
          leading: IconButton(
            tooltip: 'المفضلة',
            onPressed: () => setState(() => _isFavorite = !_isFavorite),
            icon: Icon(
              _isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: _isFavorite
                  ? AppColors.secondary
                  : AppColors.textSecondary,
            ),
          ),
        ),
        body: Stack(
          children: [
            ListView(
              padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 126.h),
              children: [
                _buildGallery(),
                SizedBox(height: 24.h),
                _buildProductIntro(),
                SizedBox(height: 28.h),
                _buildDescription(),
                SizedBox(height: 28.h),
                _buildSpecifications(),
                SizedBox(height: 28.h),
                _buildVariants(),
                SizedBox(height: 20.h),
                _buildInventoryStatus(),
              ],
            ),
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildGallery() {
    return Column(
      children: [
        Container(
          height: 248.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.border),
            boxShadow: const [
              BoxShadow(
                color: Color(0x08053B79),
                blurRadius: 18,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Padding(
              padding: EdgeInsets.all(30.r),
              child: Image.asset(
                _productImages[_selectedImage],
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _productImages.length,
            (index) => GestureDetector(
              onTap: () => setState(() => _selectedImage = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                height: 6.h,
                width: index == _selectedImage ? 20.w : 6.w,
                decoration: BoxDecoration(
                  color: index == _selectedImage
                      ? AppColors.primary
                      : AppColors.blue100,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductIntro() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'بطاريات',
          style: TextStyle(
            color: AppColors.primary,
            fontFamily: 'IBMPlexSansArabic',
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 7.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'بطارية ليثيوم للطاقة الشمسية',
                style: TextStyle(
                  color: _ink,
                  fontFamily: 'IBMPlexSansArabic',
                  fontSize: 22.sp,
                  height: 1.35,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            _availabilityBadge(),
          ],
        ),
        SizedBox(height: 14.h),
        Text(
          '\$250',
          textDirection: TextDirection.ltr,
          style: TextStyle(
            color: AppColors.secondary,
            fontFamily: 'IBMPlexSansArabic',
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _availabilityBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF8EF),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 7.r,
            width: 7.r,
            decoration: const BoxDecoration(
              color: AppColors.available,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            'متوفر',
            style: TextStyle(
              color: AppColors.available,
              fontFamily: 'IBMPlexSansArabic',
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return _section(
      title: 'الوصف',
      child: Text(
        'بطارية ليثيوم عملية وموثوقة مصممة لتخزين الطاقة بكفاءة، وتناسب أنظمة الطاقة الشمسية المنزلية والتجارية. تتميز بعمر تشغيلي طويل وأداء ثابت.',
        style: TextStyle(
          color: AppColors.textSecondary,
          fontFamily: 'IBMPlexSansArabic',
          fontSize: 14.sp,
          height: 1.8,
        ),
      ),
    );
  }

  Widget _buildSpecifications() {
    return _section(
      title: 'المواصفات',
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Column(
          children: List.generate(_specifications.length, (index) {
            final specification = _specifications[index];
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(specification.key, style: _specLabelStyle()),
                  ),
                  Text(specification.value, style: _specValueStyle()),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildVariants() {
    return _section(
      title: 'الخيارات المتاحة',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('السعة', style: _specLabelStyle()),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: List.generate(_capacities.length, (index) {
              final selected = index == _selectedCapacity;
              return ChoiceChip(
                label: Text(_capacities[index]),
                selected: selected,
                onSelected: (_) => setState(() => _selectedCapacity = index),
                labelStyle: TextStyle(
                  color: selected ? AppColors.primary : AppColors.textSecondary,
                  fontFamily: 'IBMPlexSansArabic',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
                backgroundColor: AppColors.white,
                selectedColor: AppColors.blue100,
                side: BorderSide(
                  color: selected ? AppColors.primary : AppColors.border,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                showCheckmark: false,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryStatus() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF6FBF7),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFD7F0DF)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            color: AppColors.available,
            size: 19,
          ),
          SizedBox(width: 10.w),
          Text(
            'متوفر في المخزون',
            style: TextStyle(
              color: AppColors.available,
              fontFamily: 'IBMPlexSansArabic',
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(24.w, 14.h, 24.w, 18.h),
        decoration: const BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 16,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.chat_bubble_outline_rounded, size: 19),
                label: const Text('تواصل مع تاركوم'),
                style: FilledButton.styleFrom(
                  minimumSize: Size.fromHeight(52.h),
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  textStyle: TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            SizedBox(
              width: 92.w,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  minimumSize: Size.fromHeight(52.h),
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'طلب المنتج',
                  style: TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: _ink,
            fontFamily: 'IBMPlexSansArabic',
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 12.h),
        child,
      ],
    );
  }

  TextStyle _specLabelStyle() => TextStyle(
    color: AppColors.textSecondary,
    fontFamily: 'IBMPlexSansArabic',
    fontSize: 13.sp,
    fontWeight: FontWeight.w500,
  );

  TextStyle _specValueStyle() => TextStyle(
    color: _ink,
    fontFamily: 'IBMPlexSansArabic',
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
  );
}
