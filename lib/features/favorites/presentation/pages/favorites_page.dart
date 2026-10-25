import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/routes/route_imports.dart';
import '../../domain/entities/favorite_material_entity.dart';
import '../bloc/favorites/favorites_bloc.dart';

/// صفحة المنتجات المفضلة.
///
/// تعتمد على [FavoritesBloc] المشترك المُوفَّر على مستوى الـ shell (انظر
/// `route_main.dart`)، لذلك تظلّ قائمة المفضلة متزامنة مع أي تبديل يحدث
/// في الصفحات الأخرى (المنتجات/التفاصيل/البحث) وتظهر العناصر الجديدة فوراً.
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FavoritesView();
  }
}

class _FavoritesView extends StatelessWidget {
  const _FavoritesView();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocListener<FavoritesBloc, FavoritesState>(
      // نعرض رسالة لمرة واحدة عند تغيّرها فقط (تجنّباً للتكرار).
      listenWhen: (previous, current) =>
          current is FavoritesSuccess &&
          previous is FavoritesSuccess &&
          (current.lastMessage != previous.lastMessage ||
              current.lastError != previous.lastError),
      listener: (context, state) {
        final success = state as FavoritesSuccess;
        final message = success.lastError ?? success.lastMessage;
        if (message == null || message.isEmpty) return;

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: success.lastError != null
                  ? AppColors.error
                  : AppColors.primary,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(12.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          );
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              switch (state) {
                case FavoritesInitial():
                case FavoritesLoading():
                  return const _FavoritesLoadingView();
                case FavoritesFailure():
                  return _FavoritesFailureView(
                    message: state.message,
                    onRetry: () => context.read<FavoritesBloc>().add(
                      const FavoritesRequested(),
                    ),
                  );
                case FavoritesSuccess():
                  return _FavoritesListView(
                    favorites: state.favorites,
                    textTheme: textTheme,
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}

class _FavoritesListView extends StatelessWidget {
  const _FavoritesListView({required this.favorites, required this.textTheme});

  final List<FavoriteMaterialEntity> favorites;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<FavoritesBloc>();

    return FadeInUp(
      duration: const Duration(milliseconds: 400),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
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
                        '${favorites.length} منتجات محفوظة للرجوع إليها',
                        textDirection: TextDirection.rtl,
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (favorites.isEmpty)
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
                delegate: SliverChildBuilderDelegate((context, index) {
                  final favorite = favorites[index];
                  return _FavoriteTile(
                    favorite: favorite,
                    onToggle: () => bloc.add(
                      FavoriteToggled(materialId: favorite.materialId),
                    ),
                  );
                }, childCount: favorites.length),
              ),
            ),
        ],
      ),
    );
  }
}

/// بطاقة عنصر مفضّل مع مراقبة حالة التبديل الخاصة به فقط (تقليل إعادة البناء).
class _FavoriteTile extends StatelessWidget {
  const _FavoriteTile({required this.favorite, required this.onToggle});

  final FavoriteMaterialEntity favorite;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final isToggling = context.select<FavoritesBloc, bool>((bloc) {
      final state = bloc.state;
      return state is FavoritesSuccess && state.isToggling(favorite.materialId);
    });

    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: _FavoriteProductCard(
        favorite: favorite,
        isToggling: isToggling,
        onToggle: onToggle,
      ),
    );
  }
}

class _FavoriteProductCard extends StatefulWidget {
  const _FavoriteProductCard({
    required this.favorite,
    required this.isToggling,
    required this.onToggle,
  });

  final FavoriteMaterialEntity favorite;
  final bool isToggling;
  final VoidCallback onToggle;

  @override
  State<_FavoriteProductCard> createState() => _FavoriteProductCardState();
}

class _FavoriteProductCardState extends State<_FavoriteProductCard> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final detail = widget.favorite.materialDetail;
    final borderRadius = BorderRadius.circular(22.r);

    return InkWell(
      onTap: () {
        // تمرير بيانات المنتج المضغوط عليه إلى صفحة التفاصيل.
        // المواصفات تُقرأ من `material_detail` عبر الـ getter `specs`،
        // والوصف والسعر بالليرة ورابط/ملف المعلومات صارت متوفرة في الاستجابة الجديدة.
        context.push(
          NavPaths.withinBranch(context, NavPaths.details),
          extra: ProductDetailsArgs(
            name: detail.name,
            price: detail.consumerPriceLabel,
            image: detail.image ?? '',
            desc: detail.description,
            category: detail.categoryName,
            materialId: detail.id,
            priceInSp: detail.customerPriceInSpLabel,
            infoUrl: detail.infoUrl,
            infoFile: detail.infoFile,
            specifications: detail.specs
                .map((s) => MapEntry(s.key, s.value))
                .toList(),
          ),
        );
      },
      child: Dismissible(
        key: ValueKey('favorite_${widget.favorite.id}'),
        direction: DismissDirection.endToStart,
        // السحب للحذف يرسل حدث التبديل الذي يُزيل العنصر عند نجاحه.
        confirmDismiss: (_) async {
          widget.onToggle();
          return false;
        },
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
                          child: _ProductImage(imageUrl: detail.image),
                        ),
                      ),
                      PositionedDirectional(
                        top: 7.r,
                        end: 7.r,
                        child: _RoundActionButton(
                          isLoading: widget.isToggling,
                          icon: Icons.favorite_rounded,
                          color: AppColors.secondary,
                          onPressed: widget.isToggling ? null : widget.onToggle,
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
                                detail.name,
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
                              isLoading: widget.isToggling,
                              icon: Icons.close_rounded,
                              color: AppColors.textSecondary,
                              onPressed: widget.isToggling
                                  ? null
                                  : widget.onToggle,
                            ),
                          ],
                        ),
                        SizedBox(height: 7.h),
                        if (detail.categoryName.isNotEmpty)
                          Text(
                            detail.categoryName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textDirection: TextDirection.rtl,
                            style: textTheme.bodySmall?.copyWith(
                              height: 1.45,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        const Spacer(),
                        Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            Text(
                              '${detail.consumerPriceLabel} \$',
                              textDirection: TextDirection.ltr,
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
                                color: detail.isActive
                                    ? AppColors.orange50
                                    : AppColors.blue50,
                                borderRadius: BorderRadius.circular(9.r),
                              ),
                              child: Text(
                                detail.isActive ? 'متوفر' : 'غير متوفر',
                                style: textTheme.labelSmall?.copyWith(
                                  color: detail.isActive
                                      ? AppColors.orange800
                                      : AppColors.textSecondary,
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
      ),
    );
  }
}

