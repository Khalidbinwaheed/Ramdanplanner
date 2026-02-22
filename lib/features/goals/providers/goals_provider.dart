import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RamadanGoal {
  final String id;
  final String title;
  final String emoji;
  final int target;
  int current;
  final bool isDefault;

  RamadanGoal({
    required this.id,
    required this.title,
    required this.emoji,
    required this.target,
    this.current = 0,
    this.isDefault = true,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'emoji': emoji,
    'target': target,
    'current': current,
    'isDefault': isDefault,
  };

  factory RamadanGoal.fromJson(Map<String, dynamic> json) => RamadanGoal(
    id: json['id'],
    title: json['title'],
    emoji: json['emoji'],
    target: json['target'],
    current: json['current'] ?? 0,
    isDefault: json['isDefault'] ?? false,
  );

  double get progress => target <= 0 ? 0 : (current / target).clamp(0.0, 1.0);
  bool get isCompleted => current >= target;
}

class GoalsState {
  final List<RamadanGoal> goals;

  const GoalsState({required this.goals});

  GoalsState copyWith({List<RamadanGoal>? goals}) {
    return GoalsState(goals: goals ?? this.goals);
  }
}

List<RamadanGoal> _defaultGoals() => [
  RamadanGoal(id: 'g1', title: 'Finish the Holy Quran', emoji: '', target: 30),
  RamadanGoal(id: 'g2', title: 'Pray 5 times daily', emoji: '', target: 150),
  RamadanGoal(id: 'g3', title: 'Give charity (sadaqah)', emoji: '', target: 30),
  RamadanGoal(id: 'g4', title: 'Learn 10 special duas', emoji: '', target: 10),
  RamadanGoal(id: 'g5', title: 'Fast all 30 days', emoji: '', target: 30),
  RamadanGoal(id: 'g6', title: 'Pray Taraweeh', emoji: '', target: 30),
];

class GoalsNotifier extends StateNotifier<GoalsState> {
  GoalsNotifier() : super(GoalsState(goals: _defaultGoals())) {
    _load();
  }

  static const _prefKey = 'ramadan_goals';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefKey);
    if (raw == null) {
      state = GoalsState(goals: _defaultGoals());
      return;
    }
    try {
      final List list = json.decode(raw);
      final goals = list.map((e) => RamadanGoal.fromJson(e)).toList();
      state = GoalsState(goals: goals);
    } catch (_) {
      state = GoalsState(goals: _defaultGoals());
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefKey,
      json.encode(state.goals.map((g) => g.toJson()).toList()),
    );
  }

  Future<void> increment(String goalId) async {
    final updated = state.goals.map((g) {
      if (g.id == goalId && g.current < g.target) {
        return RamadanGoal(
          id: g.id,
          title: g.title,
          emoji: g.emoji,
          target: g.target,
          current: g.current + 1,
          isDefault: g.isDefault,
        );
      }
      return g;
    }).toList();
    state = state.copyWith(goals: updated);
    await _save();
  }

  Future<void> decrement(String goalId) async {
    final updated = state.goals.map((g) {
      if (g.id == goalId && g.current > 0) {
        return RamadanGoal(
          id: g.id,
          title: g.title,
          emoji: g.emoji,
          target: g.target,
          current: g.current - 1,
          isDefault: g.isDefault,
        );
      }
      return g;
    }).toList();
    state = state.copyWith(goals: updated);
    await _save();
  }

  Future<void> addCustomGoal(String title, int target) async {
    final id = 'custom_${DateTime.now().millisecondsSinceEpoch}';
    final updated = [
      ...state.goals,
      RamadanGoal(
        id: id,
        title: title,
        emoji: '',
        target: target,
        isDefault: false,
      ),
    ];
    state = state.copyWith(goals: updated);
    await _save();
  }

  Future<void> removeGoal(String goalId) async {
    final updated = state.goals.where((g) => g.id != goalId).toList();
    state = state.copyWith(goals: updated);
    await _save();
  }
}

final goalsProvider = StateNotifierProvider<GoalsNotifier, GoalsState>((ref) {
  return GoalsNotifier();
});
