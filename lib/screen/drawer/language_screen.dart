import 'package:flutter/material.dart';
import '../../helper/color.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  final List<String> _languages = [
    "English",
    "Hindi (हिन्दी)",
    "Bengali (বাংলা)",
    "Gujarati (ગુજરાતી)",
    "Kannada (ಕನ್ನಡ)",
    "Marathi (मराठी)",
    "Punjabi (ਪੰਜਾਬੀ)",
    "Tamil (தமிழ்)",
    "Telugu (తెలుగు)",
    "Urdu (اردو)",
  ];

  String _selectedLanguage = "English";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Select Language"),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _languages.length,
        separatorBuilder: (context, index) =>
            Divider(color: isDark ? Colors.white10 : Colors.grey.shade200),
        itemBuilder: (context, index) {
          final lang = _languages[index];
          final isSelected = _selectedLanguage == lang;
          return ListTile(
            onTap: () {
              setState(() {
                _selectedLanguage = lang;
              });
            },
            title: Text(
              lang,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            trailing: Radio<String>(
              value: lang,
              groupValue: _selectedLanguage,
              activeColor: AppColors.goldAccent,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
              },
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Language changed to $_selectedLanguage")),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.goldAccent,
            foregroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "Confirm Language",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
