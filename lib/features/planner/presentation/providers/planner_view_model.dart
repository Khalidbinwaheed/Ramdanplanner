import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramadan_planner/features/planner/data/models/day_entry_model.dart';
import 'package:ramadan_planner/features/planner/data/repositories/planner_repository.dart';
import 'package:ramadan_planner/features/planner/presentation/providers/planner_providers.dart';

class PlannerState {
  final int selectedDay;
  final DayEntry? currentEntry;
  final List<DayEntry> allEntries;
  final bool isLoading;
  final int streak;
  final int daysFull;
  final double ashraProgress;
  final double overallProgress;

  PlannerState({
    required this.selectedDay,
    this.currentEntry,
    this.allEntries = const [],
    this.isLoading = false,
    this.streak = 0,
    this.daysFull = 0,
    this.ashraProgress = 0.0,
    this.overallProgress = 0.0,
  });

  PlannerState copyWith({
    int? selectedDay,
    DayEntry? currentEntry,
    List<DayEntry>? allEntries,
    bool? isLoading,
    int? streak,
    int? daysFull,
    double? ashraProgress,
    double? overallProgress,
  }) {
    return PlannerState(
      selectedDay: selectedDay ?? this.selectedDay,
      currentEntry: currentEntry ?? this.currentEntry,
      allEntries: allEntries ?? this.allEntries,
      isLoading: isLoading ?? this.isLoading,
      streak: streak ?? this.streak,
      daysFull: daysFull ?? this.daysFull,
      ashraProgress: ashraProgress ?? this.ashraProgress,
      overallProgress: overallProgress ?? this.overallProgress,
    );
  }
}

class PlannerViewModel extends StateNotifier<PlannerState> {
  final PlannerRepository _repository;

  PlannerViewModel(this._repository) : super(PlannerState(selectedDay: 1)) {
    loadDay(1);
    _loadAllEntries();
  }

  void loadDay(int dayNumber) {
    state = state.copyWith(isLoading: true, selectedDay: dayNumber);
    final entry = _repository.getDayEntry(dayNumber);

    if (entry == null) {
      // Create a default entry if not found
      final newEntry = DayEntry(
        dayNumber: dayNumber,
        dateG: DateTime.now(), // TODO: Calculate actual date
        dateH: '1 Ramadan 1447',
        sadaqahAmount: 0.0,
        istighfarCount: 0,
        duroodCount: 0,
        subhanAllahCount: 0,
        prayers: {
          'fajr': [],
          'dhuhr': [],
          'asr': [],
          'maghrib': [],
          'isha': [],
        },
        adhkar: {'morning': false, 'evening': false},
        tilawat: {'paras': 0, 'fromPage': 0, 'toPage': 0},
        dars: {'attended': false, 'link': ''},
        customItems: [],
        personalDuas: [],
        reflections: {
          'best': '',
          'shortfall': '',
          'special': '',
          'gratitude': '',
        },
        updatedAt: DateTime.now(),
      );
      state = state.copyWith(currentEntry: newEntry, isLoading: false);
    } else {
      state = state.copyWith(currentEntry: entry, isLoading: false);
    }
  }

  void _loadAllEntries() {
    final entries = _repository.getAllEntries();
    state = state.copyWith(
      allEntries: entries,
      streak: _calculateStreak(entries),
      daysFull: _calculateDaysFull(entries),
      overallProgress: _calculateOverallProgress(entries),
      ashraProgress: _calculateAshraProgress(entries, state.selectedDay),
    );
  }

  int _calculateStreak(List<DayEntry> entries) {
    if (entries.isEmpty) return 0;
    // Sort by day number descending
    final sorted = List<DayEntry>.from(entries)
      ..sort((a, b) => b.dayNumber.compareTo(a.dayNumber));

    int streak = 0;
    int currentDay = sorted.first.dayNumber;

    for (var entry in sorted) {
      if (entry.dayNumber == currentDay && entry.progressPercent > 50) {
        streak++;
        currentDay--;
      } else {
        break;
      }
    }
    return streak;
  }

  int _calculateDaysFull(List<DayEntry> entries) {
    return entries.where((e) => e.progressPercent >= 100).length;
  }

