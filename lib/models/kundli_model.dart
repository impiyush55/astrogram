class KundliRequest {
  final String? userId; // Adding userId as per requirements
  final String name;
  final String location;
  final String date;
  final String time;
  final String timezone;

  KundliRequest({
    this.userId,
    required this.name,
    required this.location,
    required this.date,
    required this.time,
    required this.timezone,
  });

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "name": name,
      "location": location,
      "date": date,
      "time": time,
      "timezone": timezone,
    };
  }
}

class KundliData {
  final BasicDetails basicDetails;
  final ManglikAnalysis manglikAnalysis;
  final List<PlanetaryInfo> planetaryTable;
  final UnderstandingKundli understandingYourKundli;
  final PanchangDetails panchangDetails;
  final AvakhadaDetails avakhadaDetails;
  final List<DashaInfo>? vimsottariDasha;
  final List<PredictionInfo>? predictions;

  KundliData({
    required this.basicDetails,
    required this.manglikAnalysis,
    required this.planetaryTable,
    required this.understandingYourKundli,
    required this.panchangDetails,
    required this.avakhadaDetails,
    this.vimsottariDasha,
    this.predictions,
  });

  factory KundliData.fromJson(Map<String, dynamic> json) {
    return KundliData(
      basicDetails: BasicDetails.fromJson(json['basic_details'] ?? {}),
      manglikAnalysis: ManglikAnalysis.fromJson(json['manglik_analysis'] ?? {}),
      planetaryTable:
          (json['planetary_table'] as List?)
              ?.map((i) => PlanetaryInfo.fromJson(i))
              .toList() ??
          [],
      understandingYourKundli: UnderstandingKundli.fromJson(
        json['understanding_your_kundli'] ?? {},
      ),
      panchangDetails: PanchangDetails.fromJson(json['panchang_details'] ?? {}),
      avakhadaDetails: AvakhadaDetails.fromJson(json['avakhada_details'] ?? {}),
      vimsottariDasha: (json['vimsottari_dasha'] as List?)
          ?.map((i) => DashaInfo.fromJson(i))
          .toList(),
      predictions: (json['predictions'] as List?)
          ?.map((i) => PredictionInfo.fromJson(i))
          .toList(),
    );
  }
}

class BasicDetails {
  final String name;
  final String dob;
  final String time;
  final String place;
  final String latLong;
  final String timezone;
  final String sunrise;
  final String sunset;
  final String ayanamsha;

  BasicDetails({
    required this.name,
    required this.dob,
    required this.time,
    required this.place,
    required this.latLong,
    required this.timezone,
    required this.sunrise,
    required this.sunset,
    required this.ayanamsha,
  });

  factory BasicDetails.fromJson(Map<String, dynamic> json) {
    return BasicDetails(
      name: json['name'] ?? '',
      dob: json['dob'] ?? '',
      time: json['time'] ?? '',
      place: json['place'] ?? '',
      latLong: json['lat_long'] ?? '',
      timezone: json['timezone'] ?? '',
      sunrise: json['sunrise'] ?? '',
      sunset: json['sunset'] ?? '',
      ayanamsha: json['ayanamsha'] ?? '',
    );
  }
}

class ManglikAnalysis {
  final bool isManglik;
  final String status;
  final String description;

  ManglikAnalysis({
    required this.isManglik,
    required this.status,
    required this.description,
  });

  factory ManglikAnalysis.fromJson(Map<String, dynamic> json) {
    return ManglikAnalysis(
      isManglik: json['is_manglik'] ?? false,
      status: json['status'] ?? 'Unknown',
      description: json['description'] ?? '',
    );
  }
}

class PlanetaryInfo {
  final String planet;
  final String sign;
  final String lord;
  final String degree;
  final int house;

  PlanetaryInfo({
    required this.planet,
    required this.sign,
    required this.lord,
    required this.degree,
    required this.house,
  });

  factory PlanetaryInfo.fromJson(Map<String, dynamic> json) {
    return PlanetaryInfo(
      planet: json['planet'] ?? '',
      sign: json['sign'] ?? '',
      lord: json['lord'] ?? '',
      degree: json['degree'] ?? '',
      house: json['house'] ?? 0,
    );
  }
}

class UnderstandingKundli {
  final String general;
  final String planetary;
  final String yoga;

  UnderstandingKundli({
    required this.general,
    required this.planetary,
    required this.yoga,
  });

  factory UnderstandingKundli.fromJson(Map<String, dynamic> json) {
    return UnderstandingKundli(
      general: json['general'] ?? '',
      planetary: json['planetary'] ?? '',
      yoga: json['yoga'] ?? '',
    );
  }
}

class PanchangDetails {
  final String tithi;
  final String karan;
  final String yog;
  final String nakshatra;
  final String sunrise;
  final String sunset;

  PanchangDetails({
    required this.tithi,
    required this.karan,
    required this.yog,
    required this.nakshatra,
    required this.sunrise,
    required this.sunset,
  });

