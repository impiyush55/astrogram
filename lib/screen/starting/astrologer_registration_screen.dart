import 'package:flutter/material.dart';
import '../../helper/color.dart';
import '../../helper/custom_text.style.dart';
import '../../widgets/my_text_button.dart';
import '../../services/astrologer_service.dart';
import 'dart:ui';

class AstrologerRegistrationScreen extends StatefulWidget {
  const AstrologerRegistrationScreen({super.key});

  @override
  State<AstrologerRegistrationScreen> createState() =>
      _AstrologerRegistrationScreenState();
}

class _AstrologerRegistrationScreenState
    extends State<AstrologerRegistrationScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _chargesController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  final AstrologerService _astrologerService = AstrologerService();
  bool _isLoading = false;

  String _selectedGender = "Male";
  final List<String> _selectedSystems = [];

  final List<String> _allSystems = [
    "Vedic",
    "KP System",
    "Lal Kitab",
    "Vastu",
    "Tarot Reading",
    "Nadi",
    "Numerology",
    "Ashtakvarga",
    "Palmistry",
    "Ramal",
    "Jaimini",
    "Tajik",
    "Western",
    "Kerala",
    "Swar Shastra",
    "Reiki",
    "Crystal Healing",
    "Angel Reading",
    "Feng Shui",
    "Prashna / Horary",
    "Pendulum Dowsing",
    "Psychic Reading",
    "Face Reading",
    "Muhurta",
  ];

  final List<String> _selectedLanguages = [];
  final List<String> _allLanguages = [
    "Hindi",
    "English",
    "Bengali",
    "Marathi",
    "Telugu",
    "Tamil",
    "Gujarati",
    "Kannada",
    "Malayalam",
    "Assamese",
    "Odia",
    "Punjabi",
    "Urdu",
    "Bhojpuri",
    "Nepali",
    "Maithili",
    "Dogri",
    "Kashmiri",
    "Konkani",
    "Sindhi",
    "Haryanvi",
    "Rajasthani",
    "Manipuri",
    "Sanskrit",
    "Kumaoni",
    "Tulu",
    "Santali",
    "Spanish",
    "French",
    "Arabic",
    "Chinese",
    "Russian",
    "Portuguese",
    "Indonesian",
    "Japanese",
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _experienceController.dispose();
    _chargesController.dispose();
    _cityController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: AppColors.darkGradient,
                )
              : null,
          color: isDark ? null : theme.scaffoldBackgroundColor,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "Join as Astrologer",
                        style: myTextStyle28(
                          fontweight: FontWeight.w700,
                          textColor: theme.colorScheme.onSurface,
                          fontFamily: "secondary",
                        ),
                      ),
                      Text(
                        "Fill details to send request",
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Name Fields
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextFieldGroup(
                              "First Name",
                              _firstNameController,
                              "First Name",
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextFieldGroup(
                              "Last Name",
                              _lastNameController,
                              "Last Name",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Gender
                      _buildLabel("Gender"),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white10 : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark
                                ? Colors.white24
                                : Colors.grey.shade300,
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(child: _buildGenderOption("Male")),
                            Expanded(child: _buildGenderOption("Female")),
                          ],
                        ),
                      ),
                      _buildTextFieldGroup(
                        "City",
                        _cityController,
                        "Your City",
                      ),
                      const SizedBox(height: 16),
                      // System Known
                      _buildLabel("System Known"),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _showSystemSelectionDialog,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.black.withValues(alpha: 0.3)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.goldAccent.withValues(alpha: 0.1)
                                  : Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          child: Text(
                            _selectedSystems.isEmpty
                                ? "Select System(s)"
                                : _selectedSystems.join(", "),
                            style: TextStyle(
                              color: _selectedSystems.isEmpty
                                  ? theme.colorScheme.onSurface.withValues(
                                      alpha: 0.4,
                                    )
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Contact
                      _buildTextFieldGroup(
                        "Phone No.",
                        _phoneController,
                        "+91 XXXXX XXXXX",
                        inputType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      _buildTextFieldGroup(
                        "Email Id",
                        _emailController,
                        "example@email.com",
                        inputType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      _buildTextFieldGroup(
                        "Experience (Years)",
                        _experienceController,
                        "e.g. 5",
                        inputType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      _buildTextFieldGroup(
                        "Charges per Minute (₹)",
                        _chargesController,
                        "e.g. 20",
                        inputType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),

                      // Select Language
                      _buildLabel("Select Language(s)"),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _showLanguageSelectionDialog,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.black.withValues(alpha: 0.3)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.goldAccent.withValues(alpha: 0.1)
                                  : Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          child: Text(
                            _selectedLanguages.isEmpty
                                ? "Select Language(s)"
                                : _selectedLanguages.join(", "),
                            style: TextStyle(
                              color: _selectedLanguages.isEmpty
                                  ? theme.colorScheme.onSurface.withValues(
                                      alpha: 0.4,
                                    )
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildTextFieldGroup(
                        "Short Bio",
                        _bioController,
                        "Tell us about yourself...",
                        maxLines: 3,
                      ),

                      const SizedBox(height: 40),

                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: AppColors.goldGradient,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.goldAccent.withValues(
                                alpha: 0.3,
                              ),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.goldAccent,
                                ),
                              )
                            : MyTextButton(
                                btnText: "Send Registration Request",
                                borderRadius: 16,
                                btnBackgroundColor: Colors.transparent,
                                btnTextColor: Colors.black87,
                                onPress: _handleRegistration,
                              ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.white24 : Colors.grey.shade300,
                  width: 0.5,
                ),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: theme.colorScheme.onSurface,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderOption(String gender) {
    final theme = Theme.of(context);
    final isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.goldAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            gender,
            style: TextStyle(
              color: isSelected ? Colors.black : theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldGroup(
    String label,
    TextEditingController controller,
    String hint, {
    TextInputType inputType = TextInputType.text,
    int maxLines = 1,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.white.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.grey.shade300,
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: TextField(
                controller: controller,
                keyboardType: inputType,
                maxLines: maxLines,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: isDark ? AppColors.goldAccent : AppColors.primaryPurple,
        letterSpacing: 1.2,
      ),
    );
  }

  void _showSystemSelectionDialog() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                "System Known",
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _allSystems.length,
                  itemBuilder: (context, index) {
                    final system = _allSystems[index];
                    final isSelected = _selectedSystems.contains(system);
                    return CheckboxListTile(
                      title: Text(
                        system,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 14,
                        ),
                      ),
                      value: isSelected,
                      activeColor: AppColors.goldAccent,
                      checkColor: Colors.black,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      side: BorderSide(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          if (val == true) {
                            _selectedSystems.add(system);
                          } else {
                            _selectedSystems.remove(system);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    this.setState(() {}); // Refresh parent UI
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(color: AppColors.goldAccent),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedSystems.clear();
                    });
                    this.setState(() {});
                    Navigator.pop(context);
                  },
                  child: Text(
                    "CANCEL",
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    ).then((_) => setState(() {})); // Refresh parent UI on close
  }

  void _showLanguageSelectionDialog() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                "Select Language(s)",
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _allLanguages.length,
                  itemBuilder: (context, index) {
                    final language = _allLanguages[index];
                    final isSelected = _selectedLanguages.contains(language);
                    return CheckboxListTile(
                      title: Text(
                        language,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 14,
                        ),
                      ),
                      value: isSelected,
                      activeColor: AppColors.goldAccent,
                      checkColor: Colors.black,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      side: BorderSide(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          if (val == true) {
                            _selectedLanguages.add(language);
                          } else {
                            _selectedLanguages.remove(language);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    this.setState(() {}); // Refresh parent UI
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(color: AppColors.goldAccent),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedLanguages.clear();
                    });
                    this.setState(() {});
                    Navigator.pop(context);
                  },
                  child: Text(
                    "CANCEL",
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    ).then((_) => setState(() {})); // Refresh parent UI on close
  }

  Future<void> _handleRegistration() async {
    if (_firstNameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all required fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final Map<String, dynamic> registrationData = {
      "name": "${_firstNameController.text} ${_lastNameController.text}",
      "bio": _bioController.text,
      "experience": int.tryParse(_experienceController.text) ?? 0,
      "languages": _selectedLanguages.join(","),
      "gender": _selectedGender,
      "perMinuteCharge": double.tryParse(_chargesController.text) ?? 0.0,
      "skills": _selectedSystems.join(" "),
    };

    final success = await _astrologerService.registerAstrologer(
      registrationData,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registration request sent successfully!"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Failed to send registration request. Please try again.",
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