  double _calculateOverallProgress(List<DayEntry> entries) {
    if (entries.isEmpty) return 0.0;
    double sum = entries.fold(0.0, (prev, e) => prev + e.progressPercent);
    return sum / 30; // Total 30 days
  }

  double _calculateAshraProgress(List<DayEntry> entries, int selectedDay) {
    final ashra = (selectedDay - 1) ~/ 10 + 1;
    final startDay = (ashra - 1) * 10 + 1;
    final endDay = ashra * 10;

    final ashraEntries = entries.where(
      (e) => e.dayNumber >= startDay && e.dayNumber <= endDay,
    );
    if (ashraEntries.isEmpty) return 0.0;

    double sum = ashraEntries.fold(0.0, (prev, e) => prev + e.progressPercent);
    return sum / 10; // 10 days per ashra
  }

  Future<void> updateCurrentEntry(DayEntry entry) async {
    // Calculate progress
    entry.progressPercent = _calculateProgress(entry);
    entry.updatedAt = DateTime.now();

    await _repository.saveDayEntry(entry);
    state = state.copyWith(currentEntry: entry);
    _loadAllEntries();
  }

  double _calculateProgress(DayEntry entry) {
    int total = 0;
    int achieved = 0;

    // Prayers (5 points - one for each prayer if at least something is done)
    total += 5;
    entry.prayers.forEach((key, value) {
      if (value.isNotEmpty) achieved += 1;
    });

    // Fast (3 points)
    total += 3;
    if (entry.fastKept) achieved += 3;

    // Taraweeh (2 points)
    total += 2;
    if (entry.taraweeh) achieved += 2;

    // Adhkar (2 points)
    total += 2;
    achieved += entry.adhkar.values.where((v) => v).length;

    // Goals (2 points)
    total += 2;
    if (entry.istighfar1000x) achieved += 1;
    if (entry.durood100x) achieved += 1;

    if (total == 0) return 0;
    return (achieved / total) * 100;
  }

  // Action methods
  void togglePrayer(String key, String subItem) {
    if (state.currentEntry == null) return;
    final prayers = Map<String, List<String>>.from(state.currentEntry!.prayers);
    final items = List<String>.from(prayers[key] ?? []);
    if (items.contains(subItem)) {
      items.remove(subItem);
    } else {
      items.add(subItem);
    }
    prayers[key] = items;
    final newEntry = state.currentEntry!..prayers = prayers;
    updateCurrentEntry(newEntry);
  }

  void toggleTaraweeh(bool value) {
    if (state.currentEntry == null) return;
    final newEntry = state.currentEntry!..taraweeh = value;
    updateCurrentEntry(newEntry);
  }

  void toggleSurahMulk(bool value) {
    if (state.currentEntry == null) return;
    final newEntry = state.currentEntry!..surahMulk = value;
    updateCurrentEntry(newEntry);
  }

  void incrementSadaqah() {
    if (state.currentEntry == null) return;
    final entry = state.currentEntry!;
    updateCurrentEntry(entry.copyWith(sadaqahAmount: entry.sadaqahAmount + 10));
  }

  void decrementSadaqah() {
    if (state.currentEntry == null) return;
    final entry = state.currentEntry!;
    if (entry.sadaqahAmount >= 10) {
      updateCurrentEntry(
        entry.copyWith(sadaqahAmount: entry.sadaqahAmount - 10),
      );
    }
  }

  Future<void> resetAllData() async {
    await _repository.clearAllBox();
    loadDay(1);
    _loadAllEntries();
  }

  void addPersonalDua(String text) {
    if (state.currentEntry == null) return;
    final duas = List<Map<String, dynamic>>.from(
      state.currentEntry!.personalDuas,
    );
    duas.add({'text': text, 'answered': false, 'recurring': false});
    final newEntry = state.currentEntry!..personalDuas = duas;
    updateCurrentEntry(newEntry);
  }

  void deletePersonalDua(int index) {
    if (state.currentEntry == null) return;
    final duas = List<Map<String, dynamic>>.from(
      state.currentEntry!.personalDuas,
    );
    duas.removeAt(index);
    final newEntry = state.currentEntry!..personalDuas = duas;
    updateCurrentEntry(newEntry);
  }

