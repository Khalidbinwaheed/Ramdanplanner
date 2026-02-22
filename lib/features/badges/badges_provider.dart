import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ramadan_planner/features/goals/providers/goals_provider.dart';
import 'package:ramadan_planner/features/routine/providers/routine_provider.dart';

class BadgeDefinition {
  final String id;
  final String title;
  final String emoji;
  final String description;
  final String howToEarn;

  const BadgeDefinition({
    required this.id,
    required this.title,
    required this.emoji,
    required this.description,
    required this.howToEarn,
  });
}

const List<BadgeDefinition> allBadges = [
  BadgeDefinition(
    id: 'prayer_hero',
    title: 'Prayer Hero',
    emoji: '🕌',
    description: 'Prayed 5 times a day for 7 consecutive days',
    howToEarn: 'Complete all 5 prayers for 7 days in a row',
  ),
  BadgeDefinition(
    id: 'quran_star',
    title: 'Quran Star',
    emoji: '⭐',
    description: 'Read at least 30 Juz during Ramadan',
    howToEarn: 'Complete your Quran daily goal for 30 days',
  ),
  BadgeDefinition(
    id: 'charity_champion',
    title: 'Charity Champion',
    emoji: '🤝',
    description: 'Gave sadaqah or charity',
    howToEarn: 'Progress the "Give charity" goal',
  ),
  BadgeDefinition(
    id: 'fasting_strong',
    title: 'Fasting Strong',
    emoji: '💪',
    description: 'Fasted for 30 days of Ramadan',
    howToEarn: 'Complete the "Fast all 30 days" goal',
  ),
  BadgeDefinition(
    id: 'streak_master',
    title: 'Streak Master',
    emoji: '🔥',
    description: 'Completed daily routine for 7+ consecutive days',
    howToEarn: 'Maintain a 7-day routine streak',
  ),
  BadgeDefinition(
    id: 'dua_collector',
    title: 'Dua Collector',
    emoji: '🤲',
    description: 'Learned 10 special duas',
    howToEarn: 'Complete the "Learn 10 duas" goal',
  ),
  BadgeDefinition(
    id: 'taraweeh_champion',
    title: 'Taraweeh Champion',
    emoji: '🌙',
    description: 'Prayed Taraweeh for all 30 nights',
    howToEarn: 'Complete the "Pray Taraweeh" goal',
  ),
  BadgeDefinition(
    id: 'early_bird',
    title: 'Early Bird',
    emoji: '🌅',
    description: 'Completed morning routine for 7 days straight',
    howToEarn: 'Check off all morning tasks for 7 days',
  ),
];

class BadgesState {
  final Set<String> unlockedBadges;
  const BadgesState({required this.unlockedBadges});
}

class BadgesNotifier extends StateNotifier<BadgesState> {
  BadgesNotifier() : super(const BadgesState(unlockedBadges: {})) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('unlocked_badges') ?? [];
    state = BadgesState(unlockedBadges: Set.from(list));
  }

  Future<void> evaluateBadges({
    required GoalsState goals,
    required RoutineState routine,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final unlocked = Set<String>.from(state.unlockedBadges);

    // Prayer Hero: 7-day streak of completing daily routine
    if (routine.streakCount >= 7) unlocked.add('streak_master');
    if (routine.streakCount >= 3) unlocked.add('early_bird');

    // Goal-based badges
    final goalMap = {for (final g in goals.goals) g.id: g};
    if ((goalMap['g2']?.current ?? 0) >= 7 * 5) unlocked.add('prayer_hero');
    if ((goalMap['g1']?.current ?? 0) >= 30) unlocked.add('quran_star');
    if ((goalMap['g3']?.current ?? 0) >= 1) unlocked.add('charity_champion');
    if ((goalMap['g5']?.isCompleted ?? false)) unlocked.add('fasting_strong');
    if ((goalMap['g4']?.isCompleted ?? false)) unlocked.add('dua_collector');
    if ((goalMap['g6']?.isCompleted ?? false)) {
      unlocked.add('taraweeh_champion');
    }

    await prefs.setStringList('unlocked_badges', unlocked.toList());
    state = BadgesState(unlockedBadges: unlocked);
  }
}

final badgesProvider = StateNotifierProvider<BadgesNotifier, BadgesState>((
  ref,
) {
  return BadgesNotifier();
});
