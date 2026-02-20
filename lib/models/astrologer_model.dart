class Astrologer {
  final String? id;
  final String name;
  final String bio;
  final String skills;
  final String languages;
  final double rating;
  final int orders;
  final int price;
  final bool isFree;
  final String image;
  final bool isVerified;
  final List<String> availableOptions;
  final bool isOnline;
  final int experience; // years of experience
  final List<String> specialization;

  Astrologer({
    this.id,
    required this.name,
    required this.bio,
    required this.skills,
    required this.languages,
    required this.rating,
    required this.orders,
    required this.price,
    required this.isFree,
    required this.image,
    required this.isVerified,
    required this.availableOptions,
    this.isOnline = false,
    this.experience = 5,
    this.specialization = const [],
  });

  factory Astrologer.fromJson(Map<String, dynamic> json) {
    int charge = 0;
    if (json['perMinuteCharge'] != null) {
      charge = int.tryParse(json['perMinuteCharge'].toString()) ?? 0;
    } else if (json['price'] != null) {
      charge = int.tryParse(json['price'].toString()) ?? 0;
    }

    return Astrologer(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      name: json['name'] ?? 'Unknown Astrologer',
      bio: json['bio'] ?? '',
      skills: json['skills'] ?? '',
      languages: json['languages'] ?? '',
      rating: double.tryParse(json['rating']?.toString() ?? '0') ?? 4.5,
      orders:
          int.tryParse(
            (json['totalOrders'] ?? json['orders'] ?? '0').toString(),
          ) ??
          0,
      price: charge,
      isFree: charge == 0,
      image:
          (json['profileImage'] != null &&
              json['profileImage'].toString().isNotEmpty)
          ? json['profileImage']
          : 'lib/assets/images/user_placeholder.png',
      isVerified: json['isVerified'] ?? json['isActive'] ?? false,
      availableOptions: json['availableOptions'] != null
          ? List<String>.from(json['availableOptions'])
          : ["Chat", "Call"],
      isOnline: json['isOnline'] ?? false,
      experience: int.tryParse(json['experience']?.toString() ?? '5') ?? 5,
      specialization: json['specialization'] != null
          ? List<String>.from(json['specialization'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'name': name,
      'bio': bio,
      'skills': skills,
      'languages': languages,
      'rating': rating,
      'orders': orders,
      'price': price,
      'profileImage': image,
      'isVerified': isVerified,
      'availableOptions': availableOptions,
      'isOnline': isOnline,
      'experience': experience,
      'specialization': specialization,
    };
  }

  /// Parse skills string to list
  List<String> getSkillsList() {
    if (skills.isEmpty) return [];
    return skills
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  /// Parse languages string to list
  List<String> getLanguagesList() {
    if (languages.isEmpty) return [];
    return languages
        .split(',')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
  }

  /// Get formatted price string
  String getPriceString() {
    if (isFree) return 'FREE';
    return '₹$price/min';
  }

  /// Get experience string
  String getExperienceString() {
    return '$experience ${experience == 1 ? 'year' : 'years'} exp';
  }
}
