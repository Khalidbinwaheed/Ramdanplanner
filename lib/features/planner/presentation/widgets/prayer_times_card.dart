import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ramadan_planner/features/planner/presentation/providers/dashboard_providers.dart';
import 'package:ramadan_planner/l10n/app_localizations.dart';
import 'package:ramadan_planner/features/settings/settings_view_model.dart';

class PrayerTimesCard extends ConsumerWidget {
  const PrayerTimesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: dashboardAsync.when(
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (err, stack) => Center(
          child: Text('Error: $err', style: const TextStyle(color: Colors.red)),
        ),
        data: (state) {
          final pt = state.prayerTimes;
          final weather = state.weather;
          final is24h = ref
              .watch(settingsViewModelProvider.notifier)
              .advanced
              .is24HourFormat;

          final dateFormat = DateFormat(is24h ? 'HH:mm' : 'h:mm a');

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Colors.white70,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.prayerTimes,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Weather Row
              if (weather != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.wb_sunny_outlined,
                        color: Colors.white70,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${weather['temp']}°C',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              if (weather != null) const SizedBox(height: 16),

              // Prayer Times Grid
              if (pt != null)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final itemWidth = (width - 24) / 3;

                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTimeBox(
                              l10n.fajr,
                              dateFormat.format(pt.fajr),
                              width: itemWidth,
                            ),
                            _buildTimeBox(
                              l10n.sunrise,
                              dateFormat.format(pt.sunrise),
                              width: itemWidth,
                            ),
                            _buildTimeBox(
                              l10n.dhuhr,
                              dateFormat.format(pt.dhuhr),
                              width: itemWidth,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTimeBox(
                              l10n.asr,
                              dateFormat.format(pt.asr),
                              width: itemWidth,
                            ),
                            _buildTimeBox(
                              l10n.maghrib,
                              dateFormat.format(pt.maghrib),
                              width: itemWidth,
                            ),
                            _buildTimeBox(
                              l10n.isha,
                              dateFormat.format(pt.isha),
                              width: itemWidth,
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                )
              else
                const Text(
                  'Set location to see prayer times',
                  style: TextStyle(color: Colors.white70),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTimeBox(String label, String time, {required double width}) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
