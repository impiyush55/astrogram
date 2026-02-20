import 'package:flutter/material.dart';

class Blog {
  final String? id;
  final String title;
  final String excerpt;
  final String content;
  final String category;
  final String imagePath;
  final String readTime;
  final DateTime publishDate;
  final String author;

  // Blog Category Constants
  static const String categoryHoroscope = 'Horoscope';
  static const String categoryKundli = 'Kundli';
  static const String categoryRemedies = 'Remedies';
  static const String categoryNumerology = 'Numerology';
  static const String categoryLove = 'Love';
  static const String categoryCareer = 'Career';

  Blog({
    this.id,
    required this.title,
    required this.excerpt,
    required this.content,
    required this.category,
    required this.imagePath,
    required this.readTime,
    required this.publishDate,
    required this.author,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      title: json['title'] ?? '',
      excerpt: json['excerpt'] ?? '',
      content: json['content'] ?? '',
      category: json['category'] ?? '',
      imagePath:
          json['imagePath'] ??
          json['imageUrl'] ??
          'lib/assets/images/placeholder.png',
      readTime: json['readTime'] ?? '5 min read',
      publishDate: json['publishDate'] != null
          ? DateTime.parse(json['publishDate'])
          : DateTime.now(),
      author: json['author'] ?? 'Astrology Expert',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'title': title,
      'excerpt': excerpt,
      'content': content,
      'category': category,
      'imagePath': imagePath,
      'readTime': readTime,
      'publishDate': publishDate.toIso8601String(),
      'author': author,
    };
  }

  /// Get icon for blog category
  IconData getCategoryIcon() {
    switch (category) {
      case 'Horoscope':
        return Icons.star_rate;
      case 'Kundli':
        return Icons.auto_awesome;
      case 'Remedies':
        return Icons.healing;
      case 'Numerology':
        return Icons.calculate;
      case 'Love':
        return Icons.favorite;
      case 'Career':
        return Icons.work;
      default:
        return Icons.article;
    }
  }

  /// Get color for blog category
  Color getCategoryColor() {
    switch (category) {
      case 'Horoscope':
        return const Color(0xFFFFA726); // Orange
      case 'Kundli':
        return const Color(0xFF9C27B0); // Purple
      case 'Remedies':
        return const Color(0xFF66BB6A); // Green
      case 'Numerology':
        return const Color(0xFF42A5F5); // Blue
      case 'Love':
        return const Color(0xFFEC407A); // Pink
      case 'Career':
        return const Color(0xFF26C6DA); // Cyan
      default:
        return const Color(0xFFF4C430); // Gold
    }
  }
}
