// import 'dart:convert';
// import 'package:http/http.dart' as http;

class AstrologerService {
  // Replace with your actual API endpoint
  final String baseUrl = 'http://your-api-domain.com/api';

  Future<List<Map<String, dynamic>>> fetchAstrologers() async {
    // try {
    //   final response = await http.get(Uri.parse('$baseUrl/astrologers'));
    //
    //   if (response.statusCode == 200) {
    //     final List<dynamic> data = json.decode(response.body);
    //     return data.cast<Map<String, dynamic>>();
    //   } else {
    //     throw Exception('Failed to load astrologers');
    //   }
    // } catch (e) {
    //   // Fallback to dummy data if API fails or is not ready
    //   print('Error fetching astrologers: $e');
    //   return _getDummyAstrologers();
    // }
    return Future.delayed(
      const Duration(seconds: 1),
      () => _getDummyAstrologers(),
    );
  }

  List<Map<String, dynamic>> _getDummyAstrologers() {
    return [
      {
        "name": "Mr. Krishna",
        "skills": "Vedic astrology",
        "languages": "English, Hindi",
        "rating": 4.5,
        "orders": 301448,
        "isFree": true,
        "price": 0,
        "image": "lib/assets/images/men1.png",
        "availableOptions": ["Chat"],
        "isVerified": false,
      },
      {
        "name": "Anurag Sharma",
        "skills": "Vedic astrology",
        "languages": "Hindi, English",
        "rating": 4.9,
        "orders": 10,
        "isFree": false,
        "price": 18,
        "image": "lib/assets/images/panditji.jpg",
        "availableOptions": ["Call", "Chat"],
        "isVerified": true,
      },
      {
        "name": "Varun K",
        "skills": "Vedic astrology",
        "languages": "Hindi, English, Punjabi",
        "rating": 5.0,
        "orders": 11,
        "isFree": false,
        "price": 30,
        "image": "lib/assets/images/pandit2.jpg",
        "availableOptions": ["Call", "Chat"],
        "isVerified": true,
      },
      {
        "name": "Ankit G",
        "skills": "Tarot",
        "languages": "Hindi, English",
        "rating": 5.0,
        "orders": 6,
        "isFree": false,
        "price": 30,
        "image": "lib/assets/images/pandit3.jpeg",
        "availableOptions": ["Call", "Chat"],
        "isVerified": true,
      },
      {
        "name": "Mohit Parmar",
        "skills": "Vedic astrology",
        "languages": "Hindi, English",
        "rating": 4.7,
        "orders": 8,
        "isFree": false,
        "price": 32,
        "image": "lib/assets/images/men1.png",
        "availableOptions": ["Call", "Chat"],
        "isVerified": true,
      },
    ];
  }
}
