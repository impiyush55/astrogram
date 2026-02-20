import 'package:astrogram/helper/color.dart';
import 'package:astrogram/helper/custom_text.style.dart';
import 'package:astrogram/screen/starting/otp_screen.dart';
import 'package:astrogram/widgets/my_text_button.dart';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size mqData = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  // Custom Back Button
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.all(8),
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
                    "Welcome Back",
                    style: myTextStyle28(
                      fontweight:
                          FontWeight.w700, // Reduced weight for elegance
                      textColor: Colors.white,
                      fontFamily: "secondary", // Premium Font
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Enter your mobile number to continue\nyour spiritual journey",
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.white60,
                    ),
                  ),

                  SizedBox(height: mqData.height * 0.06),

                  // Label
                  Text(
                    "Mobile Number",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary, // Gold
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Input Field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.05),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "+91",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(height: 24, width: 1, color: Colors.white24),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              letterSpacing: 1.0,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "88888 88888",
                              hintStyle: TextStyle(color: Colors.white24),
                              counterText: "",
                            ),
                            maxLength: 10,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: mqData.height * 0.35), // push button down
                  // Get OTP Button
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.25),
                          blurRadius: 20,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: MyTextButton(
                      btnText: "Get OTP",
                      borderRadius: 30, // Rounder for premium feel
                      btnBackgroundColor: AppColors.primary,
                      onPress: () async {
                        if (_phoneController.text.length == 10) {
                          // Show Loading
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
                          // Call API (Add your actual URL in auth_service.dart)
                          bool success = await authService.sendOtp(
                            _phoneController.text,
                          );

                          if (context.mounted) {
                            Navigator.pop(context); // Hide loading
                          }

                          if (success) {
                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OtpScreen(
                                    phoneNumber: _phoneController.text,
                                  ),
                                ),
                              );
                            }
                          } else {
                            // Show Error
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Failed to send OTP.",
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
                              content: Text(
                                "Please enter a valid 10-digit number",
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
                  SizedBox(height: mqData.height * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
