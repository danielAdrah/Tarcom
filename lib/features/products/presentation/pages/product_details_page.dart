import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/routes/route_imports.dart';
import '../../../favorites/presentation/bloc/favorites/favorites_bloc.dart';

/// بيانات المنتج التي تمرَّر عبر الـ route extra من القوائم إلى صفحة التفاصيل.
class ProductDetailsArgs {
  const ProductDetailsArgs({
    required this.name,
    required this.price,
    required this.image,
    required this.desc,
    required this.category,
    this.materialId,
    this.priceInSp = '',
    this.specifications = const [],
    this.infoUrl,
    this.infoFile,
  });

  final String name;
  final String price;
  final String image;
  final String desc;
  final String category;
  // معرّف المادة المستخدم لتبديل المفضلة. قد يكون غائباً في المسارات القديمة.
  final int? materialId;
  // سعر المستهلك بالليرة السورية نصياً (مثل "25,200")؛ قد يغيب في المسارات القديمة.
  final String priceInSp;
  final List<MapEntry<String, String>> specifications;
  // رابط/ملف المعلومات الاختياريان القادمان من الـ API؛ قد يغيبان في المسارات القديمة.
  final String? infoUrl;
  final String? infoFile;
}

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({
    super.key,
    required this.proName,
    required this.proPrice,
    required this.proImage,
    required this.proDesc,
    required this.proCategory,
    this.materialId,
    this.proPriceInSp = '',
    this.infoUrl,
    this.infoFile,
    this.specifications = const [
      MapEntry('المعالج', 'Core i5 13 H'),
      MapEntry('الرام', '16G DDR5'),
      MapEntry('كرت الشاشة', 'RTX 4050 6G'),
      MapEntry('الهارد', 'SSD 512'),
      MapEntry('الشاشة', '16.5 FHD'),
    ],
  });

  final List<MapEntry<String, String>> specifications;
  final String proName;
  final String proPrice;
  final String proImage;
  final String proDesc;
  final String proCategory;
  final int? materialId;
  final String proPriceInSp;
  // رابط معلوماتي (info_url) وملف معلوماتي (info_file) اختياريان.
  final String? infoUrl;
  final String? infoFile;

  @override
  Widget build(BuildContext context) {
    // [FavoritesBloc] مشترك على مستوى الـ shell (انظر `route_main.dart`)،
    // فيظهر القلب ممتلئاً إن كان المنتج محفوظاً، وينعكس أي تبديل هنا
    // فوراً على صفحة المفضلة دون إعادة بناء الـ Bloc.
    return _ProductDetailsView(
      proName: proName,
      proPrice: proPrice,
      proImage: proImage,
      proDesc: proDesc,
      proCategory: proCategory,
      materialId: materialId,
      proPriceInSp: proPriceInSp,
      infoUrl: infoUrl,
      infoFile: infoFile,
      specifications: specifications,
    );
  }
}

class _ProductDetailsView extends StatefulWidget {
  const _ProductDetailsView({
    required this.proName,
    required this.proPrice,
    required this.proImage,
    required this.proDesc,
    required this.proCategory,
    required this.materialId,
    required this.proPriceInSp,
    required this.specifications,
    this.infoUrl,
    this.infoFile,
  });

  final List<MapEntry<String, String>> specifications;
  final String proName;
  final String proPrice;
  final String proImage;
  final String proDesc;
  final String proCategory;
  final int? materialId;
  final String proPriceInSp;
  final String? infoUrl;
  final String? infoFile;

