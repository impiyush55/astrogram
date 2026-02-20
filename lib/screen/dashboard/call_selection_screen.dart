import 'package:flutter/material.dart';
import '../../helper/color.dart';
import '../../models/astrologer_model.dart';

class CallSelectionScreen extends StatefulWidget {
  final Astrologer astrologer;

  const CallSelectionScreen({super.key, required this.astrologer});

  @override
  State<CallSelectionScreen> createState() => _CallSelectionScreenState();
}

class _CallSelectionScreenState extends State<CallSelectionScreen> {
  String? _selectedType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [AppColors.darkBackground, AppColors.onboardingBlack]
                : [AppColors.lightBackground, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context, theme),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      _buildProfileSection(theme, isDark),
                      const SizedBox(height: 40),
                      _buildCallOptions(theme, isDark),
                    ],
                  ),
                ),
              ),
              _buildFooter(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          Text(
            "Call Selection",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48), // Balancing spacer
        ],
      ),
    );
  }

  Widget _buildProfileSection(ThemeData theme, bool isDark) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.goldAccent, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.goldAccent.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 65,
              backgroundColor: Colors.grey[300],
              backgroundImage: NetworkImage(widget.astrologer.image),
              onBackgroundImageError: (exception, stackTrace) {},
              child: widget.astrologer.image.isEmpty
                  ? const Icon(Icons.person, size: 60, color: Colors.grey)
                  : null,
            ),
            Positioned(
              bottom: 5,
              right: 5,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.verified, color: Colors.blue, size: 24),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          widget.astrologer.name,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.astrologer.skills,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.star_rounded,
              color: AppColors.goldAccent,
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              "${widget.astrologer.rating} (${widget.astrologer.orders} orders)",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCallOptions(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select prefered way to connect",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 20),
        _SelectionCard(
          title: "Audio Call",
          subtitle: "Clear voice interaction",
          icon: Icons.call_rounded,
          price: "₹${widget.astrologer.price}/min",
          isSelected: _selectedType == "Audio",
          onTap: () => setState(() => _selectedType = "Audio"),
          color: const Color(0xFF4CAF50),
          isDark: isDark,
        ),
        const SizedBox(height: 16),
        _SelectionCard(
          title: "Video Call",
          subtitle: "Personal face-to-face guidance",
          icon: Icons.videocam_rounded,
          price:
              "₹${widget.astrologer.price + 5}/min", // Slightly higher for video
          isSelected: _selectedType == "Video",
          onTap: () => setState(() => _selectedType = "Video"),
          color: const Color(0xFF2196F3),
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildFooter(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _selectedType == null
            ? null
            : () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Initiating $_selectedType call with ${widget.astrologer.name}...",
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.goldAccent,
          foregroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Text(
          _selectedType == null ? "Select Call Type" : "Connect Now",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _SelectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String price;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;
  final bool isDark;

  const _SelectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.price,
    required this.isSelected,
    required this.onTap,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isSelected
                  ? color.withOpacity(isDark ? 0.15 : 0.1)
                  : (isDark ? AppColors.darkCard : AppColors.lightCard),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isSelected
                    ? color
                    : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                width: 2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isSelected ? color : color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? Colors.white : color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: (isDark ? Colors.white : Colors.black)
                              .withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    if (isSelected)
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 20,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
