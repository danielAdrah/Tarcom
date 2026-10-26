import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/update_profile_params.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../bloc/get_user_profile/get_user_profile_bloc.dart';
import '../bloc/update_user_profile/update_user_profile_bloc.dart';
import '../../../auth/presentation/bloc/log_out/bloc/log_out_bloc.dart';
import '../widgets/profile_edit_field.dart';
import '../widgets/profile_info_tile.dart';
import '../widgets/profile_shimmer.dart';

/// صفحة الملف الشخصي (Concept A: Collapsing Identity Banner).
///
/// بانر هوية متقلّص بتدرّج أزرق العلامة مع parallax خفيف، بطاقة بيضاء تطفو
/// على حافته وشارة أحرف أولى برتقالية نابضة، ثم مؤشر اكتمال الملف المتحرك
/// بعدّاد تصاعدي، فبطاقات الاسم والتواصل الزجاجية مع النسخ بضغطة.
///
/// يدعم وضع تعديل (عبر أيقونة القلم في الشريط العلوي) يحوّل البطاقات الثابتة
/// إلى حقول تحرير مع تحقق من الاسم والهاتف، وحفظ عبر `PUT /api/users/me/`.
class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              sl<GetUserProfileBloc>()..add(const GetUserProfileRequested()),
        ),
        BlocProvider(create: (_) => sl<UpdateUserProfileBloc>()),
        BlocProvider(create: (_) => sl<LogOutBloc>()),
      ],
      child: const _UserProfileView(),
    );
  }
}

class _UserProfileView extends StatefulWidget {
  const _UserProfileView();

  @override
  State<_UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<_UserProfileView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameCtrl = TextEditingController();
  final TextEditingController _lastNameCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();

  bool _isEditing = false;

  /// رمز الدولة السوري الثابت كبادئة غير قابلة للتحرير أمام حقل الهاتف.
  static const String _phonePrefix = '+963';

  /// التحقق من الجزء المحلي فقط: 9 أرقام بعد البادئة `_phonePrefix`.
  static final RegExp _localPhoneRegex = RegExp(r'^\d{9}$');

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  /// الدخول في وضع التعديل: تعبئة الحقول بالقيم الحالية.
  void _startEdit(UserProfileEntity profile) {
    _firstNameCtrl.text = profile.firstName;
    _lastNameCtrl.text = profile.lastName;
    // نخزّن الجزء المحلي فقط في الحقل؛ البادئة `_phonePrefix` ثابتة في الواجهة.
    _phoneCtrl.text = _stripPhonePrefix(profile.phone);
    setState(() => _isEditing = true);
  }

  /// إزالة البادئة الدولية من الرقم المحفوظ لاستخراج 9 الأرقام المحلية.
  String _stripPhonePrefix(String phone) {
    String local = phone.trim();
    if (local.startsWith(_phonePrefix)) {
      local = local.substring(_phonePrefix.length);
    }
    return local.replaceAll(RegExp(r'[^0-9]'), '');
  }

  void _cancelEdit() => setState(() => _isEditing = false);

