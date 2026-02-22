import 'package:flutter/material.dart';
import 'package:ramadan_planner/l10n/app_localizations.dart';

class IbadahChecklist extends StatefulWidget {
  final Map<String, List<String>> prayers;
  final bool fastKept;
  final bool taraweeh;
  final int subhanAllahCount;
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
  final Function(bool) onSurahMulkChanged;
  final Function(String) onAddCustomItem;
  final Function(String) onRemoveCustomItem;

  const IbadahChecklist({
    super.key,
    required this.prayers,
    required this.fastKept,
    required this.taraweeh,
    required this.subhanAllahCount,
    required this.currency,
    required this.tilawat,
    required this.dars,
    required this.adhkar,
    required this.surahMulk,
    required this.customItems,
    required this.onPrayerToggle,
    required this.onFastingToggle,
    required this.onTaraweehChanged,
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
                true,
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
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => widget.onPrayerToggle(lowerKey, 'fard'),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                  vertical: 4.0,
                ),
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
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onChanged(!isChecked),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                  vertical: 4.0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isChecked ? Icons.check_circle : Icons.circle_outlined,
                      color: isChecked
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
}
