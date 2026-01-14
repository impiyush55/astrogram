import 'package:astrogram/helper/custom_text.style.dart';
import 'package:astrogram/widgets/my_text_button.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../../services/auth_service.dart';

import '../../helper/color.dart';
import '../starting/enter_details_screen.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late Size mqData = MediaQuery.of(context).size;
  String? otpCode;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,

      /// app bar
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        title: Text("Verify Phone", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),

      /// body
      body: SafeArea(
        child: Column(
          children: [
            Divider(color: Colors.white24),

            SizedBox(height: mqData.height * 0.05),

            Text(
              "OTP sent to +91-${widget.phoneNumber}",
              style: myTextStyle18(
                textColor: Colors.green,
                fontweight: FontWeight.bold,
              ),
            ),

            SizedBox(height: mqData.height * 0.05),

            /// here we show pin box
            Pinput(
              length: 4,
              showCursor: true,
              onCompleted: (pin) => otpCode = pin,

              /// number keyboard show
              keyboardType: TextInputType.number,

              /// space between box
              separatorBuilder: (index) => SizedBox(width: mqData.width * 0.05),

              defaultPinTheme: PinTheme(
                height: 50,
                width: 50,
                textStyle: myTextStyle24(textColor: Colors.white),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            SizedBox(height: mqData.height * 0.025),

            /// Submit buton
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: mqData.width,
                child: MyTextButton(
                  btnText: "SUBMIT",
                  borderRadius: 12,
                  onPress: () async {
                    if (otpCode != null && otpCode!.length == 4) {
                      // Show Loading
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) =>
                            const Center(child: CircularProgressIndicator()),
                      );

                      final authService = AuthService();
                      // Call Verify API
                      final responseData = await authService.verifyOtp(
                        widget.phoneNumber,
                        otpCode!,
                      );

                      if (context.mounted) {
                        Navigator.pop(context); // Hide loading
                      }

                      if (responseData != null) {
                        // Success!
                        // You can store the token here using SharedPreferences if you want.

                        if (context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EnterDetailsScreen(),
                            ),
                          );
                        }
                      } else {
                        // Fail
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Invalid OTP. Please try again.",
                                style: myTextStyle15(textColor: Colors.white),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Please enter a valid 4-digit OTP",
                            style: myTextStyle15(textColor: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),

            /// resSend button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 26,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Resend OTP available in 60 s ",
                    style: myTextStyle18(
                      textColor: Colors.green,
                      fontweight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            /// divider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(child: Divider(thickness: 2, color: Colors.white24)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "or",
                      style: myTextStyle21(
                        fontweight: FontWeight.bold,
                        textColor: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(thickness: 2, color: Colors.white24)),
                ],
              ),
            ),

            SizedBox(height: mqData.height * 0.05),

            /// Login with true caller
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {},

                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                    side: BorderSide(width: 1, color: Colors.blue),
                  ),
                  backgroundColor: const Color(0xFF1E1E1E),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_calling_3, size: 31, color: Colors.blue),
                      SizedBox(width: 16),
                      Text(
                        "Login with Truecaller",
                        style: myTextStyle21(
                          fontweight: FontWeight.bold,
                          textColor: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
