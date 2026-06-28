import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

import '../screens/home_screen.dart';
import '../screens/search_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/help_screen.dart';
import '../theme/app_colors.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    SearchScreen(),
    ProfileScreen(),
    HelpScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    final items = [
      NavigationItem(icon: Icons.home_rounded,       label: l.navHome),
      NavigationItem(icon: Icons.search_rounded,     label: l.navSearch),
      NavigationItem(icon: Icons.person_rounded,     label: l.navProfile),
      NavigationItem(icon: Icons.help_outline_rounded, label: l.navHelp),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.surfaceVariant, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: items
              .map((item) => BottomNavigationBarItem(
                    icon: Icon(item.icon),
                    label: item.label,
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String label;
  const NavigationItem({required this.icon, required this.label});
}
