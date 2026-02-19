import 'package:hive_flutter/hive_flutter.dart';
import 'package:ramadan_planner/core/constants/app_constants.dart';
import 'package:ramadan_planner/features/planner/data/models/settings_model.dart';

class SettingsRepository {
  final Box _box;

  SettingsRepository({Box? box})
    : _box = box ?? Hive.box(AppConstants.settingsBox);

  ShellUserSettings getSettings() {
    final settings = _box.get('current_settings');
    if (settings != null) {
      return settings as ShellUserSettings;
    }
    return ShellUserSettings.defaultSettings();
  }

  Future<void> saveSettings(ShellUserSettings settings) async {
    await _box.put('current_settings', settings);
  }

  Future<void> clearSettings() async {
    await _box.delete('current_settings');
  }
}
