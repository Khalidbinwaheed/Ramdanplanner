import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramadan_planner/features/planner/data/models/settings_model.dart';
import 'package:ramadan_planner/features/settings/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});

class AdvancedSettings {
  final String? email;
  final int? age;
  final bool is24HourFormat;
  final double fontSize;
  final bool animationsEnabled;
  final String notificationStyle;
  final Map<String, bool> notificationToggles;
  final bool appLockEnabled;
  final String? appLockPin;

  const AdvancedSettings({
    this.email,
    this.age,
    this.is24HourFormat = false,
    this.fontSize = 1.0,
    this.animationsEnabled = true,
    this.notificationStyle = 'Standard',
    this.notificationToggles = const {
      'quran': true,
      'suhoor': true,
      'iftar': true,
      'taraweeh': true,
      'dua': true,
      'quote': true,
      'weekly': true,
    },
    this.appLockEnabled = false,
    this.appLockPin,
  });

  AdvancedSettings copyWith({
    String? email,
    int? age,
    bool? is24HourFormat,
    double? fontSize,
    bool? animationsEnabled,
    String? notificationStyle,
    Map<String, bool>? notificationToggles,
    bool? appLockEnabled,
    String? appLockPin,
  }) => AdvancedSettings(
    email: email ?? this.email,
    age: age ?? this.age,
    is24HourFormat: is24HourFormat ?? this.is24HourFormat,
    fontSize: fontSize ?? this.fontSize,
    animationsEnabled: animationsEnabled ?? this.animationsEnabled,
    notificationStyle: notificationStyle ?? this.notificationStyle,
    notificationToggles: notificationToggles ?? this.notificationToggles,
    appLockEnabled: appLockEnabled ?? this.appLockEnabled,
    appLockPin: appLockPin ?? this.appLockPin,
  );
}

class SettingsViewModel extends StateNotifier<ShellUserSettings> {
  final SettingsRepository _repository;
  AdvancedSettings _advanced = const AdvancedSettings();

  SettingsViewModel(this._repository) : super(_repository.getSettings()) {
    _loadAdvanced();
    _listenToAuth();
  }

