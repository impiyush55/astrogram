import 'package:astrogram/helper/custom_text.style.dart';
import 'package:astrogram/screen/dashboard/dashboard_screen.dart';
import 'package:astrogram/screen/starting/login_screen.dart';
import 'package:astrogram/widgets/my_text_button.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0, top: 8, bottom: 8),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardScreen(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24),
                ),
                child: Text(
                  "Skip",
                  style: myTextStyle18(
                    textColor: Colors.white,
                    fontweight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Image.asset(
                        "lib/assets/images/group.jpg",
                        height: mqData.height * 0.4, // Limit image height
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),

                      SizedBox(height: mqData.height * 0.05),

                      Text(
                        "Congratulations you got a ",
                        style: myTextStyle24(
                          fontweight: FontWeight.w900,
                          textColor: Colors.white,
                          fontFamily: "secondary",
                        ),
                      ),
                      Text(
                        "Free Chat !",
                        style: myTextStyle24(
                          fontweight: FontWeight.w900,
                          fontFamily: "secondary",
                          textColor: const Color(0xFFFFD700),
                        ),
                      ),

                      const Spacer(),
                      //start button
                      SizedBox(
                        width: mqData.width * 0.9,
                        child: MyTextButton(
                          btnText: 'Start Free Chat',
                          onPress: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => LoginScreen()),
                            );
                          },
                          borderRadius: 0,
                        ),
                      ),

                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
