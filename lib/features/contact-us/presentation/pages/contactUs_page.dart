import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/contact_info_entity.dart';
import '../bloc/get_contact_info/get_contact_info_bloc.dart';

class ContactusPage extends StatelessWidget {
  const ContactusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<GetContactInfoBloc>()..add(const GetContactInfoRequested()),
      child: const _ContactusView(),
    );
  }
}

class _ContactusView extends StatefulWidget {
  const _ContactusView();

  @override
  State<_ContactusView> createState() => _ContactusViewState();
}

class _ContactusViewState extends State<_ContactusView> {
  // السحب للتحديث: ننتهي من المؤشر عند انتهاء حالة التحميل.
  Future<void> _onRefresh() async {
    final bloc = context.read<GetContactInfoBloc>();
    final completer = Completer<void>();

    final subscription = bloc.stream.listen((state) {
      if (state is! GetContactInfoLoading && !completer.isCompleted) {
        completer.complete();
      }
    });

    bloc.add(const GetContactInfoRefreshRequested());

    // فترة أطول قليلاً لإظهار مؤشر التحديث بشكل مريح.
    await Future.delayed(const Duration(milliseconds: 600));
    await completer.future.timeout(
      const Duration(seconds: 30),
      onTimeout: () {},
    );
    await subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: AppColors.primary,
          child: FadeInUp(
            delay: Duration(milliseconds: 400),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: AppColors.background,
                  surfaceTintColor: Colors.transparent,
                  elevation: 0,
                  toolbarHeight: 72.h,
                  title: Text(
                    'تواصل معنا',
                    style: textTheme.titleLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  centerTitle: true,
                ),

                //banner section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8.r, 10.h, 8.r, 20.h),
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
                          image: AssetImage('assets/img/contactusbanner.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),

                //contactUs info section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: BlocBuilder<GetContactInfoBloc, GetContactInfoState>(
                      builder: (context, state) {
                        if (state is GetContactInfoFailure) {
                          return _ContactFailure(message: state.message);
                        }

                        final contactInfo = state is GetContactInfoSuccess
                            ? state.contactInfo
                            : null;

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            headerTitle(textTheme, 'تواصل مباشرة'),
                            SizedBox(height: 10.h),
                            if (contactInfo == null)
                              _NumbersShimmer()
                            else
                              NumbersTile(
                                textTheme: textTheme,
                                contactInfo: contactInfo,
                              ),
                            SizedBox(height: 10.h),
                            headerTitle(textTheme, 'موقعنا'),
                            SizedBox(height: 10.h),
                            if (contactInfo == null)
                              _LocationShimmer()
                            else
                              LocationTile(
                                textTheme: textTheme,
                                contactInfo: contactInfo,
                              ),
                            SizedBox(height: 10.h),
                            headerTitle(textTheme, 'تابعنا'),
                            SizedBox(height: 10.h),
                            if (contactInfo == null)
                              _SocialShimmer()
                            else
                              FacebookTile(
                                textTheme: textTheme,
                                contactInfo: contactInfo,
                              ),
                            SizedBox(height: 10.h),
                          ],
                        );
                      },
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

  Row headerTitle(TextTheme textTheme, String title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 2.h,
          width: 16.w,
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        SizedBox(width: 5.w),
        Text(title, style: textTheme.titleMedium),
      ],
    );
  }
}

class LocationTile extends StatelessWidget {
  const LocationTile({super.key, required this.textTheme, this.contactInfo});

