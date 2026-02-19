import 'package:hive/hive.dart';

part 'day_entry_model.g.dart';

@HiveType(typeId: 1)
class DayEntry extends HiveObject {
  @HiveField(0)
  final int dayNumber; // 1-30

  @HiveField(1)
  final DateTime dateG; // Gregorian

  @HiveField(2)
  final String dateH; // Hijri String

  @HiveField(3)
  bool fastKept;

  @HiveField(4)
  double sadaqahAmount;

  @HiveField(5)
  int istighfarCount;

  @HiveField(6)
  int duroodCount;

  @HiveField(7)
  Map<String, List<String>> prayers; // {fajr: ['fard', 'sunnah'], ...}

  @HiveField(8)
  bool taraweeh;

  @HiveField(9)
  Map<String, bool> adhkar; // {morning: bool, evening: bool}

  @HiveField(10)
  Map<String, dynamic> tilawat; // {paras: int, fromPage: int, toPage: int}

  @HiveField(11)
  Map<String, dynamic> dars; // {attended: bool, link: string}

  @HiveField(12)
  bool surahMulk;

  @HiveField(13)
  List<String> customItems;

  @HiveField(14)
  List<Map<String, dynamic>> personalDuas; // {text: string, answered: bool, recurring: bool}

  @HiveField(15)
  Map<String, String> reflections; // {best: string, shortfall: string, special: string, gratitude: string}

  @HiveField(16)
  double progressPercent;

  @HiveField(17)
  DateTime updatedAt;

  @HiveField(18)
  bool istighfar1000x;

  @HiveField(19)
  bool durood100x;

  @HiveField(20, defaultValue: 0)
  int subhanAllahCount;

  DayEntry({
    required this.dayNumber,
    required this.dateG,
    required this.dateH,
    this.fastKept = false,
    this.sadaqahAmount = 0.0,
    this.istighfarCount = 0,
    this.duroodCount = 0,
    this.subhanAllahCount = 0,
    required this.prayers,
    this.taraweeh = false,
    required this.adhkar,
    required this.tilawat,
    required this.dars,
    this.surahMulk = false,
    required this.customItems,
    required this.personalDuas,
    required this.reflections,
    this.progressPercent = 0.0,
    required this.updatedAt,
    this.istighfar1000x = false,
    this.durood100x = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'dayNumber': dayNumber,
      'dateG': dateG.toIso8601String(),
      'dateH': dateH,
      'fastKept': fastKept,
      'sadaqahAmount': sadaqahAmount,
      'istighfarCount': istighfarCount,
      'duroodCount': duroodCount,
      'subhanAllahCount': subhanAllahCount,
      'prayers': prayers,
      'taraweeh': taraweeh,
      'adhkar': adhkar,
      'tilawat': tilawat,
      'dars': dars,
      'surahMulk': surahMulk,
      'customItems': customItems,
      'personalDuas': personalDuas,
      'reflections': reflections,
      'progressPercent': progressPercent,
      'updatedAt': updatedAt.toIso8601String(),
      'istighfar1000x': istighfar1000x,
      'durood100x': durood100x,
    };
  }

  factory DayEntry.fromJson(Map<String, dynamic> json) {
    return DayEntry(
      dayNumber: json['dayNumber'],
      dateG: DateTime.parse(json['dateG']),
      dateH: json['dateH'],
      fastKept: json['fastKept'] ?? false,
      sadaqahAmount: (json['sadaqahAmount'] ?? 0.0).toDouble(),
      istighfarCount: json['istighfarCount'] ?? 0,
      duroodCount: json['duroodCount'] ?? 0,
      prayers: Map<String, List<String>>.from(
        (json['prayers'] as Map).map(
          (k, v) => MapEntry(k as String, List<String>.from(v as Iterable)),
        ),
      ),
      taraweeh: json['taraweeh'] ?? false,
      adhkar: Map<String, bool>.from(json['adhkar'] ?? {}),
      tilawat: Map<String, dynamic>.from(json['tilawat'] ?? {}),
      dars: Map<String, dynamic>.from(json['dars'] ?? {}),
      surahMulk: json['surahMulk'] ?? false,
      customItems: List<String>.from(json['customItems'] ?? []),
      personalDuas: List<Map<String, dynamic>>.from(json['personalDuas'] ?? []),
      reflections: Map<String, String>.from(json['reflections'] ?? {}),
      progressPercent: (json['progressPercent'] ?? 0.0).toDouble(),
      updatedAt: DateTime.parse(json['updatedAt']),
      istighfar1000x: json['istighfar1000x'] ?? false,
      durood100x: json['durood100x'] ?? false,
    );
  }

  DayEntry copyWith({
    int? dayNumber,
    DateTime? dateG,
    String? dateH,
    bool? fastKept,
    double? sadaqahAmount,
    int? istighfarCount,
    int? duroodCount,
    Map<String, List<String>>? prayers,
    bool? taraweeh,
    Map<String, bool>? adhkar,
    Map<String, dynamic>? tilawat,
    Map<String, dynamic>? dars,
    bool? surahMulk,
    List<String>? customItems,
    List<Map<String, dynamic>>? personalDuas,
    Map<String, String>? reflections,
    double? progressPercent,
    DateTime? updatedAt,
    bool? istighfar1000x,
    bool? durood100x,
  }) {
    return DayEntry(
      dayNumber: dayNumber ?? this.dayNumber,
      dateG: dateG ?? this.dateG,
      dateH: dateH ?? this.dateH,
      fastKept: fastKept ?? this.fastKept,
      sadaqahAmount: sadaqahAmount ?? this.sadaqahAmount,
      istighfarCount: istighfarCount ?? this.istighfarCount,
      duroodCount: duroodCount ?? this.duroodCount,
      prayers: prayers ?? this.prayers,
      taraweeh: taraweeh ?? this.taraweeh,
      adhkar: adhkar ?? this.adhkar,
      tilawat: tilawat ?? this.tilawat,
      dars: dars ?? this.dars,
      surahMulk: surahMulk ?? this.surahMulk,
      customItems: customItems ?? this.customItems,
      personalDuas: personalDuas ?? this.personalDuas,
      reflections: reflections ?? this.reflections,
      progressPercent: progressPercent ?? this.progressPercent,
      updatedAt: updatedAt ?? this.updatedAt,
      istighfar1000x: istighfar1000x ?? this.istighfar1000x,
      durood100x: durood100x ?? this.durood100x,
    );
  }
}
