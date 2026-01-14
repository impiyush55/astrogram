import 'package:flutter/material.dart';
import 'package:astrogram/screen/dashboard/home_screen.dart';
import 'package:astrogram/screen/dashboard/live_screen.dart'; // Ensure this file exists

import 'package:astrogram/screen/dashboard/ask_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // Placeholder for screens that are not implemented yet or imported
  List<Widget> get _pages => [
    const HomeScreen(),
    const Center(child: Text('AI Astro')),
    const LiveScreen(), // Use actual widget if available
    const AskScreen(), // Using AskScreen for the 'Ask' tab
    const Center(child: Text('Sign Up')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: const Color(0xFFFFD700), // Match the gold theme
        unselectedItemColor: Colors.white54,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: 'AI Astro',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: 'Live'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Ask'),
          BottomNavigationBarItem(icon: Icon(Icons.healing), label: 'Remedies'),
        ],
      ),
    );
  }
}
