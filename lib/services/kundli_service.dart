import 'dart:convert';
import 'package:astrogram/models/kundli_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class KundliService {
  final String baseUrl = "http://localhost:8080/api/kundli";

  Future<Map<String, dynamic>> fetchBasicPlanetData(
    KundliRequest request,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/basic"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load basic kundli data");
    }
  }

  Future<List<PredictionInfo>> fetchPredictions(KundliRequest request) async {
    final response = await http.post(
      Uri.parse("$baseUrl/predictions"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Based on screenshot, response might be nested
      final List predictionsJson =
          data['Output']?['Predictions'] ?? data['predictions'] ?? [];
      return predictionsJson.map((i) => PredictionInfo.fromJson(i)).toList();
    } else {
      throw Exception("Failed to load predictions");
    }
  }

  Future<List<DashaInfo>> fetchDasha(KundliRequest request) async {
    final response = await http.post(
      Uri.parse("$baseUrl/dasha"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List dashaJson =
          data['Output']?['VimsottariDasha'] ?? data['vimsottari_dasha'] ?? [];
      return dashaJson.map((i) => DashaInfo.fromJson(i)).toList();
    } else {
      throw Exception("Failed to load dasha data");
    }
  }

  Future<Map<String, dynamic>> fetchCharts(
    KundliRequest request,
    String type,
  ) async {
    // Match the provided API structure
    final endpoint = type == "South Indian"
        ? "chart/SouthIndianChart"
        : "chart/NorthIndianChart";

    final url = Uri.parse("$baseUrl/$endpoint");

    try {
      debugPrint("Fetching Kundli Chart: $url");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      debugPrint("Chart Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        debugPrint("Failed to load chart: ${response.body}");
        throw Exception("Failed to load chart data");
      }
    } catch (e) {
      debugPrint("Error fetching chart: $e");
      throw Exception("Error connecting to chart API");
    }
  }

  // Legacy support for current UI while transitioning
  Future<Map<String, dynamic>> fetchKundliData() async {
    // This now simulates a combined call or returns basic data
    // In a real app, you might want to call multiple APIs or wait for the new UI
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      "basic_details": {
        "name": "Piyush",
        "dob": "15 July 1995",
        "time": "10:30 AM",
        "place": "New Delhi, India",
        "lat_long": "28.6139° N, 77.2090° E",
        "timezone": "IST (UTC +5:30)",
        "sunrise": "05:32 AM",
        "sunset": "07:12 PM",
        "ayanamsha": "Lahiri (23° 47' 12\")",
      },
      "manglik_analysis": {
        "is_manglik": false,
        "status": "Non Manglik",
        "description":
            "The placement of Mars in your chart does not create a Manglik Dosha.",
      },
      "planetary_table": [],
      "understanding_your_kundli": {
        "general": "Personality characterized by self-respect.",
        "planetary": "Sun Lagna lord gives vitality.",
        "yoga": "Gaja Kesari Yoga present.",
      },
      "panchang_details": {
        "tithi": "Shukla Navami",
        "karan": "Kaulava",
        "yog": "Subha",
        "nakshatra": "Purva Phalguni",
        "sunrise": "05:32 AM",
        "sunset": "07:12 PM",
      },
      "avakhada_details": {
        "varna": "Kshatriya",
        "vashya": "Vanchar",
        "yoni": "Mooshak",
        "gan": "Manushya",
        "nadi": "Madhya",
        "sign": "Leo",
        "sign_lord": "Sun",
        "tatva": "Agni (Fire)",
        "name_alphabet": "Mo",
        "paya": "Gold",
      },
    };
  }

  /// Match two kundlis for marriage compatibility
  /// POST /api/kundli/match
  Future<KundliMatchResponse?> matchKundli(KundliMatchRequest request) async {
    final url = Uri.parse("$baseUrl/match");

    try {
      debugPrint("Matching Kundli: $url");
      debugPrint("Request: ${request.toJson()}");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      debugPrint("Match Response Status: ${response.statusCode}");
      debugPrint("Match Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return KundliMatchResponse.fromJson(data);
      } else {
        debugPrint("Failed to match kundli: ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Error matching kundli: $e");
      return null;
    }
  }
}
