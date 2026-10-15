import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/colors.dart';
import '../../domain/entities/banner_entity.dart';
import '../bloc/get_banners/get_banners_bloc.dart';

/// قسم اللافتات في الرئيسية.
///
/// يربط حالة الـ BLoC (تحميل/نجاح/فشل/فارغ) ويعرض اللافتات عبر
/// widget CarouselView المدمج مع تخصيص ينسجم مع هوية التطبيق (زوايا دائرية،
/// ظل أزرق، مؤشّر نقاط، وصورة شبكية مع shimmer أثناء التحميل).
class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key, this.height});

  final double? height;

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetBannersBloc, GetBannersState>(
      builder: (context, state) {
        if (state is GetBannersInitial || state is GetBannersLoading) {
          return _BannerCarouselShimmer(height: _height(context));
        }

        if (state is GetBannersFailure) {
          return _BannerFailure(height: _height(context));
        }

        if (state is GetBannersSuccess) {
          if (state.banners.isEmpty) {
            return const SizedBox.shrink();
          }
          return _buildCarousel(context, state.banners);
        }

        return const SizedBox.shrink();
      },
    );
  }

  double _height(BuildContext context) => widget.height ?? 200.h;

  Widget _buildCarousel(BuildContext context, List<BannerEntity> banners) {
    final size = MediaQuery.sizeOf(context).width;
    // كل لافتة تشغل معظم العرض مع ترك طرف مجاور «بازق» للإيحاء بالتمرير.
    final itemExtent = size * 0.88;
    final loop = banners.length > 1;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                color:
                    //  Colors.grey.withValues(alpha: 0.20),
                    const Color.fromARGB(
                      255,
                      51,
                      151,
                      228,
                    ).withValues(alpha: 0.20),
                blurRadius: 20.r,
                offset: Offset(0, 8.h),
              ),
            ],
          ),
          height: _height(context),
          child: CarouselView(
            itemExtent: itemExtent,
            shrinkExtent: itemExtent * 0.82,
            itemSnapping: true,
            infinite: loop,
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            elevation: 0,
            onTap: (index) => setState(() => _currentIndex = index),
            onIndexChanged: (index) =>
                setState(() => _currentIndex = index % banners.length),
            children: [
              for (final banner in banners)
                _BannerSlide(
                  banner: banner,
                  isActive: banners.indexOf(banner) == _currentIndex,
                ),
            ],
          ),
        ),
        if (loop) ...[
          SizedBox(height: 12.h),
          _DotIndicator(
            count: banners.length,
            activeIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
          ),
        ],
      ],
    );
  }
}

/// شريحة لافتة واحدة: صورة شبكية بزاويا دائرية + تدرّج سفلي للعنوان.
class _BannerSlide extends StatelessWidget {
  const _BannerSlide({required this.banner, required this.isActive});

  final BannerEntity banner;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: isActive ? 0.20 : 0.10),
            blurRadius: isActive ? 20.r : 12.r,
            offset: Offset(0, isActive ? 8.h : 4.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: banner.image,
              fit: BoxFit.fill,
              fadeInDuration: const Duration(milliseconds: 250),
              fadeInCurve: Curves.easeOutCubic,
              placeholder: (context, url) => const _BannerImageShimmer(),
              errorWidget: (context, url, error) => _imageFallback(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageFallback() {
    return Container(
      color: AppColors.blue50,
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 40.w,
          color: AppColors.blue100,
        ),
      ),
    );
  }
}

/// shimmer لبانر واحد أثناء تحميل الصورة.
class _BannerImageShimmer extends StatelessWidget {
  const _BannerImageShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.skeletonBase,
      highlightColor: AppColors.skeletonHighlight,
      child: Container(color: AppColors.skeletonBase),
    );
  }
}

/// هيكل shimmer للّافتة كاملة أثناء تحميل القائمة.
class _BannerCarouselShimmer extends StatelessWidget {
  const _BannerCarouselShimmer({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context).width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.r),
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: AppColors.skeletonBase,
            highlightColor: AppColors.skeletonHighlight,
            child: Container(
              height: height,
              width: size * 0.88,
              decoration: BoxDecoration(
                color: AppColors.skeletonBase,
                borderRadius: BorderRadius.circular(18.r),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < 3; i++)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  width: i == 0 ? 18.w : 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: AppColors.skeletonBase,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// حالة الفشل: رسالة + إعادة محاولة عبر إرسال الحدث للّBloc.
class _BannerFailure extends StatelessWidget {
  const _BannerFailure({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 34.w,
              color: Theme.of(context).colorScheme.error,
            ),
            SizedBox(height: 8.h),
            Text(
              'تعذّر تحميل اللافتات',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 8.h),
            TextButton.icon(
              onPressed: () {
                context.read<GetBannersBloc>().add(
                  const GetBannersRefreshRequested(),
                );
              },
              icon: Icon(Icons.refresh_rounded, size: 18.w),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}

/// مؤشّر نقاط سفلي بأسلوب التطبيق (النشِط أوسع وملوّن).
class _DotIndicator extends StatelessWidget {
  const _DotIndicator({
    required this.count,
    required this.activeIndex,
    required this.onTap,
  });

  final int count;
  final int activeIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < count; i++)
          GestureDetector(
            onTap: () => onTap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              margin: EdgeInsets.symmetric(horizontal: 3.w),
              height: 8.h,
              width: i == activeIndex ? 20.w : 8.w,
              decoration: BoxDecoration(
                color: i == activeIndex
                    ? AppColors.secondary
                    : const Color.fromARGB(255, 187, 210, 231),
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
      ],
    );
  }
}
