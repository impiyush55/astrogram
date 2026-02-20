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
  // late Size mqData = MediaQuery.of(context).size; // Error safe init
  String? otpCode;

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.darkGradient,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SizedBox(
              height:
                  mqData.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(
                    context,
                  ).padding.bottom, // Full height constraint
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  // Custom Back Button
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white24, width: 0.5),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),

                  SizedBox(height: mqData.height * 0.04),

                  // Premium Title
                  Text(
                    "Verify Mobile",
                    style: myTextStyle28(
                      fontweight: FontWeight.w700,
                      textColor: Colors.white,
                      fontFamily: "secondary",
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Enter the 4-digit code sent to \n+91-${widget.phoneNumber}",
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.white60,
                    ),
                  ),

                  SizedBox(height: mqData.height * 0.06),

                  // OTP Input
                  Center(
                    child: Pinput(
                      length: 4,
                      showCursor: true,
                      onCompleted: (pin) => otpCode = pin,
                      keyboardType: TextInputType.number,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      defaultPinTheme: PinTheme(
                        height: 60,
                        width: 60,
                        textStyle: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white24),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      focusedPinTheme: PinTheme(
                        height: 60,
                        width: 60,
                        textStyle: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.primary),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: mqData.height * 0.05),

                  // Verify Button
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.25),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: MyTextButton(
                      btnText: "Verify & Proceed",
                      borderRadius: 30,
                      btnBackgroundColor: AppColors.primary,
                      onPress: () async {
                        if (otpCode != null && otpCode!.length == 4) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          );

                          final authService = AuthService();
                          final responseData = await authService.verifyOtp(
                            widget.phoneNumber,
                            otpCode!,
                          );

                          if (context.mounted) {
                            Navigator.pop(context);
                          }

                          if (responseData != null) {
                            String? userId =
                                responseData['id']?.toString() ??
                                responseData['userId']?.toString() ??
                                responseData['_id']?.toString() ??
                                widget
                                    .phoneNumber; // Do not allow ID to be null
                            String? token = responseData['token']?.toString();

                            // 1. Initial Session Update
                            AuthService.updateSession(
                              userId: userId,
                              token: token,
                              phone: widget.phoneNumber,
                            );

                            // 2. Immediately try to fetch full user profile
                            debugPrint("Fetching full profile after login...");
                            try {
                              await authService.fetchUserProfile(
                                widget.phoneNumber,
                              );
                            } catch (e) {
                              debugPrint(
                                "Profile fetch failed, proceeding anyway: $e",
                              );
                            }

                            if (context.mounted) {
                              Navigator.pop(
                                context,
                              ); // Pop current (OTP screen)
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const EnterDetailsScreen(),
                                ),
                              );
                            }
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    "Invalid OTP. Please try again.",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.red.shade900,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            }
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                "Please enter a valid 4-digit OTP",
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red.shade900,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),

                  // Resend Text
                  const SizedBox(height: 24),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Didn't receive code? ",
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: "Resend",
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const TextSpan(text: " in 60s"),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Footer / Alternate Login
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Row(
                      children: const [
                        Expanded(child: Divider(color: Colors.white24)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "OR",
                            style: TextStyle(color: Colors.white24),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.white24)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.blue.withOpacity(0.5)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue.withOpacity(0.05),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.wifi_calling_3, color: Colors.blue),
                          SizedBox(width: 12),
                          Text(
                            "Login with Truecaller",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
