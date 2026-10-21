import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'features/favorites/presentation/bloc/favorites/favorites_bloc.dart';

class MainNavBar extends StatefulWidget {
  const MainNavBar({super.key, required this.navigationShell});

  /// القشرة الحيّة التي يوفّرها [StatefulShellRoute.indexedStack]؛ تدير
  /// التبديل بين الفروع وتحفظ حالة كل تبويب تلقائياً (عبر IndexedStack).
  final StatefulNavigationShell navigationShell;

  @override
  State<MainNavBar> createState() => _MainNavBarState();
}

class _MainNavBarState extends State<MainNavBar> {
  bool _favoritesBootstrapped = false;

  @override
  void initState() {
    super.initState();
    // [FavoritesBloc] معرَّض على جذر التطبيق (انظر `main.dart`). هذه أول
    // نقطة بعد المصادقة يصل فيها المستخدم إلى الـ shell، فهي المكان
    // الصحيح لإطلاق طلب الجلب لأول مرة بدل إطلاقه في الجذر قبل تسجيل
    // الدخول. العلم `_favoritesBootstrapped` يمنع التكرار إذا أعيد بناء
    // الـ widget لنفس الجلسة؛ عند الخروج والدخول من جديد يُستأنف الطلب
    // بأمان لأن الـ Bloc يُجلب من جديد (idempotent).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _favoritesBootstrapped) return;
      _favoritesBootstrapped = true;
      context.read<FavoritesBloc>().add(const FavoritesRequested());
    });
  }

  void _onDestinationSelected(int index) {
    // التبديل الفوري إلى فرع آخر دون presses رجوع متعددة. عند النقر على
    // التبويب النشط نعود إلى جذره (سلوك pop-to-root الشائع).
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // [navigationShell] يعرض فرع التبويب الحالي فوقه شريط تنقّل دائم.
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.navigationShell.currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view),
            label: 'المنتجات',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'المفضلة',
          ),
          NavigationDestination(
            icon: Icon(Icons.phone),
            selectedIcon: Icon(Icons.phone),
            label: 'تواصل معنا',
          ),
        ],
      ),
    );
  }
}
