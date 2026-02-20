import 'package:astrogram/screen/dashboard/common_history_screen.dart';
import 'package:astrogram/screen/starting/start_screen.dart';
import 'package:flutter/material.dart';
import '../../helper/color.dart';
import '../../helper/custom_text.style.dart';
import '../../services/auth_service.dart';
import '../wallet/add_money_screen.dart';
import '../starting/astrologer_registration_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildHeader(theme, isDark),
              const SizedBox(height: 24),
              _buildWalletCard(context, theme, isDark),
              const SizedBox(height: 32),
              _buildMenuSection(
                title: 'Expert Portal',
                items: [
                  _MenuItem(
                    icon: Icons.auto_awesome_rounded,
                    label: 'Register as Astrologer',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AstrologerRegistrationScreen(),
                      ),
                    ),
                    color: AppColors.goldAccent,
                  ),
                ],
                theme: theme,
                isDark: isDark,
              ),
              const SizedBox(height: 24),
              _buildMenuSection(
                title: 'My Astrology',
                items: [
                  _MenuItem(
                    icon: Icons.history,
                    label: 'Chat History',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const CommonHistoryScreen(title: "Chat History"),
                      ),
                    ),
                  ),
                  _MenuItem(
                    icon: Icons.call,
                    label: 'Call History',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const CommonHistoryScreen(title: "Call History"),
                      ),
                    ),
                  ),
                  _MenuItem(
                    icon: Icons.menu_book,
                    label: 'My Kundli',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const CommonHistoryScreen(title: "My Kundli"),
                      ),
                    ),
                  ),
                  _MenuItem(
                    icon: Icons.shopping_bag_outlined,
                    label: 'My Orders',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const CommonHistoryScreen(title: "My Orders"),
                      ),
                    ),
                  ),
                ],
                theme: theme,
                isDark: isDark,
              ),
              const SizedBox(height: 24),
              _buildMenuSection(
                title: 'Support & Settings',
                items: [
                  _MenuItem(
                    icon: Icons.account_balance_wallet_outlined,
                    label: 'Wallet Transactions',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddMoneyScreen()),
                    ),
                  ),
                  _MenuItem(
                    icon: Icons.help_outline,
                    label: 'Help & Support',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const CommonHistoryScreen(title: "Help & Support"),
                      ),
                    ),
                  ),
                  _MenuItem(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const CommonHistoryScreen(title: "Settings"),
                      ),
                    ),
                  ),
                  _MenuItem(
                    icon: Icons.logout,
                    label: 'Logout',
                    onTap: () {
                      AuthService.currentUserId = null;
                      AuthService.currentUserToken = null;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const StartScreen()),
                        (route) => false,
                      );
                    },
                    color: Colors.redAccent,
                  ),
                ],
                theme: theme,
                isDark: isDark,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.goldAccent, width: 2),
            ),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: isDark
                  ? AppColors.goldAccent.withValues(alpha: 0.1)
                  : Colors.grey.shade200,
              child: Icon(
                Icons.person,
                size: 40,
                color: isDark ? AppColors.goldAccent : Colors.grey.shade400,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AuthService.currentUserProfile?['fullName']?.toString() ??
                      "Guest User",
                  style: myTextStyle24(
                    fontweight: FontWeight.bold,
                    textColor: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AuthService.userPhone ?? "+91 XXXXX XXXXX",
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.black.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.black.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.edit_rounded,
                          size: 14,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.7,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Edit Profile",
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.7,
                            ),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletCard(BuildContext context, ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [AppColors.onboardingPurple, AppColors.onboardingBlack]
                : [AppColors.primaryPurple, AppColors.secondaryPurple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.goldAccent.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Wallet Balance",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "₹ ${AuthService.userWalletBalance.toStringAsFixed(2)}",
                    style: myTextStyle28(
                      fontweight: FontWeight.bold,
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddMoneyScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.goldAccent,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: const Text(
                "Add Money",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection({
    required String title,
    required List<_MenuItem> items,
    required ThemeData theme,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
            ),
          ),
          child: ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: isDark ? Colors.white12 : Colors.grey.shade100,
              indent: 50,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                onTap: item.onTap,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        (item.color ??
                                (isDark
                                    ? AppColors.goldAccent
                                    : AppColors.primaryPurple))
                            .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    item.icon,
                    size: 20,
                    color:
                        item.color ??
                        (isDark
                            ? AppColors.goldAccent
                            : AppColors.primaryPurple),
                  ),
                ),
                title: Text(
                  item.label,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  size: 20,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });
}
