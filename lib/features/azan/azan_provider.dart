import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AzanState {
  final bool azanEnabled;
  final double volume;
  final String selectedSound;
  final Map<String, bool> prayerAlarms; // per-prayer alarm toggle

  const AzanState({
    this.azanEnabled = true,
    this.volume = 1.0,
    this.selectedSound = 'azan1',
    this.prayerAlarms = const {
      'fajr': true,
      'dhuhr': true,
      'asr': true,
      'maghrib': true,
      'isha': true,
    },
  });

  AzanState copyWith({
    bool? azanEnabled,
    double? volume,
    String? selectedSound,
    Map<String, bool>? prayerAlarms,
  }) {
    return AzanState(
      azanEnabled: azanEnabled ?? this.azanEnabled,
      volume: volume ?? this.volume,
      selectedSound: selectedSound ?? this.selectedSound,
      prayerAlarms: prayerAlarms ?? this.prayerAlarms,
    );
  }
}

class AzanNotifier extends StateNotifier<AzanState> {
  AzanNotifier() : super(const AzanState()) {
    _load();
  }

  static const _prefKeyEnabled = 'azan_enabled';
  static const _prefKeyVolume = 'azan_volume';
  static const _prefKeySound = 'azan_sound';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(_prefKeyEnabled) ?? true;
    final volume = prefs.getDouble(_prefKeyVolume) ?? 1.0;
    final sound = prefs.getString(_prefKeySound) ?? 'azan1';

    final prayerAlarms = <String, bool>{};
    for (final prayer in ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha']) {
      prayerAlarms[prayer] = prefs.getBool('azan_$prayer') ?? true;
    }

    state = AzanState(
      azanEnabled: enabled,
      volume: volume,
      selectedSound: sound,
      prayerAlarms: prayerAlarms,
    );
  }

  Future<void> toggleAzan(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKeyEnabled, value);
    state = state.copyWith(azanEnabled: value);
  }

  Future<void> togglePrayerAlarm(String prayer, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('azan_$prayer', value);
    final updated = Map<String, bool>.from(state.prayerAlarms);
    updated[prayer] = value;
    state = state.copyWith(prayerAlarms: updated);
  }

  Future<void> setVolume(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_prefKeyVolume, value);
    state = state.copyWith(volume: value);
  }

  Future<void> setSound(String sound) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKeySound, sound);
    state = state.copyWith(selectedSound: sound);
  }
}

final azanProvider = StateNotifierProvider<AzanNotifier, AzanState>((ref) {
  return AzanNotifier();
});
