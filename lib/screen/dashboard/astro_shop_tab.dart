import 'package:flutter/material.dart';
import '../../helper/color.dart';
import '../../models/product_model.dart';
import '../../services/dummy_product_service.dart';
import '../shop/product_detail_screen.dart';

class AstroShopTab extends StatefulWidget {
  const AstroShopTab({super.key});

  @override
  State<AstroShopTab> createState() => _AstroShopTabState();
}

class _AstroShopTabState extends State<AstroShopTab> {
  final DummyProductService _productService = DummyProductService();
  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final products = await _productService.getAllProducts();
    if (mounted) {
      setState(() {
        _products = products;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          _buildPromoBanner(theme, isDark),
          const SizedBox(height: 16),
          _buildCategoryFilters(isDark),
          const SizedBox(height: 16),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildShopGrid(theme, isDark),
        ],
      ),
    );
  }

  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Rudraksha',
    'Gemstone',
    'Yantra',
    'Mala',
    'Pendant',
  ];

  Widget _buildCategoryFilters(bool isDark) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
                _isLoading = true;
              });
              _filterProducts(category);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.goldAccent
                    : (isDark ? AppColors.darkCard : Colors.grey.shade200),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.goldAccent
                      : (isDark ? AppColors.darkBorder : Colors.grey.shade300),
                ),
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.black
                        : (isDark ? Colors.white : Colors.black),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _filterProducts(String category) async {
    final products = await _productService.getProductsByCategory(category);
    if (mounted) {
      setState(() {
        _products = products;
        _isLoading = false;
      });
    }
  }

  Widget _buildPromoBanner(ThemeData theme, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      height: 140, // Approximate height
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.onboardingPurple, AppColors.onboardingBlack]
              : [
                  const Color(0xFF800000),
                  const Color(0xFF400000),
                ], // Dark Red gradient
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
                                color: AppColors.goldAccent,
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
                          color: AppColors.goldAccent,
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
                        decoration: BoxDecoration(color: Colors.red),
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

          // Sparkle decorations
          Positioned(
            top: 15,
            right: 120,
            child: Icon(
              Icons.auto_awesome,
              color: AppColors.goldAccent.withValues(alpha: 0.3),
              size: 24,
            ),
          ),
          Positioned(
            top: 40,
            right: 80,
            child: Icon(
              Icons.auto_awesome,
              color: AppColors.goldAccent.withValues(alpha: 0.2),
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopGrid(ThemeData theme, bool isDark) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.75, // Adjusted for better height
        crossAxisSpacing: 16,
        mainAxisSpacing: 12,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final item = _products[index];
        return InkWell(
          onTap: () {
            print("Tapped on product: ${item.name}");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(product: item),
              ),
            );
          },
          child: Container(
            color: Colors.transparent, // Ensure hit test works on full area
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkBorder
                          : Colors.grey.shade300,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: item.primaryImage.isEmpty
                        ? Center(
                            child: Icon(
                              Icons.diamond,
                              size: 28,
                              color: isDark
                                  ? AppColors.goldAccent
                                  : Colors.brown,
                            ),
                          )
                        : (item.primaryImage.startsWith('http')
                              ? Image.network(
                                  item.primaryImage,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        size: 28,
                                        color: isDark
                                            ? AppColors.goldAccent
                                            : Colors.brown,
                                      ),
                                    );
                                  },
                                )
                              : Image.asset(
                                  item.primaryImage,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Icon(
                                        Icons.local_mall,
                                        size: 28,
                                        color: isDark
                                            ? AppColors.goldAccent
                                            : Colors.brown,
                                      ),
                                    );
                                  },
                                )),
                  ),
                ),
                const SizedBox(height: 6),
                Flexible(
                  child: Text(
                    item.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${item.finalPrice.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: AppColors.goldAccent, // Or a price color
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
