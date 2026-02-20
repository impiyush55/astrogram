import 'package:astrogram/helper/color.dart';
import 'package:astrogram/helper/custom_text.style.dart';
import 'package:astrogram/screen/dashboard/dashboard_screen.dart';
import 'package:astrogram/screen/starting/login_screen.dart';
import 'package:astrogram/widgets/my_text_button.dart';
import 'package:astrogram/widgets/mystic_celestial_core.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 12),
            child: InkWell(
              // Use InkWell for better touch feedback
              onTap: () {
                debugPrint("Skip button pressed"); // Debug print to verify tap
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const DashboardScreen(),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(
                    0.15,
                  ), // Slightly more visible
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                  ), // Adding border for visibility
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      "Skip",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.4), // Slightly above center
            radius: 1.1,
            colors: AppColors.radialDarkGradient,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 1),

              // 🔮 Mystic Celestial Core Animation (Replaces static image)
              const MysticCelestialCore(size: 320),

              const SizedBox(height: 20),

              // ✨ Premium Typography
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Text(
                      "Unveil Your Destiny",
                      textAlign: TextAlign.center,
                      style: myTextStyle28(
                        fontweight: FontWeight.w300,
                        textColor: Colors.white,
                        fontFamily: "secondary", // Elegant Serif
                      ).copyWith(letterSpacing: 1.2),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Get ",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: AppColors.goldGradient,
                          ).createShader(bounds),
                          child: Text(
                            "Free Chat",
                            style: myTextStyle28(
                              fontweight: FontWeight.bold,
                              fontFamily: "secondary",
                              textColor:
                                  Colors.white, // Will be masked by gradient
                            ),
                          ),
                        ),
                        Text(
                          " Now!",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Connect with elite astrologers for instant guidance on Love, Career & Life path.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 14,
                        height: 1.5,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // 🚀 Premium Glowing Button
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(
                          0xFFFFD700,
                        ).withOpacity(0.4), // Increased opacity
                        blurRadius: 30, // Increased blur
                        spreadRadius: 4, // Increased spread
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: MyTextButton(
                    btnText: 'Start Free Chat',
                    onPress: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    borderRadius: 16,
                    btnBackgroundColor: const Color(0xFFFFD700),
                    // Assuming MyTextButton needs text color tweak inside,
                    // usually gold bg means black text is best.
                    // If MyTextButton defaults to white text, we might need a custom version
                    // or ensure it accepts a textColor parameter if accessible.
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
