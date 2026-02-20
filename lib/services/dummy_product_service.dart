import '../models/product_model.dart';

class DummyProductService {
  static final List<Product> _allProducts = [
    // --- Rudraksha ---
    Product(
      id: 'rud-001',
      name: '5 Mukhi Rudraksha - Nepal Origin',
      category: 'Rudraksha',
      subcategory: 'Single Bead',
      shortDescription: 'For peace of mind and general well-being.',
      longDescription:
          'The 5 Mukhi Rudraksha is the most common and accessible Rudraksha bead. It represents Lord Shiva himself (Kalagni Rudra). Wearing this bead brings peace of mind, improved memory, and general well-being. It is excellent for reducing stress and anxiety. This bead is of Nepal origin, known for its high quality and effectiveness.',
      price: 1500,
      discountPercentage: 20,
      stock: 50,
      primaryImage:
          'lib/assets/images/rudraksha.png', // Ensure this exists or use placeholder
      images: ['lib/assets/images/rudraksha.png'],
      deliveryTime: '3-5 days',
      rating: 4.8,
      reviewCount: 124,
      isBestSeller: true,
      tags: ['peace', 'health', 'shiva', 'stress-relief'],
      categorySpecificData: RudrakshData(
        mukhiType: 5,
        productForm: 'Single Bead',
        primaryPurpose: ['Peace', 'Health', 'Spiritual Growth'],
        problemsSolved: ['Stress', 'Anxiety', 'Blood Pressure'],
        zodiacCompatibility: [
          'Aries',
          'Leo',
          'Sagittarius',
          'Scorpio',
        ], // Generally good for all
        chakraAssociation: 'Throat Chakra',
        whoShouldWear:
            'Anyone seeking peace of mind, students, teachers, and public speakers.',
        materialQuality: 'Original Nepal',
        origin: 'Nepal',
        beadSize: '18mm',
        isEnergized: true,
      ).toJson(),
    ),
    Product(
      id: 'rud-002',
      name: '7 Mukhi Rudraksha - Wealth & Prosperity',
      category: 'Rudraksha',
      subcategory: 'Single Bead',
      shortDescription: 'For wealth, career growth and financial stability.',
      longDescription:
          'The 7 Mukhi Rudraksha represents Goddess Mahalakshmi. It is believed to bless the wearer with wealth, prosperity, and financial stability. It opens new opportunities in career and business. Beneficial for reducing financial stress.',
      price: 2500,
      discountPercentage: 10,
      stock: 8,
      rating: 4.9,
      reviewCount: 42,
      primaryImage: 'lib/assets/images/rudraksha.png',
      categorySpecificData: {
        'mukhi_type': 7,
        'product_form': 'Single Bead',
        'primary_purpose': ['Wealth', 'Career', 'Prosperity'],
        'problems_solved': ['Financial Debt', 'Business Losses'],
        'zodiac_compatibility': ['Capricorn', 'Aquarius'],
        'associated_deity': 'Mahalakshmi',
        'origin': 'Nepal',
        'who_should_wear':
            'Business owners, professionals seeking promotion, and those facing financial crunch.',
      },
    ),

    // --- Gemstones ---
    Product(
      id: 'gem-001',
      name: 'Yellow Sapphire (Pukhraj)',
      category: 'Gemstone',
      shortDescription: 'For wisdom, prosperity, and marriage.',
      longDescription:
          'Yellow Sapphire is the gemstone of Jupiter (Guru). It brings wisdom, prosperity, and happiness. It is highly recommended for success in education, career, and for early marriage for women.',
      price: 15000,
      stock: 5,
      rating: 4.9,
      reviewCount: 45,
      primaryImage: 'lib/assets/images/Gemstone.png',
      isTrending: true,
      categorySpecificData: GemstoneData(
        gemstoneType: 'Yellow Sapphire',
        associatedPlanet: 'Jupiter',
        caratWeight: 5.2,
        color: 'Golden Yellow',
        origin: 'Sri Lanka (Ceylon)',
        isCertified: true,
        treatment: 'Natural, Unheated',
        zodiacCompatibility: ['Sagittarius', 'Pisces'],
        whoShouldWear:
            'Teachers, lawyers, judges, and people looking for marriage or higher education.',
        clarity: 'Eye Clean',
        shape: 'Oval',
        whoShouldNotWear: 'Avoid if Jupiter is in 6th, 8th or 12th house.',
        astrologicalBenefits: ['Wisdom', 'Prosperity', 'Marriage'],
        healthBenefits: ['Digestive Health', 'Mental Peace'],
      ).toJson(),
    ),
    Product(
      id: 'gem-002',
      name: 'Blue Sapphire (Neelam)',
      category: 'Gemstone',
      shortDescription: 'For fast success, wealth and protection.',
      longDescription:
          'Blue Sapphire is the gemstone of Saturn (Shani). It acts very fast and can bring immense wealth, fame, and success if it suits the wearer. It also protects from enemies and bad luck.',
      price: 25000,
      discountPercentage: 12,
      stock: 2,
      rating: 4.5,
      reviewCount: 158,
      primaryImage: 'lib/assets/images/Gemstone.png',
      categorySpecificData: GemstoneData(
        gemstoneType: 'Blue Sapphire',
        associatedPlanet: 'Saturn',
        caratWeight: 4.5,
        color: 'Royal Blue',
        origin: 'Burma',
        isCertified: true,
        treatment: 'Heated',
        zodiacCompatibility: ['Capricorn', 'Aquarius'],
        whoShouldWear: 'Professionals, Businessmen, Politicians.',
        clarity: 'VVS',
        shape: 'Cushion',
        whoShouldNotWear: 'If Saturn is debilitated or malefic.',
        astrologicalBenefits: ['Wealth', 'Fame', 'Success'],
        healthBenefits: ['Joint Pain Relief', 'Improved Focus'],
      ).toJson(),
    ),
    Product(
      id: 'gem-003',
      name: 'Ruby (Manik)',
      category: 'Gemstone',
      shortDescription: 'For power, name, and fame.',
      longDescription:
          'Ruby represents the Sun (Surya). It gives name, fame, vigor, virtue, warmth and the capacity to command. It helps to raise the individual far above the status in which he was born.',
      price: 12000,
      discountPercentage: 5,
      stock: 15,
      rating: 4.8,
      reviewCount: 65,
      primaryImage: '', // Placeholder as requested
      categorySpecificData: GemstoneData(
        gemstoneType: 'Ruby',
        associatedPlanet: 'Sun',
        caratWeight: 3.5,
        color: 'Deep Red',
        origin: 'Burma',
        isCertified: true,
        treatment: 'Natural',
        zodiacCompatibility: ['Leo'],
        whoShouldWear: 'Leaders, Politicians, Administrators.',
        clarity: 'VS',
        shape: 'Oval',
        whoShouldNotWear: 'If Sun is not favorable.',
        astrologicalBenefits: ['Power', 'Leadership', 'Confidence'],
        healthBenefits: ['Heart Health', 'Vitality'],
      ).toJson(),
    ),
    Product(
      id: 'gem-004',
      name: 'Emerald (Panna)',
      category: 'Gemstone',
      shortDescription: 'For intelligence, business, and communication.',
      longDescription:
          'Emerald is the gemstone of Mercury (Budh). It improves intelligence, communication skills, and business trade. It is highly beneficial for students and businessmen.',
      price: 18000,
      discountPercentage: 8,
      stock: 10,
      rating: 4.7,
      reviewCount: 50,
      primaryImage: '', // Placeholder as requested
      categorySpecificData: GemstoneData(
        gemstoneType: 'Emerald',
        associatedPlanet: 'Mercury',
        caratWeight: 4.0,
        color: 'Rich Green',
        origin: 'Zambia',
        isCertified: true,
        treatment: 'Oiled',
        zodiacCompatibility: ['Gemini', 'Virgo'],
        whoShouldWear: 'Students, Writers, Businessmen.',
        clarity: 'Included',
        shape: 'Emerald Cut',
        whoShouldNotWear: 'If Mercury is weak or malefic.',
        astrologicalBenefits: ['Intelligence', 'Business Success', 'Speech'],
        healthBenefits: ['Nervous System', 'Skin Health'],
      ).toJson(),
    ),
    Product(
      id: 'gem-005',
      name: 'Pearl (Moti)',
      category: 'Gemstone',
      shortDescription: 'For peace of mind and emotional balance.',
      longDescription:
          'Pearl represents the Moon (Chandra). It gives peace of mind, emotional stability, and calmness. It is beneficial for those who have a short temper or are suffering from depression.',
      price: 5000,
      discountPercentage: 0,
      stock: 30,
      rating: 4.5,
      reviewCount: 80,
      primaryImage: '', // Placeholder as requested
      categorySpecificData: GemstoneData(
        gemstoneType: 'Pearl',
        associatedPlanet: 'Moon',
        caratWeight: 6.0,
        color: 'White',
        origin: 'South Sea',
        isCertified: true,
        treatment: 'Natural',
        zodiacCompatibility: ['Cancer'],
        whoShouldWear: 'Anyone seeking mental peace.',
        clarity: 'N/A',
        shape: 'Round',
        whoShouldNotWear: 'Generally safe for all.',
        astrologicalBenefits: ['Mental Peace', 'Emotional Stability'],
        healthBenefits: ['Insomnia', 'Stress Relief'],
      ).toJson(),
    ),
    Product(
      id: 'gem-006',
      name: 'Red Coral (Moonga)',
      category: 'Gemstone',
      shortDescription: 'For courage, energy, and physical strength.',
      longDescription:
          'Red Coral is the gemstone of Mars (Mangal). It brings courage, energy, and physical strength. It helps in overcoming fear and enemies.',
      price: 8000,
      discountPercentage: 15,
      stock: 20,
      rating: 4.6,
      reviewCount: 55,
      primaryImage: '', // Placeholder as requested
      categorySpecificData: GemstoneData(
        gemstoneType: 'Red Coral',
        associatedPlanet: 'Mars',
        caratWeight: 5.5,
        color: 'Red',
        origin: 'Italian',
        isCertified: true,
        treatment: 'Natural',
        zodiacCompatibility: ['Aries', 'Scorpio'],
        whoShouldWear: 'Police, Army, Athletes.',
        clarity: 'Opaque',
        shape: 'Capsule',
        whoShouldNotWear: 'If Mars is malefic.',
        astrologicalBenefits: ['Courage', 'Energy', 'Strength'],
        healthBenefits: ['Blood Health', 'Immunity'],
      ).toJson(),
    ),

    // --- Yantra ---
    Product(
      id: 'yan-001',
      name: 'Sri Yantra - Gold Plated',
      category: 'Yantra',
      shortDescription: 'The most powerful Yantra for wealth and totality.',
      longDescription:
          'Sri Yantra is considered the king of all Yantras. It represents the cosmic energy of the universe. Worshipping it brings material and spiritual wealth, removes negativity, and creates harmony in life.',
      price: 1100,
      discountPercentage: 9,
      rating: 4.7,
      reviewCount: 88,
      stock: 0,
      primaryImage: 'lib/assets/images/yantra.jpg',
      categorySpecificData: {
        'yantra_type': 'Sri Yantra',
        'material': 'Copper with Gold Polish',
        'size': '3x3 inches',
        'purpose': ['Wealth', 'Harmony', 'Vastu'],
        'placement': 'North-East corner of home or office.',
      },
    ),

    // --- Malas ---
    Product(
      id: 'mala-001',
      name: 'Crystal (Sphatik) Mala',
      category: 'Mala',
      shortDescription: 'For cooling the body and calming the mind.',
      longDescription:
          'Sphatik (Crystal Quartz) Mala is known for its cooling properties. It calms the mind, reduces body heat, and improves concentration. It is associated with Goddess Saraswati and Venus.',
      price: 800,
      stock: 50,
      rating: 4.6,
      reviewCount: 30,
      primaryImage: 'lib/assets/images/mala.png',
      categorySpecificData: {
        'material': 'Sphatik (Quartz)',
        'bead_count': 108,
        'bead_size': '6mm',
      },
    ),
  ];

  Future<List<Product>> getProductsByCategory(String category) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate mock latency
    if (category == 'All') {
      return _allProducts;
    }
    return _allProducts.where((p) => p.category == category).toList();
  }

  Future<Product?> getProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _allProducts.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Product>> getAllProducts() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _allProducts;
  }
}
