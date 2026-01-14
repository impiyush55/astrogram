import 'package:astrogram/screen/starting/start_screen.dart';
import 'package:flutter/material.dart';

import '../../helper/custom_text.style.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
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
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(1000),

              child: Image.asset(
                "lib/assets/icons/app_logo.png",
                height: mqData.height * 0.2,
                width: mqData.height * 0.2,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 12),

            Text(
              "Devine",
              style: myTextStyle36(
                fontweight: FontWeight.bold,
                textColor: Colors.white,
                //fontFamily: "secondary",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
