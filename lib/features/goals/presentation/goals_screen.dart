import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramadan_planner/features/goals/providers/goals_provider.dart';
import 'package:ramadan_planner/features/badges/badges_screen.dart';
import 'package:ramadan_planner/l10n/app_localizations.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(goalsProvider);
    final notifier = ref.read(goalsProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.ramadanGoals),
        backgroundColor: const Color(0xFF4A148C),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const BadgesScreen())),
            icon: const Icon(Icons.emoji_events, color: Colors.white),
            label: Text(
              l10n.badges,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            onPressed: () => _showAddGoalDialog(context, notifier, l10n),
            icon: const Icon(Icons.add_circle, color: Colors.white),
            tooltip: l10n.addCustomItem,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Summary header
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: const Color(0xFF4A148C),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatChip(
                    label: l10n.ramadanGoals,
                    value: '${state.goals.length}',
                    icon: Icons.flag,
                  ),
                  _StatChip(
                    label: l10n.goalsCompleted,
                    value: '${state.goals.where((g) => g.isCompleted).length}',
                    icon: Icons.check_circle,
                  ),
                  _StatChip(
                    label: l10n.goalsInProgress,
                    value:
                        '${state.goals.where((g) => !g.isCompleted && g.current > 0).length}',
                    icon: Icons.trending_up,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Goal cards
          ...state.goals.map(
            (goal) => _GoalCard(
              goal: goal,
              onIncrement: () => notifier.increment(goal.id),
              onDecrement: () => notifier.decrement(goal.id),
              onDelete: goal.isDefault
                  ? null
                  : () => notifier.removeGoal(goal.id),
              l10n: l10n,
            ),
          ),

          const SizedBox(height: 16),

          // Add custom goal button
          OutlinedButton.icon(
            onPressed: () => _showAddGoalDialog(context, notifier, l10n),
            icon: const Icon(Icons.add),
            label: Text(l10n.addCustomGoal),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              foregroundColor: const Color(0xFF4A148C),
              side: const BorderSide(color: Color(0xFF4A148C)),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _showAddGoalDialog(
    BuildContext context,
    GoalsNotifier notifier,
    AppLocalizations l10n,
  ) {
    final titleCtrl = TextEditingController();
    int target = 10;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(l10n.addCustomGoal),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: InputDecoration(
                  labelText: l10n.goalTitle,
                  hintText: l10n.goalHint,
                ),
              ),
              const SizedBox(height: 12),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('${l10n.target}: '),
                  Expanded(
                    child: Slider(
                      value: target.toDouble(),
                      min: 1,
                      max: 100,
                      divisions: 99,
                      label: '$target',
                      activeColor: const Color(0xFF4A148C),
                      onChanged: (v) => setState(() => target = v.round()),
                    ),
                  ),
                  Text('$target'),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleCtrl.text.isNotEmpty) {
                  notifier.addCustomGoal(titleCtrl.text, target);
                  Navigator.pop(ctx);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A148C),
                foregroundColor: Colors.white,
              ),
              child: Text(l10n.addCustomItem),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final RamadanGoal goal;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback? onDelete;
  final AppLocalizations l10n;

  const _GoalCard({
    required this.goal,
    required this.onIncrement,
    required this.onDecrement,
    this.onDelete,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: goal.isCompleted
            ? const BorderSide(color: Color(0xFF2E7D32), width: 1.5)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.flag, color: Color(0xFF4A148C), size: 26),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _getLocalizedTitle(goal, l10n),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
                if (goal.isCompleted)
                  const Icon(Icons.check_circle, color: Color(0xFF2E7D32)),
                if (onDelete != null)
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline, size: 18),
                    color: Colors.red,
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: goal.progress,
                      minHeight: 10,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        goal.isCompleted
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFF4A148C),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${goal.current}/${goal.target}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton.outlined(
                  onPressed: goal.current > 0 ? onDecrement : null,
                  icon: const Icon(Icons.remove, size: 18),
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: goal.isCompleted ? null : onIncrement,
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(l10n.goalProgress),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A148C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    textStyle: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
            if (goal.isCompleted)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  l10n.goalCompletedMsg,
                  style: const TextStyle(
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getLocalizedTitle(RamadanGoal goal, AppLocalizations l10n) {
    if (!goal.isDefault) return goal.title;
    switch (goal.id) {
      case 'g1':
        return l10n.goalQuran;
      case 'g2':
        return l10n.goalPrayers;
      case 'g3':
        return l10n.goalSadaqah;
      case 'g4':
        return l10n.goalDua;
      case 'g5':
        return l10n.goalFast;
      case 'g6':
        return l10n.goalTaraweeh;
      default:
        return goal.title;
    }
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }
}
