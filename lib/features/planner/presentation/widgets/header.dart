import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ramadan_planner/core/constants/app_constants.dart';
import 'package:ramadan_planner/features/settings/settings_view_model.dart';
import 'package:ramadan_planner/features/planner/presentation/providers/dashboard_providers.dart';
import 'package:ramadan_planner/l10n/app_localizations.dart';

class RamadanHeader extends ConsumerWidget {
  const RamadanHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsViewModelProvider);
    final dashboardAsync = ref.watch(dashboardProvider);
    final l10n = AppLocalizations.of(context)!;

    final now = DateTime.now();
    final dateString = DateFormat('EEEE, d MMM y').format(now);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.nightlight_round,
                      color: Colors.white,
                      size: 32,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${l10n.greeting}, ${settings.userName ?? l10n.guestUser}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    AppConstants.ramadanBadge,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${l10n.hijri} ${AppConstants.hijriYear}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            dateString,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          dashboardAsync.when(
            data: (state) {
              return Text(
                '${state.hijriDate.hDay} ${state.hijriDate.longMonthName} ${state.hijriDate.hYear}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
            loading: () => Text(
              l10n.loading,
              style: const TextStyle(color: Colors.white70, fontSize: 18),
            ),
            error: (error, stack) => Text(
              l10n.errorDate,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
