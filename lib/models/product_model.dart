class Product {
  final String id;
  final String name;
  final String category;
  final String? subcategory;
  final String shortDescription;
  final String longDescription;
  final double price;
  final double discountPercentage;
  final String primaryImage;
  final List<String> images;
  final String? videoUrl;
  final String deliveryTime;
  final double shippingCharges;
  final int totalSales;
  final bool isTrending;
  final bool isBestSeller;
  final bool isNewArrival;
  final bool isFeatured;
  final List<String> tags;
  // Category specific data (Map to hold flexible attributes)
  final Map<String, dynamic>? categorySpecificData;
  final List<String> relatedProductIds;

  final double rating;
  final int reviewCount;
  final int stock;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    this.subcategory,
    required this.shortDescription,
    this.longDescription = '',
    required this.price,
    this.discountPercentage = 0,
    required this.primaryImage,
    this.images = const [],
    this.videoUrl,
    this.deliveryTime = '3-5 days',
    this.shippingCharges = 0,
    this.totalSales = 0,
    this.isTrending = false,
    this.isBestSeller = false,
    this.isNewArrival = false,
    this.isFeatured = false,
    this.tags = const [],
    this.categorySpecificData,
    this.relatedProductIds = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.stock = 0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      subcategory: json['subcategory'],
      shortDescription: json['short_description'] ?? '',
      longDescription: json['long_description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      discountPercentage: (json['discount_percentage'] ?? 0).toDouble(),
      primaryImage: json['primary_image'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      videoUrl: json['video_url'],
      deliveryTime: json['delivery_time'] ?? '3-5 days',
      shippingCharges: (json['shipping_charges'] ?? 0).toDouble(),
      totalSales: json['total_sales'] ?? 0,
      isTrending: json['is_trending'] ?? false,
      isBestSeller: json['is_best_seller'] ?? false,
      isNewArrival: json['is_new_arrival'] ?? false,
      isFeatured: json['is_featured'] ?? false,
      tags: List<String>.from(json['tags'] ?? []),
      categorySpecificData: json['category_specific_data'],
      relatedProductIds: List<String>.from(json['related_product_ids'] ?? []),
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      stock: json['stock'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'subcategory': subcategory,
      'short_description': shortDescription,
      'long_description': longDescription,
      'price': price,
      'discount_percentage': discountPercentage,
      'primary_image': primaryImage,
      'images': images,
      'video_url': videoUrl,
      'delivery_time': deliveryTime,
      'shipping_charges': shippingCharges,
      'total_sales': totalSales,
      'is_trending': isTrending,
      'is_best_seller': isBestSeller,
      'is_new_arrival': isNewArrival,
      'is_featured': isFeatured,
      'tags': tags,
      'category_specific_data': categorySpecificData,
      'related_product_ids': relatedProductIds,
      'rating': rating,
      'reviewCount': reviewCount,
      'stock': stock,
    };
  }

  double get finalPrice => price - (price * discountPercentage / 100);
  double get savingsAmount => price - finalPrice;
  bool get hasDiscount => discountPercentage > 0;
  bool get isInStock => stock > 0;
  bool get isLowStock => stock < 10 && stock > 0;
  bool get isOutOfStock => stock == 0;
}

// Category-specific data models
class RudrakshData {
  final int mukhiType;
  final String productForm; // 'single_bead', 'bracelet', 'mala', 'pendant'
  final List<String> primaryPurpose;
  final List<String> problemsSolved;
  final List<String> zodiacCompatibility;
  final String? chakraAssociation;
  final Map<String, List<String>>? energyBenefits;
  final String whoShouldWear;
  final Map<String, String>? wearingInstructions;
  final bool isEnergized;
  final bool isMantraCharged;
  final String materialQuality;
  final String origin;
  final String beadSize;

  RudrakshData({
    required this.mukhiType,
    required this.productForm,
    required this.primaryPurpose,
    required this.problemsSolved,
    required this.zodiacCompatibility,
    this.chakraAssociation,
    this.energyBenefits,
    required this.whoShouldWear,
    this.wearingInstructions,
    this.isEnergized = false,
    this.isMantraCharged = false,
    required this.materialQuality,
    required this.origin,
    required this.beadSize,
  });

  factory RudrakshData.fromJson(Map<String, dynamic> json) {
    return RudrakshData(
      mukhiType: json['mukhi_type'] ?? 5,
      productForm: json['product_form'] ?? 'single_bead',
      primaryPurpose: List<String>.from(json['primary_purpose'] ?? []),
      problemsSolved: List<String>.from(json['problems_solved'] ?? []),
      zodiacCompatibility: List<String>.from(
        json['zodiac_compatibility'] ?? [],
      ),
      chakraAssociation: json['chakra_association'],
      energyBenefits: json['energy_benefits'] != null
          ? Map<String, List<String>>.from(json['energy_benefits'])
          : null,
      whoShouldWear: json['who_should_wear'] ?? '',
      wearingInstructions: json['wearing_instructions'] != null
          ? Map<String, String>.from(json['wearing_instructions'])
          : null,
      isEnergized: json['is_energized'] ?? false,
      isMantraCharged: json['is_mantra_charged'] ?? false,
      materialQuality: json['material_quality'] ?? 'Original',
      origin: json['origin'] ?? 'Nepal',
      beadSize: json['bead_size'] ?? '12mm',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'mukhi_type': mukhiType,
      'product_form': productForm,
      'primary_purpose': primaryPurpose,
      'problems_solved': problemsSolved,
      'zodiac_compatibility': zodiacCompatibility,
      'chakra_association': chakraAssociation,
      'energy_benefits': energyBenefits,
      'who_should_wear': whoShouldWear,
      'wearing_instructions': wearingInstructions,
      'is_energized': isEnergized,
      'is_mantra_charged': isMantraCharged,
      'material_quality': materialQuality,
      'origin': origin,
      'bead_size': beadSize,
    };
  }
}

class GemstoneData {
  final String gemstoneType;
  final String associatedPlanet;
  final double caratWeight;
  final String color;
  final String clarity;
  final String shape;
  final String origin;
  final String treatment;
  final bool isCertified;
  final List<String> zodiacCompatibility;
  final String whoShouldWear;
  final String whoShouldNotWear;
  final Map<String, String>? wearingInstructions;
  final List<String> astrologicalBenefits;
  final List<String> healthBenefits;

  GemstoneData({
    required this.gemstoneType,
    required this.associatedPlanet,
    required this.caratWeight,
    required this.color,
    required this.clarity,
    required this.shape,
    required this.origin,
    required this.treatment,
    this.isCertified = false,
    required this.zodiacCompatibility,
    required this.whoShouldWear,
    required this.whoShouldNotWear,
    this.wearingInstructions,
    required this.astrologicalBenefits,
    required this.healthBenefits,
  });

  factory GemstoneData.fromJson(Map<String, dynamic> json) {
    return GemstoneData(
      gemstoneType: json['gemstone_type'] ?? '',
      associatedPlanet: json['associated_planet'] ?? '',
      caratWeight: (json['carat_weight'] ?? 0).toDouble(),
      color: json['color'] ?? '',
      clarity: json['clarity'] ?? '',
      shape: json['shape'] ?? '',
      origin: json['origin'] ?? '',
      treatment: json['treatment'] ?? 'Natural',
      isCertified: json['is_certified'] ?? false,
      zodiacCompatibility: List<String>.from(
        json['zodiac_compatibility'] ?? [],
      ),
      whoShouldWear: json['who_should_wear'] ?? '',
      whoShouldNotWear: json['who_should_not_wear'] ?? '',
      wearingInstructions: json['wearing_instructions'] != null
          ? Map<String, String>.from(json['wearing_instructions'])
          : null,
      astrologicalBenefits: List<String>.from(
        json['astrological_benefits'] ?? [],
      ),
      healthBenefits: List<String>.from(json['health_benefits'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gemstone_type': gemstoneType,
      'associated_planet': associatedPlanet,
      'carat_weight': caratWeight,
      'color': color,
      'clarity': clarity,
      'shape': shape,
      'origin': origin,
      'treatment': treatment,
      'is_certified': isCertified,
      'zodiac_compatibility': zodiacCompatibility,
      'who_should_wear': whoShouldWear,
      'who_should_not_wear': whoShouldNotWear,
      'wearing_instructions': wearingInstructions,
      'astrological_benefits': astrologicalBenefits,
      'health_benefits': healthBenefits,
    };
  }
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => product.finalPrice * quantity;
}
