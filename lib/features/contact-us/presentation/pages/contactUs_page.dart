import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

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

class _ContactusView extends StatelessWidget {
  const _ContactusView();

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
