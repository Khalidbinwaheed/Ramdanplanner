import 'package:hive/hive.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 0)
class ShellUserSettings extends HiveObject {
  @HiveField(0)
  final String language; // en, ar, ur

  @HiveField(1)
  final String theme; // light, dark, system

  @HiveField(2)
  final String currency; // PKR, USD, etc.

  @HiveField(3)
  final String? city;

  @HiveField(4)
  final String? country;

  @HiveField(5)
  final double? latitude;

  @HiveField(6)
  final double? longitude;

  @HiveField(7)
  final String timezone;

  @HiveField(8)
  final int calculationMethod; // Aladhan method ID

  @HiveField(9)
  final int asrSchool; // 0: Shafi, 1: Hanafi

  @HiveField(10)
  final bool notifications;

  @HiveField(11)
  final String? userName;

  @HiveField(12)
  final String? tasbihName;

  @HiveField(13)
  final int tasbihCount;

  ShellUserSettings({
    required this.language,
    required this.theme,
    required this.currency,
    this.city,
    this.country,
    this.latitude,
    this.longitude,
    required this.timezone,
    required this.calculationMethod,
    required this.asrSchool,
    this.notifications = true,
    this.userName,
    this.tasbihName,
    this.tasbihCount = 0,
  });

  factory ShellUserSettings.defaultSettings() {
    return ShellUserSettings(
      language: 'en',
      theme: 'system',
      currency: 'PKR',
      timezone: 'Asia/Karachi',
      calculationMethod: 1, // University of Islamic Sciences, Karachi
      asrSchool: 1, // Hanafi
      notifications: true,
      userName: 'User',
      tasbihName: 'SubhanAllah',
      tasbihCount: 0,
    );
  }

  ShellUserSettings copyWith({
    String? language,
    String? theme,
    String? currency,
    String? city,
    String? country,
    double? latitude,
    double? longitude,
    String? timezone,
    int? calculationMethod,
    int? asrSchool,
    bool? notifications,
    String? userName,
    String? tasbihName,
    int? tasbihCount,
  }) {
    return ShellUserSettings(
      language: language ?? this.language,
      theme: theme ?? this.theme,
      currency: currency ?? this.currency,
      city: city ?? this.city,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timezone: timezone ?? this.timezone,
      calculationMethod: calculationMethod ?? this.calculationMethod,
      asrSchool: asrSchool ?? this.asrSchool,
      notifications: notifications ?? this.notifications,
      userName: userName ?? this.userName,
      tasbihName: tasbihName ?? this.tasbihName,
      tasbihCount: tasbihCount ?? this.tasbihCount,
    );
  }
}
