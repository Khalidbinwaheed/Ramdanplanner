import 'package:flutter/material.dart';
import 'package:ramadan_planner/features/planner/presentation/widgets/dua_list_dialog.dart';
import 'package:ramadan_planner/l10n/app_localizations.dart';

class IbadahChecklist extends StatefulWidget {
  final Map<String, List<String>> prayers;
  final bool fastKept;
  final bool taraweeh;
  final bool istighfar1000x;
  final bool
  durood100x; // Kept for backward compatibility if needed, but we use counts now
  final int istighfarCount;
  final int duroodCount;
  final int subhanAllahCount;
  final double sadaqahAmount;
  final Map<String, dynamic> tilawat;
  final Map<String, dynamic> dars;
  final Map<String, dynamic> adhkar;
  final bool surahMulk;
  final List<String> customItems;
  final String currency;
  final Function(bool) onTilawatToggle;
  final Function(bool) onDarsToggle;
  final Function(bool) onAdhkarToggle;
  final Function(String, String) onPrayerToggle;
  final Function(bool) onFastingToggle;
  final Function(bool) onTaraweehChanged;
  final Function(bool) onIstighfarToggle; // Kept if needed
  final Function(bool) onDuroodToggle; // Kept if needed
  final Function(int) onIstighfarCountChanged;
  final Function(int) onDuroodCountChanged;
  final Function(int) onSubhanAllahCountChanged;
  final Function(double) onSadaqahChanged;
  final Function(bool) onSurahMulkChanged;
  final Function(String) onAddCustomItem;
  final Function(String) onRemoveCustomItem;

  const IbadahChecklist({
    super.key,
    required this.prayers,
    required this.fastKept,
    required this.taraweeh,
    required this.istighfar1000x,
    required this.durood100x,
    required this.istighfarCount,
    required this.duroodCount,
    required this.subhanAllahCount,
    required this.sadaqahAmount,
    required this.currency,
    required this.tilawat,
    required this.dars,
    required this.adhkar,
    required this.surahMulk,
    required this.customItems,
    required this.onPrayerToggle,
    required this.onFastingToggle,
    required this.onTaraweehChanged,
    required this.onIstighfarToggle,
    required this.onDuroodToggle,
    required this.onIstighfarCountChanged,
    required this.onDuroodCountChanged,
    required this.onSubhanAllahCountChanged,
    required this.onSadaqahChanged,
    required this.onTilawatToggle,
    required this.onDarsToggle,
    required this.onAdhkarToggle,
    required this.onSurahMulkChanged,
    required this.onAddCustomItem,
    required this.onRemoveCustomItem,
  });

  @override
  State<IbadahChecklist> createState() => _IbadahChecklistState();
}

class _IbadahChecklistState extends State<IbadahChecklist> {
  final TextEditingController _customItemController = TextEditingController();

  @override
  void dispose() {
    _customItemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine if it's dark mode for styling
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor =
        Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor;
    final l10n = AppLocalizations.of(context)!;

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
          Text(
            l10n.ibadahChecklist,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.prayers,
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
          const SizedBox(height: 8),

          // Prayers List
          _buildPrayerRow(
            'Fajr',
            l10n.fajr,
            l10n.fard,
            l10n.sunnah,
            l10n.jamah,
          ),
          _buildPrayerRow(
            'Dhuhr',
            l10n.dhuhr,
            l10n.fard,
            l10n.sunnah,
            l10n.jamah,
          ),
          _buildPrayerRow('Asr', l10n.asr, l10n.fard, l10n.sunnah, l10n.jamah),
          _buildPrayerRow(
            'Maghrib',
            l10n.maghrib,
            l10n.fard,
            l10n.sunnah,
            l10n.jamah,
          ),
          _buildPrayerRow(
            'Isha',
            l10n.isha,
            l10n.fard,
            l10n.sunnah,
            l10n.jamah,
          ),

          const SizedBox(height: 16),

          // Other Ibadah
          _buildSimpleCheckRow(
            l10n.didYouFast,
            widget.fastKept,
            (val) => widget.onFastingToggle(val ?? false),
          ),
          _buildSimpleCheckRow(
            l10n.taraweeh,
            widget.taraweeh,
            (val) => widget.onTaraweehChanged(val ?? false),
          ),
          _buildSimpleCheckRow(
            l10n.quranTilawat,
            (widget.tilawat['paras'] ?? 0) > 0 ||
                (widget.tilawat['toPage'] ?? 0) > 0,
            (val) => widget.onTilawatToggle(val ?? false),
          ),
          _buildSimpleCheckRow(
            l10n.islamicStudy,
            widget.dars['attended'] == true,
            (val) => widget.onDarsToggle(val ?? false),
          ),
          _buildSimpleCheckRow(
            l10n.morningEveningAdhkar,
            (widget.adhkar['morning'] == true) ||
                (widget.adhkar['evening'] == true),
            (val) => widget.onAdhkarToggle(val ?? false),
          ),
          _buildSimpleCheckRow(
            l10n.surahMulk,
            widget.surahMulk,
            (val) => widget.onSurahMulkChanged(val ?? false),
          ),

          const SizedBox(height: 24),

          // Counters
          _buildCounterRow(
            l10n.istighfar,
            widget.istighfarCount,
            1000, // Daily target could be dynamic
            widget.onIstighfarCountChanged,
            onInfoTap: () => _showDuaList(context, l10n.istighfar, [
              "أَسْتَغْفِرُ اللَّهَ",
              "أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ وَأَتُوبُ إِلَيْهِ",
              "اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ...",
            ]),
          ),
          const SizedBox(height: 8),
          _buildCounterRow(
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
          const SizedBox(height: 8),
          _buildCounterRow(
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
          const SizedBox(height: 8),
          _buildSadaqahRow(l10n.sadaqah, widget.currency),

          const SizedBox(height: 24),

          // Custom Item Input
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _customItemController,
                  decoration: InputDecoration(
                    hintText: l10n.addCustomItem,
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: isDark ? Colors.black26 : Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 0,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Theme.of(context).primaryColor),
                ),
                child: IconButton(
                  icon: Icon(Icons.add, color: Theme.of(context).primaryColor),
                  onPressed: () {
                    if (_customItemController.text.isNotEmpty) {
                      widget.onAddCustomItem(_customItemController.text);
                      _customItemController.clear();
                    }
                  },
                ),
              ),
            ],
          ),

