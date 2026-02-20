import 'package:flutter/material.dart';
import '../../helper/color.dart';

class LegalScreen extends StatelessWidget {
  final String title;
  final String content;

  const LegalScreen({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.goldAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.goldAccent.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                "Last Updated: Oct 2025",
                style: TextStyle(
                  color: AppColors.goldAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              content,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 15,
                height: 1.6,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                "© 2026 Devine AI. All Rights Reserved.",
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dummy contents
const String tcContent = """
1. Introduction
Welcome to Devine. By using our application, you agree to these terms and conditions in full. If you disagree with any part of these terms, you must not use our services.

2. Services Provided
Devine provides astrological consultations, horoscope readings, and spiritual remedies. Please note that astrology is for entertainment and personal guidance only and should not replace professional medical, legal, or financial advice.

3. User Responsibilities
You must provide accurate information for horoscope calculations. You are responsible for maintaining the confidentiality of your account.

4. Payments and Refunds
All consultations are paid upfront. Refunds are subject to our cancellation policy.

5. Limitation of Liability
Devine is not liable for any decisions made based on astrological readings.

6. Changes to Terms
We reserve the right to modify these terms at any time. Continued use of the app signifies acceptance.
""";

const String privacyContent = """
1. Data Collection
We collect personal information such as name, date of birth, time of birth, and location to provide accurate astrological services.

2. Usage of Data
Your data is used solely for generating reports and connecting you with neurologists/astrologers. We do not sell your personal data to third parties.

3. Data Security
We implement industry-standard security measures to protect your information from unauthorized access.

4. Third-Party Services
We may use third-party payment gateways. These services have their own privacy policies.

5. Cookies and Tracking
We use minimal tracking to improve app performance and user experience.

6. Your Rights
You can request the deletion of your account and personal data at any time by contacting support.
""";
