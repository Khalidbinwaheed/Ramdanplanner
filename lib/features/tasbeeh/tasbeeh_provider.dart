import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Dua Model ───────────────────────────────────────────────────────────────
class TasbeehDua {
  final String id;
  final String name;
  final String arabic;
  final String transliteration;
  final String translation;
  final int defaultTarget;
  final bool isCustom;

  const TasbeehDua({
    required this.id,
    required this.name,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.defaultTarget,
    this.isCustom = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'arabic': arabic,
    'transliteration': transliteration,
    'translation': translation,
    'defaultTarget': defaultTarget,
    'isCustom': isCustom,
  };

  factory TasbeehDua.fromJson(Map<String, dynamic> j) => TasbeehDua(
    id: j['id'],
    name: j['name'],
    arabic: j['arabic'],
    transliteration: j['transliteration'],
    translation: j['translation'],
    defaultTarget: j['defaultTarget'],
    isCustom: j['isCustom'] ?? false,
  );
}

// ─── History Entry ────────────────────────────────────────────────────────────
class TasbeehHistoryEntry {
  final String date; // yyyy-MM-dd
  final String duaName;
  final int count;

  const TasbeehHistoryEntry({
    required this.date,
    required this.duaName,
    required this.count,
  });

  Map<String, dynamic> toJson() => {
    'date': date,
    'duaName': duaName,
    'count': count,
  };

  factory TasbeehHistoryEntry.fromJson(Map<String, dynamic> j) =>
      TasbeehHistoryEntry(
        date: j['date'],
        duaName: j['duaName'],
        count: j['count'],
      );
}

// ─── State ────────────────────────────────────────────────────────────────────
class TasbeehState {
  final List<TasbeehDua> duas;
  final int activeDuaIndex;
  final int count;
  final int target;
  final int streak;
  final String lastCountedDate;
  final List<TasbeehHistoryEntry> history;

  const TasbeehState({
    required this.duas,
    this.activeDuaIndex = 0,
    this.count = 0,
    this.target = 33,
    this.streak = 0,
    this.lastCountedDate = '',
    this.history = const [],
  });

  TasbeehDua get activeDua => duas[activeDuaIndex.clamp(0, duas.length - 1)];
  bool get isTargetReached => count >= target;
  double get progress => target <= 0 ? 0 : (count / target).clamp(0.0, 1.0);