  final TextTheme textTheme;
  final ContactInfoEntity? contactInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.3),
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          //location image
          Container(
            height: 100.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Image.asset('assets/img/location.jpg', fit: BoxFit.cover),
          ),
          SizedBox(height: 5.h),
          Row(
            children: [
              //location icon
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 202, 219, 235),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Icon(
                    Icons.location_on,
                    size: 30.h,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              //address section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'شركة تاركوم',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (contactInfo?.address.isNotEmpty == true)
                      Text(
                        contactInfo!.address,
                        style: textTheme.bodySmall,
                        textDirection: TextDirection.rtl,
                      ),
                    if (contactInfo?.email.isNotEmpty == true)
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          contactInfo!.email,
                          style: textTheme.bodySmall,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NumbersTile extends StatelessWidget {
  const NumbersTile({super.key, required this.textTheme, this.contactInfo});

  final TextTheme textTheme;
  final ContactInfoEntity? contactInfo;

  @override
  Widget build(BuildContext context) {
    final phones = <String>[
      if (contactInfo?.phone1.isNotEmpty == true) contactInfo!.phone1,
      if (contactInfo?.phone2.isNotEmpty == true) contactInfo!.phone2,
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.3),
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              //phone icon
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 202, 219, 235),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Icon(
                    Icons.phone_enabled,
                    size: 30.h,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              //numbers section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'اتصل بنا',
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text('أرقام الشركة', style: textTheme.bodySmall),
                  SizedBox(height: 6.h),
                  for (final phone in phones)
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(phone, style: textTheme.bodySmall),
                    ),
                ],
              ),
            ],
          ),

          //arrow
          Container(
            padding: EdgeInsets.all(3.r),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 202, 219, 235),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Center(
              child: Icon(
                Icons.keyboard_arrow_left_outlined,
                size: 25.h,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// بليكة فيسبوك الحديثة: تفتح صفحة فيسبوك الخاصة بالشركة عند النقر.
class FacebookTile extends StatelessWidget {
  const FacebookTile({super.key, required this.textTheme, this.contactInfo});

  final TextTheme textTheme;
  final ContactInfoEntity? contactInfo;

  static const Color _facebookBlue = Color(0xFF1877F2);

  Future<void> _launchFacebook(BuildContext context) async {
    final raw = contactInfo?.facebook.trim() ?? '';
    if (raw.isEmpty) return;

    // توحيد الرابط: إزالة البروتوكول والنطاقات الفرعية ثم إعادة بناء رابط https نظيف.
    final link = raw
        .replaceFirst(RegExp(r'^https?://', caseSensitive: false), '')
        .replaceFirst(RegExp(r'^www\.', caseSensitive: false), '')
        .replaceFirst(RegExp(r'^m\.', caseSensitive: false), '');
    if (!link.contains('facebook.com')) return;
    final fbUrl = 'https://$link';

    // فتح الرابط في التطبيق الخارجي (تطبيق فيسبوك إن كان مثبتًا، وإلا المتصفح الافتراضي).
    try {
      final opened = await launchUrl(
        Uri.parse(fbUrl),
        mode: LaunchMode.externalApplication,
      );
      if (!opened && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تعذّر فتح رابط فيسبوك على هذا الجهاز'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تعذّر فتح رابط فيسبوك على هذا الجهاز'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final facebook = contactInfo?.facebook.trim() ?? '';
    if (facebook.isEmpty) return const SizedBox.shrink();

    return FadeInUp(
      duration: const Duration(milliseconds: 400),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [_facebookBlue, Color(0xFF42A5F5)],
          ),
          boxShadow: [
            BoxShadow(
              color: _facebookBlue.withValues(alpha: 0.35),
              blurRadius: 16.r,
              offset: Offset(0, 6.h),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12.r),
            splashColor: Colors.white.withValues(alpha: 0.15),
            highlightColor: Colors.white.withValues(alpha: 0.08),
            onTap: () => _launchFacebook(context),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 12.w),
              child: Row(
                children: [
                  //facebook icon
                  Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.facebook_rounded,
                      size: 28.h,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  //label + link
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'فيسبوك',
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            facebook,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  //open indicator
                  Container(
                    padding: EdgeInsets.all(3.r),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Icon(
                      Icons.arrow_outward_rounded,
                      size: 22.h,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// هيكل shimmer لبليكة الأرقام أثناء التحميل.
class _NumbersShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.skeletonBase,
      highlightColor: AppColors.skeletonHighlight,
      child: Container(
        height: 92.h,
        decoration: BoxDecoration(
          color: AppColors.skeletonBase,
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}

/// هيكل shimmer لبليكة الموقع أثناء التحميل.
class _LocationShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.skeletonBase,
      highlightColor: AppColors.skeletonHighlight,
      child: Container(
        height: 190.h,
        decoration: BoxDecoration(
          color: AppColors.skeletonBase,
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}

/// هيكل shimmer لبليكة التواصل الاجتماعي أثناء التحميل.
class _SocialShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.skeletonBase,
      highlightColor: AppColors.skeletonHighlight,
      child: Container(
        height: 72.h,
        decoration: BoxDecoration(
          color: AppColors.skeletonBase,
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}

/// حالة الفشل: رسالة + إعادة محاولة عبر إرسال الحدث للـ Bloc.
class _ContactFailure extends StatelessWidget {
  const _ContactFailure({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.h),
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
            message.isEmpty ? 'تعذّر تحميل معلومات التواصل' : message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          TextButton.icon(
            onPressed: () {
              context.read<GetContactInfoBloc>().add(
                const GetContactInfoRefreshRequested(),
              );
            },
            icon: Icon(Icons.refresh_rounded, size: 18.w),
            label: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}