  void _listenToAuth() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        // Only update if the current name is generic or empty
        if (state.userName == null ||
            state.userName!.isEmpty ||
            state.userName == 'User') {
          if (user.displayName != null && user.displayName!.isNotEmpty) {
            setUserName(user.displayName!);
          }
        }
      } else {
        // Refresh UI on logout
        state = state.copyWith();
      }
    });
  }

  AdvancedSettings get advanced => _advanced;

  static const _prefPrefix = 'adv_settings_';

  Future<void> _loadAdvanced() async {
    final prefs = await SharedPreferences.getInstance();
    final toggles = Map<String, bool>.from(_advanced.notificationToggles);
    for (final key in toggles.keys) {
      toggles[key] = prefs.getBool('${_prefPrefix}notif_$key') ?? true;
    }

    _advanced = AdvancedSettings(
      email: prefs.getString('${_prefPrefix}email'),
      age: prefs.getInt('${_prefPrefix}age'),
      is24HourFormat: prefs.getBool('${_prefPrefix}24h') ?? false,
      fontSize: prefs.getDouble('${_prefPrefix}font') ?? 1.0,
      animationsEnabled: prefs.getBool('${_prefPrefix}anim') ?? true,
      notificationStyle:
          prefs.getString('${_prefPrefix}notif_style') ?? 'Standard',
      notificationToggles: toggles,
      appLockEnabled: prefs.getBool('${_prefPrefix}lock_en') ?? false,
      appLockPin: prefs.getString('${_prefPrefix}lock_pin'),
    );
    // Trigger UI update
    state = state.copyWith();
  }

  Future<void> _saveAdvanced() async {
    final prefs = await SharedPreferences.getInstance();
    if (_advanced.email != null) {
      prefs.setString('${_prefPrefix}email', _advanced.email!);
    }
    if (_advanced.age != null) {
      prefs.setInt('${_prefPrefix}age', _advanced.age!);
    }
    prefs.setBool('${_prefPrefix}24h', _advanced.is24HourFormat);
    prefs.setDouble('${_prefPrefix}font', _advanced.fontSize);
    prefs.setBool('${_prefPrefix}anim', _advanced.animationsEnabled);
    prefs.setString('${_prefPrefix}notif_style', _advanced.notificationStyle);
    for (final entry in _advanced.notificationToggles.entries) {
      prefs.setBool('${_prefPrefix}notif_${entry.key}', entry.value);
    }
    prefs.setBool('${_prefPrefix}lock_en', _advanced.appLockEnabled);
    if (_advanced.appLockPin != null) {
      prefs.setString('${_prefPrefix}lock_pin', _advanced.appLockPin!);
    }
  }

  Future<void> updateSettings(ShellUserSettings newSettings) async {
    await _repository.saveSettings(newSettings);
    state = newSettings;
  }

  void setLocation(double lat, double long) =>
      updateSettings(state.copyWith(latitude: lat, longitude: long));

  // Hive setters
  void setLanguage(String lang) =>
      updateSettings(state.copyWith(language: lang));
  void setTheme(String theme) => updateSettings(state.copyWith(theme: theme));
  void setCurrency(String curr) =>
      updateSettings(state.copyWith(currency: curr));
  void setAsrSchool(int school) =>
      updateSettings(state.copyWith(asrSchool: school));
  void setCalculationMethod(int method) =>
      updateSettings(state.copyWith(calculationMethod: method));
  void setUserName(String name) async {
    await updateSettings(state.copyWith(userName: name));
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'name': name})
          .catchError((e) => null);
    }
  }

  // Advanced setters
  void setProfile(String? email, int? age) {
    _advanced = _advanced.copyWith(email: email, age: age);
    _saveAdvanced();
    state = state.copyWith();
  }

  void setTimeFormat(bool is24h) {
    _advanced = _advanced.copyWith(is24HourFormat: is24h);
    _saveAdvanced();
    state = state.copyWith();
  }

  void setFontSize(double size) {
    _advanced = _advanced.copyWith(fontSize: size);
    _saveAdvanced();
    state = state.copyWith();
  }

  void setAnimations(bool enabled) {
    _advanced = _advanced.copyWith(animationsEnabled: enabled);
    _saveAdvanced();
    state = state.copyWith();
  }

  void setNotificationToggle(String key, bool val) {
    final toggles = Map<String, bool>.from(_advanced.notificationToggles);
    toggles[key] = val;
    _advanced = _advanced.copyWith(notificationToggles: toggles);
    _saveAdvanced();
    state = state.copyWith();
  }

  void setNotificationStyle(String style) {
    _advanced = _advanced.copyWith(notificationStyle: style);
    _saveAdvanced();
    state = state.copyWith();
  }

  // Tasbih legacy (used by new system too)
  void updateTasbihName(String name) =>
      updateSettings(state.copyWith(tasbihName: name));
  void incrementTasbih() =>
      updateSettings(state.copyWith(tasbihCount: state.tasbihCount + 1));
  void resetTasbih() => updateSettings(state.copyWith(tasbihCount: 0));

  void setAppLock(bool enabled, String? pin) {
    _advanced = _advanced.copyWith(appLockEnabled: enabled, appLockPin: pin);
    _saveAdvanced();
    state = state.copyWith();
  }

  Future<void> exportData(List<dynamic> entries) async {
    final buffer = StringBuffer();
    buffer.writeln('Date,Fast,Taraweeh,Quran');
    for (var e in entries) {
      buffer.writeln('${e.date},${e.fastKept},${e.taraweeh},${e.tilawat}');
    }
    await SharePlus.instance.share(
      ShareParams(text: buffer.toString(), subject: 'Ramadan Progress'),
    );
  }
}

final settingsViewModelProvider =
    StateNotifierProvider<SettingsViewModel, ShellUserSettings>((ref) {
      final repo = ref.watch(settingsRepositoryProvider);
      return SettingsViewModel(repo);
    });
