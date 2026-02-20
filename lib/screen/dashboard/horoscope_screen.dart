import 'package:flutter/material.dart';
import '../../helper/color.dart';
import '../../services/horoscope_service.dart';

class HoroscopeScreen extends StatefulWidget {
  final int initialZodiacIndex;
  const HoroscopeScreen({super.key, this.initialZodiacIndex = 0});

  @override
  State<HoroscopeScreen> createState() => _HoroscopeScreenState();
}

class _HoroscopeScreenState extends State<HoroscopeScreen>
    with TickerProviderStateMixin {
  late TabController _dateTabController;
  late TabController _typeTabController;

  List<String> _zodiacs = [
    'Aries',
    'Taurus',
    'Gemini',
    'Cancer',
    'Leo',
    'Virgo',
    'Libra',
    'Scorpio',
    'Sagittarius',
    'Capricorn',
    'Aquarius',
    'Pisces',
  ];
  int _selectedZodiacIndex = 0;

  // Dynamic Data State
  bool _isLoading = true;
  Map<String, dynamic>? _dailyData;
  final HoroscopeService _horoscopeService = HoroscopeService();
  int _lastFetchedIndex = 1; // Track last fetched to avoid dupes

  @override
  void initState() {
    super.initState();
    _selectedZodiacIndex = widget.initialZodiacIndex;
    _dateTabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: 0,
    ); // Daily, Weekly, Monthly
    _typeTabController = TabController(length: 3, vsync: this);

    _initializeData();

    // Listen to tab changes to fetch data
    _dateTabController.addListener(() {
      if (!_dateTabController.indexIsChanging) {
        if (_dateTabController.index != _lastFetchedIndex) {
          _fetchHoroscope();
        }
      }
    });
  }

  Future<void> _initializeData() async {
    // 1. Fetch real zodiac signs from backend
    final liveSigns = await _horoscopeService.fetchZodiacSigns();
    if (liveSigns.isNotEmpty && mounted) {
      setState(() {
        // Convert to Title Case for UI display if needed, but backend returns UPPPERCASE
        _zodiacs = liveSigns.map((s) {
          if (s.isEmpty) return s;
          return s[0] + s.substring(1).toLowerCase();
        }).toList();
      });
    }

    // 2. Fetch initial horoscope
    _fetchHoroscope();
  }

  void _fetchHoroscope() async {
    final int currentIndex = _dateTabController.index;
    _lastFetchedIndex = currentIndex;

    setState(() {
      _isLoading = true;
    });

    String type = "DAILY";
    if (currentIndex == 1) type = "WEEKLY";
    if (currentIndex == 2) type = "MONTHLY";

    try {
      final liveResponse = await _horoscopeService.fetchHoroscopeBySign(
        type,
        _zodiacs[_selectedZodiacIndex],
      );

      if (mounted) {
        final String label = (currentIndex == 0)
            ? "Today"
            : (currentIndex == 1)
            ? "This Week"
            : "This Month";

        if (liveResponse != null) {
          setState(() {
            _dailyData = _horoscopeService.injectMetadata(liveResponse, label);
            _isLoading = false;
          });
        } else {
          // Fallback to dummy data if API fails
          setState(() {
            _dailyData = _horoscopeService.generateDummyData(
              _zodiacs[_selectedZodiacIndex],
              label,
            );
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Error in _fetchHoroscope: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _dateTabController.dispose();
    _typeTabController.dispose();
    super.dispose();
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
            Icons.arrow_back,
            color: theme.appBarTheme.foregroundColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Daily Horoscope',
          style: TextStyle(
            color: theme.appBarTheme.foregroundColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.share, color: Colors.green, size: 20),
            label: const Text('Share', style: TextStyle(color: Colors.green)),
            style: TextButton.styleFrom(
              side: const BorderSide(color: Colors.green),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Zodiac Selector
          SizedBox(
            height: 90,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _zodiacs.length,
              separatorBuilder: (context, index) => const SizedBox(width: 16),

              itemBuilder: (context, index) {
                final isSelected = _selectedZodiacIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedZodiacIndex = index;
                    });
                    _fetchHoroscope(); // Fetch new data when zodiac changes
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(
                                  color: AppColors.goldAccent,
                                  width: 2,
                                )
                              : null,
                        ),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.yellow.shade100,
                          child: Text(
                            _zodiacs[index][0],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.goldAccent
                                  : Colors.brown,
                            ),
                          ), // Placeholder for image
                          // backgroundImage: AssetImage('assets/zodiac/${_zodiacs[index].toLowerCase()}.png'),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _zodiacs[index],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Tabs (Yesterday, Today, Tomorrow)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(25),
            ),
            child: TabBar(
              controller: _dateTabController,
              indicator: BoxDecoration(
                color: isDark ? AppColors.darkSection : Colors.yellow.shade100,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: AppColors.goldAccent),
              ),
              labelColor: theme.colorScheme.onSurface,
              unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(
                0.5,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Daily'),
                Tab(text: 'Weekly'),
                Tab(text: 'Monthly'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFFD700)),
                  )
                : TabBarView(
                    controller: _dateTabController,
                    children: [
                      _buildHoroscopeContent("Daily", theme, isDark),
                      _buildHoroscopeContent("Weekly", theme, isDark),
                      _buildHoroscopeContent("Monthly", theme, isDark),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHoroscopeContent(String day, ThemeData theme, bool isDark) {
    if (_dailyData == null) return const SizedBox();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkCard
                  : const Color(0xFF0F172A), // Dark blue
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [AppColors.darkCard, Colors.black87]
                    : [const Color(0xFF0F172A), Colors.black],
              ),
            ),
            child: Column(
              children: [
                Text(
                  _dailyData!['date'] ?? '',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your ${_dateTabController.index == 0
                      ? "Daily"
                      : _dateTabController.index == 1
                      ? "Weekly"
                      : "Monthly"} horoscope is ready!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Lucky Colours',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Color(
                                  _dailyData!['hero']['luckyColor1'] ??
                                      0xFFFFFFFF,
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Color(
                                  _dailyData!['hero']['luckyColor2'] ??
                                      0xFFFFFFFF,
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Lucky Number',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        Text(
                          _dailyData!['hero']['luckyNumber'] ?? '0',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // Zodiac Icon Middle
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFFFD700),
                          width: 1,
                        ),
                        color: Colors.white12,
                      ),
                      child: Text(
                        _dailyData!['hero']['moodEmoji'] ?? '✨',
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Mood of day',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _dailyData!['hero']['moodEmoji'] ?? '✨',
                          style: const TextStyle(fontSize: 16),
                        ), // Emoji
                        const SizedBox(height: 16),
                        const Text(
                          'Lucky Time',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        Text(
                          _dailyData!['hero']['luckyTime'] ?? '--:--',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          // General Reading Section (Primary Live Data)
          if (_dailyData!['description'] != null) ...[
            Text(
              'General Reading',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.yellow.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.goldAccent,
                ),
              ),
              child: Text(
                _dailyData!['description'],
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],

          Text(
            '$day Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),

          // Love
          _buildInfoCard(
            title: 'Love & Relation',
            icon: Icons.favorite,
            color: Colors.red.shade100,
            iconColor: Colors.red,
            percentage: _dailyData!['love']['percentage'] ?? 50,
            content: _dailyData!['love']['content'] ?? "No data",
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          // Career
          _buildInfoCard(
            title: 'Career & Work',
            icon: Icons.work,
            color: Colors.orange.shade100,
            iconColor: Colors.deepOrange,
            percentage: _dailyData!['career']['percentage'] ?? 50,
            content: _dailyData!['career']['content'] ?? "No data",
            isDark: isDark,
          ),

          const SizedBox(height: 16),
          // Money
          _buildInfoCard(
            title: 'Money',
            icon: Icons.attach_money,
            color: Colors.green.shade100,
            iconColor: Colors.green,
            percentage: _dailyData!['money']['percentage'] ?? 50,
            content: _dailyData!['money']['content'] ?? "No data",
            isCompact: true,
            isDark: isDark,
          ),

          const SizedBox(height: 16),
          // Health
          _buildInfoCard(
            title: 'Health',
            icon: Icons.health_and_safety,
            color: Colors.blue.shade100,
            iconColor: Colors.blue,
            percentage: _dailyData!['health']['percentage'] ?? 50,
            content: _dailyData!['health']['content'] ?? "No data",
            isCompact: true,
            isDark: isDark,
          ),

          const SizedBox(height: 16),
          // Travel
          _buildInfoCard(
            title: 'Travel',
            icon: Icons.flight,
            color: Colors.purple.shade100,
            iconColor: Colors.purple,
            percentage: _dailyData!['travel']['percentage'] ?? 50,
            content: _dailyData!['travel']['content'] ?? "No data",
            isCompact: true,
            isDark: isDark,
          ),

          const SizedBox(height: 24),
          Text(
            'Daily Horoscope Insights',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),

          _buildInsightCard(
            "God of the Day",
            _dailyData!['insights']['food']['name'],
            _dailyData!['insights']['food']['desc'],
            _dailyData!['insights']['food']['image'] ?? '',
            theme,
            isDark,
          ),
          const SizedBox(height: 16),
          _buildInsightCard(
            "Product of the Day",
            _dailyData!['insights']['product']['name'],
            _dailyData!['insights']['product']['desc'],
            _dailyData!['insights']['product']['image'] ?? '',
            theme,
            isDark,
          ),
          const SizedBox(height: 16),
          _buildInsightCard(
            "Activity of the Day",
            _dailyData!['insights']['activity']['name'],
            _dailyData!['insights']['activity']['desc'],
            _dailyData!['insights']['activity']['image'] ?? '',
            theme,
            isDark,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required int percentage,
    required String content,
    bool isCompact = false,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : color.withOpacity(0.3),

        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: iconColor),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Text(
                '$percentage%',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black87,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(
    String badge,
    String title,
    String desc,
    String imagePath,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),

            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.asset(
                  // Switching to network for fallback if asset not found
                  imagePath,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 150,
                    color: Colors.grey.shade300,
                    child: Icon(Icons.broken_image),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  color: AppColors.goldAccent,
                  child: Text(
                    badge,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '"$title"',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  desc,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
