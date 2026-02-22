import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ramadan_planner/core/constants/app_constants.dart';
import 'package:ramadan_planner/features/quran/providers/quran_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ramadan_planner/l10n/app_localizations.dart';

class SurahDetailScreen extends ConsumerStatefulWidget {
  final int surahNumber;
  final String surahName;
  final String surahArabic;
  final int ayahCount;
  final String translation;

  const SurahDetailScreen({
    super.key,
    required this.surahNumber,
    required this.surahName,
    required this.surahArabic,
    required this.ayahCount,
    required this.translation,
  });

  @override
  ConsumerState<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends ConsumerState<SurahDetailScreen> {
  List<Map<String, dynamic>> _ayahs = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAyahs();
  }

  Future<void> _loadAyahs() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final box = await Hive.openBox(AppConstants.cacheBox);
      if (box.containsKey('surah_${widget.surahNumber}')) {
        final cached = json.decode(box.get('surah_${widget.surahNumber}'));
        final arabicData = cached['arabic'] as List;
        final transData = cached['translation'] as List;

        final ayahs = List.generate(
          arabicData.length,
          (i) => {
            'number': arabicData[i]['numberInSurah'],
            'arabic': arabicData[i]['text'],
            'translation': transData[i]['text'],
          },
        );

        if (mounted) {
          setState(() {
            _ayahs = ayahs;
            _loading = false;
          });
          return;
        }
      }

      // Al-Quran Cloud API Fallback
      final edition = widget.translation == 'urdu' ? 'ur.maududi' : 'en.sahih';

      final arabicUrl =
          'https://api.alquran.cloud/v1/surah/${widget.surahNumber}';
      final transUrl =
          'https://api.alquran.cloud/v1/surah/${widget.surahNumber}/$edition';

      final results = await Future.wait([
        http.get(Uri.parse(arabicUrl)),
        http.get(Uri.parse(transUrl)),
      ]);

      if (results[0].statusCode == 200 && results[1].statusCode == 200) {
        final arabicData =
            json.decode(results[0].body)['data']['ayahs'] as List;
        final transData = json.decode(results[1].body)['data']['ayahs'] as List;

        final ayahs = List.generate(
          arabicData.length,
          (i) => {
            'number': arabicData[i]['numberInSurah'],
            'arabic': arabicData[i]['text'],
            'translation': transData[i]['text'],
          },
        );
        if (mounted) {
          setState(() {
            _ayahs = ayahs;
            _loading = false;
          });
        }
      } else {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          setState(() {
            _error = l10n.failedLoadInternet;
            _loading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        setState(() {
          _error = '${l10n.noInternet}\n$e';
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final quranState = ref.watch(quranProvider);
    final notifier = ref.read(quranProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.surahName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '${widget.surahArabic} • ${widget.ayahCount} ${AppLocalizations.of(context)!.verses}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => _openRecitation(),
            icon: const Icon(Icons.play_circle_outline),
            tooltip: AppLocalizations.of(context)!.listenRecitation,
          ),
        ],
      ),
      body: _loading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Color(0xFF2E7D32)),
                  const SizedBox(height: 16),
                  Text(AppLocalizations.of(context)!.loadingAyahs),
                ],
              ),
            )
          : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadAyahs,
                      child: Text(AppLocalizations.of(context)!.retry),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _ayahs.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, thickness: 0.5),
              itemBuilder: (context, index) {
                final ayah = _ayahs[index];
                final ayahRef = '${widget.surahNumber}:${ayah['number']}';
                final isBookmarked = quranState.bookmarks.contains(ayahRef);

                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Ayah number row
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF2E7D32,
                              ).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${ayah['number']}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => notifier.toggleBookmark(ayahRef),
                            icon: Icon(
                              isBookmarked
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: const Color(0xFF2E7D32),
                              size: 20,
                            ),
                            tooltip: isBookmarked
                                ? AppLocalizations.of(context)!.removeBookmark
                                : AppLocalizations.of(context)!.addBookmark,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Arabic text
                      Text(
                        ayah['arabic'] as String,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          fontSize: 22,
                          fontFamily: 'serif',
                          height: 1.8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Translation
                      Text(
                        ayah['translation'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.5,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Future<void> _openRecitation() async {
    // Open Mishary Rashid recitation from MP3 Quran
    final url = Uri.parse(
      'https://server8.mp3quran.net/afs/${widget.surahNumber.toString().padLeft(3, '0')}.mp3',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
