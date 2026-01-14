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
        backgroundColor: AppColors.lightBackground,
        appBar: AppBar(
          backgroundColor: AppColors.lightBackground,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: mqData.height * 0.02),
                Text(
                  "Enter your mobile number",
                  style: myTextStyle24(
                    fontweight: FontWeight.bold,
                    textColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "We will send you an OTP to verify",
                  style: myTextStyle15(textColor: Colors.white70),
                ),
                SizedBox(height: mqData.height * 0.05),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "+91",
                        style: myTextStyle18(
                          fontweight: FontWeight.bold,
                          textColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(height: 30, width: 1, color: Colors.white12),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: myTextStyle18(textColor: Colors.white),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Phone Number",
                            hintStyle: TextStyle(color: Colors.white54),
                            counterText: "",
                          ),
                          maxLength: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: MyTextButton(
                    btnText: "Get OTP",
                    borderRadius: 16,
                    onPress: () async {
                      if (_phoneController.text.length == 10) {
                        // Show Loading
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        );

                        final authService = AuthService();
                        // Call API (Add your actual URL in auth_service.dart)
                        bool success = await authService.sendOtp(
                          _phoneController.text,
                        );

                        // For demo purposes, we might want to bypass if API is not real yet.
                        // But since user asked for integration, we assume they will put real URL.
                        // IF YOU WANT TO TEST WITHOUT API: Comment out the 'success' check below.

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
                                  "Failed to send OTP. Check internet or API URL.",
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
                              "Please enter a valid 10-digit number",
                              style: myTextStyle15(textColor: Colors.white),
                            ),
                            backgroundColor: Colors.red,
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
    );
  }
}
