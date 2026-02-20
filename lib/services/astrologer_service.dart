import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/astrologer_model.dart';

class AstrologerService extends ChangeNotifier {
  // Singleton Pattern
  static final AstrologerService _instance = AstrologerService._internal();
  factory AstrologerService() => _instance;
  AstrologerService._internal();

  final String baseUrl = 'http://localhost:8080/api/astrologer';

  // Global State
  List<Astrologer> _astrologers = [];
  List<Astrologer> get astrologers => List.unmodifiable(_astrologers);

  Future<List<Astrologer>> fetchAstrologers() async {
    final url = Uri.parse('$baseUrl/list');
    try {
      debugPrint("Fetching astrologers from: $url");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        List<dynamic> listData = [];
        if (data is List) {
          listData = data;
        } else if (data is Map && data.containsKey('data')) {
          listData = data['data'];
        } else if (data is Map && data.containsKey('astrologers')) {
          listData = data['astrologers'];
        }

        _astrologers = listData
            .map((json) => Astrologer.fromJson(json))
            .toList();
        notifyListeners();
        return _astrologers;
      } else {
        debugPrint(
          'Failed to load astrologers. Status: ${response.statusCode}',
        );
        _astrologers = _getDummyAstrologers();
        notifyListeners();
        return _astrologers;
      }
    } catch (e) {
      debugPrint('Error fetching astrologers: $e');
      _astrologers = _getDummyAstrologers();
      notifyListeners();
      return _astrologers;
    }
  }

  // Temporary dummy data while integrating
  List<Astrologer> _getDummyAstrologers() {
    final List<Map<String, dynamic>> dummyData = [
      {
        "id": "1",
        "name": "Pandit Sharma",
        "skills": "Vedic, Marriage, Love",
        "languages": "Hindi, English",
        "rating": 4.5,
        "orders": 150,
        "price": 15,
        "profileImage": "lib/assets/images/men1.png",
        "availableOptions": ["Call", "Chat"],
        "isVerified": true,
        "isOnline": true,
        "experience": 10,
      },
      {
        "id": "2",
        "name": "Neha Sharma",
        "skills": "Tarot, Numerology, Love",
        "languages": "Hindi, English",
        "rating": 4.8,
        "orders": 200,
        "price": 20,
        "profileImage": "lib/assets/images/woman.png",
        "availableOptions": ["Call", "Chat"],
        "isVerified": true,
        "isOnline": false,
        "experience": 8,
      },
    ];
    return dummyData.map((json) => Astrologer.fromJson(json)).toList();
  }

  Future<List<Astrologer>> filterAstrologers({
    String? skill,
    String? language,
    double? minRating,
    bool? isVerified,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (skill != null && skill.isNotEmpty) queryParams['skill'] = skill;
      if (language != null && language.isNotEmpty)
        queryParams['language'] = language;
      if (minRating != null) queryParams['minRating'] = minRating.toString();
      if (isVerified != null) queryParams['isVerified'] = isVerified.toString();

      final uri = Uri.parse(
        '$baseUrl/filter',
      ).replace(queryParameters: queryParams);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        List<dynamic> listData = data is List
            ? data
            : (data['data'] ?? data['astrologers'] ?? []);
        return listData.map((json) => Astrologer.fromJson(json)).toList();
      } else {
        return _astrologers.where((a) {
          if (skill != null && !a.skills.contains(skill)) return false;
          if (language != null && !a.languages.contains(language)) return false;
          return true;
        }).toList();
      }
    } catch (e) {
      return _astrologers;
    }
  }

  Future<List<Astrologer>> getLiveAstrologers() async {
    try {
      final uri = Uri.parse('$baseUrl/live');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        List<dynamic> listData = data is List
            ? data
            : (data['data'] ?? data['astrologers'] ?? []);
        return listData.map((json) => Astrologer.fromJson(json)).toList();
      } else {
        return _astrologers.where((a) => a.isOnline).toList();
      }
    } catch (e) {
      return _astrologers.where((a) => a.isOnline).toList();
    }
  }

  Future<Astrologer?> getAstrologerById(String id) async {
    try {
      final uri = Uri.parse('$baseUrl/$id');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Astrologer.fromJson(data);
      } else {
        return _astrologers.cast<Astrologer?>().firstWhere(
          (a) => a?.id == id,
          orElse: () => null,
        );
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> registerAstrologer(Map<String, dynamic> data) async {
    try {
      final uri = Uri.parse('$baseUrl/create');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic data = json.decode(response.body);
        final Map<String, dynamic> astroJson =
            data is Map && data.containsKey('data')
            ? data['data']
            : (data is Map && data.containsKey('astrologer')
                  ? data['astrologer']
                  : data);
        final newAstro = Astrologer.fromJson(astroJson);

        // Optimistically update local list
        _astrologers = [newAstro, ..._astrologers];
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
