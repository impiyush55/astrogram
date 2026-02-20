import 'package:astrogram/helper/color.dart';
import 'package:astrogram/models/kundli_model.dart';
import 'package:astrogram/services/kundli_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/auth_service.dart';
import 'kundli_input_screen.dart';

class KundliScreen extends StatefulWidget {
  final KundliRequest? request;
  const KundliScreen({super.key, this.request});

  @override
  State<KundliScreen> createState() => _KundliScreenState();
}

class _KundliScreenState extends State<KundliScreen>
    with TickerProviderStateMixin {
  late TabController _mainTabController;
  late TabController _understandingTabController;
  final KundliService _kundliService = KundliService();
  final AuthService _authService = AuthService();
  KundliData? _kundliData;
  bool _isLoading = true;
  String? _errorMessage;
  String _chartType = "North Indian";

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 6, vsync: this);
    _understandingTabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      KundliRequest? effectiveRequest = widget.request;

      // 1. If no request provided, attempt to fetch from user profile
      Map<String, dynamic>? profile;
      if (effectiveRequest == null) {
        profile = await _authService.fetchUserProfile();

        // FALLBACK: If profile fetch fails (500/404) or is missing, use dummy data for demo
        if (profile == null ||
            profile.containsKey('notFound') ||
            profile.containsKey('error') ||
            profile.containsKey('status')) {
          profile = {
            "fullName": "Test User",
            "dateOfBirth": "1990-01-01",
            "timeOfBirth": "12:00:00",
            "placeOfBirth": "New Delhi, Delhi, India",
            "gender": "Male",
          };
        }

        effectiveRequest = _mapProfileToRequest(profile);
      }

      // 2. If we still don't have a valid request, show error/redirect
      if (effectiveRequest == null) {
        setState(() {
          _isLoading = false;
          _errorMessage =
              "Profile details missing. Please complete your profile first.";
        });
        return;
      }

      // 3. Fetch Kundli data using the request
      final results = await Future.wait([
        _kundliService.fetchBasicPlanetData(effectiveRequest),
        _kundliService.fetchPredictions(effectiveRequest),
        _kundliService.fetchDasha(effectiveRequest),
      ]);

      if (mounted) {
        setState(() {
          // Merge results into a single KundliData object
          final Map<String, dynamic> basicData =
              results[0] as Map<String, dynamic>;
          final Map<String, dynamic> predictionData =
              results[1] as Map<String, dynamic>;
          final Map<String, dynamic> dashaData =
              results[2] as Map<String, dynamic>;

          final predictions = predictionData['predictions'] as List;
          final dasha = dashaData['vimsottari_dasha'] as List;

          _kundliData = KundliData.fromJson(basicData).copyWith(
            predictions: predictions
                .map((p) => PredictionInfo(type: p['type'], text: p['text']))
                .toList(),
            vimsottariDasha: dasha
                .map(
                  (d) => DashaInfo(
                    planet: d['planet'],
                    startTime: d['start_time'],
                    endTime: d['end_time'],
                  ),
                )
                .toList(),
          );
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading Kundli data: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Failed to load Kundli data. Please try again.";
        });
      }
    }
  }

  KundliRequest? _mapProfileToRequest(Map<String, dynamic> profile) {
    try {
      final name = profile['fullName']?.toString();
      final dobStr = profile['dateOfBirth']?.toString();
      final tobStr = profile['timeOfBirth']?.toString();
      final pob = profile['placeOfBirth']?.toString();

      if (name == null || dobStr == null || tobStr == null || pob == null) {
        return null;
      }

      // Parse Date (Expects YYYY-MM-DD or similar from backend)
      // Kundli API wants dd/MM/yyyy
      DateTime? dob;
      try {
        dob = DateTime.parse(dobStr);
      } catch (e) {
        // Handle other formats if necessary
        debugPrint("DOB parse error: $e");
      }

      if (dob == null) return null;

      // Format time (HH:mm:ss -> HH:mm)
      String time = tobStr;
      if (tobStr.contains(":")) {
        final parts = tobStr.split(":");
        if (parts.length >= 2) {
          time = "${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}";
        }
      }

      return KundliRequest(
        userId: AuthService.currentUserId,
        name: name,
        location: pob,
        date: DateFormat('dd/MM/yyyy').format(dob),
        time: time,
        timezone: "+05:30", // Default for India
      );
    } catch (e) {
      debugPrint("Error mapping profile to KundliRequest: $e");
      return null;
    }
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    _understandingTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Kundli",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.language)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_rounded)),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.goldAccent),
            )
          : _errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const KundliInputScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.goldAccent,
                        foregroundColor: Colors.black,
                      ),
                      child: const Text("Enter Details Manually"),
                    ),
                  ],
                ),
              ),
            )
          : _kundliData == null
          ? const Center(child: Text("No Kundli data available."))
          : Column(
              children: [
                _buildMainTabBar(isDark),
                Expanded(
                  child: TabBarView(
                    controller: _mainTabController,
                    children: [
                      _buildBasicTab(isDark),
                      _buildChartsTab(isDark),
                      const Center(child: Text("KP System Data Coming Soon")),
                      const Center(child: Text("Ashtakvarga Data Coming Soon")),
                      _buildDashaTab(isDark),
                      _buildReportTab(isDark),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: _buildBottomActionButtons(isDark),
    );
  }

  Widget _buildMainTabBar(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: Colors.transparent,
      child: Container(
        height: 50,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.grey.shade200,
          ),
        ),
        child: TabBar(
          controller: _mainTabController,
          isScrollable: true,
          dividerColor: Colors.transparent,
          tabAlignment: TabAlignment.start,
          indicator: BoxDecoration(
            color: AppColors.goldAccent,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: AppColors.goldAccent.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          labelColor: Colors.black,
          unselectedLabelColor: isDark ? Colors.white70 : Colors.black54,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(text: "Basic"),
            Tab(text: "Charts"),
            Tab(text: "KP"),
            Tab(text: "Ashtakvarga"),
            Tab(text: "Dasha"),
            Tab(text: "Report"),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicTab(bool isDark) {
    if (_kundliData == null) return const SizedBox();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoGrid(isDark),
          const SizedBox(height: 16),
          _buildManglikCard(isDark),
          const SizedBox(height: 16),
          _buildPanchangDetails(isDark),
          const SizedBox(height: 16),
          _buildAvakhadaDetails(isDark),
        ],
      ),
    );
  }

  Widget _buildInfoGrid(bool isDark) {
    final basic = _kundliData!.basicDetails;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
      ),
      color: isDark ? AppColors.darkCard : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildGridRow("Name", basic.name, "DOB", basic.dob),
            const Divider(),
            _buildGridRow("Time", basic.time, "Place", basic.place),
            const Divider(),
            _buildGridRow(
              "Lat/Long",
              basic.latLong,
              "Timezone",
              basic.timezone,
            ),
            const Divider(),
            _buildGridRow("Sunrise", basic.sunrise, "Sunset", basic.sunset),
            const Divider(),
            _buildGridRow("Ayanamsha", basic.ayanamsha, "", ""),
          ],
        ),
      ),
    );
  }

  Widget _buildGridRow(String l1, String v1, String l2, String v2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: _buildInfoItem(l1, v1)),
          if (l2.isNotEmpty) Expanded(child: _buildInfoItem(l2, v2)),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildManglikCard(bool isDark) {
    final manglik = _kundliData!.manglikAnalysis;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: manglik.isManglik
              ? Colors.red.shade100
              : Colors.green.shade100,
        ),
      ),
      color: manglik.isManglik
          ? Colors.red.withOpacity(0.05)
          : Colors.green.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: manglik.isManglik ? Colors.red : Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    manglik.status,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: manglik.isManglik ? Colors.red : Colors.green,
                    ),
                  ),
                  Text(
                    manglik.description,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPanchangDetails(bool isDark) {
    final p = _kundliData!.panchangDetails;
    return _buildSectionCard("Panchang Details", isDark, [
      _buildDetailRow("Tithi", p.tithi),
      _buildDetailRow("Karan", p.karan),
      _buildDetailRow("Yog", p.yog),
      _buildDetailRow("Nakshatra", p.nakshatra),
    ]);
  }

  Widget _buildAvakhadaDetails(bool isDark) {
    final a = _kundliData!.avakhadaDetails;
    return _buildSectionCard("Avakhada Details", isDark, [
      _buildDetailRow("Varna", a.varna),
      _buildDetailRow("Vashya", a.vashya),
      _buildDetailRow("Yoni", a.yoni),
      _buildDetailRow("Gan", a.gan),
      _buildDetailRow("Nadi", a.nadi),
      _buildDetailRow("Sign", a.sign),
      _buildDetailRow("Sign Lord", a.signLord),
      _buildDetailRow("Tatva", a.tatva),
    ]);
  }

  Widget _buildSectionCard(String title, bool isDark, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
            ),
          ),
          color: isDark ? AppColors.darkCard : Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(
            v,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildChartsTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildChartToggle(),
          const SizedBox(height: 24),
          _buildKundliVisual(isDark),
          const SizedBox(height: 32),
          _buildPlanetaryTable(isDark),
          const SizedBox(height: 32),
          _buildUnderstandingSection(isDark),
        ],
      ),
    );
  }

  Widget _buildChartToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildChartToggleBtn("North Indian", _chartType == "North Indian"),
          _buildChartToggleBtn("South Indian", _chartType == "South Indian"),
        ],
      ),
    );
  }

  Widget _buildChartToggleBtn(String label, bool isActive) {
    return GestureDetector(
      onTap: () => setState(() => _chartType = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.goldAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildKundliVisual(bool isDark) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkBorder.withOpacity(0.3)
            : Colors.amber.shade50,
        border: Border.all(
          color: AppColors.goldAccent.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: CustomPaint(
        painter: NorthIndianChartPainter(isDark: isDark),
        child: _buildPlanetOverlay(),
      ),
    );
  }

  Widget _buildPlanetOverlay() {
    if (_kundliData == null || _kundliData!.planetaryTable.isEmpty) {
      return const SizedBox();
    }

    // Group planets by house
    final Map<int, List<String>> housePlanets = {};
    for (var p in _kundliData!.planetaryTable) {
      final house = p.house;
      if (!housePlanets.containsKey(house)) {
        housePlanets[house] = [];
      }
      // Use short names for planets
      String shortName = _getShortName(p.planet);
      housePlanets[house]!.add(shortName);
    }

    // Re-calculating based on a 300x300 square
    // 1 is top diamond, 4 is left diamond, 7 is bottom diamond, 10 is right diamond
    final Map<int, Offset> finalOffsets = {
      1: const Offset(135, 120), // Top middle diamond
      2: const Offset(70, 60), // Top left triangle
      3: const Offset(40, 100), // Left top triangle
      4: const Offset(100, 135), // Left middle diamond
      5: const Offset(40, 180), // Left bottom triangle
      6: const Offset(70, 220), // Bottom left triangle
      7: const Offset(135, 180), // Bottom middle diamond
      8: const Offset(200, 220), // Bottom right triangle
      9: const Offset(230, 200), // Right bottom triangle
      10: const Offset(180, 135), // Right middle diamond
      11: const Offset(230, 100), // Right top triangle
      12: const Offset(200, 60), // Top right triangle
    };

    return Stack(
      children: housePlanets.entries.map((entry) {
        final house = entry.key;
        final planets = entry.value.join(", ");
        final pos = finalOffsets[house] ?? const Offset(150, 150);

        return _houseLabel(house, planets, pos.dy, pos.dx);
      }).toList(),
    );
  }

  String _getShortName(String full) {
    if (full.contains("Sun")) return "Su";
    if (full.contains("Moon")) return "Mo";
    if (full.contains("Mars")) return "Ma";
    if (full.contains("Mercury")) return "Me";
    if (full.contains("Jupiter")) return "Ju";
    if (full.contains("Venus")) return "Ve";
    if (full.contains("Saturn")) return "Sa";
    if (full.contains("Rahu")) return "Ra";
    if (full.contains("Ketu")) return "Ke";
    if (full.contains("Ascendant")) return "Asc";
    return full.substring(0, 2);
  }

  Widget _houseLabel(int house, String planets, double top, double left) {
    return Positioned(
      top: top,
      left: left,
      child: Column(
        children: [
          Text(
            "$house",
            style: const TextStyle(fontSize: 8, color: Colors.grey),
          ),
          Text(
            planets,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.goldAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanetaryTable(bool isDark) {
    final planets = _kundliData!.planetaryTable;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            "Planet Table",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
            ),
          ),
          child: Column(
            children: [
              // Header Row
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.goldAccent.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: const [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Planet",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: AppColors.goldAccent,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Sign",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: AppColors.goldAccent,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Lord",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: AppColors.goldAccent,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Degree",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: AppColors.goldAccent,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Hse",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: AppColors.goldAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Data Rows
              ...planets.asMap().entries.map((entry) {
                final index = entry.key;
                final p = entry.value;
                final isEven = index % 2 == 0;
                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: isEven
                        ? (isDark
                              ? Colors.white.withOpacity(0.02)
                              : Colors.yellow.shade50.withOpacity(0.5))
                        : Colors.transparent,
                    border: index != planets.length - 1
                        ? Border(
                            bottom: BorderSide(
                              color: isDark
                                  ? AppColors.darkBorder.withOpacity(0.5)
                                  : Colors.grey.shade100,
                            ),
                          )
                        : null,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          p.planet,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          p.sign,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          p.lord,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          p.degree,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          p.house.toString(),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUnderstandingSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            "Understanding Your Kundli",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
            ),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 8.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black26 : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TabBar(
                    controller: _understandingTabController,
                    indicator: BoxDecoration(
                      color: AppColors.goldAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    tabs: const [
                      Tab(text: "General"),
                      Tab(text: "Planetary"),
                      Tab(text: "Yoga"),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 180,
                child: TabBarView(
                  controller: _understandingTabController,
                  children: [
                    _buildPredictionCard(
                      _kundliData!.understandingYourKundli.general,
                    ),
                    _buildPredictionCard(
                      _kundliData!.understandingYourKundli.planetary,
                    ),
                    _buildPredictionCard(
                      _kundliData!.understandingYourKundli.yoga,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDashaTab(bool isDark) {
    final dasha = _kundliData?.vimsottariDasha ?? [];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Vimsottari Dasha Timeline",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),
          ...dasha.map((d) => _buildDashaItem(d, isDark)),
        ],
      ),
    );
  }

  Widget _buildDashaItem(DashaInfo d, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.goldAccent,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  d.planet.substring(0, 1),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                d.planet,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Ends: ${d.endTime}",
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.goldAccent,
                ),
              ),
              Text(
                "From: ${d.startTime}",
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportTab(bool isDark) {
    final reports = _kundliData?.predictions ?? [];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Detailed Predictions",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),
          ...reports.map((r) => _buildReportSection(r, isDark)),
        ],
      ),
    );
  }

  Widget _buildReportSection(PredictionInfo p, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            p.type,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.goldAccent,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            p.text,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionCard(String text) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, height: 1.5, color: Colors.grey),
      ),
    );
  }

  Widget _buildBottomActionButtons(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F122B) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildCTAButton(
              "Chat with Astrologer",
              Icons.chat_bubble_outline,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildCTAButton("Call with Astrologer", Icons.call_outlined),
          ),
        ],
      ),
    );
  }

  Widget _buildCTAButton(String label, IconData icon) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.goldAccent,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class NorthIndianChartPainter extends CustomPainter {
  final bool isDark;
  NorthIndianChartPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.goldAccent.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final w = size.width;
    final h = size.height;

    canvas.drawRect(Offset.zero & size, paint);
    canvas.drawLine(Offset.zero, Offset(w, h), paint);
    canvas.drawLine(Offset(0, h), Offset(w, 0), paint);
    canvas.drawLine(Offset(w / 2, 0), Offset(0, h / 2), paint);
    canvas.drawLine(Offset(0, h / 2), Offset(w / 2, h), paint);
    canvas.drawLine(Offset(w / 2, h), Offset(w, h / 2), paint);
    canvas.drawLine(Offset(w, h / 2), Offset(w / 2, 0), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

extension on KundliData {
  KundliData copyWith({
    List<DashaInfo>? vimsottariDasha,
    List<PredictionInfo>? predictions,
  }) {
    return KundliData(
      basicDetails: basicDetails,
      manglikAnalysis: manglikAnalysis,
      planetaryTable: planetaryTable,
      understandingYourKundli: understandingYourKundli,
      panchangDetails: panchangDetails,
      avakhadaDetails: avakhadaDetails,
      vimsottariDasha: vimsottariDasha ?? this.vimsottariDasha,
      predictions: predictions ?? this.predictions,
    );
  }
}
