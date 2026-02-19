import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ramadan_planner/core/constants/app_constants.dart';
import 'package:ramadan_planner/features/planner/data/models/day_entry_model.dart';
import 'package:ramadan_planner/features/planner/data/sources/aladhan_api_client.dart';

class PlannerRepository {
  final Box _box;
  final AladhanApiClient _aladhanClient;

  PlannerRepository({Box? box, AladhanApiClient? aladhanClient})
    : _box = box ?? Hive.box(AppConstants.plannerBox),
      _aladhanClient = aladhanClient ?? AladhanApiClient();

  Future<void> saveDayEntry(DayEntry entry) async {
    await _box.put(entry.dayNumber, entry);
  }

  DayEntry? getDayEntry(int dayNumber) {
    return _box.get(dayNumber) as DayEntry?;
  }

  List<DayEntry> getAllEntries() {
    return _box.values.cast<DayEntry>().toList();
  }

  Future<void> resetDay(int dayNumber) async {
    await _box.delete(dayNumber);
  }

  // Sync timings from API and cache them
  Future<void> syncPrayerTimes({
    required String city,
    required String country,
    int method = 1,
    int school = 1,
  }) async {
    try {
      final data = await _aladhanClient.getTimingsByCity(
        city: city,
        country: country,
        method: method,
        school: school,
      );
      // Cache this data in cacheBox
      final cacheBox = Hive.box(AppConstants.cacheBox);
      await cacheBox.put('today_timings', data['data']);
    } catch (e) {
      // Handle fallback or retry
    }
  }

  Future<String> exportToJson() async {
    final entries = getAllEntries();
    final jsonList = entries.map((e) => e.toJson()).toList();
    return jsonEncode(jsonList);
  }

  Future<void> importFromJson(String jsonString) async {
    final List<dynamic> jsonList = jsonDecode(jsonString);
    for (var json in jsonList) {
      final entry = DayEntry.fromJson(Map<String, dynamic>.from(json));
      await saveDayEntry(entry);
    }
  }

  Future<void> clearAllBox() async {
    await _box.clear();
  }
}
