import 'package:flutter/material.dart';

class AstroShopTab extends StatelessWidget {
  const AstroShopTab({super.key});

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
      'image': 'assets/shop/services.png',
      'icon': Icons.miscellaneous_services,
    },
    {
      'name': 'Kundli AI+',
      'image': 'lib/assets/images/kundli.png',
      'icon': Icons.psychology,
    },
    {
      'name': 'CogniAstro',
      'image': 'assets/shop/cogniastro.png',
      'icon': Icons.school,
    },
    {
      'name': 'Miscellaneous',
      'image': 'assets/shop/misc.png',
      'icon': Icons.folder,
    },
    {'name': 'Aroma', 'image': 'assets/shop/aroma.png', 'icon': Icons.air},
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          _buildPromoBanner(),
          const SizedBox(height: 16),
          _buildShopGrid(),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      height: 140, // Approximate height
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [Color(0xFF800000), Color(0xFF400000)], // Dark Red gradient
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Stack(
        children: [
          // Background decorations (stars/sparkles)
          Positioned(
            top: 10,
            left: 10,
            child: Icon(Icons.star, color: Colors.white24, size: 20),
          ),
          Positioned(
            bottom: 20,
            right: 40,
            child: Icon(Icons.star, color: Colors.white24, size: 15),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Up to ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: '75%',
                              style: TextStyle(
                                color: Color(0xFFFFD700),
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: ' Off',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'on all Astrology Products',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFFCC00), // Light Gold
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 0,
                          ),
                          minimumSize: Size(0, 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Order Now',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Placeholder for 2026 Sale graphic
                      Text(
                        '20\n26',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFFFD700),
                          fontSize: 32,
                          height: 0.9,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              offset: Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'New Year',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        color: Colors.red,
                        child: Text(
                          'SALE',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Product Image Placeholder (Top center-ish)
          Positioned(
            top: 5,
            right: 100,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xFFFFD700), width: 1),
                image: DecorationImage(
                  image: NetworkImage(
                    'https://via.placeholder.com/50',
                  ), // Replace with local asset later
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.75, // Adjust height
        crossAxisSpacing: 16,
        mainAxisSpacing: 20,
      ),
      itemCount: shopItems.length,
      itemBuilder: (context, index) {
        final item = shopItems[index]; // Use final for safety
        return Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300, width: 1),
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
                        color: Colors.brown,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item['name'] as String,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      },
    );
  }
}
