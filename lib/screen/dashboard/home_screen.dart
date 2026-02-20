import 'package:flutter/material.dart';
import '../../widgets/premium_ai_popup.dart';
import '../../services/popup_service.dart';
import '../../services/blog_service.dart';
import '../../models/blog_model.dart';
import '../../widgets/blog_card_widget.dart';
import 'astro_shop_tab.dart';
import 'book_puja_screen.dart';
import 'horoscope_screen.dart';
import 'kundli_matching_screen.dart';
import 'kundli_screen.dart';
import 'ask_screen.dart';
import 'blog_detail_screen.dart';
import '../wallet/add_money_screen.dart';
import '../drawer/notifications_screen.dart';

import 'package:astrogram/main.dart'; // Import for themeNotifier
import 'package:astrogram/helper/color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchAndShowPopup();
  }

  Future<void> _fetchAndShowPopup() async {
    final service = PopupService();
    final data = await service.fetchPopupData();

    if (mounted && data != null && data.isVisible) {
      showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.8),
        builder: (context) => PremiumAIPopup(data: data),
      );
    }
  }

  final List<Map<String, dynamic>> astrologers = const [
    {
      "id": 1,
      "name": "Pandit Krishna Sharma",
      "image": "lib/assets/images/men1.png",
      "price": "20",
      "isFree": true,
      "isLive": true,
    },
    {
      "id": 2,
      "name": "Preeti Singh",
      "image": "lib/assets/images/prity.jpg",
      "price": "25",
      "isFree": false,
      "isLive": true,
    },
    {
      "id": 3,
      "name": "Acharya Subramanian",
      "image": "lib/assets/images/image.png",
      "price": "30",
      "isFree": false,
      "isLive": false,
    },
    {
      "id": 4,
      "name": "Anuradh Mishra",
      "image": "lib/assets/images/panditji.jpg",
      "price": "22",
      "isFree": true,
      "isLive": true,
    },
    {
      "id": 5,
      "name": "Vishal Tripathi",
      "image": "lib/assets/images/pandit2.jpg",
      "price": "40",
      "isFree": false,
      "isLive": false,
    },
    {
      "id": 6,
      "name": "Ramesh Ojha",
      "image": "lib/assets/images/pandit3.jpeg",
      "price": "50",
      "isFree": false,
      "isLive": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? AppColors.darkGradient
                  : AppColors.primaryGradient,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        title: Text(
          _currentTabIndex == 2 ? 'Astro Shop' : 'Devine',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: "secondary",
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: () {
              themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.account_balance_wallet_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddMoneyScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Placeholder for Search
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Search coming soon!")),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: theme.scaffoldBackgroundColor),
        child: Column(
          children: [
            _buildTopTabs(),
            Expanded(
              child: _currentTabIndex == 2
                  ? const AstroShopTab()
                  : _currentTabIndex == 0
                  ? _buildHomeContent()
                  : _currentTabIndex == 3
                  ? const BookPujaScreen()
                  : Center(
                      child: Text(
                        'Coming Soon',
                        style: TextStyle(color: theme.colorScheme.onSurface),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Panchang Quick-View Banner (Replaced Today's Energy)
          _buildPanchangBanner(),
          const SizedBox(height: 24),

          // 2. Astro Tools Section
          _buildSectionHeader('Kundli & Horoscope'),
          _buildAstroToolsSection(),
          const SizedBox(height: 24),

          // 3. Astro AI Assistant Banner
          _buildAstroAIWideBanner(),
          const SizedBox(height: 24),

          // 4. Guidance from Experts
          _buildSectionHeader('Guidance from Experts'),
          _buildCallChatSection(),
          const SizedBox(height: 24),

          // 5. Live Section (Optional, keeping as secondary)
          _buildSectionHeader('Live Astrologers'),
          _buildLiveSection(),
          const SizedBox(height: 24),

          // 6. Astrology Blog
          _buildSectionHeader('Astrology Blog'),
          _buildBlogSection(),
          const SizedBox(height: 24),

          // 7. Astro Store
          _buildSectionHeader('Astro Store'),
          _buildAstroStoreSection(),
        ],
      ),
    );
  }

  Widget _buildTopTabs() {
    final tabs = ['Home', 'Matrimony', 'Astro Shop', 'Book Puja'];
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: theme.appBarTheme.backgroundColor,
        // Bottom border for separation
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: tabs.length,
          separatorBuilder: (context, index) => const SizedBox(width: 12),

          itemBuilder: (context, index) {
            final isSelected = index == _currentTabIndex;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _currentTabIndex = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors
                            .goldAccent // Active: Gold
                      : Colors.transparent, // Inactive: Transparent
                  borderRadius: BorderRadius.circular(20),
                  border: isSelected
                      ? Border.all(color: AppColors.goldAccent)
                      : Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : Colors.grey.withOpacity(0.5),
                        ),
                ),
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.primaryPurple
                        : theme.colorScheme.onSurface, // Text: Purple on Gold
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPanchangBanner() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Get current date
    final now = DateTime.now();
    final dateStr = "${now.day} ${_getMonthName(now.month)}, ${now.year}";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF1F122B), const Color(0xFF331B45)]
              : [const Color(0xFFFFF8F0), const Color(0xFFFFEBD6)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark ? AppColors.goldAccent.withOpacity(0.1) : Colors.white,
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              Icons.wb_sunny_outlined,
              color: AppColors.goldAccent.withOpacity(0.05),
              size: 150,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Panchang",
                          style: TextStyle(
                            fontFamily: "secondary",
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          dateStr,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.goldAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.goldAccent.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 12,
                            color: AppColors.goldAccent,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "New Delhi",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.goldAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPanchangItem(
                      "Tithi",
                      "Shukla Navami",
                      Icons.brightness_3,
                      const Color(0xFFE1BEE7),
                    ),
                    _buildPanchangItem(
                      "Nakshatra",
                      "Krittika",
                      Icons.star_rate,
                      const Color(0xFFFFF9C4),
                    ),
                    _buildPanchangItem(
                      "Rahu Kaal",
                      "15:12 - 16:32",
                      Icons.block_flipped,
                      const Color(0xFFFFCDD2),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to full Panchang Screen
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Full Panchang",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.goldAccent,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: AppColors.goldAccent,
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

  Widget _buildPanchangItem(
    String label,
    String value,
    IconData icon,
    Color bg,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDark ? bg.withOpacity(0.1) : bg,
            shape: BoxShape.circle,
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: bg.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Icon(icon, color: isDark ? bg : Colors.black87, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  Widget _buildSectionHeader(String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Gold Line Indicator
          Row(
            children: [
              Container(
                width: 3,
                height: 18,
                decoration: BoxDecoration(
                  color: AppColors.goldAccent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildCallChatSection() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      height: 160,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: astrologers.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),

        itemBuilder: (context, index) {
          final astro = astrologers[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AskScreen()),
              );
            },
            child: Container(
              width: 120,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: NetworkImage(astro['image']),
                    onBackgroundImageError: (exception, stackTrace) =>
                        const Icon(Icons.person, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      astro['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: theme.colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    '₹ ${astro['price']}/min',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                      fontSize: 10,
                    ),
                  ),
                  if (astro['isFree'])
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.green),
                      ),
                      child: const Text(
                        'FREE',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  //live section

  Widget _buildLiveSection() {
    final liveAstrologers = astrologers.where((a) => a['isLive']).toList();
    final theme = Theme.of(context);
    return SizedBox(
      height: 100,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: liveAstrologers.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),

        itemBuilder: (context, index) {
          final astro = liveAstrologers[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AskScreen()),
              );
            },
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: NetworkImage(astro['image']),
                        onBackgroundImageError: (exception, stackTrace) =>
                            const Icon(Icons.person, color: Colors.grey),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 70,
                  child: Text(
                    astro['name'],
                    style: TextStyle(
                      fontSize: 10,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAstroToolsSection() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final tools = [
      {'name': 'Kundli', 'icon': 'lib/assets/images/kundli_premium.png'},
      {
        'name': 'Kundli Match',
        'icon': 'lib/assets/images/love_match_premium.png',
      },
      {'name': 'Horoscope', 'icon': 'lib/assets/images/horoscope_premium.png'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: tools.map((tool) {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (tool['name'] == 'Horoscope') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HoroscopeScreen()),
                  );
                } else if (tool['name'] == 'Kundli') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const KundliScreen()),
                  );
                } else if (tool['name'] == 'Kundli Match') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const KundliMatchingScreen(),
                    ),
                  );
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : Colors.grey.shade100,
                  ),
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Premium Icon with subtle glow
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.goldAccent.withOpacity(0.15),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          tool['icon'] as String,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.auto_awesome,
                                color: AppColors.goldAccent,
                                size: 40,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      tool['name'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAstroAIWideBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      height: 90, // Compact banner
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2E0F45),
            Color(0xFF532478),
          ], // Deep Purple Gradient
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppColors.goldAccent.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Star decorations
          Positioned(
            top: 10,
            right: 30,
            child: Icon(Icons.star, color: Colors.white24, size: 12),
          ),
          Positioned(
            bottom: 20,
            left: 200,
            child: Icon(Icons.star, color: Colors.white12, size: 20),
          ),
          Positioned(
            top: 40,
            right: 80,
            child: Icon(
              Icons.auto_awesome,
              color: AppColors.goldAccent.withOpacity(0.3),
              size: 18,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Astro AI Assistant",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Ask Anything About Your Life",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to AI Chat / Guidance
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AskScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.goldAccent,
                    foregroundColor: const Color(0xFF2E0F45),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 4,
                  ),
                  child: Row(
                    children: const [
                      Text(
                        "Ask Now",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios, size: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAstroStoreSection() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final List<Map<String, dynamic>> shopItems = const [
      {
        'name': 'Brihat Kundli',
        'image': 'lib/assets/images/kundli.png',
        'icon': Icons.book,
      },
      {
        'name': 'Rudraksha',
        'image': 'lib/assets/images/rudraksha.png',
        'icon': Icons.circle,
      },
      {
        'name': 'Yantra',
        'image': 'lib/assets/images/yantra.jpg',
        'icon': Icons.filter_center_focus,
      },
      {
        'name': 'Gemstone',
        'image': 'lib/assets/images/Gemstone.png',
        'icon': Icons.diamond,
      },
      {
        'name': 'Mala',
        'image': 'lib/assets/images/mala.png',
        'icon': Icons.scatter_plot,
      },
      {
        'name': 'Jadi',
        'image': 'lib/assets/images/jadi.jpg',
        'icon': Icons.grass,
      },
      {
        'name': 'Services',
        'image': 'lib/assets/images/customer-service-agent.png',
        'icon': Icons.miscellaneous_services,
      },
      {
        'name': 'Kundli AI+',
        'image': 'lib/assets/images/kundli.png',
        'icon': Icons.psychology,
      },
      {
        'name': 'CogniAstro',
        'image': 'lib/assets/images/study.png',
        'icon': Icons.school,
      },
      {
        'name': 'Miscellaneous',
        'image': 'lib/assets/images/image.png',
        'icon': Icons.folder,
      },
      {
        'name': 'Aroma',
        'image': 'lib/assets/images/Evileye.jpg',
        'icon': Icons.air,
      },
      {
        'name': 'Bracelet',
        'image': 'lib/assets/images/bracelets.jpeg',
        'icon': Icons.watch,
      },
      {
        'name': 'Premium',
        'image': 'lib/assets/images/b1.png',
        'icon': Icons.workspace_premium,
      },
      {
        'name': 'Pendant',
        'image': 'lib/assets/images/pendant.png',
        'icon': Icons.vertical_align_bottom,
      },
      {
        'name': 'Tumble',
        'image': 'lib/assets/images/tumble.png',
        'icon': Icons.terrain,
      },
    ];

    return SizedBox(
      height: 140,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: shopItems.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = shopItems[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                _currentTabIndex = 2; // Switch to Astro Shop tab
              });
            },
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkBorder
                          : Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      item['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            item['icon'] as IconData,
                            size: 30,
                            color: AppColors.goldAccent,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 80,
                  child: Text(
                    item['name']!,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBlogSection() {
    final BlogService blogService = BlogService();

    return FutureBuilder<List<Blog>>(
      future: blogService.fetchBlogs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 160,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.goldAccent),
            ),
          );
        }

        final blogs = snapshot.data ?? [];

        if (blogs.isEmpty) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: 180,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: blogs.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final blog = blogs[index];
              return BlogCardWidget(
                blog: blog,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlogDetailScreen(blog: blog),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