/// صورة المنتج: شبكة مع كاش وshimmer، أو عنصر نائب عند غياب الصورة.
class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Center(
        child: Icon(
          Icons.inventory_2_outlined,
          size: 36.w,
          color: AppColors.blue100,
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      fit: BoxFit.contain,
      fadeInDuration: const Duration(milliseconds: 250),
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: AppColors.skeletonBase,
        highlightColor: AppColors.skeletonHighlight,
        child: Container(color: Colors.white.withValues(alpha: 0.55)),
      ),
      errorWidget: (context, url, error) => Icon(
        Icons.broken_image_outlined,
        size: 32.w,
        color: AppColors.blue100,
      ),
    );
  }
}

class _RoundActionButton extends StatelessWidget {
  const _RoundActionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    this.isLoading = false,
  });

  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;
  final bool isLoading;

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
          child: isLoading
              ? SizedBox(
                  width: 17.r,
                  height: 17.r,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.r,
                    color: color,
                  ),
                )
              : Icon(icon, color: color, size: 17.r),
        ),
      ),
    );
  }
}

/// حالة التحميل: بطاقات skeleton تحاكي بطاقة المفضلة الحقيقية 1:1.
class _FavoritesLoadingView extends StatelessWidget {
  const _FavoritesLoadingView();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 24.h),
      itemCount: 4,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(bottom: 14.h),
        child: const _FavoriteShimmerCard(),
      ),
    );
  }
}

/// هيكل تحميل مفصّل: كتل shimmer منفصلة لكل عنصر (الصورة، زر المفضلة،
/// العنوان، الوصف، السعر، وشارة التوفّر) بدلاً من تبليط البلاطة بالكامل.
/// شفافية كل كتلة تعكس التسلسل البصري (الصورة أقوى، الوصف أخفت).
class _FavoriteShimmerCard extends StatelessWidget {
  const _FavoriteShimmerCard();

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(22.r);

    return Container(
      height: 155.h,
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: borderRadius,
        border: Border.all(color: AppColors.blue100),
      ),
      child: Shimmer.fromColors(
        baseColor: AppColors.skeletonBase,
        highlightColor: AppColors.skeletonHighlight,
        child: Row(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // منطقة صورة المنتج + زر المفضلة الدائري.
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Positioned.fill(child: _block(radius: 16.r, alpha: 1.0)),
                  PositionedDirectional(
                    top: 7.r,
                    end: 7.r,
                    child: _block(
                      height: 29.r,
                      width: 29.r,
                      radius: 29.r,
                      alpha: 0.8,
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
                    // العنوان + زر الإغلاق.
                    Row(
                      children: [
                        Expanded(
                          child: _block(height: 15.h, width: 140.w, alpha: 0.9),
                        ),
                        SizedBox(width: 6.w),
                        _block(
                          height: 29.r,
                          width: 29.r,
                          radius: 29.r,
                          alpha: 0.8,
                        ),
                      ],
                    ),
                    SizedBox(height: 7.h),
                    // سطر الفئة/الوصف (أخفت).
                    _block(height: 11.h, width: 90.w, alpha: 0.5),
                    const Spacer(),
                    // السعر + التسمية + شارة التوفّر.
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        _block(height: 18.h, width: 55.w, alpha: 0.85),
                        SizedBox(width: 4.w),
                        _block(height: 10.h, width: 30.w, alpha: 0.4),
                        const Spacer(),
                        _block(
                          height: 22.h,
                          width: 46.w,
                          radius: 9.r,
                          alpha: 0.6,
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
    );
  }

  /// كتلة skeleton واحدة؛ شفائيتها تتحكم في مدى مشاركتها في تأثير shimmer.
  Widget _block({
    double? height,
    double? width,
    double? radius,
    required double alpha,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: alpha),
        borderRadius: BorderRadius.circular(radius ?? 5.r),
      ),
    );
  }
}

/// حالة الفشل: رسالة واضحة مع زر إعادة المحاولة.
class _FavoritesFailureView extends StatelessWidget {
  const _FavoritesFailureView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48.r,
              color: AppColors.error,
            ),
            SizedBox(height: 14.h),
            Text(
              message,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            SizedBox(height: 18.h),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
