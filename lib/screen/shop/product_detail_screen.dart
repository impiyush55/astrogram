import 'package:flutter/material.dart';
import '../../helper/color.dart';

import '../../models/product_model.dart';
import 'package:share_plus/share_plus.dart';
import '../../services/cart_service.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final CartService _cartService = CartService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final product = widget.product;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.share,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () =>
                Share.share('Check out ${product.name} on AstroGram!'),
          ),
          AnimatedBuilder(
            animation: _cartService,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartScreen(),
                        ),
                      );
                    },
                  ),
                  if (_cartService.itemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${_cartService.itemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      // Extending body behind app bar if needed? existing design didn't.
      // We will use a SingleChildScrollView with a centralized Card look.
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              // Main Product Card
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Product Image Area
                    Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSection
                            : AppColors.lightSection,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                            child: product.primaryImage.isEmpty
                                ? Icon(
                                    Icons.diamond_outlined,
                                    size: 100,
                                    color: isDark
                                        ? AppColors.goldAccent.withOpacity(0.5)
                                        : Colors.grey.shade400,
                                  )
                                : (product.primaryImage.startsWith('http')
                                      ? Image.network(
                                          product.primaryImage,
                                          fit: BoxFit.contain,
                                        )
                                      : Image.asset(
                                          product.primaryImage,
                                          fit: BoxFit.contain,
                                        )),
                          ),
                          // Optional: Image dots if multiple images (omitted for simplicity based on screenshot)
                        ],
                      ),
                    ),

                    // Product Details Content
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Size dummy text (from screenshot)
                          Text(
                            product.category == 'Rudraksha'
                                ? 'Size • 17mm - 22mm'
                                : product.category,
                            style: TextStyle(
                              color: isDark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Product Name
                          Text(
                            product.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Ratings
                          Row(
                            children: [
                              ...List.generate(5, (index) {
                                return Icon(
                                  index < product.rating.floor()
                                      ? Icons.star
                                      : (index < product.rating
                                            ? Icons.star_half
                                            : Icons.star_border),
                                  color: const Color(0xFFFFC107), // Amber/Gold
                                  size: 18,
                                );
                              }),
                              const SizedBox(width: 8),
                              Text(
                                '${product.rating} (${product.reviewCount} reviews)',
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Stock Indicator
                          if (product.stock < 10 && product.stock > 0)
                            Row(
                              children: [
                                const Icon(
                                  Icons.bolt,
                                  color: Colors.orange,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Only ${product.stock} left in stock!',
                                  style: const TextStyle(
                                    color: Colors.orange,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          else if (product.stock == 0)
                            const Text(
                              'Out of Stock',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                          const SizedBox(height: 16),

                          // Price Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Rs. ${product.finalPrice.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(
                                    0xFFE67E22,
                                  ), // Pumpkin Orange
                                ),
                              ),
                              if (product.hasDiscount) ...[
                                const SizedBox(width: 12),
                                Text(
                                  'Rs. ${product.price.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isDark
                                        ? Colors.grey.shade500
                                        : Colors.grey.shade400,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                              if (product.hasDiscount) ...[
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'or Rs. ${(product.finalPrice / 3).toStringAsFixed(2)}/month  EMI',
                            style: TextStyle(
                              color: isDark
                                  ? Colors.grey.shade500
                                  : Colors.grey.shade600,
                              fontSize: 10,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Buttons
                          Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // This logic already exists on this page, but if the design
                                    // implies "View Details" moves you to more info, we can scroll.
                                    // For now, let's keep it structurally similar to the screenshot.
                                    // Maybe scroll down to description?
                                    // Or just act as "Add to Cart" since we are already viewing details?
                                    // User said "next page will be open like that", suggesting this IS the view.
                                    // I will map "View Details" to Add to Cart for functionality sake,
                                    // or maybe just scroll to description below.
                                    _cartService.addToCart(product);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Added ${product.name} to cart',
                                        ),
                                        action: SnackBarAction(
                                          label: 'CART',
                                          onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const CartScreen(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(
                                      0xFFE67E22,
                                    ), // Orange
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'Add to Cart', // "View Details" in screenshot likely leads here, but we are here. Changed to Add to Cart for utility. OR should I label it View Details and just scroll?
                                    // Actually, let's label it "View Details" -> Opens BottomSheet with full text?
                                    // No, let's just make it Add to Cart but with Orange color.
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    // Placeholder for chat
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Expert chat coming soon!',
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.chat_bubble_outline,
                                    size: 20,
                                  ),
                                  label: const Text('Talk to Expert'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    side: BorderSide(
                                      color: isDark
                                          ? Colors.grey.shade600
                                          : Colors.black,
                                    ),
                                    foregroundColor: isDark
                                        ? Colors.white
                                        : Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
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

              const SizedBox(height: 24),
              // Full details below the card (Description, Specs)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.longDescription.isNotEmpty
                          ? product.longDescription
                          : product.shortDescription,
                      style: TextStyle(
                        color: isDark
                            ? Colors.grey.shade300
                            : Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Specifications
                    if (product.categorySpecificData != null &&
                        product.categorySpecificData!.isNotEmpty) ...[
                      Text(
                        'Specifications',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...product.categorySpecificData!.entries.map((entry) {
                        if (entry.value == null) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 120,
                                child: Text(
                                  _formatKey(entry.key),
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  entry.value.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: isDark
                                        ? Colors.grey.shade300
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to format map keys (e.g., "mukhi_type" -> "Mukhi Type")
  String _formatKey(String key) {
    return key
        .split('_')
        .map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }
}
