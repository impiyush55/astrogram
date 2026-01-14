import 'dart:async';

class HoroscopeService {
  // Simulate API Network Delay
  Future<Map<String, dynamic>> fetchHoroscope(String sign, String day) async {
    await Future.delayed(
      const Duration(milliseconds: 800),
    ); // Fake network latency

    return _generateDummyData(sign, day);
  }

  Map<String, dynamic> _generateDummyData(String sign, String day) {
    // Basic variety based on sign to show dynamic nature
    final isFireSign = ['Aries', 'Leo', 'Sagittarius'].contains(sign);
    final isWaterSign = ['Cancer', 'Scorpio', 'Pisces'].contains(sign);
    // final isAirSign = ['Gemini', 'Libra', 'Aquarius'].contains(sign);
    // final isEarthSign = ['Taurus', 'Virgo', 'Capricorn'].contains(sign);

    int baseMood = isFireSign ? 80 : (isWaterSign ? 60 : 70);

    // Dynamic content generator
    return {
      "date":
          "13-01-2026", // In real app, calculate based on 'day' (Yesterday/Today/Tomorrow)
      "dayName": day,
      "sign": sign,
      "hero": {
        "luckyColor1": isFireSign
            ? 0xFFFF0000
            : 0xFF2196F3, // Red for fire, Blue otherwise
        "luckyColor2": isWaterSign ? 0xFF00BCD4 : 0xFFFFC107,
        "luckyNumber": "${sign.length}",
        "moodEmoji": isFireSign ? "🔥" : (isWaterSign ? "🌊" : "😌"),
        "luckyTime": "10:00 AM",
      },
      "love": {
        "content":
            "For $sign, $day brings a focus on emotional connections. ${isFireSign ? "Passion is high!" : "Deep conversations are favored."} Connect with your partner on a spiritual level today.",
        "pencentage": baseMood + (isFireSign ? 10 : 5),
      },
      "career": {
        "content":
            "Work demands attention. ${isWaterSign ? "Trust your intuition" : "Use logic and strategy"} to solve complex problems. Teamwork is your strength today.",
        "pencentage": baseMood + (isWaterSign ? 10 : 15),
      },
      "money": {
        "content":
            "Avoid impulsive spending. A good day for planning investments.",
        "pencentage": baseMood - 5,
      },
      "health": {
        "content":
            "Energy levels are ${isFireSign ? "explosive" : "steady"}. Take time for ${isWaterSign ? "meditation" : "exercise"}.",
        "pencentage": baseMood,
      },
      "travel": {
        "content":
            "Not a great day for long travel, but a short trip could be fun.",
        "pencentage": baseMood - 20,
      },
      "insights": {
        "food": {
          "name": isFireSign ? "Spicy Curry" : "Fresh Salad",
          "desc": "Fuels your ${isFireSign ? 'fiery' : 'calm'} nature today.",
          "image": "lib/assets/images/god_poster.jpg",
        },
        "product": {
          "name": "Amethyst Crystal",
          "desc": "Brings clarity and peace to your mind.",
          "image": "lib/assets/images/rudraksha.png", // Corrected file name
        },
        "activity": {
          "name": isWaterSign ? "Yoga" : "Running",
          "desc": "Helps channel your excess energy.",
          "image": "lib/assets/images/yantra.jpg",
        },
      },
    };
  }
}