  factory PanchangDetails.fromJson(Map<String, dynamic> json) {
    return PanchangDetails(
      tithi: json['tithi'] ?? '',
      karan: json['karan'] ?? '',
      yog: json['yog'] ?? '',
      nakshatra: json['nakshatra'] ?? '',
      sunrise: json['sunrise'] ?? '',
      sunset: json['sunset'] ?? '',
    );
  }
}

class AvakhadaDetails {
  final String varna;
  final String vashya;
  final String yoni;
  final String gan;
  final String nadi;
  final String sign;
  final String signLord;
  final String tatva;
  final String nameAlphabet;
  final String paya;

  AvakhadaDetails({
    required this.varna,
    required this.vashya,
    required this.yoni,
    required this.gan,
    required this.nadi,
    required this.sign,
    required this.signLord,
    required this.tatva,
    required this.nameAlphabet,
    required this.paya,
  });

  factory AvakhadaDetails.fromJson(Map<String, dynamic> json) {
    return AvakhadaDetails(
      varna: json['varna'] ?? '',
      vashya: json['vashya'] ?? '',
      yoni: json['yoni'] ?? '',
      gan: json['gan'] ?? '',
      nadi: json['nadi'] ?? '',
      sign: json['sign'] ?? '',
      signLord: json['sign_lord'] ?? '',
      tatva: json['tatva'] ?? '',
      nameAlphabet: json['name_alphabet'] ?? '',
      paya: json['paya'] ?? '',
    );
  }
}

class DashaInfo {
  final String planet;
  final String startTime;
  final String endTime;

  DashaInfo({
    required this.planet,
    required this.startTime,
    required this.endTime,
  });

  factory DashaInfo.fromJson(Map<String, dynamic> json) {
    return DashaInfo(
      planet: json['planet'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
    );
  }
}

class PredictionInfo {
  final String type;
  final String text;

  PredictionInfo({required this.type, required this.text});

  factory PredictionInfo.fromJson(Map<String, dynamic> json) {
    return PredictionInfo(type: json['type'] ?? '', text: json['text'] ?? '');
  }
}

// Kundli Match Models
class KundliMatchRequest {
  final String boyLocation;
  final String boyDate;
  final String boyTime;
  final String boyTimezone;
  final String girlLocation;
  final String girlDate;
  final String girlTime;
  final String girlTimezone;

  KundliMatchRequest({
    required this.boyLocation,
    required this.boyDate,
    required this.boyTime,
    required this.boyTimezone,
    required this.girlLocation,
    required this.girlDate,
    required this.girlTime,
    required this.girlTimezone,
  });

  Map<String, dynamic> toJson() {
    return {
      "boyLocation": boyLocation,
      "boyDate": boyDate,
      "boyTime": boyTime,
      "boyTimezone": boyTimezone,
      "girlLocation": girlLocation,
      "girlDate": girlDate,
      "girlTime": girlTime,
      "girlTimezone": girlTimezone,
    };
  }
}

class KundliMatchResponse {
  final int totalScore;
  final int maxScore;
  final String compatibilityStatus;
  final Map<String, GunaScore> gunaScores;
  final String? recommendation;
  final bool? boyManglik;
  final bool? girlManglik;

  KundliMatchResponse({
    required this.totalScore,
    required this.maxScore,
    required this.compatibilityStatus,
    required this.gunaScores,
    this.recommendation,
    this.boyManglik,
    this.girlManglik,
  });

  factory KundliMatchResponse.fromJson(Map<String, dynamic> json) {
    // Parse guna scores
    Map<String, GunaScore> scores = {};
    final gunaData = json['gunaScores'] ?? json['guna_milan'] ?? {};

    gunaData.forEach((key, value) {
      if (value is Map) {
        scores[key] = GunaScore.fromJson(value as Map<String, dynamic>);
      }
    });

    return KundliMatchResponse(
      totalScore: json['totalScore'] ?? json['total_score'] ?? 0,
      maxScore: json['maxScore'] ?? json['max_score'] ?? 36,
      compatibilityStatus:
          json['compatibilityStatus'] ??
          json['compatibility_status'] ??
          _getStatusFromScore(json['totalScore'] ?? 0),
      gunaScores: scores,
      recommendation: json['recommendation'],
      boyManglik: json['boyManglik'] ?? json['boy_manglik'],
      girlManglik: json['girlManglik'] ?? json['girl_manglik'],
    );
  }

  static String _getStatusFromScore(int score) {
    if (score >= 28) return "Excellent";
    if (score >= 24) return "Very Good";
    if (score >= 18) return "Good";
    if (score >= 12) return "Average";
    return "Poor";
  }

  double get compatibilityPercentage => (totalScore / maxScore) * 100;
}

class GunaScore {
  final String name;
  final int obtained;
  final int maximum;
  final String? description;

  GunaScore({
    required this.name,
    required this.obtained,
    required this.maximum,
    this.description,
  });

  factory GunaScore.fromJson(Map<String, dynamic> json) {
    return GunaScore(
      name: json['name'] ?? '',
      obtained: json['obtained'] ?? json['score'] ?? 0,
      maximum: json['maximum'] ?? json['max'] ?? 0,
      description: json['description'],
    );
  }

  double get percentage => maximum > 0 ? (obtained / maximum) * 100 : 0;
}
