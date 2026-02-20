import 'package:flutter/material.dart';
import '../../helper/color.dart';

class BookPujaScreen extends StatefulWidget {
  const BookPujaScreen({super.key});

  @override
  State<BookPujaScreen> createState() => _BookPujaScreenState();
}

class _BookPujaScreenState extends State<BookPujaScreen> {
  bool _isLoading = false;
  bool _locationDetected = false;
  String _currentLocation = "Unknown Location";
  List<Map<String, dynamic>> _filteredPandits = [];

  // Mock Data
  final List<Map<String, dynamic>> _allPandits = [
    {
      "id": 1,
      "name": "Pandit Krishna Sharma",
      "speciality": "Vedic Puja, Hawan",
      "experience": "15 Years",
      "distance": 3.2, // km
      "location": "Lajpat Nagar, New Delhi",
      "price": 2100,
      "rating": 4.9,
      "image": "lib/assets/images/men1.png",
      "isAvailable": true,
    },
    {
      "id": 2,
      "name": "Acharya Ravi Shastri",
      "speciality": "Griha Pravesh, Vastu",
      "experience": "12 Years",
      "distance": 8.5, // km
      "location": "Saket, New Delhi",
      "price": 5100,
      "rating": 4.8,
      "image": "lib/assets/images/panditji.jpg",
      "isAvailable": true,
    },
    {
      "id": 3,
      "name": "Pandit Suresh Mishra",
      "speciality": "Marriage, Kundli",
      "experience": "20 Years",
      "distance": 12.0, // km
      "location": "Dwarka, New Delhi",
      "price": 3100,
      "rating": 4.7,
      "image": "lib/assets/images/pandit2.jpg",
      "isAvailable": true,
    },
    {
      "id": 4,
      "name": "Acharya Deepak",
      "speciality": "Rudrabhishek, Kaal Sarp",
      "experience": "8 Years",
      "distance": 18.5, // km - Outside 15km
      "location": "Noida Sector 18",
      "price": 2500,
      "rating": 4.6,
      "image": "lib/assets/images/pandit3.jpeg",
      "isAvailable": true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _detectLocation(); // Auto-detect on load
  }

  Future<void> _detectLocation() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay for location simulation
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _locationDetected = true;
        _currentLocation = "New Delhi, India"; // Mocked Location
        // Filter pandits within 15km
        _filteredPandits = _allPandits
            .where((p) => (p['distance'] as double) <= 15.0)
            .toList();
        // Sort by distance
        _filteredPandits.sort(
          (a, b) =>
              (a['distance'] as double).compareTo(b['distance'] as double),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          Colors.transparent, // Handled by HomeScreen body container
      body: Column(
        children: [
          _buildLocationHeader(isDark),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredPandits.isEmpty
                ? Center(
                    child: Text(
                      "No Pandits found nearby.",
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredPandits.length,
                    itemBuilder: (context, index) {
                      return _buildPanditCard(
                        _filteredPandits[index],
                        isDark,
                        theme,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSection : AppColors.lightSection,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.location_on, color: AppColors.goldAccent, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _locationDetected ? "Current Location" : "Detecting...",
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? Colors.grey : Colors.grey.shade700,
                  ),
                ),
                Text(
                  _currentLocation,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.goldAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.goldAccent),
            ),
            child: Text(
              "Within 15 KM",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.goldAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPanditCard(
    Map<String, dynamic> pandit,
    bool isDark,
    ThemeData theme,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(pandit['image']),
                      fit: BoxFit.cover,
                      onError:
                          (
                            e,
                            s,
                          ) {}, // Image placeholder handled by errorBuilder usually, but simple here
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pandit['name'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        pandit['speciality'],
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.goldAccent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            "${pandit['rating']} (${pandit['experience']})",
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.grey
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.near_me, size: 14, color: Colors.green),
                          const SizedBox(width: 4),
                          Text(
                            "${pandit['distance']} km away",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
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
          // Actions
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withOpacity(0.2)
                  : Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "₹ ${pandit['price']}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Booking request sent to ${pandit['name']}",
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 0,
                    ),
                  ),
                  child: const Text("Book Now"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
