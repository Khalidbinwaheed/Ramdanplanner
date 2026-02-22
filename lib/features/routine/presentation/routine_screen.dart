import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramadan_planner/features/routine/providers/routine_provider.dart';
import 'package:ramadan_planner/features/meals/presentation/meal_planner_screen.dart';

class RoutineScreen extends ConsumerWidget {
  const RoutineScreen({super.key});

  static const _blocks = [
    {
      'key': 'morning',
      'label': 'Morning (After Fajr)',
      'color': Color(0xFFFF8F00),
    },
    {'key': 'afternoon', 'label': 'Afternoon', 'color': Color(0xFFF57F17)},
    {'key': 'evening', 'label': ' Evening', 'color': Color(0xFFE64A19)},
    {'key': 'night', 'label': ' Night', 'color': Color(0xFF1A237E)},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(routineProvider);
    final notifier = ref.read(routineProvider.notifier);
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Ramadan Routine'),
          backgroundColor: const Color(0xFF1B5E20),
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.checklist), text: 'Daily Routine'),
              Tab(icon: Icon(Icons.restaurant), text: 'Meals & Water'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Daily Routine
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Streak + Progress header
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: const Color(0xFF1B5E20),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ramadan Streak',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              '${state.streakCount} days',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${state.completedCount}/${state.tasks.length} tasks done',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: state.progressPercent,
                                  backgroundColor: Colors.white24,
                                  valueColor: const AlwaysStoppedAnimation(
                                    Color(0xFFFFD54F),
                                  ),
                                  minHeight: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${(state.progressPercent * 100).round()}% complete',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (state.allCompleted)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFD54F), Color(0xFFFFB300)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('', style: TextStyle(fontSize: 24)),
                          SizedBox(width: 8),
                          Text(
                            'All tasks complete! MashaAllah!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 8),

                // Time blocks
                ..._blocks.map((block) {
                  final blockKey = block['key'] as String;
                  final blockLabel = block['label'] as String;
                  final blockColor = block['color'] as Color;
                  final blockTasks = state.tasks
                      .where((t) => t.timeBlock == blockKey)
                      .toList();
                  final doneCount = blockTasks.where((t) => t.completed).length;

                  return _TimeBlockCard(
                    label: blockLabel,
                    color: blockColor,
                    blockKey: blockKey,
                    tasks: blockTasks,
                    doneCount: doneCount,
                    onToggle: (id) => notifier.toggleTask(id),
                    onAddTask: (title, block) =>
                        notifier.addCustomTask(title, block),
                    onDeleteTask: (id) => notifier.removeCustomTask(id),
                    theme: theme,
                  );
                }),

                const SizedBox(height: 40),
              ],
            ),

            // Tab 2: Meals & Water
            const MealPlannerScreen(),
          ],
        ),
      ),
    );
  }
}

class _TimeBlockCard extends StatefulWidget {
  final String label;
  final Color color;
  final String blockKey;
  final List<RoutineTask> tasks;
  final int doneCount;
  final void Function(String id) onToggle;
  final void Function(String title, String block) onAddTask;
  final void Function(String id) onDeleteTask;
  final ThemeData theme;

  const _TimeBlockCard({
    required this.label,
    required this.color,
    required this.blockKey,
    required this.tasks,
    required this.doneCount,
    required this.onToggle,
    required this.onAddTask,
    required this.onDeleteTask,
    required this.theme,
  });

  @override
  State<_TimeBlockCard> createState() => _TimeBlockCardState();
}

class _TimeBlockCardState extends State<_TimeBlockCard> {
  bool _expanded = true;
  final TextEditingController _addController = TextEditingController();

  @override
  void dispose() {
    _addController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: widget.color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 30,
                    decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.label,
                      style: widget.theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${widget.doneCount}/${widget.tasks.length}',
                      style: TextStyle(
                        color: widget.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: widget.theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            ...widget.tasks.map(
              (task) => CheckboxListTile(
                value: task.completed,
                onChanged: (_) => widget.onToggle(task.id),
                title: Text(
                  '${task.emoji} ${task.title}',
                  style: TextStyle(
                    decoration: task.completed
                        ? TextDecoration.lineThrough
                        : null,
                    color: task.completed
                        ? widget.theme.colorScheme.onSurfaceVariant
                        : null,
                  ),
                ),
                secondary: task.id.startsWith('c_')
                    ? IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20),
                        onPressed: () => widget.onDeleteTask(task.id),
                        color: Colors.redAccent.withValues(alpha: 0.7),
                      )
                    : null,
                activeColor: widget.color,
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _addController,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Add custom task',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onSubmitted: (v) {
                        if (v.isNotEmpty) {
                          widget.onAddTask(v, widget.blockKey);
                          _addController.clear();
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle, color: widget.color),
                    onPressed: () {
                      if (_addController.text.isNotEmpty) {
                        widget.onAddTask(_addController.text, widget.blockKey);
                        _addController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
