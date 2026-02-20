import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/remedy_model.dart';

class RemedyService {
  final String baseUrl = 'http://localhost:8080/api/remedies';

  /// Fetch remedies with optional filters
  /// GET /api/remedies?type=HEALING&planet=Sun&problemType=Health
  Future<List<Remedy>> fetchRemedies({
    String? type,
    String? planet,
    String? problemType,
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, String>{};
      if (type != null && type.isNotEmpty) queryParams['type'] = type;
      if (planet != null && planet.isNotEmpty) queryParams['planet'] = planet;
      if (problemType != null && problemType.isNotEmpty) {
        queryParams['problemType'] = problemType;
      }

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);

      debugPrint("Fetching Remedies: $uri");

      final response = await http.get(uri);

      debugPrint("Remedies Response Status: ${response.statusCode}");
      debugPrint("Remedies Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Remedy.fromJson(json)).toList();
      } else {
        debugPrint("Failed to fetch remedies: ${response.body}");
        return _getFallbackRemedies();
      }
    } catch (e) {
      debugPrint("Error fetching remedies: $e");
      return _getFallbackRemedies();
    }
  }

  /// Fetch single remedy by ID
  /// GET /api/remedies/:id
  Future<Remedy?> fetchRemedyById(String id) async {
    try {
      final uri = Uri.parse("$baseUrl/$id");

      debugPrint("Fetching Remedy by ID: $uri");

      final response = await http.get(uri);

      debugPrint("Remedy Detail Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Remedy.fromJson(data);
      } else {
        debugPrint("Failed to fetch remedy: ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching remedy by ID: $e");
      return null;
    }
  }

  /// Fallback remedies when API is unavailable
  List<Remedy> _getFallbackRemedies() {
    return [
      Remedy(
        id: '1',
        title: 'VIP E-Pooja',
        type: 'POOJA',
        planet: 'All',
        problemType: 'General',
        description:
            'Almost everything runs on Internet today. Book your pooja online and watch it live.',
        instructions: 'Book online, watch live.',
        isPaid: true,
        price: 'Starts at INR 1100',
        imagePath: 'lib/assets/images/vip-e-pooja.jpg',
      ),
      Remedy(
        id: '2',
        title: 'Problem Solving Remedy Combos',
        type: 'COMBO',
        planet: 'Multi',
        problemType: 'Life',
        description: 'Powerful combinations for complex problems.',
        instructions: 'Consult astrologer for usage.',
        isPaid: true,
        price: 'Get 2 @ INR 1100',
        imagePath:
            'lib/assets/images/149fef6f-8254-4ee9-b116-17f6b662149d.jpeg',
      ),
      Remedy(
        id: '3',
        title: 'Spell',
        type: 'SPELL',
        planet: 'Venus',
        problemType: 'Love',
        description:
            'Spell is the process of taking up Nature\'s energy for specific purposes.',
        instructions: 'Perform at midnight.',
        isPaid: true,
        price: 'Starts at INR 1100',
        imagePath: 'lib/assets/images/spell.jpg',
      ),
      Remedy(
        id: '4',
        title: 'Evil Eye Removal',
        type: 'HEALING',
        planet: 'Rahu',
        problemType: 'Protection',
        description: 'Protection from negative energies and evil eye.',
        instructions: 'Wear protection charm.',
        isPaid: true,
        price: 'Starts at INR 499',
        imagePath: 'lib/assets/images/Evileye.jpg',
      ),
      Remedy(
        id: '5',
        title: 'Reiki Healing',
        type: 'HEALING',
        planet: 'Sun',
        problemType: 'Health',
        description:
            'Reiki Healing is the process of healing through energy transfer.',
        instructions: 'Remote sessions available.',
        isPaid: true,
        price: 'Starts at INR 1100',
        imagePath: 'lib/assets/images/reiki.jpg',
      ),
      Remedy(
        id: '6',
        title: 'Rahu-Ketu Transit',
        type: 'TRANSIT',
        planet: 'Rahu-Ketu',
        problemType: 'Dosha',
        description: 'The Rahu-Ketu transit is a powerful cosmic event.',
        instructions: 'Chant mantras daily.',
        isPaid: true,
        price: 'Highly Recommended',
        imagePath: 'lib/assets/images/rahu-ketu.jpg',
      ),
      Remedy(
        id: '7',
        title: 'Palmistry',
        type: 'READING',
        planet: 'Mercury',
        problemType: 'Future',
        description: 'Palmistry or Chiromancy is the process of reading palms.',
        instructions: 'Send clear photo of palm.',
        isPaid: true,
        price: 'Starts at INR 800',
        imagePath: 'lib/assets/images/palmistry.jpg',
      ),
      Remedy(
        id: '8',
        title: 'Theta Healing',
        type: 'HEALING',
        planet: 'Moon',
        problemType: 'Mind',
        description: 'Theta Healing is a useful technique for mental wellness.',
        instructions: 'Video call session.',
        isPaid: true,
        price: 'Starts at INR 1100',
        imagePath: 'lib/assets/images/theta healing.jpg',
      ),
    ];
  }
}
