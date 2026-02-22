import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramadan_planner/features/azan/azan_provider.dart';
import 'package:ramadan_planner/l10n/app_localizations.dart';

class AzanSettingsCard extends ConsumerWidget {
  const AzanSettingsCard({super.key});

  static const _prayers = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'];
  static const _soundOptions = ['azan1', 'azan2'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final azan = ref.watch(azanProvider);
    final notifier = ref.read(azanProvider.notifier);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.mosque,
                  color: Color(0xFF2E7D32),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.azanAlarm,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      l10n.prayerTimeNotifications,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: azan.azanEnabled,
                onChanged: notifier.toggleAzan,
                activeThumbColor: const Color(0xFF2E7D32),
              ),
            ],
          ),

          if (azan.azanEnabled) ...[
            const Divider(height: 24),

            // Per-prayer toggles
            Text(
              l10n.prayerAlarms,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: _prayers.map((prayer) {
                final enabled = azan.prayerAlarms[prayer] ?? true;
                final label = prayer == 'fajr'
                    ? l10n.fajr
                    : prayer == 'dhuhr'
                    ? l10n.dhuhr
                    : prayer == 'asr'
                    ? l10n.asr
                    : prayer == 'maghrib'
                    ? l10n.maghrib
                    : l10n.isha;
                return FilterChip(
                  label: Text(label),
                  selected: enabled,
                  onSelected: (val) => notifier.togglePrayerAlarm(prayer, val),
                  selectedColor: const Color(
                    0xFF2E7D32,
                  ).withValues(alpha: 0.25),
                  checkmarkColor: const Color(0xFF2E7D32),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Volume slider
            Row(
              children: [
                const Icon(Icons.volume_down, size: 20),
                Expanded(
                  child: Slider(
                    value: azan.volume,
                    onChanged: notifier.setVolume,
                    activeColor: const Color(0xFF2E7D32),
                    divisions: 10,
                    label: '${(azan.volume * 100).round()}%',
                  ),
                ),
                const Icon(Icons.volume_up, size: 20),
              ],
            ),

            const SizedBox(height: 8),

            // Sound picker
            Text(
              l10n.azanSound,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 6),
            SegmentedButton<String>(
              segments: List.generate(
                _soundOptions.length,
                (i) => ButtonSegment(
                  value: _soundOptions[i],
                  label: Text(i == 0 ? l10n.azanMakkah : l10n.azanMadinah),
                  icon: const Icon(Icons.music_note, size: 16),
                ),
              ),
              selected: {azan.selectedSound},
              onSelectionChanged: (s) => notifier.setSound(s.first),
              style: ButtonStyle(
                iconColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.selected)
                      ? const Color(0xFF2E7D32)
                      : null,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
