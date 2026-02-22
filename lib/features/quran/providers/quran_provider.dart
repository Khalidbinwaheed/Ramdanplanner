import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ramadan_planner/core/constants/app_constants.dart';

class QuranState {
  final Set<String> bookmarks; // e.g. "2:255" for Ayah 255 of Surah 2
  final int dailyGoalJuz; // 0 = off, 1..30
  final int totalPagesRead; // persistent across sessions
  final int completedJuzToday;
  final String selectedTranslation; // 'english' or 'urdu'
  final String lastDate;
  final Set<int> downloadedSurahs;
  final bool isDownloadingAll;
  final double downloadProgress;

  const QuranState({
    this.bookmarks = const {},
    this.dailyGoalJuz = 1,
    this.totalPagesRead = 0,
    this.completedJuzToday = 0,
    this.selectedTranslation = 'urdu',
    this.lastDate = '',
    this.downloadedSurahs = const {},
    this.isDownloadingAll = false,
    this.downloadProgress = 0.0,
  });

  QuranState copyWith({
    Set<String>? bookmarks,
    int? dailyGoalJuz,
    int? totalPagesRead,
    int? completedJuzToday,
    String? selectedTranslation,
    String? lastDate,
    Set<int>? downloadedSurahs,
    bool? isDownloadingAll,
    double? downloadProgress,
  }) {
    return QuranState(
      bookmarks: bookmarks ?? this.bookmarks,
      dailyGoalJuz: dailyGoalJuz ?? this.dailyGoalJuz,
      totalPagesRead: totalPagesRead ?? this.totalPagesRead,
      completedJuzToday: completedJuzToday ?? this.completedJuzToday,
      selectedTranslation: selectedTranslation ?? this.selectedTranslation,
      lastDate: lastDate ?? this.lastDate,
      downloadedSurahs: downloadedSurahs ?? this.downloadedSurahs,
      isDownloadingAll: isDownloadingAll ?? this.isDownloadingAll,
      downloadProgress: downloadProgress ?? this.downloadProgress,
    );
  }
}

class QuranNotifier extends StateNotifier<QuranState> {
  Box? _cacheBox;

  QuranNotifier() : super(const QuranState()) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarksList = prefs.getStringList('quran_bookmarks') ?? [];
    final dailyGoal = prefs.getInt('quran_daily_goal') ?? 1;
    final completedJuz = prefs.getInt('quran_completed_juz_today') ?? 0;
    final totalPages = prefs.getInt('quran_total_pages') ?? 0;
    final translation = prefs.getString('quran_translation') ?? 'urdu';

    // Reset daily completed if new day
    final lastDateStr = prefs.getString('quran_last_date') ?? '';
    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month}-${today.day}';
    final effectiveCompleted = lastDateStr == todayStr ? completedJuz : 0;
    if (lastDateStr != todayStr) {
      await prefs.setString('quran_last_date', todayStr);
      await prefs.setInt('quran_completed_juz_today', 0);
    }

    _cacheBox = await Hive.openBox(AppConstants.cacheBox);
    final downloaded = <int>{};
    for (int i = 1; i <= 114; i++) {
      if (_cacheBox?.containsKey('surah_$i') ?? false) {
        downloaded.add(i);
      }
    }

    state = QuranState(
      bookmarks: Set<String>.from(bookmarksList),
      dailyGoalJuz: dailyGoal,
      completedJuzToday: effectiveCompleted,
      totalPagesRead: totalPages,
      selectedTranslation: translation,
      lastDate: todayStr,
      downloadedSurahs: downloaded,
    );
  }

  Future<void> toggleBookmark(String ayahRef) async {
    final prefs = await SharedPreferences.getInstance();
    final updated = Set<String>.from(state.bookmarks);
    if (updated.contains(ayahRef)) {
      updated.remove(ayahRef);
    } else {
      updated.add(ayahRef);
    }
    await prefs.setStringList('quran_bookmarks', updated.toList());
    state = state.copyWith(bookmarks: updated);
  }

  Future<void> setDailyGoal(int juz) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('quran_daily_goal', juz);
    state = state.copyWith(dailyGoalJuz: juz);
  }

  Future<void> incrementJuzProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final newVal = (state.completedJuzToday + 1).clamp(0, 30);
    await prefs.setInt('quran_completed_juz_today', newVal);
    state = state.copyWith(completedJuzToday: newVal);
  }

  Future<void> addPages(int pages) async {
    final prefs = await SharedPreferences.getInstance();
    final newTotal = state.totalPagesRead + pages;
    await prefs.setInt('quran_total_pages', newTotal);
    state = state.copyWith(totalPagesRead: newTotal);
  }

  Future<void> setTranslation(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('quran_translation', lang);
    state = state.copyWith(selectedTranslation: lang);
  }

  Future<void> downloadSurah(int surahNumber) async {
    _cacheBox ??= await Hive.openBox(AppConstants.cacheBox);

    try {
      final edition = state.selectedTranslation == 'urdu'
          ? 'ur.maududi'
          : 'en.sahih';
      final arabicUrl = 'https://api.alquran.cloud/v1/surah/$surahNumber';
      final transUrl =
          'https://api.alquran.cloud/v1/surah/$surahNumber/$edition';

      final results = await Future.wait([
        http.get(Uri.parse(arabicUrl)),
        http.get(Uri.parse(transUrl)),
      ]);

      if (results[0].statusCode == 200 && results[1].statusCode == 200) {
        final arabicData = json.decode(results[0].body)['data']['ayahs'];
        final transData = json.decode(results[1].body)['data']['ayahs'];

        final surahMap = {'arabic': arabicData, 'translation': transData};

        await _cacheBox!.put('surah_$surahNumber', json.encode(surahMap));

        final downloaded = Set<int>.from(state.downloadedSurahs);
        downloaded.add(surahNumber);
        state = state.copyWith(downloadedSurahs: downloaded);
      }
    } catch (e) {
      // Handle error quietly or update state with error
    }
  }

  Future<void> downloadFullQuran() async {
    if (state.isDownloadingAll) return;
    state = state.copyWith(isDownloadingAll: true, downloadProgress: 0.0);

    for (int i = 1; i <= 114; i++) {
      if (!state.downloadedSurahs.contains(i)) {
        await downloadSurah(i);
      }
      state = state.copyWith(downloadProgress: i / 114);
    }

    state = state.copyWith(isDownloadingAll: false, downloadProgress: 1.0);
  }

  Future<void> deleteDownloadedSurah(int surahNumber) async {
    _cacheBox ??= await Hive.openBox(AppConstants.cacheBox);
    await _cacheBox!.delete('surah_$surahNumber');

    final downloaded = Set<int>.from(state.downloadedSurahs);
    downloaded.remove(surahNumber);
    state = state.copyWith(downloadedSurahs: downloaded);
  }
}

final quranProvider = StateNotifierProvider<QuranNotifier, QuranState>((ref) {
  return QuranNotifier();
});
