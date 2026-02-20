import 'package:flutter/material.dart';
import 'package:astrogram/screen/dashboard/home_screen.dart';
import 'package:astrogram/screen/dashboard/ask_screen.dart';
import 'package:astrogram/screen/dashboard/remedies_screen.dart';
import 'package:astrogram/screen/dashboard/profile_screen.dart';
import 'package:astrogram/widgets/main_drawer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  List<Widget> get _pages => [
    const HomeScreen(),
    const AskScreen(), // Guidance Screen
    const Center(child: Text('AI Astro')), // Astro AI Placeholder
    const RemediesScreen(),
    const ProfileScreen(), // You Screen
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(
          context,
        ).bottomNavigationBarTheme.backgroundColor,
        selectedItemColor: Theme.of(
          context,
        ).bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor: Theme.of(
          context,
        ).bottomNavigationBarTheme.unselectedItemColor,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Guidance'),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology),
            label: 'Astro AI',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.spa), label: 'Remedies'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'You'),
        ],
      ),
    );
  }
}