  @override
  State<_ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<_ProductDetailsView> {
  static const int _initialSpecificationCount = 4;
  bool _showAllSpecifications = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: BlocListener<FavoritesBloc, FavoritesState>(
          // نعرض رسالة لمرة واحدة عند تغيّرها فقط (نجاح/فشل التبديل).
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
                ),
                //Product image
                SliverToBoxAdapter(
                  child: Container(
                    height: 250.h,
                    margin: EdgeInsets.symmetric(
                      vertical: 5.r,
                      horizontal: 15.r,
                    ),
                    padding: EdgeInsets.all(16.r),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: AppColors.surface.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(child: _buildProductImage()),
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
                          widget.proName.isNotEmpty ? widget.proName : 'منتج',
                          style: textTheme.displaySmall?.copyWith(
                            color: const Color.fromARGB(255, 82, 90, 105),
                          ),
                        ),
                        //product category
                        if (widget.proCategory.isNotEmpty)
                          Text(
                            widget.proCategory,
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        SizedBox(height: 10.h),
                        //product price
                        if (widget.proPrice.isNotEmpty ||
                            widget.proPriceInSp.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: AppColors.primary.withValues(
                                  alpha: 0.35,
                                ),
                                width: 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.05,
                                  ),
                                  blurRadius: 16.r,
                                  offset: Offset(0, 5.h),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (widget.proPrice.isNotEmpty)
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    textDirection: TextDirection.rtl,
                                    children: [
                                      Icon(
                                        Icons.sell_outlined,
                                        color: AppColors.secondary,
                                        size: 22.r,
                                      ),
                                      SizedBox(width: 10.w),
                                      Text(
                                        '${widget.proPrice}\$',
                                        textDirection: TextDirection.rtl,
                                        style: textTheme.headlineMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.secondary,
                                            ),
                                      ),
                                    ],
                                  ),
                                // السعر بالليرة السورية (customer_price_in_sp) أسفل سعر الدولار.
                                if (widget.proPriceInSp.isNotEmpty) ...[
                                  if (widget.proPrice.isNotEmpty) ...[
                                    SizedBox(height: 10.h),
                                    Divider(
                                      height: 1.h,
                                      color: AppColors.divider,
                                    ),
                                    SizedBox(height: 10.h),
                                  ],
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    textDirection: TextDirection.rtl,
                                    children: [
                                      Icon(
                                        Icons.currency_lira_rounded,
                                        color: AppColors.primary,
                                        size: 18.r,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        '${widget.proPriceInSp} ل.س',
                                        textDirection: TextDirection.rtl,
                                        style: textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      SizedBox(width: 2),
                                      Text(
                                        '(السعر بالليرة)',
                                        style: textTheme.labelSmall?.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // container with key-value specs for the product
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    vertical: 5.h,
                    horizontal: 10.w,
                  ),
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
                          widget.proDesc.isNotEmpty
                              ? widget.proDesc
                              : 'لا يوجد وصف متاح لهذا المنتج.',
                          style: textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),

                // قسم المعلومات الإضافية: يظهر فقط عند وجود info_url أو info_file.
                if (_hasAdditionalInfo)
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.h,
                      horizontal: 10.w,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: _buildAdditionalInfo(context),
                    ),
                  ),

                // زر المفضلة: يبدّل حالة حفظ المنتج عبر [FavoritesBloc].
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 15.h,
                    ),
                    child: _buildFavoriteButton(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// يبني زر المفضلة اعتماداً على حالة القلب لهذا المنتج من [FavoritesBloc]:
  /// قلب ممتلئ عند الإضافة، مع مؤشّر تحميل أثناء التبديل.
  Widget _buildFavoriteButton() {
    final materialId = widget.materialId;
    // لا معرّف: تعذّر التبديل، نُبقي الزر معطّلاً.
    if (materialId == null) {
      return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
        onPressed: null,
        icon: const Icon(Icons.favorite_border),
        label: const Text("أضف إلى المفضلة"),
      );
    }

    final isFavorite = context.select<FavoritesBloc, bool>((bloc) {
      final state = bloc.state;
      return state is FavoritesSuccess && state.isFavorite(materialId);
    });
    final isToggling = context.select<FavoritesBloc, bool>((bloc) {
      final state = bloc.state;
      return state is FavoritesSuccess && state.isToggling(materialId);
    });

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: isFavorite ? AppColors.error : AppColors.secondary,
      ),
      onPressed: isToggling
          ? null
          : () => context.read<FavoritesBloc>().add(
              FavoriteToggled(materialId: materialId),
            ),
      icon: isToggling
          ? SizedBox(
              width: 18.r,
              height: 18.r,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
      label: Text(isFavorite ? "إزالة من المفضلة" : "أضف إلى المفضلة"),
    );
  }

  /// بديل shimmer أثناء تحميل الصورة من الكاش/الشبكة.
  Widget _imageShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: AppColors.skeletonBase,
      highlightColor: AppColors.skeletonHighlight,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
    );
  }

  // الصورة: رابط من الـ API أو أصل محلي من الأصول، مع معالجة الأخطاء.
  Widget _buildProductImage() {
    final image = widget.proImage;

    if (image.isEmpty) {
      return _imageFallback();
    }

    if (image.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: image,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.contain,
        alignment: Alignment.center,
        fadeInDuration: const Duration(milliseconds: 250),
        placeholder: (context, url) => _imageShimmerPlaceholder(),
        errorWidget: (context, url, error) => _imageFallback(),
      );
    }

    return Image.asset(
      image,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.contain,
      alignment: Alignment.center,
      filterQuality: FilterQuality.high,
      errorBuilder: (context, error, stackTrace) => _imageFallback(),
    );
  }

  Widget _imageFallback() {
    return Icon(
      Icons.image_not_supported_outlined,
      size: 42.r,
      color: AppColors.textSecondary,
    );
  }

  // ---------------------- المعلومات الإضافية (info_url / info_file) ----------------------

  static const _imageExtensions = {'png', 'jpg', 'jpeg', 'gif', 'webp', 'bmp'};

  /// هل تتوفر معلومات إضافية لعرضها؟ (رابط أو ملف غير فارغين)
  bool get _hasAdditionalInfo => _hasInfoUrl || _hasInfoFile;

  bool get _hasInfoUrl => (widget.infoUrl?.trim().isNotEmpty ?? false);

  bool get _hasInfoFile => (widget.infoFile?.trim().isNotEmpty ?? false);

  /// استخراج الامتداد السفلي لمسار الرابط مع تجاهل السلسلة الاستعلامية.
  String _extensionOf(String url) {
    try {
      final path = Uri.parse(url).path;
      final dot = path.lastIndexOf('.');
      return dot == -1 ? '' : path.substring(dot + 1).toLowerCase();
    } catch (_) {
      return '';
    }
  }

  /// هل ملف المعلومات صورة؟ (نعم إن كان الامتداد ضمن الصور المعروفة)
  bool get _infoFileIsImage =>
      _imageExtensions.contains(_extensionOf(widget.infoFile ?? ''));

  /// فتح رابط في التطبيق الخارجي (المتصفح)، مع رسالة خطأ عند الفشل.
  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.isAbsolute) return;

    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      _showInfoSnack(context, 'تعذّر فتح الرابط على هذا الجهاز.');
    }
  }

  void _showInfoSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(12.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      );
  }

  /// معاينة صورة المعلومات بالحجم الكامل عند النقر.
  void _showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => _imageShimmerPlaceholder(),
                  errorWidget: (context, url, error) => _imageFallback(),
                ),
              ),
            ),
            PositionedDirectional(
              top: 12,
              end: 12,
              child: IconButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                icon: const Icon(Icons.close_rounded, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// يبني حاوية المعلومات الإضافية بأسلوب مطابق لحاوية المواصفات.
  Widget _buildAdditionalInfo(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
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
                  Icons.info_outline_rounded,
                  color: AppColors.primary,
                  size: 20.r,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  'معلومات إضافية',
                  textDirection: TextDirection.rtl,
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (_hasInfoUrl) _buildInfoUrlTile(context, textTheme),
          if (_hasInfoFile) ...[
            if (_hasInfoUrl) Divider(height: 20.h, color: AppColors.divider),
            _buildInfoFileTile(context, textTheme),
          ],
        ],
      ),
    );
  }

  /// بلاطة فتح رابط المعلومات في المتصفح.
  Widget _buildInfoUrlTile(BuildContext context, TextTheme textTheme) {
    final url = widget.infoUrl!;
    return InkWell(
      onTap: () => _openUrl(context, url),
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.blue50,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            Icon(Icons.link_rounded, color: AppColors.primary, size: 20.r),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'للمزيد من المعلومات افتح هذا الرابط',
                    textDirection: TextDirection.rtl,
                    style: textTheme.titleSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    url,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.ltr,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.open_in_new_rounded,
              color: AppColors.primary,
              size: 18.r,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoFileTile(BuildContext context, TextTheme textTheme) {
    final file = widget.infoFile!;

    if (_infoFileIsImage) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Icon(Icons.image_outlined, color: AppColors.primary, size: 20.r),
              SizedBox(width: 10.w),
              Text(
                'صورة معلوماتية',
                textDirection: TextDirection.rtl,
                style: textTheme.titleSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          InkWell(
            onTap: () => _showFullImage(context, file),
            borderRadius: BorderRadius.circular(12.r),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: CachedNetworkImage(
                imageUrl: file,
                height: 220.h,
                fit: BoxFit.contain,
                width: double.infinity,
                placeholder: (context, url) => _imageShimmerPlaceholder(),
                errorWidget: (context, url, error) => _imageFallback(),
              ),
            ),
          ),
        ],
      );
    }

    // PDF أو نوع غير معروف: نعرض الملف عبر التطبيق الخارجي (المتصفح/قارئ PDF)
    // ما يتيح مشاهدته وتنزيله دون الحاجة إلى FileProvider أو حزم إضافية.
    return InkWell(
      onTap: () => _openUrl(context, file),
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.orange50,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            Icon(
              Icons.picture_as_pdf_rounded,
              color: AppColors.orange800,
              size: 22.r,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                'عرض / تنزيل الملف (PDF)',
                textDirection: TextDirection.rtl,
                style: textTheme.titleSmall?.copyWith(
                  color: AppColors.orange800,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Icon(
              Icons.download_rounded,
              color: AppColors.orange800,
              size: 18.r,
            ),
          ],
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
