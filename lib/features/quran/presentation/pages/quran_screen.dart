import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramadan_planner/features/quran/data/quran_data.dart';
import 'package:ramadan_planner/features/quran/providers/quran_provider.dart';
import 'package:ramadan_planner/features/quran/presentation/pages/surah_detail_screen.dart';
import 'package:ramadan_planner/l10n/app_localizations.dart';

class QuranScreen extends ConsumerStatefulWidget {
  const QuranScreen({super.key});

  @override
  ConsumerState<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends ConsumerState<QuranScreen> {
  String _searchQuery = '';
  int _selectedJuz = 0; // 0 = all

  @override
  Widget build(BuildContext context) {
    final quranState = ref.watch(quranProvider);
    final notifier = ref.read(quranProvider.notifier);
    final theme = Theme.of(context);

    final allSurahs = QuranData.surahs;
    final filtered = allSurahs.where((s) {
      final query = _searchQuery.toLowerCase();
      final matchesSearch =
          query.isEmpty ||
          (s['name'] as String).toLowerCase().contains(query) ||
          (s['arabic'] as String).contains(query) ||
          (s['meaning'] as String).toLowerCase().contains(query);
      final matchesJuz = _selectedJuz == 0 || s['juz'] == _selectedJuz;
      return matchesSearch && matchesJuz;
    }).toList();

    final progress = quranState.dailyGoalJuz > 0
        ? (quranState.completedJuzToday / quranState.dailyGoalJuz).clamp(
            0.0,
            1.0,
          )
        : 0.0;

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 220,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1B5E20),
                      Color(0xFF2E7D32),
                      Color(0xFF388E3C),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      16,
                      16,
                      16,
                      8,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.holyQuran,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.quranArabic,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Daily Juz progress
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.juzCompleted(
                                      quranState.completedJuzToday,
                                      quranState.dailyGoalJuz,
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: LinearProgressIndicator(
                                      value: progress,
                                      backgroundColor: Colors.white24,
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                            Color(0xFFFFD54F),
                                          ),
                                      minHeight: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              onPressed: notifier.incrementJuzProgress,
                              icon: const Icon(
                                Icons.add_circle,
                                color: Colors.white,
                                size: 32,
                              ),
                              tooltip: l10n.juzAddedTooltip,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (quranState.isDownloadingAll)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: LinearProgressIndicator(
                              value: quranState.downloadProgress,
                              backgroundColor: Colors.white12,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.greenAccent,
                              ),
                            ),
                          ),

                        // Download All Button
                        if (!quranState.isDownloadingAll &&
                            quranState.downloadedSurahs.length < 114)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: OutlinedButton.icon(
                              onPressed: () => ref
                                  .read(quranProvider.notifier)
                                  .downloadFullQuran(),
                              icon: const Icon(
                                Icons.download_for_offline,
                                size: 18,
                              ),
                              label: const Text('Download Full Quran'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.greenAccent,
                                side: const BorderSide(
                                  color: Colors.greenAccent,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Container(
                color: theme.colorScheme.surface,
                padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
                child: TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: l10n.searchSurah,
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 8,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Juz filter chips
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 4),
              child: Row(
                children: [
                  FilterChip(
                    label: Text(l10n.allJuz),
                    selected: _selectedJuz == 0,
                    onSelected: (_) => setState(() => _selectedJuz = 0),
                    selectedColor: const Color(
                      0xFF2E7D32,
                    ).withValues(alpha: 0.2),
                  ),
                  const SizedBox(width: 6),
                  ...List.generate(30, (i) => i + 1).map(
                    (juz) => Padding(
                      padding: const EdgeInsetsDirectional.only(end: 6),
                      child: FilterChip(
                        label: Text(l10n.juzLabel(juz)),
                        selected: _selectedJuz == juz,
                        onSelected: (_) => setState(() => _selectedJuz = juz),
                        selectedColor: const Color(
                          0xFF2E7D32,
                        ).withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Translation selector + goal setter
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 8),
              child: Row(
                children: [
                  Text('${l10n.translationLabel}: '),
                  ChoiceChip(
                    label: Text(l10n.languageEnglish),
                    selected: quranState.selectedTranslation == 'english',
                    onSelected: (_) => notifier.setTranslation('english'),
                  ),
                  const SizedBox(width: 6),
                  ChoiceChip(
                    label: Text(l10n.languageUrdu),
                    selected: quranState.selectedTranslation == 'urdu',
                    onSelected: (_) => notifier.setTranslation('urdu'),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () =>
                        _showGoalDialog(context, quranState, notifier),
                    icon: const Icon(Icons.flag, size: 16),
                    label: Text(l10n.goalLabel(quranState.dailyGoalJuz)),
                  ),
                ],
              ),
            ),
          ),

          // Surah list
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final surah = filtered[index];
              final number = surah['number'] as int;
              final isBookmarked = quranState.bookmarks.contains('$number:1');

              return ListTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF2E7D32),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$number',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ),
                title: Text(
                  surah['name'] as String,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  '${surah['meaning']} • ${surah['ayahs']} ${l10n.versesLabel} • ${l10n.juzLabel(surah['juz'])}',
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      surah['arabic'] as String,
                      style: const TextStyle(fontSize: 18, fontFamily: 'serif'),
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(width: 8),
                    if (isBookmarked)
                      const Icon(
                        Icons.bookmark,
                        color: Color(0xFF2E7D32),
                        size: 18,
                      ),
                    const SizedBox(width: 8),
                    if (quranState.downloadedSurahs.contains(number))
                      IconButton(
                        icon: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        onPressed: () => notifier.deleteDownloadedSurah(number),
                        tooltip: 'Downloaded (Click to delete)',
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      )
                    else
                      IconButton(
                        icon: const Icon(
                          Icons.download_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () => notifier.downloadSurah(number),
                        tooltip: 'Download Surah',
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SurahDetailScreen(
                        surahNumber: number,
                        surahName: surah['name'] as String,
                        surahArabic: surah['arabic'] as String,
                        ayahCount: surah['ayahs'] as int,
                        translation: quranState.selectedTranslation,
                      ),
                    ),
                  );
                },
              );
            }, childCount: filtered.length),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  void _showGoalDialog(
    BuildContext context,
    QuranState state,
    QuranNotifier notifier,
  ) {
    int tempGoal = state.dailyGoalJuz;
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.dailyQuranGoal),
        content: StatefulBuilder(
          builder: (ctx, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.juzPerDay(tempGoal),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Slider(
                value: tempGoal.toDouble(),
                min: 1,
                max: 30,
                divisions: 29,
                label: l10n.juzLabel(tempGoal),
                activeColor: const Color(0xFF2E7D32),
                onChanged: (v) => setState(() => tempGoal = v.round()),
              ),
              Text(
                tempGoal == 1
                    ? l10n.finishQuran30Days
                    : l10n.finishQuranDays(30 ~/ tempGoal),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              notifier.setDailyGoal(tempGoal);
              Navigator.pop(ctx);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}