          // List Custom Items
          if (widget.customItems.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...widget.customItems.map(
              (item) => _buildSimpleCheckRow(
                item,
                true, // Always checked initially? Or just a list item with delete?
                // Design shows "Add Custom Item" input.
                // Usually custom items in checklists are things you want to do.
                // Let's show as checked/unchecked?
                // The model `customItems` is a List<String>. It doesn't store state per day?
                // Actually day_entry_model.dart says:
                // List<String> customItems;
                // It seems these are just strings.
                // If they are in the list, does it mean they are DONE?
                // Or is the list the DEFINITION of custom items for that day?
                // Given "Add Custom Item" at the bottom, it implies adding to the DONE list or TODO list.
                // Let's assume adding it adds to the list of things DONE/TRACKED.
                // For now, I'll display them with a delete button.
                (val) {},
                isCustom: true,
                onDelete: () => widget.onRemoveCustomItem(item),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPrayerRow(
    String prayerKey,
    String localizedName,
    String fardLabel,
    String sunnahLabel,
    String jamahLabel,
  ) {
    final lowerKey = prayerKey.toLowerCase();
    final prayerData = widget.prayers[lowerKey] ?? [];
    final isFardDone = prayerData.contains('fard');
    final isSunnahDone = prayerData.contains('sunnah');
    final isJamahDone = prayerData.contains('jamah');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          // Fard Checkbox (Custom styled)
          InkWell(
            onTap: () => widget.onPrayerToggle(lowerKey, 'fard'),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isFardDone ? Icons.check_circle : Icons.circle_outlined,
                  color: isFardDone
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  localizedName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Sunnah Chip
          _buildToggleChip(
            sunnahLabel,
            isSunnahDone,
            () => widget.onPrayerToggle(lowerKey, 'sunnah'),
          ),
          const SizedBox(width: 8),
          // Jamah Chip
          _buildToggleChip(
            jamahLabel,
            isJamahDone,
            () => widget.onPrayerToggle(lowerKey, 'jamah'),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleChip(String label, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? Theme.of(context).primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? Theme.of(context).primaryColor
                : Colors.grey.shade700,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isActive ? Colors.black : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleCheckRow(
    String title,
    bool isChecked,
    Function(bool?) onChanged, {
    bool isCustom = false,
    VoidCallback? onDelete,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          InkWell(
            onTap: () => onChanged(!isChecked),
            child: Icon(
              isChecked ? Icons.check_circle : Icons.circle_outlined,
              color: isChecked ? Theme.of(context).primaryColor : Colors.grey,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          if (isCustom && onDelete != null) ...[
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.close, size: 18, color: Colors.grey),
              onPressed: onDelete,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCounterRow(
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
        InkWell(
          onTap: onInfoTap,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Text(
          ' / $target',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        const Spacer(),
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

  Widget _buildSadaqahRow(String label, String currency) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        _buildCircleButton(Icons.remove, () {
          if (widget.sadaqahAmount >= 10) {
            widget.onSadaqahChanged(widget.sadaqahAmount - 10);
          }
        }),
        SizedBox(
          width: 80,
          child: Text(
            '$currency ${widget.sadaqahAmount.toInt()}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
              fontSize: 16,
            ),
          ),
        ),
        _buildCircleButton(
          Icons.add,
          () => widget.onSadaqahChanged(widget.sadaqahAmount + 10),
        ),
      ],
    );
  }

  Widget _buildCircleButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white10,
        ),
        child: Icon(icon, size: 16, color: Colors.grey),
      ),
    );
  }
}