  void toggleDuaAnswered(int index, bool value) {
    if (state.currentEntry == null) return;
    final duas = List<Map<String, dynamic>>.from(
      state.currentEntry!.personalDuas,
    );
    final dua = Map<String, dynamic>.from(duas[index]);
    dua['answered'] = value;
    duas[index] = dua;
    final newEntry = state.currentEntry!..personalDuas = duas;
    updateCurrentEntry(newEntry);
  }

  void toggleFast(bool value) {
    if (state.currentEntry == null) return;
    final newEntry = state.currentEntry!..fastKept = value;
    updateCurrentEntry(newEntry);
  }

  void setSadaqah(double amount) {
    if (state.currentEntry == null) return;
    final newEntry = state.currentEntry!..sadaqahAmount = amount;
    updateCurrentEntry(newEntry);
  }

  void updateReflection(String key, String value) {
    if (state.currentEntry == null) return;
    final reflections = Map<String, String>.from(
      state.currentEntry!.reflections,
    );
    reflections[key] = value;
    final newEntry = state.currentEntry!..reflections = reflections;
    updateCurrentEntry(newEntry);
  }

  void toggleIstighfarGoal(bool value) {
    if (state.currentEntry == null) return;
    final newEntry = state.currentEntry!..istighfar1000x = value;
    updateCurrentEntry(newEntry);
  }

  void toggleDuroodGoal(bool value) {
    if (state.currentEntry == null) return;
    final newEntry = state.currentEntry!..durood100x = value;
    updateCurrentEntry(newEntry);
  }

  Future<void> resetDay(int dayNumber) async {
    await _repository.resetDay(dayNumber);
    loadDay(dayNumber);
    _loadAllEntries();
  }

  void updateIstighfarCount(int count) {
    if (state.currentEntry == null) return;
    final newEntry = state.currentEntry!..istighfarCount = count;
    updateCurrentEntry(newEntry);
  }

  void updateDuroodCount(int count) {
    if (state.currentEntry == null) return;
    final updatedEntry = state.currentEntry!..duroodCount = count;
    updateCurrentEntry(updatedEntry);
  }

  void updateSubhanAllahCount(int count) {
    if (state.currentEntry == null) return;
    final updatedEntry = state.currentEntry!..subhanAllahCount = count;
    updateCurrentEntry(updatedEntry);
  }

  void addCustomItem(String item) {
    if (state.currentEntry == null) return;
    final items = List<String>.from(state.currentEntry!.customItems);
    items.add(item);
    final newEntry = state.currentEntry!..customItems = items;
    updateCurrentEntry(newEntry);
  }

  void removeCustomItem(String item) {
    if (state.currentEntry == null) return;
    final items = List<String>.from(state.currentEntry!.customItems);
    items.remove(item);
    final newEntry = state.currentEntry!..customItems = items;
    updateCurrentEntry(newEntry);
  }

  void toggleTilawat(bool value) {
    if (state.currentEntry == null) return;
    final tilawat = Map<String, dynamic>.from(state.currentEntry!.tilawat);
    if (value) {
      if ((tilawat['paras'] ?? 0) == 0 && (tilawat['toPage'] ?? 0) == 0) {
        tilawat['paras'] = 1;
      }
    } else {
      tilawat['paras'] = 0;
      tilawat['fromPage'] = 0;
      tilawat['toPage'] = 0;
    }
    final newEntry = state.currentEntry!..tilawat = tilawat;
    updateCurrentEntry(newEntry);
  }

  void toggleDars(bool value) {
    if (state.currentEntry == null) return;
    final dars = Map<String, dynamic>.from(state.currentEntry!.dars);
    dars['attended'] = value;
    final newEntry = state.currentEntry!..dars = dars;
    updateCurrentEntry(newEntry);
  }

  void toggleAdhkar(bool value) {
    if (state.currentEntry == null) return;
    final adhkar = Map<String, bool>.from(state.currentEntry!.adhkar);
    adhkar['morning'] = value;
    adhkar['evening'] = value;
    final newEntry = state.currentEntry!..adhkar = adhkar;
    updateCurrentEntry(newEntry);
  }
}

final plannerViewModelProvider =
    StateNotifierProvider<PlannerViewModel, PlannerState>((ref) {
      final repo = ref.watch(plannerRepositoryProvider);
      return PlannerViewModel(repo);
    });
