import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/routes/nav_paths.dart';
import '../../../products/domain/entities/material_entity.dart';
import '../../../products/presentation/pages/product_details_page.dart';
import '../cubit/search_cubit.dart';
import 'search_suggestions_panel.dart';

/// شريط البحث في الصفحة الرئيسية مع لوحة مرشّحات عائمة (Overlay) أسفله.
///
/// - يكتب المستخدم ⇒ SearchCubit يطبّق debounce ويجلب النتائج.
/// - تظهر اللوحة كـ Overlay عبر LayerLink حتى لا تتأثر slivers في الصفحة.
/// - الضغط على نتيجة ⇒ صفحة تفاصيل المنتج. الإدخال (Enter) أو "عرض الكل"
///   ⇒ صفحة نتائج البحث الكاملة. فقدان التركيز ⇒ إخفاء اللوحة فقط.
class HomeSearchBar extends StatefulWidget {
  const HomeSearchBar({super.key});

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _fieldKey = GlobalKey();

  OverlayEntry? _overlayEntry;
  double _panelWidth = 0;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    _removeOverlay();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus) {
      // فقدان التركيز يُخفي اللوحة دون تنقّل.
      context.read<SearchCubit>().dismiss();
      _syncOverlay();
    }
  }

  bool _shouldShow(SearchState state) {
    final query = _controller.text.trim();
    if (query.length < 2) return false;
    return state is SearchLoading ||
        state is SearchResults ||
        state is SearchEmpty ||
        state is SearchFailure;
  }

  void _syncOverlay() {
    final state = context.read<SearchCubit>().state;
    final shouldShow = _shouldShow(state);

    if (shouldShow && _overlayEntry == null) {
      _insertOverlay();
    } else if (!shouldShow && _overlayEntry != null) {
      _removeOverlay();
    } else if (shouldShow) {
      _overlayEntry?.markNeedsBuild();
    }
  }

  void _measurePanelWidth() {
    final renderObject = _fieldKey.currentContext?.findRenderObject();
    if (renderObject is RenderBox) {
      _panelWidth = renderObject.size.width;
    }
  }

  void _insertOverlay() {
    _measurePanelWidth();
    final entry = OverlayEntry(builder: _buildOverlayContent);
    _overlayEntry = entry;
    Overlay.of(context, rootOverlay: true).insert(entry);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Widget _buildOverlayContent(BuildContext overlayContext) {
    // اللوحة تُدرج في جذر الـ Overlay (rootOverlay) الذي يجلس *فوق*
    // الـ BlocProvider<SearchCubit> المعرّف داخل HomePage، لذا سياق الـ Overlay
    // لا يرى الـ cubit. نلتقطه من سياق هذا الـ Widget (الواقع تحت الـ provider)
    // ونمرّره لأسفل عبر BlocProvider.value حتى يعمل BlocBuilder داخل اللوحة.
    final searchCubit = this.context.read<SearchCubit>();
    // حاجز شفاف لالتقاط النقر خارج اللوحة لإخفائها، ثم اللوحة المتتبعة للحقل.
    return BlocProvider.value(
      value: searchCubit,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                FocusScope.of(overlayContext).unfocus();
                if (mounted) searchCubit.dismiss();
                _removeOverlay();
              },
              child: const SizedBox.expand(),
            ),
          ),
          CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            targetAnchor: Alignment.bottomLeft,
            followerAnchor: Alignment.topLeft,
            offset: Offset(0, 8.h),
            child: SizedBox(
              width: _panelWidth > 0 ? _panelWidth : null,
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  // إخفاء أي وميض أثناء تغيّر النص السريع.
                  if (!_shouldShow(state)) {
                    return const SizedBox.shrink();
                  }
                  return SearchSuggestionsPanel(
                    isLoading: state is SearchLoading,
                    isEmpty: state is SearchEmpty,
                    errorMessage: state is SearchFailure ? state.message : null,
                    items: state is SearchResults ? state.items : const [],
                    showSeeAll: state is SearchResults && state.truncated,
                    onSelect: _onSelectSuggestion,
                    onSeeAll: () => _openResultsPage(_controller.text.trim()),
                    onRetry: () => searchCubit.retry(_controller.text),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSelectSuggestion(MaterialEntity material) {
    _focusNode.unfocus();
    context.read<SearchCubit>().dismiss();
    _removeOverlay();
    context.push(
      NavPaths.withinBranch(context, NavPaths.details),
      extra: ProductDetailsArgs(
        name: material.displayTitle,
        price: material.consumerPriceLabel,
        priceInSp: material.customerPriceInSpLabel,
        image: material.image ?? '',
        desc: material.displayDescription,
        category: material.categoryName,
        materialId: material.id,
        specifications: material.specifications,
        infoUrl: material.infoUrl,
        infoFile: material.infoFile,
      ),
    );
  }

  void _openResultsPage(String query) {
    if (query.isEmpty) return;
    _focusNode.unfocus();
    context.read<SearchCubit>().dismiss();
    _removeOverlay();
    context.push(NavPaths.withinBranch(context, NavPaths.search), extra: query);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return CompositedTransformTarget(
      link: _layerLink,
      child: LayoutBuilder(
        builder: (context, constraints) {
          _panelWidth = constraints.maxWidth;
          return Container(
            key: _fieldKey,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18.r),
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
            ),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              textInputAction: TextInputAction.search,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
              ),
              onChanged: (value) {
                context.read<SearchCubit>().onQueryChanged(value);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) _syncOverlay();
                });
              },
              onSubmitted: (value) => _openResultsPage(value.trim()),
              decoration: InputDecoration(
                hintText: 'ابحث عن منتج...',
                hintStyle: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 24.w,
                  color: AppColors.primary,
                ),
                suffixIcon: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _controller,
                  builder: (context, value, _) {
                    if (value.text.isEmpty) return const SizedBox.shrink();
                    return IconButton(
                      onPressed: () {
                        _controller.clear();
                        context.read<SearchCubit>().dismiss();
                        _removeOverlay();
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.close_rounded,
                        size: 20.w,
                        color: AppColors.textSecondary,
                      ),
                    );
                  },
                ),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 18.w,
                  vertical: 16.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18.r),
                  borderSide: BorderSide(
                    color: AppColors.blue100.withValues(alpha: 0.7),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18.r),
                  borderSide: BorderSide(
                    color: AppColors.primary,
                    width: 1.4.w,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
