import 'package:flutter/material.dart';

import 'core/constants/colors.dart';
import 'features/contact-us/presentation/pages/contactUs_page.dart';
import 'features/favorites/presentation/pages/favorites_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/products/presentation/pages/products_category_page.dart';

class MainNavBar extends StatefulWidget {
  const MainNavBar({super.key});

  @override
  State<MainNavBar> createState() => _MainNavBarState();
}

class _MainNavBarState extends State<MainNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomePage(),
    ProductsCategoryPage(),
    FavoritesPage(),
    ContactusPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,

        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
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
