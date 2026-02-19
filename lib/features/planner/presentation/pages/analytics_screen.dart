import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramadan_planner/features/planner/presentation/providers/planner_view_model.dart';
import 'package:ramadan_planner/features/planner/presentation/widgets/heatmap.dart';
import 'package:ramadan_planner/features/planner/presentation/widgets/dashboard_stats.dart';
import 'package:ramadan_planner/features/planner/presentation/widgets/dashboard_progress.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plannerState = ref.watch(plannerViewModelProvider);
    final viewModel = ref.read(plannerViewModelProvider.notifier);

    if (plannerState.currentEntry == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final entry = plannerState.currentEntry!;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Overview',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        const DashboardStats(),
        const SizedBox(height: 24),
        const DashboardProgress(),
        const SizedBox(height: 32),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            '30-Day Heatmap',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ProgressHeatmap(
          progresses: List.generate(30, (i) {
            final e = plannerState.allEntries.firstWhere(
              (element) => element.dayNumber == i + 1,
              orElse: () => entry,
            );
            return e.dayNumber == i + 1 ? e.progressPercent : 0.0;
          }),
          onDaySelected: (day) => viewModel.loadDay(day),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
