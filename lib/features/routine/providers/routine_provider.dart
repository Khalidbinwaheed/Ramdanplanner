import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoutineTask {
  final String id;
  final String title;
  final String emoji;
  final String timeBlock; // morning, afternoon, evening, night
  bool completed;

  RoutineTask({
    required this.id,
    required this.title,
    required this.emoji,
    required this.timeBlock,
    this.completed = false,
  });
}

class RoutineState {
  final List<RoutineTask> tasks;
  final int streakCount;
  final String lastCompletedDate;

  const RoutineState({
    required this.tasks,
    this.streakCount = 0,
    this.lastCompletedDate = '',
  });

  RoutineState copyWith({
    List<RoutineTask>? tasks,
    int? streakCount,
    String? lastCompletedDate,
  }) {
    return RoutineState(
      tasks: tasks ?? this.tasks,
      streakCount: streakCount ?? this.streakCount,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
    );
  }

  int get completedCount => tasks.where((t) => t.completed).length;
  double get progressPercent =>
      tasks.isEmpty ? 0 : completedCount / tasks.length;
  bool get allCompleted => completedCount == tasks.length;
}

List<RoutineTask> _defaultTasks() => [
  // --- Morning (After Fajr) ---
  RoutineTask(
    id: 'm1',
    title: 'Recite morning Adhkar',
    emoji: '',
    timeBlock: 'morning',
  ),
  RoutineTask(
    id: 'm2',
    title: 'Read Quran (at least 1 Juz page)',
    emoji: '',
    timeBlock: 'morning',
  ),
  RoutineTask(
    id: 'm3',
    title: 'Drink Suhoor water & eat dates',
    emoji: '',
    timeBlock: 'morning',
  ),
  RoutineTask(
    id: 'm4',
    title: 'Light walk or stretching',
    emoji: '',
    timeBlock: 'morning',
  ),

  // --- Afternoon ---
  RoutineTask(
    id: 'a1',
    title: 'Help family with chores',
    emoji: '',
    timeBlock: 'afternoon',
  ),
  RoutineTask(
    id: 'a2',
    title: 'Study / Work productively',
    emoji: '',
    timeBlock: 'afternoon',
  ),
  RoutineTask(
    id: 'a3',
    title: 'Avoid social media & idle talk',
    emoji: '',
    timeBlock: 'afternoon',
  ),
  RoutineTask(
    id: 'a4',
    title: 'Make Istighfar (100x)',
    emoji: '',
    timeBlock: 'afternoon',
  ),

  // --- Evening ---
  RoutineTask(
    id: 'e1',
    title: 'Recite evening Adhkar',
    emoji: '',
    timeBlock: 'evening',
  ),
  RoutineTask(
    id: 'e2',
    title: 'Prepare Iftar (set table, make dua)',
    emoji: '',
    timeBlock: 'evening',
  ),
  RoutineTask(
    id: 'e3',
    title: 'Read a page of Islamic book',
    emoji: '',
    timeBlock: 'evening',
  ),

  // --- Night ---
  RoutineTask(
    id: 'n1',
    title: 'Eat healthy Iftar (no excess)',
    emoji: '',
    timeBlock: 'night',
  ),
  RoutineTask(
    id: 'n2',
    title: 'Recite Surah Al-Mulk',
    emoji: '',
    timeBlock: 'night',
  ),
  RoutineTask(
    id: 'n3',
    title: 'Reflect on the day (muhasabah)',
    emoji: '',
    timeBlock: 'night',
  ),
  RoutineTask(
    id: 'n4',
    title: 'Make Durood Ibrahim (100x)',
    emoji: '',
    timeBlock: 'night',
  ),
  RoutineTask(
    id: 'n5',
    title: 'Sleep early (before midnight)',
    emoji: '',
    timeBlock: 'night',
  ),
];

class RoutineNotifier extends StateNotifier<RoutineState> {
  RoutineNotifier() : super(RoutineState(tasks: _defaultTasks())) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _todayStr();
    final lastDate = prefs.getString('routine_last_date') ?? '';
    int streak = prefs.getInt('routine_streak') ?? 0;

    // Load custom task definitions
    final customTaskIds = prefs.getStringList('routine_custom_ids') ?? [];
    final tasks = _defaultTasks();

    for (final id in customTaskIds) {
      final title = prefs.getString('routine_custom_${id}_title') ?? '';
      final block = prefs.getString('routine_custom_${id}_block') ?? 'morning';
      if (title.isNotEmpty) {
        tasks.add(
          RoutineTask(id: id, title: title, emoji: '📝', timeBlock: block),
        );
      }
    }

    if (lastDate == today) {
      // Restore today's completions
      for (final task in tasks) {
        task.completed = prefs.getBool('routine_task_${task.id}') ?? false;
      }
    } else {
      // New day – check if yesterday was completed to keep streak
      final yesterday = prefs.getString('routine_yesterday') ?? '';
      if (yesterday != lastDate && lastDate.isNotEmpty && lastDate != today) {
        // streak broken
        streak = 0;
        await prefs.setInt('routine_streak', 0);
      }
      await prefs.setString('routine_last_date', today);
    }

    state = RoutineState(
      tasks: tasks,
      streakCount: streak,
      lastCompletedDate: lastDate,
    );
  }

  Future<void> addCustomTask(String title, String timeBlock) async {
    final prefs = await SharedPreferences.getInstance();
    final id = 'c_${DateTime.now().millisecondsSinceEpoch}';

    final tasks = List<RoutineTask>.from(state.tasks);
    tasks.add(
      RoutineTask(id: id, title: title, emoji: '📝', timeBlock: timeBlock),
    );

    final customIds = prefs.getStringList('routine_custom_ids') ?? [];
    customIds.add(id);
    await prefs.setStringList('routine_custom_ids', customIds);
    await prefs.setString('routine_custom_${id}_title', title);
    await prefs.setString('routine_custom_${id}_block', timeBlock);

    state = state.copyWith(tasks: tasks);
  }

  Future<void> removeCustomTask(String taskId) async {
    final prefs = await SharedPreferences.getInstance();
    final tasks = List<RoutineTask>.from(state.tasks);
    tasks.removeWhere((t) => t.id == taskId);

    final customIds = prefs.getStringList('routine_custom_ids') ?? [];
    customIds.remove(taskId);
    await prefs.setStringList('routine_custom_ids', customIds);
    await prefs.remove('routine_custom_${taskId}_title');
    await prefs.remove('routine_custom_${taskId}_block');
    await prefs.remove('routine_task_$taskId');

    state = state.copyWith(tasks: tasks);
  }

  Future<void> toggleTask(String taskId) async {
    final prefs = await SharedPreferences.getInstance();
    final tasks = List<RoutineTask>.from(state.tasks);
    final idx = tasks.indexWhere((t) => t.id == taskId);
    if (idx == -1) return;
    tasks[idx].completed = !tasks[idx].completed;
    await prefs.setBool('routine_task_$taskId', tasks[idx].completed);

    int streak = state.streakCount;
    // If all tasks just got completed, increment streak
    final allDone = tasks.every((t) => t.completed);
    if (allDone && state.lastCompletedDate != _todayStr()) {
      streak += 1;
      await prefs.setInt('routine_streak', streak);
      await prefs.setString('routine_yesterday', state.lastCompletedDate);
    }

    state = state.copyWith(tasks: tasks, streakCount: streak);
  }

  String _todayStr() {
    final t = DateTime.now();
    return '${t.year}-${t.month}-${t.day}';
  }
}

final routineProvider = StateNotifierProvider<RoutineNotifier, RoutineState>((
  ref,
) {
  return RoutineNotifier();
});
