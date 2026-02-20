import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramadan_planner/features/planner/presentation/providers/planner_view_model.dart';
import 'package:ramadan_planner/l10n/app_localizations.dart';

class DashboardProgress extends ConsumerWidget {
  const DashboardProgress({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(plannerViewModelProvider);
    final entry = state.currentEntry;
    final l10n = AppLocalizations.of(context)!;

    // Calculate Day Progress (0.0 to 1.0)
    final double dayProgress = (entry?.progressPercent ?? 0) / 100.0;

    // Calculate Ashra Progress
    final double ashraProgress = state.ashraProgress / 100.0;

    // Calculate Overall Progress
    final double overallProgress = state.overallProgress / 100.0;

    String ashraLabel = l10n.ashra;
    if (state.selectedDay <= 10) {
      ashraLabel = l10n.ashra1;
    } else if (state.selectedDay <= 20) {
      ashraLabel = l10n.ashra2;
    } else {
      ashraLabel = l10n.ashra3;
    }

    final cardColor =
        Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ProgressCircle(
            progress: dayProgress,
            label: l10n.dayTitle(state.selectedDay.toString()),
            color: Theme.of(context).primaryColor,
          ),
          _ProgressCircle(
            progress: ashraProgress,
            label: ashraLabel,
            color: Colors.blueAccent,
          ),
          _ProgressCircle(
            progress: overallProgress,
            label: l10n.overall,
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}

class _ProgressCircle extends StatelessWidget {
  final double progress;
  final String label;
  final Color color;

  const _ProgressCircle({
    required this.progress,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: Stack(
            children: [
              // Track
              Center(
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 8,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white10),
                  ),
                ),
              ),
              // Progress
              Center(
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    strokeCap: StrokeCap.round,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ),
              // Percentage Text
              Center(
                child: Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
      ],
    );
  }
}