  /// تحقق + إرسال طلب التحديث إلى الـ BLoC.
  void _onSave() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    context.read<UpdateUserProfileBloc>().add(
      UpdateUserProfileSubmitted(
        params: UpdateProfileParams(
          firstName: _firstNameCtrl.text.trim(),
          lastName: _lastNameCtrl.text.trim(),
          // نجمع البادئة الثابتة مع الإدخال المحلي لإرسال الرقم الدولي الكامل.
          phone: '$_phonePrefix${_phoneCtrl.text.trim()}',
        ),
      ),
    );
  }

  String? _validateName(String? value, String label) {
    final String trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return '$label مطلوب';
    if (trimmed.length < 2) return 'قصير جداً';
    return null;
  }

  String? _validatePhone(String? value) {
    final String trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'رقم الهاتف مطلوب';
    if (!_localPhoneRegex.hasMatch(trimmed)) {
      return 'يجب أن يكون الرقم 9 أرقام (مثال: 991234567)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocListener<LogOutBloc, LogOutState>(
      listener: (context, state) {
        // بعد إنهاء الجلسة محلياً نوجّه المستخدم لتسجيل الدخول من جديد.
        if (state is LogOutSuccess) {
          context.goNamed('signInPage');
        }
      },
      child: BlocListener<UpdateUserProfileBloc, UpdateUserProfileState>(
        listener: (context, state) {
          if (state is UpdateUserProfileSuccess) {
            // عكس النتيجة محلياً + الخروج من وضع التعديل.
            context.read<GetUserProfileBloc>().add(
              GetUserProfileUpdated(profile: state.userProfile),
            );
            _cancelEdit();
            _showFeedback(
              context,
              message: 'تم تحديث ملفك الشخصي بنجاح.',
              isError: false,
            );
          } else if (state is UpdateUserProfileFailure) {
            _showFeedback(context, message: state.message, isError: true);
          }
        },
        child: Form(
          key: _formKey,
          child: Scaffold(
            bottomNavigationBar: _isEditing
                ? _buildEditActionBar(context)
                : null,
            body: SafeArea(
              bottom: false,
              child: BlocBuilder<GetUserProfileBloc, GetUserProfileState>(
                builder: (context, state) {
                  final bool isLoading =
                      state is GetUserProfileInitial ||
                      state is GetUserProfileLoading;
                  final profile = state is GetUserProfileSuccess
                      ? state.userProfile
                      : null;

                  return RefreshIndicator(
                    color: AppColors.primary,
                    // نعطّل السحب للتحديث أثناء التعديل حفاظاً على ما يُكتب.
                    onRefresh: () =>
                        _isEditing ? Future<void>.value() : _refresh(context),
                    child: CustomScrollView(
                      physics: _isEditing
                          ? const ClampingScrollPhysics()
                          : const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics(),
                            ),
                      slivers: [
                        //profile banner.
                        SliverAppBar(
                          automaticallyImplyLeading: false,

                          leading: IconButton(
                            onPressed: () {
                              if (_isEditing) {
                                _cancelEdit();
                              } else {
                                context.pop();
                              }
                            },
                            icon: Icon(
                              _isEditing
                                  ? Icons.close_rounded
                                  : Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 25.w,
                            ),
                          ),

                          // زر التعديل يظهر فقط عند توفّر البيانات وخروجها من الوضع.
                          actions: profile != null && !_isEditing
                              ? [
                                  IconButton(
                                    tooltip: 'تعديل',
                                    onPressed: () => _startEdit(profile),
                                    icon: Icon(
                                      Icons.edit_rounded,
                                      color: Colors.white,
                                      size: 24.w,
                                    ),
                                  ),
                                ]
                              : const [],

                          stretch: true,
                          expandedHeight: 250.h,
                          toolbarHeight: 65.h,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          flexibleSpace: FlexibleSpaceBar(
                            background: ZoomIn(
                              delay: const Duration(milliseconds: 350),
                              child: Image.asset(
                                'assets/img/profilebanner.webp',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                        if (profile != null) ...[
                          // مقطع الاسم: الأول والعائلة قيمة مستقلة قابلة للنسخ/التحرير،
                          // باتجاه RTL صحيح للأسماء العربية.
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(16.w, 22.h, 16.w, 0),
                              child: FadeInDown(
                                duration: const Duration(milliseconds: 400),
                                delay: const Duration(milliseconds: 250),
                                child: _sectionHeader(textTheme, 'الاسم'),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: FadeInUp(
                                duration: const Duration(milliseconds: 500),
                                delay: const Duration(milliseconds: 300),
                                child: Column(
                                  children: [
                                    SizedBox(height: 10.h),
                                    if (_isEditing)
                                      ProfileEditField(
                                        icon: Icons.person_outline,
                                        label: 'الاسم الأول',
                                        controller: _firstNameCtrl,
                                        valueDirection: TextDirection.rtl,
                                        validator: (v) =>
                                            _validateName(v, 'الاسم الأول'),
                                      )
                                    else
                                      ProfileInfoTile(
                                        icon: Icons.person_outline,
                                        label: 'الاسم الأول',
                                        value: profile.firstName,
                                        valueDirection: TextDirection.rtl,
                                      ),
                                    SizedBox(height: 10.h),
                                    if (_isEditing)
                                      ProfileEditField(
                                        icon: Icons.badge_outlined,
                                        label: 'اسم العائلة',
                                        controller: _lastNameCtrl,
                                        valueDirection: TextDirection.rtl,
                                        validator: (v) =>
                                            _validateName(v, 'اسم العائلة'),
                                      )
                                    else
                                      ProfileInfoTile(
                                        icon: Icons.badge_outlined,
                                        label: 'اسم العائلة',
                                        value: profile.lastName,
                                        valueDirection: TextDirection.rtl,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(16.w, 22.h, 16.w, 0),
                              child: FadeInDown(
                                duration: const Duration(milliseconds: 400),
                                delay: const Duration(milliseconds: 400),
                                child: _sectionHeader(
                                  textTheme,
                                  'بيانات التواصل',
                                ),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: FadeInUp(
                                duration: const Duration(milliseconds: 500),
                                delay: const Duration(milliseconds: 450),
                                child: Column(
                                  children: [
                                    SizedBox(height: 10.h),
                                    // البريد غير قابل للتعديل عبر هذا المسار.
                                    ProfileInfoTile(
                                      icon: Icons.email_outlined,
                                      label: 'البريد الإلكتروني',
                                      value: profile.email,
                                    ),
                                    SizedBox(height: 10.h),
                                    if (_isEditing)
                                      ProfileEditField(
                                        icon: Icons.phone_enabled,
                                        label: 'رقم الهاتف',
                                        controller: _phoneCtrl,
                                        // prefixText: '$_phonePrefix ',
                                        keyboardType: TextInputType.phone,
                                        maxLength: 9,
                                        hintText: '991234567',
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(9),
                                        ],
                                        validator: _validatePhone,
                                      )
                                    else
                                      ProfileInfoTile(
                                        icon: Icons.phone_enabled,
                                        label: 'رقم الهاتف',
                                        value: profile.phone,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(child: SizedBox(height: 30.h)),
                        ] else if (!isLoading) ...[
                          // الفشل يُعرض داخل بطاقة الهوية بالبانر مع زر إعادة المحاولة.
                          SliverToBoxAdapter(child: SizedBox(height: 60.h)),
                        ] else ...[
                          // هياكل shimmer granular مطابقة لمقطع المحتوى الحقيقي.
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: const CompletenessShimmer(),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(16.w, 22.h, 16.w, 0),
                              child: const ContactTilesShimmer(),
                            ),
                          ),
                          SliverToBoxAdapter(child: SizedBox(height: 30.h)),
                        ],

                        // جلسة المستخدم: تسجيل الخروج (يظهر دائماً).
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(16.w, 22.h, 16.w, 0),
                            child: FadeInDown(
                              duration: const Duration(milliseconds: 400),
                              delay: const Duration(milliseconds: 450),
                              child: _sectionHeader(textTheme, 'جلسة المستخدم'),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 10.h,
                            ),
                            child: FadeInUp(
                              duration: const Duration(milliseconds: 500),
                              delay: const Duration(milliseconds: 500),
                              // هيكل shimmer أثناء تحميل بيانات المستخدم.
                              child: isLoading
                                  ? const LogoutTileShimmer()
                                  : _buildLogoutTile(context),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(child: SizedBox(height: 30.h)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// شريط الإجراءات السفلي أثناء التعديل: إلغاء + حفظ مع مؤشر تحميل.
  Widget _buildEditActionBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: _cancelEdit,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: BorderSide(color: AppColors.border),
                  ),
                ),
                child: Text(
                  'إلغاء',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              flex: 2,
              child: BlocBuilder<UpdateUserProfileBloc, UpdateUserProfileState>(
                builder: (context, state) {
                  final bool saving = state is UpdateUserProfileLoading;
                  return FilledButton.icon(
                    onPressed: saving ? null : _onSave,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppColors.secondary.withValues(
                        alpha: 0.6,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    icon: saving
                        ? SizedBox(
                            width: 18.w,
                            height: 18.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.2,
                              color: Colors.white,
                            ),
                          )
                        : Icon(Icons.check_rounded, size: 20.w),
                    label: Text(
                      saving ? 'جارٍ الحفظ…' : 'حفظ التغييرات',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// بطاقة تسجيل الخروج: تنهي الجلسة بعد تأكيد المستخدم.
  Widget _buildLogoutTile(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<LogOutBloc, LogOutState>(
      builder: (context, state) {
        final bool isLoggingOut = state is LogOutLoading;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoggingOut ? null : () => _confirmLogout(context),
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.06),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.25),
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(9.r),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.logout_rounded,
                      size: 24.h,
                      color: AppColors.error,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'تسجيل الخروج',
                          style: textTheme.titleSmall?.copyWith(
                            color: AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'إنهاء الجلسة الحالية على هذا الجهاز',
                          style: textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  if (isLoggingOut)
                    SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: AppColors.error,
                      ),
                    )
                  else
                    Icon(
                      Icons.chevron_left_rounded,
                      color: AppColors.textSecondary,
                      size: 22.w,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// حوار تأكيد ثم إرسال حدث تسجيل الخروج إلى الـ BLoC.
  Future<void> _confirmLogout(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text(
          'هل أنت متأكد من رغبتك في تسجيل الخروج؟ ستحتاج إلى تسجيل الدخول مجدداً للوصول إلى التطبيق.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      if (!context.mounted) return;
      context.read<LogOutBloc>().add(const LogOutRequested());
    }
  }

  void _showFeedback(
    BuildContext context, {
    required String message,
    required bool isError,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? AppColors.error : AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
  }

  /// إعادة التحميل بالسحب: ننتقل لحدث التحديث حتى استقرار الحالة.
  Future<void> _refresh(BuildContext context) async {
    final GetUserProfileBloc bloc = context.read<GetUserProfileBloc>();
    bloc.add(const GetUserProfileRefreshRequested());
    await bloc.stream.firstWhere(
      (state) =>
          state is GetUserProfileSuccess || state is GetUserProfileFailure,
    );
  }

  /// عنوان مقطع بخطافة برتقالية صغيرة (نفس نمط صفحة تواصل معنا).
  Widget _sectionHeader(TextTheme textTheme, String title) {
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
