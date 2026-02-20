import 'package:flutter/material.dart';
import '../../helper/color.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _dailyHoroscope = true;
  bool _orderUpdates = true;
  bool _chatAlerts = true;
  bool _promotions = false;
  bool _liveUpdates = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Notification Settings"),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildToggleTile(
            title: "Daily Horoscope",
            subtitle: "Receive daily predictions based on your zodiac.",
            value: _dailyHoroscope,
            onChanged: (v) => setState(() => _dailyHoroscope = v),
            isDark: isDark,
            theme: theme,
          ),
          _buildToggleTile(
            title: "Order Updates",
            subtitle: "Status changes for your reports or consultations.",
            value: _orderUpdates,
            onChanged: (v) => setState(() => _orderUpdates = v),
            isDark: isDark,
            theme: theme,
          ),
          _buildToggleTile(
            title: "Chat & Call Alerts",
            subtitle: "Instant alerts when an astrologer joins your session.",
            value: _chatAlerts,
            onChanged: (v) => setState(() => _chatAlerts = v),
            isDark: isDark,
            theme: theme,
          ),
          _buildToggleTile(
            title: "Live Session Reminders",
            subtitle: "Get notified when your favorite astrologers go live.",
            value: _liveUpdates,
            onChanged: (v) => setState(() => _liveUpdates = v),
            isDark: isDark,
            theme: theme,
          ),
          _buildToggleTile(
            title: "Offers & Promotions",
            subtitle: "Exclusive discounts and festival offers.",
            value: _promotions,
            onChanged: (v) => setState(() => _promotions = v),
            isDark: isDark,
            theme: theme,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isDark,
    required ThemeData theme,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
      ),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.goldAccent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
