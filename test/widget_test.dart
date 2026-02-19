import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramadan_planner/main.dart';
import 'package:ramadan_planner/features/planner/data/repositories/planner_repository.dart';
import 'package:ramadan_planner/features/settings/settings_repository.dart';
import 'package:ramadan_planner/features/planner/presentation/providers/planner_providers.dart';
import 'package:ramadan_planner/features/planner/data/models/day_entry_model.dart';
import 'package:ramadan_planner/features/planner/data/models/settings_model.dart';

class MockPlannerRepository implements PlannerRepository {
  @override
  DayEntry? getDayEntry(int dayNumber) => null;
  @override
  List<DayEntry> getAllEntries() => [];
  @override
  Future<void> saveDayEntry(DayEntry entry) async {}
  @override
  Future<void> resetDay(int dayNumber) async {}
  @override
  Future<void> syncPrayerTimes({
    required String city,
    required String country,
    int method = 1,
    int school = 1,
  }) async {}

  @override
  Future<String> exportToJson() async => '';

  @override
  Future<void> importFromJson(String jsonString) async {}

  @override
  Future<void> clearAllBox() async {}
}

class MockSettingsRepository implements SettingsRepository {
  @override
  ShellUserSettings getSettings() => ShellUserSettings.defaultSettings();
  @override
  Future<void> saveSettings(ShellUserSettings settings) async {}
  @override
  Future<void> clearSettings() async {}
}

void main() {
  testWidgets('Ramadan Planner home page test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          plannerRepositoryProvider.overrideWithValue(MockPlannerRepository()),
          settingsRepositoryProvider.overrideWithValue(
            MockSettingsRepository(),
          ),
        ],
        child: const RamadanPlannerApp(),
      ),
    );

    // Wait for initial load
    await tester.pump();

    // Verify that our home page text is present.
    expect(find.text('Ramadan 2026'), findsOneWidget);
    expect(find.text('1st Ramadan 1447'), findsOneWidget);
  });
}