  TasbeehState copyWith({
    List<TasbeehDua>? duas,
    int? activeDuaIndex,
    int? count,
    int? target,
    int? streak,
    String? lastCountedDate,
    List<TasbeehHistoryEntry>? history,
  }) => TasbeehState(
    duas: duas ?? this.duas,
    activeDuaIndex: activeDuaIndex ?? this.activeDuaIndex,
    count: count ?? this.count,
    target: target ?? this.target,
    streak: streak ?? this.streak,
    lastCountedDate: lastCountedDate ?? this.lastCountedDate,
    history: history ?? this.history,
  );
}

// ─── Preloaded Duas ───────────────────────────────────────────────────────────
const List<TasbeehDua> _preloadedDuas = [
  TasbeehDua(
    id: 'subhanallah',
    name: 'SubhanAllah',
    arabic: 'سُبْحَانَ اللَّهِ',
    transliteration: 'SubhanAllah',
    translation: 'Glory be to Allah',
    defaultTarget: 33,
  ),
  TasbeehDua(
    id: 'alhamdulillah',
    name: 'Alhamdulillah',
    arabic: 'الْحَمْدُ لِلَّهِ',
    transliteration: 'Alhamdulillah',
    translation: 'All praise is due to Allah',
    defaultTarget: 33,
  ),
  TasbeehDua(
    id: 'allahuakbar',
    name: 'Allahu Akbar',
    arabic: 'اللَّهُ أَكْبَرُ',
    transliteration: 'Allahu Akbar',
    translation: 'Allah is the Greatest',
    defaultTarget: 34,
  ),
  TasbeehDua(
    id: 'astaghfirullah',
    name: 'Astaghfirullah',
    arabic: 'أَسْتَغْفِرُ اللَّهَ',
    transliteration: 'Astaghfirullah',
    translation: 'I seek forgiveness from Allah',
    defaultTarget: 100,
  ),
  TasbeehDua(
    id: 'lailahaillallah',
    name: 'La ilaha illallah',
    arabic: 'لَا إِلَٰهَ إِلَّا اللَّهُ',
    transliteration: 'La ilaha illallah',
    translation: 'There is no god but Allah',
    defaultTarget: 100,
  ),
  TasbeehDua(
    id: 'durood',
    name: 'Durood Shareef',
    arabic: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ',
    transliteration: "Allahumma salli 'ala Muhammad wa 'ala ali Muhammad",
    translation: 'O Allah, send blessings upon Muhammad and his family',
    defaultTarget: 100,
  ),
  TasbeehDua(
    id: 'ayatul_kursi',
    name: 'Ayat ul Kursi',
    arabic: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ',
    transliteration: 'Allahu la ilaha illa huwal hayyul qayyum',
    translation:
        'Allah — there is no deity except Him, the Ever-Living, the Sustainer',
    defaultTarget: 1,
  ),
  TasbeehDua(
    id: 'morning_adhkar',
    name: 'Morning Adhkar',
    arabic: 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ',
    transliteration: "Asbahna wa asbahal mulku lillah",
    translation:
        'We have entered the morning and the whole kingdom belongs to Allah',
    defaultTarget: 1,
  ),
  TasbeehDua(
    id: 'iftar_dua',
    name: 'Dua before Iftar',
    arabic: 'اللَّهُمَّ لَكَ صُمْتُ وَعَلَى رِزْقِكَ أَفْطَرْتُ',
    transliteration: 'Allahumma laka sumtu wa ala rizqika aftartu',
    translation:
        'O Allah, I fasted for You and I break my fast with Your sustenance',
    defaultTarget: 1,
  ),
  TasbeehDua(
    id: 'sleep_dua',
    name: 'Dua before Sleeping',
    arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
    transliteration: 'Bismika Allahumma amutu wa ahya',
    translation: 'In Your name, O Allah, I die and I live',
    defaultTarget: 1,
  ),
];

// ─── Notifier ─────────────────────────────────────────────────────────────────
class TasbeehNotifier extends StateNotifier<TasbeehState> {
  TasbeehNotifier() : super(const TasbeehState(duas: _preloadedDuas)) {
    _load();
  }

  static const _countKey = 'tasbeeh_count';
  static const _targetKey = 'tasbeeh_target';
  static const _duaIndexKey = 'tasbeeh_dua_index';
  static const _streakKey = 'tasbeeh_streak';
  static const _lastDateKey = 'tasbeeh_last_date';
  static const _historyKey = 'tasbeeh_history';
  static const _customDuasKey = 'tasbeeh_custom_duas';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _todayStr();
    final lastDate = prefs.getString(_lastDateKey) ?? '';
    int streak = prefs.getInt(_streakKey) ?? 0;

    // Reset count if it's a new day
    int count = prefs.getInt(_countKey) ?? 0;
    if (lastDate != today) {
      // Save yesterday's count to history if non-zero
      if (count > 0 && lastDate.isNotEmpty) {
        await _saveHistoryEntry(prefs, lastDate, state.activeDua.name, count);
      }
      count = 0;
      // Update streak
      final yesterday = _yesterdayStr();
      if (lastDate == yesterday) {
        // streak continues
      } else {
        streak = 0;
      }
      await prefs.setString(_lastDateKey, today);
      await prefs.setInt(_countKey, 0);
    }

    // Load custom duas
    final customJson = prefs.getStringList(_customDuasKey) ?? [];
    final customDuas = customJson
        .map((s) => TasbeehDua.fromJson(json.decode(s)))
        .toList();

    // Load history
    final histJson = prefs.getStringList(_historyKey) ?? [];
    final history = histJson
        .map((s) => TasbeehHistoryEntry.fromJson(json.decode(s)))
        .toList();

    final allDuas = [..._preloadedDuas, ...customDuas];
    final duaIndex = (prefs.getInt(_duaIndexKey) ?? 0).clamp(
      0,
      allDuas.length - 1,
    );

    state = TasbeehState(
      duas: allDuas,
      activeDuaIndex: duaIndex,
      count: count,
      target:
          prefs.getInt(_targetKey) ?? _preloadedDuas[duaIndex].defaultTarget,
      streak: streak,
      lastCountedDate: lastDate.isEmpty ? today : lastDate,
      history: history.reversed.take(30).toList(),
    );
  }

