import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/search_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/help_screen.dart';
import '../theme/app_colors.dart';

// Scaffold Principal con BottomNavigationBar
// Contiene las 4 pantallas principales: Home, Search, Profile y Help
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  // Lista de pantallas para el BottomNavigationBar
  final List<Widget> _screens = const[
     HomeScreen(),
     SearchScreen(),
     ProfileScreen(),
     HelpScreen(),
  ];

  final List<NavigationItem> _items = const [
    NavigationItem(icon: Icons.home_rounded, label:'Inicio'),
    NavigationItem(icon: Icons.search_rounded, label: 'Buscar'),
    NavigationItem(icon: Icons.person_rounded, label: 'Perfil'),
    NavigationItem(icon: Icons.help_outline_rounded, label: 'Ayuda'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration:  const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.surfaceVariant, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: _items.map((item)=> BottomNavigationBarItem(
            icon: Icon(item.icon),
            label: item.label,
            )).toList(),
          
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