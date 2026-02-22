import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramadan_planner/features/badges/badges_provider.dart';
import 'package:ramadan_planner/features/goals/providers/goals_provider.dart';
import 'package:ramadan_planner/features/routine/providers/routine_provider.dart';

class BadgesScreen extends ConsumerWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badgesState = ref.watch(badgesProvider);
    final goals = ref.watch(goalsProvider);
    final routine = ref.watch(routineProvider);
    final notifier = ref.read(badgesProvider.notifier);

    // Evaluate badges on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifier.evaluateBadges(goals: goals, routine: routine);
    });

    final unlockedCount = badgesState.unlockedBadges.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievement Badges'),
        backgroundColor: const Color(0xFF4A148C),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Card(
            color: const Color(0xFF4A148C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Icon(
                        Icons.emoji_events,
                        color: Color(0xFFFFD54F),
                        size: 40,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$unlockedCount / ${allBadges.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Earned',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        '"Every deed counts!"',
                        style: TextStyle(
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 160,
                          child: LinearProgressIndicator(
                            value: allBadges.isEmpty
                                ? 0
                                : unlockedCount / allBadges.length,
                            backgroundColor: Colors.white24,
                            valueColor: const AlwaysStoppedAnimation(
                              Color(0xFFFFD54F),
                            ),
                            minHeight: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Badge grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.9,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: allBadges.length,
            itemBuilder: (context, index) {
              final badge = allBadges[index];
              final isUnlocked = badgesState.unlockedBadges.contains(badge.id);

              return GestureDetector(
                onTap: () => _showBadgeDetail(context, badge, isUnlocked),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: isUnlocked
                        ? const BorderSide(color: Color(0xFFFFD54F), width: 2)
                        : BorderSide.none,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ColorFiltered(
                          colorFilter: isUnlocked
                              ? const ColorFilter.mode(
                                  Colors.transparent,
                                  BlendMode.multiply,
                                )
                              : const ColorFilter.matrix([
                                  0.3,
                                  0.3,
                                  0.3,
                                  0,
                                  0,
                                  0.3,
                                  0.3,
                                  0.3,
                                  0,
                                  0,
                                  0.3,
                                  0.3,
                                  0.3,
                                  0,
                                  0,
                                  0,
                                  0,
                                  0,
                                  1,
                                  0,
                                ]),
                          child: Text(
                            badge.emoji,
                            style: const TextStyle(fontSize: 44),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          badge.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: isUnlocked ? null : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (isUnlocked)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFFFD54F,
                              ).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 12,
                                  color: Color(0xFFF57F17),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Earned!',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFFF57F17),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.lock,
                                size: 12,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Locked',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _showBadgeDetail(
    BuildContext context,
    BadgeDefinition badge,
    bool isUnlocked,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(badge.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              badge.description,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 12),
            const Text(
              'How to earn:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(badge.howToEarn),
            const SizedBox(height: 12),
            if (isUnlocked)
              const Row(
                children: [
                  Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 16),
                  SizedBox(width: 8),
                  Text(
                    'You have earned this badge!',
                    style: TextStyle(
                      color: Color(0xFF2E7D32),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            else
              const Row(
                children: [
                  Icon(Icons.lock, color: Colors.orange, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Keep going – you can earn this!',
                    style: TextStyle(color: Colors.orange),
                  ),
                ],
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
