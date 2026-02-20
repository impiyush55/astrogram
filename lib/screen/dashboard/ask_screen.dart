import 'package:flutter/material.dart';
import '../../helper/color.dart';
import '../../services/astrologer_service.dart';
import '../../models/astrologer_model.dart';
import 'chat_screen.dart';
import 'call_selection_screen.dart';
import '../../helper/custom_text.style.dart';
import 'dart:ui';

class AskScreen extends StatefulWidget {
  const AskScreen({super.key});

  @override
  State<AskScreen> createState() => _AskScreenState();
}

class _AskScreenState extends State<AskScreen> {
  // Astrologer Service
  final AstrologerService _service = AstrologerService();

  // Filter state
  int _selectedFilterIndex = 0;
  final List<String> _filters = [
    'All',
    'Love',
    'Career',
    'Marriage',
    'Health',
    'Finance',
    'Education',
    'Family',
  ];

  // Astrologer Data
  List<Astrologer> _astrologers = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _service.addListener(_onServiceUpdate);
    _loadAstrologers();
  }

  void _onServiceUpdate() {
    if (mounted) {
      setState(() {
        _astrologers = _service.astrologers;
      });
    }
  }

  @override
  void dispose() {
    _service.removeListener(_onServiceUpdate);
    super.dispose();
  }

  Future<void> _loadAstrologers() async {
    try {
      final data = await _service.fetchAstrologers();
      if (mounted) {
        setState(() {
          _astrologers = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Navigator.of(context).canPop() ? Icons.arrow_back : Icons.menu,
            color: theme.appBarTheme.foregroundColor,
          ),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Scaffold.of(context).openDrawer();
            }
          },
        ),
        title: Text(
          'Guidance Selection',
          style: TextStyle(
            color: theme.appBarTheme.foregroundColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          _buildAppBarIcon(Icons.account_balance_wallet_outlined, "₹0", theme),
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: theme.appBarTheme.foregroundColor,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.notifications_none,
              color: theme.appBarTheme.foregroundColor,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.search, color: theme.appBarTheme.foregroundColor),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),

              itemBuilder: (context, index) {
                final isSelected = _selectedFilterIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFilterIndex = index;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.goldAccent
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.goldAccent),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
                    child: Text(
                      _filters[index],
                      style: TextStyle(
                        color: isSelected
                            ? (isDark ? Colors.black : Colors.white)
                            : theme.colorScheme.onSurface,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Astrologer List
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFFD700)),
                  )
                : _errorMessage != null
                ? Center(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _astrologers.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),

                    itemBuilder: (context, index) {
                      final astro = _astrologers[index];
                      return _buildAstrologerCard(astro, theme, isDark);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBarIcon(IconData icon, String? label, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.appBarTheme.foregroundColor!.withOpacity(0.5),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: theme.appBarTheme.foregroundColor, size: 20),
          if (label != null) ...[
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(color: theme.appBarTheme.foregroundColor),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAstrologerCard(Astrologer astro, ThemeData theme, bool isDark) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : AppColors.primaryPurple.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : AppColors.primaryPurple.withValues(alpha: 0.1),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Top Row: Image + Info
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar with Gold Gradient Ring
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 78,
                        height: 78,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: AppColors.goldGradient,
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: isDark
                            ? AppColors.darkBackground
                            : Colors.white,
                        child: CircleAvatar(
                          radius: 33,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: NetworkImage(astro.image),
                          onBackgroundImageError: (exception, stackTrace) =>
                              const Icon(Icons.person, color: Colors.grey),
                        ),
                      ),
                      if (astro.isVerified)
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.verified,
                              color: Colors.blue,
                              size: 18,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  // Name & Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          astro.name,
                          style: myTextStyle18(
                            fontweight: FontWeight.bold,
                            textColor: theme.colorScheme.onSurface,
                            fontFamily: "secondary",
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              size: 14,
                              color: AppColors.goldAccent,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                astro.skills.replaceAll(',', ', '),
                                style: myTextStyle12(
                                  textColor: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.language,
                              size: 14,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                astro.languages.replaceAll(',', ', '),
                                style: myTextStyle12(
                                  textColor: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.5),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Rating Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.goldAccent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: AppColors.goldAccent,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${astro.rating}',
                                style: myTextStyle12(
                                  fontweight: FontWeight.bold,
                                  textColor: AppColors.goldAccent,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(${astro.orders} orders)',
                                style: myTextStyle12(
                                  textColor: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),
              // Price and Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Session Price',
                        style: myTextStyle12(
                          textColor: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        astro.isFree ? 'FREE' : '₹${astro.price}/min',
                        style: myTextStyle18(
                          fontweight: FontWeight.bold,
                          textColor: astro.isFree
                              ? Colors.green
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      if (astro.availableOptions.contains("Call"))
                        _buildActionButton(
                          icon: Icons.call,
                          label: "Call",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CallSelectionScreen(astrologer: astro),
                              ),
                            );
                          },
                        ),
                      if (astro.availableOptions.contains("Chat")) ...[
                        const SizedBox(width: 8),
                        _buildActionButton(
                          icon: Icons.chat_bubble_rounded,
                          label: "Chat",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ChatScreen(astrologer: astro),
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: AppColors.goldGradient),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldAccent.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          shadowColor: Colors.transparent,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: Icon(icon, size: 18),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
