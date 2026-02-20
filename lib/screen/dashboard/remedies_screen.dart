import 'package:flutter/material.dart';
import '../../helper/color.dart';
import '../../models/remedy_model.dart';
import '../../services/remedy_service.dart';
import 'remedy_detail_screen.dart';
import 'dart:ui';

class RemediesScreen extends StatefulWidget {
  const RemediesScreen({super.key});

  @override
  State<RemediesScreen> createState() => _RemediesScreenState();
}

class _RemediesScreenState extends State<RemediesScreen> {
  final RemedyService _service = RemedyService();
  List<Remedy> _remedies = [];
  bool _isLoading = true;
  String? _selectedType;
  String? _selectedPlanet;
  String? _selectedProblemType;

  @override
  void initState() {
    super.initState();
    _loadRemedies();
  }

  Future<void> _loadRemedies() async {
    setState(() => _isLoading = true);
    final list = await _service.fetchRemedies(
      type: _selectedType,
      planet: _selectedPlanet,
      problemType: _selectedProblemType,
    );
    if (mounted) {
      setState(() {
        _remedies = list;
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

  void _applyFilters(String? type, String? planet, String? problemType) {
    setState(() {
      _selectedType = type;
      _selectedPlanet = planet;
      _selectedProblemType = problemType;
    });
    _loadRemedies();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Dark background
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
          icon: Icon(
            Navigator.of(context).canPop() ? Icons.arrow_back : Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Scaffold.of(context).openDrawer();
            }
          },
        ),
        title: const Text(
          'Astro Remedies',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: "secondary",
          ),
        ),
        actions: [
          _buildAppBarIcon(Icons.account_balance_wallet_outlined, "₹0", theme),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: AppColors.goldAccent),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // All Remedies Grid
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "All Remedies",
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.8,
                        ),
                    itemCount: _remedies.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RemedyDetailScreen(remedy: _remedies[index]),
                            ),
                          );
                        },
                        child: _buildRemedyCard(
                          _remedies[index],
                          theme,
                          isDark,
                        ),
                      );
                    },
                  ),
                  if (_remedies.isEmpty) _buildEmptyState(theme, isDark),
                ],
              ),
            ),
    );
  }

  Widget _buildRemedyCard(Remedy remedy, ThemeData theme, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: isDark ? null : Border.all(color: AppColors.lightBorder),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Stack(
        children: [
          // Image (as child with border radius)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              remedy.imagePath,
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: isDark ? AppColors.darkSection : Colors.grey.shade200,
                child: Icon(
                  Icons.broken_image,
                  color: theme.colorScheme.onSurface.withOpacity(0.2),
                ),
              ),
            ),
          ),

          // Glass-like Overlay at Bottom
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.9),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.4, 0.6, 1.0],
                ),
              ),
            ),
          ),

          // Price Tag (Top Left)
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF4B2B), Color(0xFFFF416C)],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Text(
                remedy.price.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          // Content (Bottom)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.black.withValues(alpha: 0.3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        remedy.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: "secondary",
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        remedy.description,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 10,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Icon(
            Icons.spa_outlined,
            size: 80,
            color: AppColors.goldAccent.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            "No remedies found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Try adjusting your filters",
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
        color: Colors.white.withValues(alpha: 0.1),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 18),
          if (label != null) ...[
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterSheet() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    String? tempType = _selectedType;
    String? tempPlanet = _selectedPlanet;
    String? tempProblemType = _selectedProblemType;

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
                    "Filter Remedies",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      setModalState(() {
                        tempType = null;
                        tempPlanet = null;
                        tempProblemType = null;
                      });
                    },
                    child: const Text("Reset"),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Type Filter
              const Text(
                "Type",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 10,
                children:
                    [
                      'POOJA',
                      'HEALING',
                      'SPELL',
                      'COMBO',
                      'TRANSIT',
                      'READING',
                    ].map((type) {
                      final isSelected = tempType == type;
                      return _buildFilterChip(
                        label: type,
                        isSelected: isSelected,
                        onSelected: (selected) {
                          setModalState(() {
                            tempType = selected ? type : null;
                          });
                        },
                      );
                    }).toList(),
              ),
              const SizedBox(height: 20),

              // Planet Filter
              const Text(
                "Planet",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 10,
                children:
                    [
                      'Sun',
                      'Moon',
                      'Mars',
                      'Mercury',
                      'Jupiter',
                      'Venus',
                      'Saturn',
                      'Rahu',
                      'Ketu',
                    ].map((planet) {
                      final isSelected = tempPlanet == planet;
                      return _buildFilterChip(
                        label: planet,
                        isSelected: isSelected,
                        onSelected: (selected) {
                          setModalState(() {
                            tempPlanet = selected ? planet : null;
                          });
                        },
                      );
                    }).toList(),
              ),
              const SizedBox(height: 20),

              // Problem Type Filter
              const Text(
                "Problem Type",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 10,
                children:
                    [
                      'Health',
                      'Love',
                      'Career',
                      'Protection',
                      'General',
                      'Mind',
                      'Future',
                      'Dosha',
                    ].map((problem) {
                      final isSelected = tempProblemType == problem;
                      return _buildFilterChip(
                        label: problem,
                        isSelected: isSelected,
                        onSelected: (selected) {
                          setModalState(() {
                            tempProblemType = selected ? problem : null;
                          });
                        },
                      );
                    }).toList(),
              ),
              const SizedBox(height: 32),

              // Apply Button
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: AppColors.goldGradient,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.goldAccent.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    _applyFilters(tempType, tempPlanet, tempProblemType);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Apply Filters",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required Function(bool) onSelected,
  }) {
    return GestureDetector(
      onTap: () => onSelected(!isSelected),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.goldAccent
              : AppColors.goldAccent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.goldAccent
                : AppColors.goldAccent.withValues(alpha: 0.2),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black87 : AppColors.goldAccent,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
