import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramadan_planner/features/planner/data/models/settings_model.dart';
import 'package:ramadan_planner/features/settings/settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});

class SettingsViewModel extends StateNotifier<ShellUserSettings> {
  final SettingsRepository _repository;

  SettingsViewModel(this._repository) : super(_repository.getSettings());

  Future<void> updateSettings(ShellUserSettings newSettings) async {
    await _repository.saveSettings(newSettings);
    state = newSettings;
  }

  void setLanguage(String lang) =>
      updateSettings(state.copyWith(language: lang));
  void setTheme(String theme) => updateSettings(state.copyWith(theme: theme));
  void setCurrency(String curr) =>
      updateSettings(state.copyWith(currency: curr));
  void setNotifications(bool val) =>
      updateSettings(state.copyWith(notifications: val));
  void setAsrSchool(int school) =>
      updateSettings(state.copyWith(asrSchool: school));
  void setCalculationMethod(int method) =>
      updateSettings(state.copyWith(calculationMethod: method));
  void setUserName(String name) =>
      updateSettings(state.copyWith(userName: name));

  void updateTasbihName(String name) =>
      updateSettings(state.copyWith(tasbihName: name));

  void incrementTasbih() =>
      updateSettings(state.copyWith(tasbihCount: state.tasbihCount + 1));

  void resetTasbih() => updateSettings(state.copyWith(tasbihCount: 0));
}

final settingsViewModelProvider =
    StateNotifierProvider<SettingsViewModel, ShellUserSettings>((ref) {
      final repo = ref.watch(settingsRepositoryProvider);
      return SettingsViewModel(repo);
    });
