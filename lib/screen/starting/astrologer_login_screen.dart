import 'package:flutter/material.dart';
import '../../helper/color.dart';
import '../../helper/custom_text.style.dart';
import '../../widgets/my_text_button.dart';

class AstrologerLoginScreen extends StatefulWidget {
  const AstrologerLoginScreen({super.key});

  @override
  State<AstrologerLoginScreen> createState() => _AstrologerLoginScreenState();
}

class _AstrologerLoginScreenState extends State<AstrologerLoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                // Back Button
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

                // Title
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.goldAccent.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: AppColors.goldAccent,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Partner Login",
                          style: myTextStyle28(
                            fontweight: FontWeight.w700,
                            textColor: Colors.white,
                            fontFamily: "secondary",
                          ),
                        ),
                        Text(
                          "Welcome back, Expert",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: mqData.height * 0.06),

                // Form Fields
                _buildLabel("Expert ID / Registered Email"),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _idController,
                  hint: "Enter your ID",
                  icon: Icons.person_outline_rounded,
                ),

                const SizedBox(height: 24),

                _buildLabel("Security Password"),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _passwordController,
                  hint: "••••••••",
                  icon: Icons.lock_outline_rounded,
                  isPassword: true,
                  obscureText: _obscurePassword,
                  onToggleVisibility: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),

                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: AppColors.goldAccent),
                    ),
                  ),
                ),

                SizedBox(height: mqData.height * 0.1),

                // Login Button
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.goldAccent.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: MyTextButton(
                    btnText: "Authenticate",
                    borderRadius: 16,
                    btnBackgroundColor: AppColors.goldAccent,
                    onPress: () {
                      // Logic for astrologer login
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Expert authentication coming soon!"),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 40),
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Not a partner yet?",
                        style: TextStyle(color: Colors.white.withOpacity(0.5)),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Join our community of experts",
                          style: TextStyle(
                            color: AppColors.goldAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.goldAccent,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.goldAccent.withOpacity(0.1),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.white30, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.white24),
              ),
            ),
          ),
          if (isPassword)
            IconButton(
              icon: Icon(
                obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.white30,
                size: 20,
              ),
              onPressed: onToggleVisibility,
            ),
        ],
      ),
    );
  }
}
