import 'package:astrogram/helper/color.dart';
import 'package:astrogram/models/kundli_model.dart';
import 'package:astrogram/screen/dashboard/kundli_screen.dart';
import 'package:astrogram/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KundliInputScreen extends StatefulWidget {
  const KundliInputScreen({super.key});

  @override
  State<KundliInputScreen> createState() => _KundliInputScreenState();
}

class _KundliInputScreenState extends State<KundliInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final AuthService _authService = AuthService();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _gender = "Male";
  bool _isAutoFetching = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill from global session if available, but do NOT auto-fetch automatically
    if (AuthService.currentUserProfile != null &&
        AuthService.currentUserProfile!['notFound'] != true) {
      _applyProfileData(AuthService.currentUserProfile!);
    }
  }

  void _applyProfileData(Map<String, dynamic> profile) {
    setState(() {
      _nameController.text = profile['fullName']?.toString() ?? "";
      _locationController.text = profile['placeOfBirth']?.toString() ?? "";

      final genderStr = profile['gender']?.toString().toUpperCase();
      _gender = (genderStr == "FEMALE") ? "Female" : "Male";

      if (profile['dateOfBirth'] != null) {
        try {
          _selectedDate = DateTime.parse(profile['dateOfBirth'].toString());
        } catch (e) {
          debugPrint("DEBUG: Date parse error: $e");
        }
      }

      if (profile['timeOfBirth'] != null) {
        try {
          final timeStr = profile['timeOfBirth'].toString();
          final parts = timeStr.split(':');
          if (parts.length >= 2) {
            _selectedTime = TimeOfDay(
              hour: int.parse(parts[0]),
              minute: int.parse(parts[1]),
            );
          }
        } catch (e) {
          debugPrint("DEBUG: Time parse error: $e");
        }
      }
    });
  }

  Future<void> _fetchProfileData() async {
    setState(() => _isAutoFetching = true);
    try {
      debugPrint("DEBUG: Initiating profile fetch...");
      final profile = await _authService.fetchUserProfile();

      if (!mounted) return;

      if (profile != null) {
        if (profile.containsKey('error') || profile.containsKey('notFound')) {
          debugPrint("DEBUG: Profile not found or error: $profile");
          setState(() => _isAutoFetching = false);
          if (profile['notFound'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Profile not found. Please enter details manually.",
                ),
                backgroundColor: Colors.orange,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Server Error: ${profile['status'] ?? '500'}"),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        debugPrint("DEBUG: Profile found! Mapping data: $profile");
        setState(() {
          _nameController.text = profile['fullName']?.toString() ?? "";
          _locationController.text = profile['placeOfBirth']?.toString() ?? "";

          final genderStr = profile['gender']?.toString().toUpperCase();
          _gender = (genderStr == "FEMALE") ? "Female" : "Male";

          if (profile['dateOfBirth'] != null) {
            try {
              _selectedDate = DateTime.parse(profile['dateOfBirth'].toString());
            } catch (e) {
              debugPrint("DEBUG: Date parse error: $e");
            }
          }

          if (profile['timeOfBirth'] != null) {
            try {
              final timeStr = profile['timeOfBirth'].toString();
              final parts = timeStr.split(':');
              if (parts.length >= 2) {
                _selectedTime = TimeOfDay(
                  hour: int.parse(parts[0]),
                  minute: int.parse(parts[1]),
                );
              }
            } catch (e) {
              debugPrint("DEBUG: Time parse error: $e");
            }
          }
          _isAutoFetching = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile data loaded successfully!")),
        );
      } else {
        debugPrint("DEBUG: Profile fetch returned null");
        setState(() => _isAutoFetching = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Profile not found. Please check your connection or enter manually.",
            ),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      debugPrint("DEBUG: Fatal error in profile fetch: $e");
      if (mounted) {
        setState(() => _isAutoFetching = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error fetching profile: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.goldAccent,
              onPrimary: Colors.black,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 12, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.goldAccent,
              onPrimary: Colors.black,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _generateKundli() {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _selectedTime != null) {
      final request = KundliRequest(
        userId: AuthService.currentUserId,
        name: _nameController.text,
        location: _locationController.text,
        date: DateFormat('dd/MM/yyyy').format(_selectedDate!),
        time:
            "${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}",
        timezone: "+05:30", // Default for India as per backend team
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => KundliScreen(request: request)),
      );
    } else if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select birth date and time")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Enter Birth Details"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const KundliScreen(request: null),
                ),
              );
            },
            child: const Text(
              "Skip",
              style: TextStyle(
                color: AppColors.goldAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Personal Information",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _fetchProfileData,
                        icon: const Icon(
                          Icons.refresh,
                          size: 18,
                          color: AppColors.goldAccent,
                        ),
                        label: const Text(
                          "Load Profile",
                          style: TextStyle(color: AppColors.goldAccent),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _nameController,
                    label: "Full Name",
                    icon: Icons.person_outline,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildGenderBtn("Male", isDark)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildGenderBtn("Female", isDark)),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    "Birth Details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildPickerField(
                    label: _selectedDate == null
                        ? "Date of Birth"
                        : DateFormat('dd MMMM, yyyy').format(_selectedDate!),
                    icon: Icons.calendar_today_outlined,
                    onTap: () => _selectDate(context),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),
                  _buildPickerField(
                    label: _selectedTime == null
                        ? "Time of Birth"
                        : _selectedTime!.format(context),
                    icon: Icons.access_time_outlined,
                    onTap: () => _selectTime(context),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _locationController,
                    label: "Place of Birth",
                    icon: Icons.location_on_outlined,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _generateKundli,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.goldAccent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 8,
                        shadowColor: AppColors.goldAccent.withOpacity(0.4),
                      ),
                      child: const Text(
                        "Generate Kundli",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const KundliScreen(request: null),
                          ),
                        );
                      },
                      child: Text(
                        "Skip for now",
                        style: TextStyle(
                          color: AppColors.goldAccent.withOpacity(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.goldAccent.withOpacity(
                            0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isAutoFetching)
            Container(
              color: Colors.black.withOpacity(0.1),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.goldAccent),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDark,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.goldAccent),
        filled: true,
        fillColor: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.goldAccent),
        ),
      ),
      validator: (value) => value!.isEmpty ? "Required" : null,
    );
  }

  Widget _buildPickerField({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.goldAccent),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black87,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderBtn(String label, bool isDark) {
    bool isSelected = _gender == label;
    return GestureDetector(
      onTap: () => setState(() => _gender = label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.goldAccent.withOpacity(0.1)
              : (isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.goldAccent : Colors.transparent,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? AppColors.goldAccent
                  : (isDark ? Colors.white60 : Colors.black54),
            ),
          ),
        ),
      ),
    );
  }
}
