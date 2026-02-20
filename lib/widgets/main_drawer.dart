import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../helper/color.dart';
import '../services/auth_service.dart';
import '../screen/starting/start_screen.dart';
import '../screen/drawer/language_screen.dart';
import '../screen/drawer/notifications_screen.dart';
import '../screen/drawer/legal_screen.dart';
import '../screen/drawer/about_screen.dart';
import '../screen/drawer/support_screen.dart';
import '../helper/custom_text.style.dart';
import 'dart:ui';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          // Header
          _buildHeader(context, theme, isDark),

          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _DrawerItem(
                  icon: Icons.language,
                  label: "Change Language",
                  onTap: () {
                    Navigator.pop(context); // Close Drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LanguageScreen()),
                    );
                  },
                ),
                _DrawerItem(
                  icon: Icons.notifications_active_outlined,
                  label: "Notification Settings",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationsScreen(),
                      ),
                    );
                  },
                ),
                _DrawerItem(
                  icon: Icons.star_outline_rounded,
                  label: "Rate Us",
                  onTap: () {
                    Navigator.pop(context);
                    _showRatingDialog(context, theme, isDark);
                  },
                ),
                _DrawerItem(
                  icon: Icons.share_outlined,
                  label: "Share App",
                  onTap: () {
                    Navigator.pop(context);
                    _showShareSheet(context, theme, isDark);
                  },
                ),
                const Divider(indent: 20, endIndent: 20),
                _DrawerItem(
                  icon: Icons.description_outlined,
                  label: "Terms & Conditions",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LegalScreen(
                          title: "Terms & Conditions",
                          content: tcContent,
                        ),
                      ),
                    );
                  },
                ),
                _DrawerItem(
                  icon: Icons.privacy_tip_outlined,
                  label: "Privacy Policy",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LegalScreen(
                          title: "Privacy Policy",
                          content: privacyContent,
                        ),
                      ),
                    );
                  },
                ),
                _DrawerItem(
                  icon: Icons.info_outline,
                  label: "About Devine",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AboutScreen()),
                    );
                  },
                ),
                _DrawerItem(
                  icon: Icons.support_agent,
                  label: "Customer Support",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CustomerSupportScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Footer / Version
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if (AuthService.currentUserId != null)
                  TextButton.icon(
                    onPressed: () {
                      AuthService.currentUserId = null;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const StartScreen()),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.logout, color: Colors.redAccent),
                    label: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                const SizedBox(height: 10),
                Text(
                  "Version 1.0.2",
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme, bool isDark) {
    final isLoggedIn = AuthService.currentUserId != null;
    final userProfile = AuthService.currentUserProfile;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark ? AppColors.darkGradient : AppColors.primaryGradient,
        ),
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(40)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 84,
                      height: 84,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: AppColors.goldGradient,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 38,
                      backgroundColor: isDark
                          ? AppColors.darkBackground
                          : Colors.white,
                      child: CircleAvatar(
                        radius: 34,
                        backgroundColor: AppColors.goldAccent,
                        child: isLoggedIn
                            ? Text(
                                (userProfile?['fullName']
                                            ?.toString()
                                            .isNotEmpty ==
                                        true)
                                    ? userProfile!['fullName'][0].toUpperCase()
                                    : "U",
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              )
                            : const Icon(
                                Icons.psychology_outlined,
                                size: 36,
                                color: Colors.black,
                              ),
                      ),
                    ),
                    if (isLoggedIn)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.goldAccent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.verified,
                            size: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  isLoggedIn
                      ? (userProfile?['fullName']?.toString() ?? "Astro User")
                      : "Namaste, Seeker",
                  style: myTextStyle21(
                    fontweight: FontWeight.bold,
                    textColor: Colors.white,
                    fontFamily: "secondary",
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isLoggedIn
                      ? (AuthService.userPhone ?? "Profile Completed")
                      : "Login to unlock your destiny",
                  style: myTextStyle15(
                    textColor: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
                if (!isLoggedIn) ...[
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const StartScreen()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.goldAccent,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Login / Sign Up",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Share Sheet implementation
  void _showShareSheet(BuildContext context, ThemeData theme, bool isDark) {
    const String shareText =
        'Check out Devine for your daily spiritual guidance! Download now: https://devine.page.link/download';
    const String shareSubject =
        'Experience the magic of Astrology with Devine!';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E2C) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Share Devine",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Spread the light of wisdom with your friends",
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ShareOption(
                  icon: Icons.chat_bubble_rounded,
                  color: const Color(0xFF25D366),
                  label: "WhatsApp",
                  onTap: () async {
                    final url = Uri.parse(
                      "https://wa.me/?text=${Uri.encodeComponent(shareText)}",
                    );
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                ),
                _ShareOption(
                  icon: Icons.camera_alt_rounded,
                  color: const Color(0xFFE4405F),
                  label: "Instagram",
                  onTap: () {
                    Share.share(shareText, subject: shareSubject);
                  },
                ),
                _ShareOption(
                  icon: Icons
                      .chat_bubble_rounded, // Use chat icon as placeholder for Snapchat
                  color: const Color(0xFFFFFC00),
                  label: "Snapchat",
                  iconColor: Colors.black,
                  onTap: () {
                    Share.share(shareText, subject: shareSubject);
                  },
                ),
                _ShareOption(
                  icon: Icons.more_horiz_rounded,
                  color: AppColors.primaryPurple,
                  label: "More",
                  onTap: () {
                    Share.share(shareText, subject: shareSubject);
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.onSurface.withOpacity(0.1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "https://devine.page.link/download",
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      Clipboard.setData(
                        const ClipboardData(
                          text: "https://devine.page.link/download",
                        ),
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Link copied to clipboard!"),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: const Text("Copy"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShareOption extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;
  final Color iconColor;

  const _ShareOption({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.goldAccent, size: 22),
      ),
      title: Text(
        label,
        style: myTextStyle15(
          textColor: theme.colorScheme.onSurface,
          fontweight: FontWeight.w600,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        size: 18,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }
}

// Custom Helper for Rating
void _showRatingDialog(BuildContext context, ThemeData theme, bool isDark) {
  int rating = 0;
  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCard : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Center(
          child: Text(
            "Rate Devine",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Your feedback helps us improve your spiritual journey.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () => setState(() => rating = index + 1),
                  icon: Icon(
                    index < rating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: AppColors.goldAccent,
                    size: 36,
                  ),
                );
              }),
            ),
            if (rating > 0) ...[
              const SizedBox(height: 16),
              Text(
                rating == 5
                    ? "Awesome! Thank you!"
                    : "Thank you for the rating!",
                style: const TextStyle(
                  color: AppColors.goldAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: rating == 0 ? null : () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.goldAccent,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Submit",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    ),
  );
}