  Future<void> _saveHistoryEntry(
    SharedPreferences prefs,
    String date,
    String duaName,
    int count,
  ) async {
    final histJson = prefs.getStringList(_historyKey) ?? [];
    final entry = TasbeehHistoryEntry(
      date: date,
      duaName: duaName,
      count: count,
    );
    histJson.insert(0, json.encode(entry.toJson()));
    // Keep last 30 entries
    if (histJson.length > 30) histJson.removeLast();
    await prefs.setStringList(_historyKey, histJson);
  }

  Future<void> tap() async {
    final prefs = await SharedPreferences.getInstance();
    final newCount = state.count + 1;
    int streak = state.streak;

    // If target just reached, increment streak
    if (newCount == state.target) {
      streak += 1;
      await prefs.setInt(_streakKey, streak);
    }

    await prefs.setInt(_countKey, newCount);
    await prefs.setString(_lastDateKey, _todayStr());
    state = state.copyWith(
      count: newCount,
      streak: streak,
      lastCountedDate: _todayStr(),
    );
  }

  Future<void> decrement() async {
    if (state.count <= 0) return;
    final prefs = await SharedPreferences.getInstance();
    final newCount = state.count - 1;
    await prefs.setInt(_countKey, newCount);
    state = state.copyWith(count: newCount);
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    // Save current session to history before resetting
    if (state.count > 0) {
      await _saveHistoryEntry(
        prefs,
        _todayStr(),
        state.activeDua.name,
        state.count,
      );
      final histJson = prefs.getStringList(_historyKey) ?? [];
      final history = histJson
          .map((s) => TasbeehHistoryEntry.fromJson(json.decode(s)))
          .toList();
      state = state.copyWith(count: 0, history: history.take(30).toList());
    } else {
      state = state.copyWith(count: 0);
    }
    await prefs.setInt(_countKey, 0);
  }

  Future<void> clearFullHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
    await prefs.remove(_countKey);
    state = state.copyWith(count: 0, history: []);
  }

  Future<void> setTarget(int target) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_targetKey, target);
    state = state.copyWith(target: target);
  }

  Future<void> selectDua(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final clamped = index.clamp(0, state.duas.length - 1);
    await prefs.setInt(_duaIndexKey, clamped);
    await prefs.setInt(_targetKey, state.duas[clamped].defaultTarget);
    state = state.copyWith(
      activeDuaIndex: clamped,
      target: state.duas[clamped].defaultTarget,
    );
  }

  Future<void> addCustomDua({
    required String name,
    required String arabic,
    required String transliteration,
    required String translation,
    required int target,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final id = 'custom_${DateTime.now().millisecondsSinceEpoch}';
    final dua = TasbeehDua(
      id: id,
      name: name,
      arabic: arabic,
      transliteration: transliteration,
      translation: translation,
      defaultTarget: target,
      isCustom: true,
    );
    final customDuas = state.duas.where((d) => d.isCustom).toList()..add(dua);
    final customJson = customDuas.map((d) => json.encode(d.toJson())).toList();
    await prefs.setStringList(_customDuasKey, customJson);
    state = state.copyWith(duas: [..._preloadedDuas, ...customDuas]);
  }

  Future<void> removeCustomDua(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final customDuas = state.duas
        .where((d) => d.isCustom && d.id != id)
        .toList();
    final customJson = customDuas.map((d) => json.encode(d.toJson())).toList();
    await prefs.setStringList(_customDuasKey, customJson);
    final allDuas = [..._preloadedDuas, ...customDuas];
    final newIndex = state.activeDuaIndex.clamp(0, allDuas.length - 1);
    state = state.copyWith(duas: allDuas, activeDuaIndex: newIndex);
  }

  String _todayStr() {
    final t = DateTime.now();
    return '${t.year}-${t.month.toString().padLeft(2, '0')}-${t.day.toString().padLeft(2, '0')}';
  }

  String _yesterdayStr() {
    final t = DateTime.now().subtract(const Duration(days: 1));
    return '${t.year}-${t.month.toString().padLeft(2, '0')}-${t.day.toString().padLeft(2, '0')}';
  }
}

final tasbeehProvider = StateNotifierProvider<TasbeehNotifier, TasbeehState>((
  ref,
) {
  return TasbeehNotifier();
});
