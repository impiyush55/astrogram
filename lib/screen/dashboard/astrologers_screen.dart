import 'package:flutter/material.dart';
import '../../helper/color.dart';
import '../../models/astrologer_model.dart';
import '../../services/astrologer_service.dart';
import 'astrologer_detail_screen.dart';

class AstrologersScreen extends StatefulWidget {
  const AstrologersScreen({super.key});

  @override
  State<AstrologersScreen> createState() => _AstrologersScreenState();
}

class _AstrologersScreenState extends State<AstrologersScreen>
    with SingleTickerProviderStateMixin {
  final AstrologerService _service = AstrologerService();
  List<Astrologer> _astrologers = [];
  bool _isLoading = true;
  late TabController _tabController;

  String? _selectedSkill;
  String? _selectedLanguage;
  double? _minRating;
  bool? _verifiedOnly;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _loadAstrologers();
      }
    });

    // Listen to service for immediate updates
    _service.addListener(_onServiceUpdate);

    // Initial load
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
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAstrologers() async {
    setState(() => _isLoading = true);

    List<Astrologer> list;
    if (_tabController.index == 1) {
      // Live tab
      list = await _service.getLiveAstrologers();
    } else if (_selectedSkill != null ||
        _selectedLanguage != null ||
        _minRating != null ||
        _verifiedOnly != null) {
      // Filtered
      list = await _service.filterAstrologers(
        skill: _selectedSkill,
        language: _selectedLanguage,
        minRating: _minRating,
        isVerified: _verifiedOnly,
      );
    } else {
      // All
      list = await _service.fetchAstrologers();
    }

    if (mounted) {
      setState(() {
        _astrologers = list;
        _isLoading = false;
      });
    }
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFilterSheet(),
    );
  }

  void _applyFilters(
    String? skill,
    String? language,
    double? rating,
    bool? verified,
  ) {
    setState(() {
      _selectedSkill = skill;
      _selectedLanguage = language;
      _minRating = rating;
      _verifiedOnly = verified;
    });
    _loadAstrologers();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : const Color(0xFFF5F5F5),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: isDark ? AppColors.darkCard : Colors.white,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Talk to Astrologers',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              ),
              actions: [
                IconButton(
                  icon: Stack(
                    children: [
                      const Icon(Icons.filter_list),
                      if (_selectedSkill != null ||
                          _selectedLanguage != null ||
                          _minRating != null ||
                          _verifiedOnly != null)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.goldAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                  onPressed: _showFilterSheet,
                ),
              ],
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.goldAccent,
                labelColor: AppColors.goldAccent,
                unselectedLabelColor: isDark ? Colors.white60 : Colors.black54,
                tabs: const [
                  Tab(text: 'All Astrologers'),
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, size: 8, color: Colors.green),
                        SizedBox(width: 6),
                        Text('Live Now'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(color: AppColors.goldAccent),
              )
            : _astrologers.isEmpty
            ? _buildEmptyState(isDark)
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildAstrologersList(isDark),
                  _buildAstrologersList(isDark),
                ],
              ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_search,
            size: 80,
            color: isDark ? Colors.white24 : Colors.black26,
          ),
          const SizedBox(height: 16),
          Text(
            'No astrologers found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white54 : Colors.black45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAstrologersList(bool isDark) {
    return RefreshIndicator(
      onRefresh: _loadAstrologers,
      color: AppColors.goldAccent,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _astrologers.length,
        itemBuilder: (context, index) {
          return _buildAstrologerCard(_astrologers[index], isDark);
        },
      ),
    );
  }

  Widget _buildAstrologerCard(Astrologer astrologer, bool isDark) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AstrologerDetailScreen(astrologer: astrologer),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
          ),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image
              Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.goldAccent.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        astrologer.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: isDark
                              ? AppColors.darkSection
                              : Colors.grey.shade200,
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: isDark ? Colors.white24 : Colors.black26,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (astrologer.isOnline)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? AppColors.darkCard : Colors.white,
                            width: 2,
                          ),
                        ),
                        child: const SizedBox(width: 8, height: 8),
                      ),
                    ),
                  if (astrologer.isVerified)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),

              // Info Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            astrologer.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (astrologer.isFree)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green),
                            ),
                            child: const Text(
                              'FREE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          astrologer.rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${astrologer.orders}+ orders',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          astrologer.getExperienceString(),
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.white54 : Colors.black45,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      astrologer.skills,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      astrologer.languages,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),

                    // Action Buttons
                    Row(
                      children: [
                        if (astrologer.availableOptions.contains('Call'))
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.call,
                              label: astrologer.getPriceString(),
                              color: Colors.green,
                              isDark: isDark,
                            ),
                          ),
                        if (astrologer.availableOptions.contains('Call') &&
                            astrologer.availableOptions.contains('Chat'))
                          const SizedBox(width: 8),
                        if (astrologer.availableOptions.contains('Chat'))
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.chat_bubble,
                              label: astrologer.getPriceString(),
                              color: AppColors.goldAccent,
                              isDark: isDark,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
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
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSheet() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    String? tempSkill = _selectedSkill;
    String? tempLanguage = _selectedLanguage;
    double? tempRating = _minRating;
    bool? tempVerified = _verifiedOnly;

    return StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Filter Astrologers",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      setModalState(() {
                        tempSkill = null;
                        tempLanguage = null;
                        tempRating = null;
                        tempVerified = null;
                      });
                    },
                    child: const Text("Reset"),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Skill Filter
              const Text(
                "Specialization",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['Vedic', 'Tarot', 'Numerology', 'Vastu', 'Palmistry']
                    .map(
                      (skill) => FilterChip(
                        label: Text(skill),
                        selected: tempSkill == skill,
                        onSelected: (selected) {
                          setModalState(() {
                            tempSkill = selected ? skill : null;
                          });
                        },
                        selectedColor: AppColors.goldAccent.withOpacity(0.3),
                        checkmarkColor: AppColors.goldAccent,
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 20),

              // Language Filter
              const Text(
                "Language",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['Hindi', 'English', 'Tamil', 'Telugu', 'Bengali']
                    .map(
                      (lang) => FilterChip(
                        label: Text(lang),
                        selected: tempLanguage == lang,
                        onSelected: (selected) {
                          setModalState(() {
                            tempLanguage = selected ? lang : null;
                          });
                        },
                        selectedColor: AppColors.goldAccent.withOpacity(0.3),
                        checkmarkColor: AppColors.goldAccent,
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 20),

              // Rating Filter
              const Text(
                "Minimum Rating",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [4.0, 4.5]
                    .map(
                      (rating) => FilterChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text('$rating+'),
                          ],
                        ),
                        selected: tempRating == rating,
                        onSelected: (selected) {
                          setModalState(() {
                            tempRating = selected ? rating : null;
                          });
                        },
                        selectedColor: AppColors.goldAccent.withOpacity(0.3),
                        checkmarkColor: AppColors.goldAccent,
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 20),

              // Verified Only
              CheckboxListTile(
                title: const Text("Verified Only"),
                value: tempVerified ?? false,
                onChanged: (value) {
                  setModalState(() {
                    tempVerified = value;
                  });
                },
                activeColor: AppColors.goldAccent,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 24),

              // Apply Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _applyFilters(
                      tempSkill,
                      tempLanguage,
                      tempRating,
                      tempVerified,
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.goldAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Apply Filters",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
