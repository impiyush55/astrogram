import 'package:astrogram/helper/color.dart';
import 'package:astrogram/screen/starting/splash_screen.dart';
import 'package:flutter/material.dart';

// Global Notifier for Theme Switching
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Devine',
          themeMode: currentMode,
          // Defines the Light Theme
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: AppColors.lightBackground,
            primaryColor: AppColors.primaryPurple,
            useMaterial3: true,
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryPurple,
              secondary: AppColors.goldAccent,
              surface: AppColors.lightCard,
              onSurface: AppColors.lightTextPrimary,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.lightBackground,
              foregroundColor: AppColors.lightTextPrimary,
              elevation: 0,
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: AppColors.lightCard,
              selectedItemColor: AppColors.goldAccent,
              unselectedItemColor: AppColors.lightTextSecondary,
            ),
          ),
          // Defines the Dark Theme
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: AppColors.darkBackground,
            primaryColor: AppColors.primaryPurple,
            useMaterial3: true,
            colorScheme: const ColorScheme.dark(
              primary: AppColors.goldAccent,
              secondary: AppColors.secondaryPurple,
              surface: AppColors.darkCard,
              onSurface: AppColors.darkTextPrimary,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.darkBackground,
              foregroundColor: AppColors.darkTextPrimary,
              elevation: 0,
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: AppColors.darkCard,
              selectedItemColor: AppColors.goldAccent,
              unselectedItemColor: AppColors.darkTextSecondary,
            ),
          ),
          builder: (context, child) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: child,
              ),
            );
          },
          home: SplashScreen(),
        );
      },
    );
  }
}
