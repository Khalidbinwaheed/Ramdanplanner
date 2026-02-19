import 'package:flutter/material.dart';

class DailyDuaSection extends StatelessWidget {
  const DailyDuaSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cardColor =
        Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.menu_book, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Daily Dua',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDuaItem(
            'اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي',
            "Allahumma innaka 'afuwwun tuhibbul 'afwa fa'fu 'anni",
            "O Allah, You are the Pardoner, You love to pardon, so pardon me.",
            Colors.amber,
          ),
          const Divider(height: 32, color: Colors.white10),
          _buildDuaItem(
            'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
            "Rabbana atina fid-dunya hasanatan wa fil-akhirati hasanatan wa qina 'adhab an-nar",
            "Our Lord, give us good in this world and good in the Hereafter, and save us from the torment of the Fire.",
            Colors.amber,
          ),
          const Divider(height: 32, color: Colors.white10),
          _buildDuaItem(
            'اللَّهُمَّ أَعِنِّي عَلَى ذِكْرِكَ وَشُكْرِكَ وَحُسْنِ عِبَادَتِكَ',
            "Allahumma a'inni 'ala dhikrika wa shukrika wa husni 'ibadatik",
            "O Allah, help me to remember You, thank You, and worship You in the best manner.",
            Colors.amber,
          ),
        ],
      ),
    );
  }

  Widget _buildDuaItem(
    String arabic,
    String transliteration,
    String translation,
    Color highlightColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          arabic,
          textAlign: TextAlign.right,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily:
                'Amiri', // Assuming a font is available, otherwise falls back
            height: 1.8,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          transliteration,
          style: TextStyle(
            fontSize: 14,
            fontStyle: FontStyle.italic,
            color: highlightColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          translation,
          style: TextStyle(fontSize: 14, color: Colors.grey[400]),
        ),
      ],
    );
  }
}
