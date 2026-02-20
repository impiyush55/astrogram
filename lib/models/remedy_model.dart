import 'package:flutter/material.dart';

class Remedy {
  final String? id;
  final String title;
  final String type;
  final String planet;
  final String problemType;
  final String description;
  final String instructions;
  final bool isPaid;
  final String imagePath;
  final String price;

  // Remedy Type Constants
  static const String typePooja = 'POOJA';
  static const String typeCombo = 'COMBO';
  static const String typeSpell = 'SPELL';
  static const String typeHealing = 'HEALING';
  static const String typeTransit = 'TRANSIT';
  static const String typeReading = 'READING';

  Remedy({
    this.id,
    required this.title,
    required this.type,
    required this.planet,
    required this.problemType,
    required this.description,
    required this.instructions,
    required this.isPaid,
    required this.imagePath,
    required this.price,
  });

  factory Remedy.fromJson(Map<String, dynamic> json) {
    return Remedy(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      planet: json['planet'] ?? '',
      problemType: json['problemType'] ?? '',
      description: json['description'] ?? '',
      instructions: json['instructions'] ?? '',
      isPaid: json['isPaid'] ?? false,
      imagePath:
          json['imagePath'] ??
          json['imageUrl'] ??
          'assets/images/placeholder.png',
      price: json['price'] ?? 'Ask for Price',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'title': title,
      'type': type,
      'planet': planet,
      'problemType': problemType,
      'description': description,
      'instructions': instructions,
      'isPaid': isPaid,
      'imagePath': imagePath,
      'price': price,
    };
  }

  /// Get icon for remedy type
  IconData getTypeIcon() {
    switch (type.toUpperCase()) {
      case 'POOJA':
        return Icons.temple_hindu;
      case 'COMBO':
        return Icons.auto_awesome;
      case 'SPELL':
        return Icons.auto_fix_high;
      case 'HEALING':
        return Icons.healing;
      case 'TRANSIT':
        return Icons.track_changes;
      case 'READING':
        return Icons.menu_book;
      default:
        return Icons.star;
    }
  }

  /// Get color for planet
  Color getPlanetColor() {
    switch (planet.toLowerCase()) {
      case 'sun':
        return Colors.orange;
      case 'moon':
        return Colors.blue.shade200;
      case 'mars':
        return Colors.red;
      case 'mercury':
        return Colors.green;
      case 'jupiter':
        return Colors.yellow.shade700;
      case 'venus':
        return Colors.pink;
      case 'saturn':
        return Colors.grey;
      case 'rahu':
        return Colors.purple;
      case 'ketu':
        return Colors.brown;
      default:
        return Colors.amber;
    }
  }
}
