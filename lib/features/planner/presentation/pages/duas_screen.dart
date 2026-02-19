import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramadan_planner/features/planner/presentation/providers/planner_view_model.dart';
import 'package:ramadan_planner/features/planner/presentation/widgets/daily_dua_section.dart';
import 'package:ramadan_planner/features/planner/presentation/widgets/personal_dua_list.dart';

class DuasScreen extends ConsumerWidget {
  const DuasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plannerState = ref.watch(plannerViewModelProvider);
    final viewModel = ref.read(plannerViewModelProvider.notifier);

    if (plannerState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (plannerState.currentEntry == null) {
      return const Center(child: Text('No data for today'));
    }

    final entry = plannerState.currentEntry!;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Duas & Azkar',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const DailyDuaSection(),
        const SizedBox(height: 24),
        PersonalDuaList(
          duas: entry.personalDuas,
          onAddDua: (text) => viewModel.addPersonalDua(text),
          onDeleteDua: (idx) => viewModel.deletePersonalDua(idx),
          onToggleAnswered: (idx, val) => viewModel.toggleDuaAnswered(idx, val),
        ),
      ],
    );
  }
}
