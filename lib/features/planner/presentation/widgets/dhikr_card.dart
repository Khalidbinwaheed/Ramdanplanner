import 'package:flutter/material.dart';
import 'package:ramadan_planner/features/planner/presentation/widgets/dua_list_dialog.dart';
import 'package:ramadan_planner/l10n/app_localizations.dart';

class DhikrCard extends StatefulWidget {
  final int istighfarCount;
  final int duroodCount;
  final int subhanAllahCount;
  final List<Map<String, dynamic>> personalDuas;
  final Function(int) onIstighfarCountChanged;
  final Function(int) onDuroodCountChanged;
  final Function(int) onSubhanAllahCountChanged;
  final Function(String) onAddPersonalDua;
  final Function(int) onDeletePersonalDua;
  final Function(int, bool) onToggleDuaAnswered;

  const DhikrCard({
    super.key,
    required this.istighfarCount,
    required this.duroodCount,
    required this.subhanAllahCount,
    required this.personalDuas,
    required this.onIstighfarCountChanged,
    required this.onDuroodCountChanged,
    required this.onSubhanAllahCountChanged,
    required this.onAddPersonalDua,
    required this.onDeletePersonalDua,
    required this.onToggleDuaAnswered,
  });

  @override
  State<DhikrCard> createState() => _DhikrCardState();
}

class _DhikrCardState extends State<DhikrCard> {
  final TextEditingController _duaController = TextEditingController();

  @override
  void dispose() {
    _duaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor =
        Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.adhkar,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildCounterRow(
            context,
            l10n.istighfar,
            widget.istighfarCount,
            1000,
            widget.onIstighfarCountChanged,
            onInfoTap: () => _showDuaList(context, l10n.istighfar, [
              "أَسْتَغْفِرُ اللَّهَ",
              "أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ وَأَتُوبُ إِلَيْهِ",
              "اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ...",
            ]),
          ),
          const SizedBox(height: 12),
          _buildCounterRow(
            context,
            l10n.durood,
            widget.duroodCount,
            100,
            widget.onDuroodCountChanged,
            onInfoTap: () => _showDuaList(context, l10n.durood, [
              "صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ",
              "اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ...",
              "جَزَى اللَّهُ عَنَّا مُحَمَّدًا مَا هُوَ أَهْلُهُ",
            ]),
          ),
          const SizedBox(height: 12),
          _buildCounterRow(
            context,
            l10n.subhanAllah,
            widget.subhanAllahCount,
            100,
            widget.onSubhanAllahCountChanged,
            onInfoTap: () => _showDuaList(context, l10n.subhanAllah, [
              "سُبْحَانَ اللَّهِ",
              "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ",
              "سُبْحَانَ اللَّهِ الْعَظِيمِ",
            ]),
          ),
          const Divider(height: 32, color: Colors.white10),

          // Personal Duas Header
          Text(
            l10n.notifDua, // Reusing appropriate label
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Input field for new personal dua
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _duaController,
                  decoration: InputDecoration(
                    hintText: 'Add personal dua...',
                    hintStyle: TextStyle(color: Colors.grey[600], fontSize: 13),
                    filled: true,
                    fillColor: isDark ? Colors.black26 : Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  onSubmitted: (val) {
                    if (val.isNotEmpty) {
                      widget.onAddPersonalDua(val);
                      _duaController.clear();
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              _buildCircleButton(Icons.add, () {
                if (_duaController.text.isNotEmpty) {
                  widget.onAddPersonalDua(_duaController.text);
                  _duaController.clear();
                }
              }),
            ],
          ),

          // Personal Duas List
          if (widget.personalDuas.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...widget.personalDuas.asMap().entries.map((entry) {
              final index = entry.key;
              final dua = entry.value;
              final isAnswered = dua['answered'] ?? false;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Checkbox(
                      value: isAnswered,
                      onChanged: (val) =>
                          widget.onToggleDuaAnswered(index, val ?? false),
                      activeColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    Expanded(
                      child: Text(
                        dua['text'] ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: isAnswered ? Colors.grey : Colors.white,
                          decoration: isAnswered
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.grey,
                      ),
                      onPressed: () => widget.onDeletePersonalDua(index),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildCounterRow(
    BuildContext context,
    String label,
    int value,
    int target,
    Function(int) onChanged, {
    VoidCallback? onInfoTap,
  }) {
    return Row(
      children: [
        if (onInfoTap != null)
          IconButton(
            icon: const Icon(Icons.info_outline, size: 20, color: Colors.grey),
            onPressed: onInfoTap,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        if (onInfoTap != null) const SizedBox(width: 8),
        Expanded(
          child: InkWell(
            onTap: onInfoTap,
            borderRadius: BorderRadius.circular(4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Goal: $target',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
        _buildCircleButton(
          Icons.remove,
          () => onChanged(value > 0 ? value - 1 : 0),
        ),
        SizedBox(
          width: 50,
          child: Text(
            '$value',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
              fontSize: 16,
            ),
          ),
        ),
        _buildCircleButton(Icons.add, () => onChanged(value + 1)),
      ],
    );
  }

  void _showDuaList(BuildContext context, String title, List<String> duas) {
    showDialog(
      context: context,
      builder: (context) => DuaListDialog(title: title, duas: duas),
    );
  }

  Widget _buildCircleButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white10,
        ),
        child: Icon(icon, size: 16, color: Colors.grey),
      ),
    );
  }
}
