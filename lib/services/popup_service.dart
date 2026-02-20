import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/popup_model.dart';

class PopupService {
  /// Simulates an API call to fetch popup data
  Future<PopupModel?> fetchPopupData() async {
    // Simulate network delay using a Future.delayed
    await Future.delayed(const Duration(seconds: 2));

    // Mock API Response (JSON String)
    const String mockApiResponse = '''
    {
      "image_url": "lib/assets/images/ai_astrologer.png",
      "title": "Consult With Premium AI\\nAstrologers",
      "sub_title": "Get Your Free Chat",
      "button_text": "CHAT FREE NOW!",
      "is_visible": true
    }
    ''';

    try {
      // Parse the mock JSON
      final Map<String, dynamic> data = json.decode(mockApiResponse);
      return PopupModel.fromJson(data);
    } catch (e) {
      debugPrint("Error fetching popup data: $e");
      return null;
    }
  }
}
