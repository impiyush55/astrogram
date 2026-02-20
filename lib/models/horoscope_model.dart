class HoroscopeResponse {
  final String zodiacSign;
  final String type;
  final String date;
  final String description;
  final int id;

  HoroscopeResponse({
    required this.zodiacSign,
    required this.type,
    required this.date,
    required this.description,
    required this.id,
  });

  factory HoroscopeResponse.fromJson(Map<String, dynamic> json) {
    return HoroscopeResponse(
      zodiacSign: json['zodiacSign'] ?? '',
      type: json['type'] ?? '',
      date: json['date'] ?? '',
      description: json['description'] ?? '',
      id: json['id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'zodiacSign': zodiacSign,
      'type': type,
      'date': date,
      'description': description,
      'id': id,
    };
  }
}
