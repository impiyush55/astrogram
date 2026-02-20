import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:astrogram/helper/color.dart';
import 'package:astrogram/models/kundli_model.dart';
import 'package:astrogram/services/kundli_service.dart';
import 'package:astrogram/screen/dashboard/kundli_match_result_screen.dart';

class KundliMatchingScreen extends StatefulWidget {
  const KundliMatchingScreen({super.key});

  @override
  State<KundliMatchingScreen> createState() => _KundliMatchingScreenState();
}

class _KundliMatchingScreenState extends State<KundliMatchingScreen> {
  final KundliService _kundliService = KundliService();
  int _selectedTabIndex = 1; // Default to "New Matching" as per UI
  bool _isLoading = false;

  // Boy's Details
  final _boyNameController = TextEditingController();
  final _boyLocationController = TextEditingController();
  DateTime? _boyDob;
  TimeOfDay? _boyTob;
  bool _boyUnknownTime = false;

  // Girl's Details
  final _girlNameController = TextEditingController();
  final _girlLocationController = TextEditingController();
  DateTime? _girlDob;
  TimeOfDay? _girlTob;
  bool _girlUnknownTime = false;

  Future<void> _selectDate(BuildContext context, bool isBoy) async {
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
    if (picked != null) {
      setState(() {
        if (isBoy) {
          _boyDob = picked;
        } else {
          _girlDob = picked;
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isBoy) async {
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
    if (picked != null) {
      setState(() {
        if (isBoy) {
          _boyTob = picked;
        } else {
          _girlTob = picked;
        }
      });
    }
  }

  Future<void> _matchHoroscope() async {
    // Validation
    if (_boyNameController.text.trim().isEmpty ||
        _girlNameController.text.trim().isEmpty) {
      _showError("Please enter both names");
      return;
    }

    if (_boyDob == null || _girlDob == null) {
      _showError("Please select birth dates for both");
      return;
    }

    if (_boyLocationController.text.trim().isEmpty ||
        _girlLocationController.text.trim().isEmpty) {
      _showError("Please enter birth places for both");
      return;
    }

    // Use default time if unknown time is checked
    final boyTime = _boyUnknownTime
        ? const TimeOfDay(hour: 12, minute: 0)
        : _boyTob;
    final girlTime = _girlUnknownTime
        ? const TimeOfDay(hour: 12, minute: 0)
        : _girlTob;

    if (boyTime == null || girlTime == null) {
      _showError("Please select birth times for both");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Format dates and times according to API requirements
      final boyDateStr = DateFormat('dd/MM/yyyy').format(_boyDob!);
      final girlDateStr = DateFormat('dd/MM/yyyy').format(_girlDob!);

      final boyTimeStr =
          "${boyTime.hour.toString().padLeft(2, '0')}:${boyTime.minute.toString().padLeft(2, '0')}";
      final girlTimeStr =
          "${girlTime.hour.toString().padLeft(2, '0')}:${girlTime.minute.toString().padLeft(2, '0')}";

      final request = KundliMatchRequest(
        boyLocation: _boyLocationController.text.trim(),
        boyDate: boyDateStr,
        boyTime: boyTimeStr,
        boyTimezone: "+05:30", // Default IST timezone
        girlLocation: _girlLocationController.text.trim(),
        girlDate: girlDateStr,
        girlTime: girlTimeStr,
        girlTimezone: "+05:30", // Default IST timezone
      );

      final result = await _kundliService.matchKundli(request);

      if (!mounted) return;

      setState(() => _isLoading = false);

      if (result != null) {
        // Navigate to results screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => KundliMatchResultScreen(matchResult: result),
          ),
        );
      } else {
        _showError("Failed to match kundli. Please try again.");
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showError("An error occurred: $e");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          "Kundli Matching",
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: Column(
        children: [
          _buildTabs(isDark),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  _buildDetailsSection(
                    title: "Boy's Details",
                    isBoy: true,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailsSection(
                    title: "Girl's Details",
                    isBoy: false,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        color: theme.scaffoldBackgroundColor,
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _matchHoroscope,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.goldAccent,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 0,
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    "Match Horoscope",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabs(bool isDark) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Expanded(child: _buildTabItem("Open Kundli", 0, isDark)),
          Expanded(child: _buildTabItem("New Matching", 1, isDark)),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, int index, bool isDark) {
    bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.goldAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? Colors.black
                  : (isDark ? Colors.white70 : Colors.black54),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsSection({
    required String title,
    required bool isBoy,
    required bool isDark,
  }) {
    final nameController = isBoy ? _boyNameController : _girlNameController;
    final locationController = isBoy
        ? _boyLocationController
        : _girlLocationController;
    final dob = isBoy ? _boyDob : _girlDob;
    final tob = isBoy ? _boyTob : _girlTob;
    final unknownTime = isBoy ? _boyUnknownTime : _girlUnknownTime;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          _buildInputLabel("Name"),
          _buildTextField(
            controller: nameController,
            hint: "Enter name",
            icon: Icons.person_outline,
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          _buildInputLabel("Birth Date"),
          _buildPickerField(
            value: dob == null ? null : DateFormat('dd MMMM yyyy').format(dob),
            hint: "Select birth date",
            icon: Icons.calendar_today_outlined,
            onTap: () => _selectDate(context, isBoy),
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          _buildInputLabel("Birth Time"),
          _buildPickerField(
            value: tob?.format(context),
            hint: "Select birth time",
            icon: Icons.access_time_outlined,
            onTap: () => _selectTime(context, isBoy),
            isDark: isDark,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(
                  value: unknownTime,
                  activeColor: AppColors.goldAccent,
                  checkColor: Colors.black,
                  onChanged: (val) {
                    setState(() {
                      if (isBoy) {
                        _boyUnknownTime = val ?? false;
                      } else {
                        _girlUnknownTime = val ?? false;
                      }
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Don't know my exact time of birth",
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32, top: 2),
            child: Text(
              "Note: Without time of birth, we can still achieve upto 80% accurate predictions",
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
          ),
          const SizedBox(height: 16),
          _buildInputLabel("Birth Place"),
          _buildTextField(
            controller: locationController,
            hint: "New Delhi, Delhi, India",
            icon: Icons.location_on_outlined,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool isDark,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(
        fontSize: 14,
        color: isDark ? Colors.white : Colors.black,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 20),
        filled: true,
        fillColor: isDark
            ? Colors.white.withOpacity(0.03)
            : Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.goldAccent),
        ),
      ),
    );
  }

  Widget _buildPickerField({
    String? value,
    required String hint,
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.03) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey.shade400, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                value ?? hint,
                style: TextStyle(
                  color: value == null
                      ? Colors.grey.shade400
                      : (isDark ? Colors.white : Colors.black),
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
