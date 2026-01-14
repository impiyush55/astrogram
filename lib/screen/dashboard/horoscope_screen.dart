import 'package:flutter/material.dart';
import '../../services/horoscope_service.dart';

class HoroscopeScreen extends StatefulWidget {
  const HoroscopeScreen({super.key});

  @override
  State<HoroscopeScreen> createState() => _HoroscopeScreenState();
}

class _HoroscopeScreenState extends State<HoroscopeScreen>
    with TickerProviderStateMixin {
  late TabController _dateTabController;
  late TabController _typeTabController;

  final List<String> _zodiacs = [
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
    _dateTabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: 1,
    ); // Yesterday, Today, Tomorrow
    _typeTabController = TabController(length: 3, vsync: this);

    // Fetch initial data for "Today" (index 1)
    _fetchHoroscope();

    // Listen to tab changes to fetch data
    _dateTabController.addListener(() {
      if (!_dateTabController.indexIsChanging) {
        // This handles end of swipe OR end of tap animation
        // For tap, index updates immediately but indexIsChanging is true.
        // Wait, for standard TabBar, tap sets index immediately.
        // Let's just check if index changed from what we last fetched.
        if (_dateTabController.index != _lastFetchedIndex) {
          _fetchHoroscope();
        }
      }
    });
  }

  void _fetchHoroscope() async {
    final currentIndex = _dateTabController.index;
    _lastFetchedIndex = currentIndex;

    setState(() {
      _isLoading = true;
    });

    String day = "Today";
    if (_dateTabController.index == 0) day = "Yesterday";
    if (_dateTabController.index == 2) day = "Tomorrow";

    final data = await _horoscopeService.fetchHoroscope(
      _zodiacs[_selectedZodiacIndex],
      day,
    );

    if (mounted) {
      setState(() {
        _dailyData = data;
        _isLoading = false;
      });
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Daily Horoscope',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
              separatorBuilder: (_, __) => const SizedBox(width: 16),
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
                                  color: const Color(0xFFFFD700),
                                  width: 2,
                                )
                              : null,
                        ),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.yellow.shade100,
                          child: Text(
                            _zodiacs[index][0],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.brown,
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
                          color: Colors.black,
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
                color: Colors.yellow.shade100,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: const Color(0xFFFFD700)),
              ),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Yesterday'),
                Tab(text: 'Today'),
                Tab(text: 'Tomorrow'),
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
                      _buildHoroscopeContent("Yesterday"),
                      _buildHoroscopeContent("Today"),
                      _buildHoroscopeContent("Tomorrow"),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHoroscopeContent(String day) {
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
              color: const Color(0xFF0F172A), // Dark blue
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                image: AssetImage(
                  'assets/images/stars_bg_placeholder.png',
                ), // Need a background or gradient
                fit: BoxFit.cover,
                opacity: 0.2,
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
                  'Your Daily horoscope is ready!',
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
          Text(
            '$day Horoscope',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Love
          _buildInfoCard(
            title: 'Love',
            icon: Icons.favorite,
            color: Colors.red.shade100,
            iconColor: Colors.red,
            percentage: _dailyData!['love']['pencentage'] ?? 50,
            content: _dailyData!['love']['content'] ?? "No data",
          ),
          const SizedBox(height: 16),
          // Career
          _buildInfoCard(
            title: 'Career',
            icon: Icons.work,
            color: Colors.orange.shade100,
            iconColor: Colors.deepOrange,
            percentage: _dailyData!['career']['pencentage'] ?? 50,
            content: _dailyData!['career']['content'] ?? "No data",
          ),

          const SizedBox(height: 16),
          // Money
          _buildInfoCard(
            title: 'Money',
            icon: Icons.attach_money,
            color: Colors.green.shade100,
            iconColor: Colors.green,
            percentage: _dailyData!['money']['pencentage'] ?? 50,
            content: _dailyData!['money']['content'] ?? "No data",
            isCompact: true,
          ),

          const SizedBox(height: 16),
          // Health
          _buildInfoCard(
            title: 'Health',
            icon: Icons.health_and_safety,
            color: Colors.blue.shade100,
            iconColor: Colors.blue,
            percentage: _dailyData!['health']['pencentage'] ?? 50,
            content: _dailyData!['health']['content'] ?? "No data",
            isCompact: true,
          ),

          const SizedBox(height: 16),
          // Travel
          _buildInfoCard(
            title: 'Travel',
            icon: Icons.flight,
            color: Colors.purple.shade100,
            iconColor: Colors.purple,
            percentage: _dailyData!['travel']['pencentage'] ?? 50,
            content: _dailyData!['travel']['content'] ?? "No data",
            isCompact: true,
          ),

          const SizedBox(height: 24),
          const Text(
            'Daily Horoscope Insights',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          _buildInsightCard(
            "God of the Day",
            _dailyData!['insights']['food']['name'],
            _dailyData!['insights']['food']['desc'],
            _dailyData!['insights']['food']['image'] ?? '',
          ),
          const SizedBox(height: 16),
          _buildInsightCard(
            "Product of the Day",
            _dailyData!['insights']['product']['name'],
            _dailyData!['insights']['product']['desc'],
            _dailyData!['insights']['product']['image'] ?? '',
          ),
          const SizedBox(height: 16),
          _buildInsightCard(
            "Activity of the Day",
            _dailyData!['insights']['activity']['name'],
            _dailyData!['insights']['activity']['desc'],
            _dailyData!['insights']['activity']['image'] ?? '',
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
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
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
            style: const TextStyle(color: Colors.black87, height: 1.4),
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
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
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
                  color: const Color(0xFFFFD700),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(desc, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
