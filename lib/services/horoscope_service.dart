import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/horoscope_model.dart';

class HoroscopeService {
  final String baseUrl = "http://localhost:8080/api/horoscope";

  /// Fetch list of zodiac signs from backend
  Future<List<String>> fetchZodiacSigns() async {
    final url = Uri.parse("$baseUrl/signs");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => e.toString()).toList();
      }
      return [];
    } catch (e) {
      debugPrint("Error fetching zodiac signs: $e");
      return [];
    }
  }

  /// Fetch horoscope by zodiac sign and type (DAILY, WEEKLY, MONTHLY)
  Future<HoroscopeResponse?> fetchHoroscopeBySign(
    String type,
    String sign,
  ) async {
    // Backend expects uppercase signs like GEMINI
    final upperSign = sign.toUpperCase();
    final upperType = type.toUpperCase();
    final url = Uri.parse("$baseUrl/$upperType/$upperSign");

    try {
      debugPrint("Fetching horoscope for $upperSign ($upperType) from $url");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return HoroscopeResponse.fromJson(data);
      }
      return null;
    } catch (e) {
      debugPrint("Error fetching horoscope by sign: $e");
      return null;
    }
  }

  /// Fetch horoscope for a specific user based on their stored zodiac sign
  Future<HoroscopeResponse?> fetchHoroscopeByUser(
    String userId,
    String type,
  ) async {
    final upperType = type.toUpperCase();
    final url = Uri.parse("$baseUrl/user/$userId?type=$upperType");

    try {
      debugPrint("Fetching horoscope for User ID: $userId from $url");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return HoroscopeResponse.fromJson(data);
      }
      return null;
    } catch (e) {
      debugPrint("Error fetching horoscope by user: $e");
      return null;
    }
  }

  /// Merges live backend data with frontend visual metadata
  Map<String, dynamic> injectMetadata(
    HoroscopeResponse liveData,
    String label,
  ) {
    // We use the dummy generator as a base for visuals (colors, icons)
    // but overwrite the core text and date with live data.
    final Map<String, dynamic> data = generateDummyData(
      liveData.zodiacSign,
      label,
    );

    data['date'] = liveData.date;
    data['description'] = liveData.description;
    data['love']['content'] = liveData.description; // Primary display

    return data;
  }

  /// Legacy helper method to bridge with existing UI
  /// In the current UI, 'day' is Today/Yesterday/Tomorrow
  /// For now, we map all to DAILY since backend doesn't take date.
  Future<Map<String, dynamic>> fetchHoroscope(String sign, String day) async {
    // Map Today/Yesterday/Tomorrow to DAILY
    // In a future update, we can add date support if backend allows
    final response = await fetchHoroscopeBySign("DAILY", sign);

    if (response != null) {
      // Return a map that matches what the existing UI expects,
      // but injecting the real description from backend.
      return _injectRealData(response, day);
    } else {
      // Fallback to dummy if API fails
      return generateDummyData(sign, day);
    }
  }

  Map<String, dynamic> _injectRealData(HoroscopeResponse liveData, String day) {
    // Use the dummy generator as a base for visuals (colors, percentages)
    // but replace the core content with live data.
    final Map<String, dynamic> data = generateDummyData(
      liveData.zodiacSign,
      day,
    );
    data['date'] = liveData.date;
    data['description'] = liveData.description; // Added this key

    // We can also put the real description into the 'love' or 'general' parts
    // for now to ensure it's visible in the existing UI structure.
    data['love']['content'] = liveData.description;

    return data;
  }

  Map<String, dynamic> generateDummyData(String sign, String day) {
    // This remains as a fallback and to provide visual metadata (mood, colors)
    // that the current backend response doesn't yet include.
    final isFireSign = [
      'ARIES',
      'LEO',
      'SAGITTARIUS',
    ].contains(sign.toUpperCase());
    final isWaterSign = [
      'CANCER',
      'SCORPIO',
      'PISCES',
    ].contains(sign.toUpperCase());

    int baseMood = isFireSign ? 80 : (isWaterSign ? 60 : 70);

    return {
      "date": "13-01-2026",
      "dayName": day,
      "sign": sign,
      "hero": {
        "luckyColor1": isFireSign ? 0xFFFF0000 : 0xFF2196F3,
        "luckyColor2": isWaterSign ? 0xFF00BCD4 : 0xFFFFC107,
        "luckyNumber": "${sign.length}",
        "moodEmoji": isFireSign ? "🔥" : (isWaterSign ? "🌊" : "😌"),
        "luckyTime": "10:00 AM",
      },
      "love": {
        "content": "Connecting with your partner on a spiritual level today.",
        "percentage": baseMood + (isFireSign ? 10 : 5),
      },
      "career": {
        "content": "Work demands attention. Use logic and strategy.",
        "percentage": baseMood + (isWaterSign ? 10 : 15),
      },
      "money": {
        "content": "Avoid impulsive spending.",
        "percentage": baseMood - 5,
      },
      "health": {
        "content": "Energy levels are steady. Take time for meditation.",
        "percentage": baseMood,
      },
      "travel": {
        "content": "Short trips are favored.",
        "percentage": baseMood - 20,
      },
      "insights": {
        "food": {
          "name": isFireSign ? "Spicy Curry" : "Fresh Salad",
          "desc": "Fuels your nature today.",
          "image": "lib/assets/images/god_poster.jpg",
        },
        "product": {
          "name": "Amethyst Crystal",
          "desc": "Brings clarity and peace.",
          "image": "lib/assets/images/rudraksha.png",
        },
        "activity": {
          "name": isWaterSign ? "Yoga" : "Running",
          "desc": "Helps channel energy.",
          "image": "lib/assets/images/yantra.jpg",
        },
      },
    };
  }
}
