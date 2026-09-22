import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final List<Map<String, String>> _favoriteProducts = [
    {
      'title': 'Asus TUF Gaming',
      'description': 'أداء قوي للألعاب والعمل اليومي',
      'price': '500',
      'image': 'assets/img/p1.png',
    },
    {
      'title': 'Lenovo IdeaPad Slim',
      'description': 'تصميم خفيف وبطارية تدوم طويلاً',
      'price': '420',
      'image': 'assets/img/p1.png',
    },
    {
      'title': 'HP Victus',
      'description': 'شاشة غامرة ومساحة تخزين واسعة',
      'price': '680',
      'image': 'assets/img/p1.png',
    },
    {
      'title': 'Dell Inspiron',
      'description': 'خيار عملي للدراسة والإنتاجية',
      'price': '390',
      'image': 'assets/img/p1.png',
    },
  ];

  void _removeProduct(int index) {
    final removedProduct = _favoriteProducts.removeAt(index);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تمت إزالة ${removedProduct['title']} من المفضلة'),
        action: SnackBarAction(
          label: 'تراجع',
          onPressed: () => setState(() {
            _favoriteProducts.insert(index, removedProduct);
          }),
        ),
      ),
    );
  }

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
                backgroundColor: AppColors.background,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                toolbarHeight: 72.h,
                title: Text(
                  'المنتجات المفضلة',
                  style: textTheme.titleLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                centerTitle: true,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 18.h),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Container(
                        width: 46.r,
                        height: 46.r,
                        decoration: BoxDecoration(
                          color: AppColors.orange50,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Icon(
                          Icons.favorite_rounded,
                          color: AppColors.secondary,
                          size: 24.r,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'اختياراتك المميزة',
                            textDirection: TextDirection.rtl,
                            style: textTheme.titleMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            '${_favoriteProducts.length} منتجات محفوظة للرجوع إليها',
                            textDirection: TextDirection.rtl,
                            style: textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (_favoriteProducts.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(28.w, 56.h, 28.w, 24.h),
                    child: Column(
                      children: [
                        Container(
                          width: 84.r,
                          height: 84.r,
                          decoration: BoxDecoration(
                            color: AppColors.blue50,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.favorite_border_rounded,
                            color: AppColors.primary,
                            size: 42.r,
                          ),
                        ),
                        SizedBox(height: 18.h),
                        Text(
                          'لا توجد منتجات مفضلة بعد',
                          textDirection: TextDirection.rtl,
                          style: textTheme.titleMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          'احفظ المنتجات التي تعجبك لتجدها هنا بسهولة.',
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((
                      BuildContext context,
                      int index,
                    ) {
                      final product = _favoriteProducts[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 14.h),
                        child: _FavoriteProductCard(
                          key: ValueKey(product['title']),
                          product: product,
                          onRemove: () => _removeProduct(index),
                        ),
                      );
                    }, childCount: _favoriteProducts.length),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FavoriteProductCard extends StatefulWidget {
  const _FavoriteProductCard({
    required this.product,
    required this.onRemove,
    super.key,
  });

  final Map<String, String> product;
  final VoidCallback onRemove;

  @override
  State<_FavoriteProductCard> createState() => _FavoriteProductCardState();
}

class _FavoriteProductCardState extends State<_FavoriteProductCard> {
  bool _isFavorite = true;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final borderRadius = BorderRadius.circular(22.r);

    return Dismissible(
      key: widget.key!,
      direction: DismissDirection.endToStart,
      onDismissed: (_) => widget.onRemove(),
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        padding: EdgeInsetsDirectional.only(end: 24.w),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: borderRadius,
        ),
        child: Icon(
          Icons.delete_outline_rounded,
          color: AppColors.white,
          size: 26.r,
        ),
      ),
      child: Material(
        color: AppColors.surface,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: Container(
          // constraints: BoxConstraints(minHeight: 156.h),
          height: 155.h,
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: Border.all(color: AppColors.blue100),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.08),
                blurRadius: 16.r,
                offset: Offset(0, 7.h),
              ),
            ],
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.blue50,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.r),
                          child: Image.asset(
                            widget.product['image']!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    PositionedDirectional(
                      top: 7.r,
                      end: 7.r,
                      child: _RoundActionButton(
                        icon: _isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: _isFavorite
                            ? AppColors.secondary
                            : AppColors.textSecondary,
                        onPressed: () =>
                            setState(() => _isFavorite = !_isFavorite),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 13.w),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.product['title']!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textDirection: TextDirection.rtl,
                              style: textTheme.titleMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          _RoundActionButton(
                            icon: Icons.close_rounded,
                            color: AppColors.textSecondary,
                            onPressed: widget.onRemove,
                          ),
                        ],
                      ),
                      SizedBox(height: 7.h),
                      Text(
                        widget.product['description']!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textDirection: TextDirection.rtl,
                        style: textTheme.bodySmall?.copyWith(height: 1.45),
                      ),
                      const Spacer(),
                      Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Text(
                            '${widget.product['price']}\$',
                            style: textTheme.titleLarge?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'السعر',
                            style: textTheme.labelSmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 5.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.orange50,
                              borderRadius: BorderRadius.circular(9.r),
                            ),
                            child: Text(
                              'متوفر',
                              style: textTheme.labelSmall?.copyWith(
                                color: AppColors.orange800,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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

class _RoundActionButton extends StatelessWidget {
  const _RoundActionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: EdgeInsets.all(6.r),
          child: Icon(icon, color: color, size: 17.r),
        ),
      ),
    );
  }
}
