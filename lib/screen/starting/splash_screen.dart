import 'package:astrogram/screen/starting/start_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const StartScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // medial query
    final mqData = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,

        children: [
          Image.asset("lib/assets/images/splash.png", fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.4)),

          // logo + app name
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                // Image.asset(
                //   "lib/assets/icons/app_logo.png",
                //   height: mqData.height * 0.18,
                // ),
                const SizedBox(height: 16),

                // App Name
                // Text(
                //   "Devine",
                //   style: myTextStyle36(
                //     fontweight: FontWeight.bold,
                //     textColor: Colors.white,
                //     //fontFamily: "secondary",
                //   ),
                ///),
                const SizedBox(height: 6),
                // Tagline (optional but recommended)
                // Text(
                //   "Astrology • Matrimony • Guidance",
                //   style: myTextStyle18(textColor: Colors.white70),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
