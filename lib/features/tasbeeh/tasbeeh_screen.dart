import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramadan_planner/features/tasbeeh/tasbeeh_provider.dart';
import 'package:ramadan_planner/l10n/app_localizations.dart';

class TasbeehScreen extends ConsumerWidget {
  const TasbeehScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.tasbeehCounter),
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: TabBar(
            indicatorColor: Colors.pinkAccent,
            tabs: [
              Tab(
                icon: const Icon(Icons.fingerprint),
                text: AppLocalizations.of(context)!.counterTab,
              ),
              Tab(
                icon: const Icon(Icons.menu_book),
                text: AppLocalizations.of(context)!.duaListTab,
              ),
            ],
          ),
        ),
        body: const TabBarView(children: [_CounterTab(), _DuaListTab()]),
      ),
    );
  }
}

class _CounterTab extends ConsumerWidget {
  const _CounterTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tasbeehProvider);
    final notifier = ref.read(tasbeehProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        const SizedBox(height: 20),
        // Streak Badge
        if (state.streak > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.orangeAccent.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.local_fire_department,
                  color: Colors.orangeAccent,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.dayStreakLabel(state.streak),
                  style: const TextStyle(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),

        const Spacer(),

        // Active Dua Display
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              Text(
                state.activeDua.arabic,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontFamily: 'serif',
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                state.activeDua.transliteration,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.pinkAccent,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 40),

        // Main Counter
        GestureDetector(
          onTap: () {
            HapticFeedback.mediumImpact();
            notifier.tap();
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Progress Ring
              SizedBox(
                width: 250,
                height: 250,
                child: CircularProgressIndicator(
                  value: state.progress,
                  strokeWidth: 8,
                  backgroundColor: Colors.white10,
                  valueColor: const AlwaysStoppedAnimation(Colors.pinkAccent),
                ),
              ),
              // Counter Button
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pinkAccent.withValues(alpha: 0.2),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${state.count}',
                        style: const TextStyle(
                          fontSize: 72,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        l10n.targetLabel(state.target),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 14,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        // Controls
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ActionButton(
                icon: Icons.refresh,
                label: l10n.reset,
                onPressed: () => _confirmReset(context, notifier, l10n),
              ),
              _ActionButton(
                icon: Icons.remove,
                label: '-1',
                onPressed: notifier.decrement,
              ),
              _ActionButton(
                icon: Icons.edit_note,
                label: l10n.setTargetTitle,
                onPressed: () =>
                    _showTargetDialog(context, notifier, state.target, l10n),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _confirmReset(
    BuildContext context,
    TasbeehNotifier notifier,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: Text(
          l10n.resetCounterTitle,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          l10n.resetCounterContent,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              notifier.reset();
              Navigator.pop(ctx);
            },
            child: Text(
              l10n.reset,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  void _showTargetDialog(
    BuildContext context,
    TasbeehNotifier notifier,
    int currentTarget,
    AppLocalizations l10n,
  ) {
    final controller = TextEditingController(text: currentTarget.toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: Text(
          l10n.setTargetTitle,
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: l10n.dailyGoalLabel,
            labelStyle: const TextStyle(color: Colors.pinkAccent),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white24),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              final val = int.tryParse(controller.text);
              if (val != null && val > 0) {
                notifier.setTarget(val);
              }
              Navigator.pop(ctx);
            },
            child: Text(
              l10n.save,
              style: const TextStyle(color: Colors.pinkAccent),
            ),
          ),
        ],
      ),
    );
  }
}

class _DuaListTab extends ConsumerWidget {
  const _DuaListTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tasbeehProvider);
    final notifier = ref.read(tasbeehProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Adhkar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: InkWell(
            onTap: () => _showAddCustomDuaDialog(context, notifier, l10n),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.pinkAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.pinkAccent.withValues(alpha: 0.3),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_circle_outline, color: Colors.pinkAccent),
                  SizedBox(width: 8),
                  Text(
                    'Add Adhkar',
                    style: TextStyle(
                      color: Colors.pinkAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.duas.length + 1,
            itemBuilder: (context, index) {
              if (index == state.duas.length) {
                return const SizedBox(height: 80); // Bottom padding
              }

              final dua = state.duas[index];
              final isSelected = state.activeDuaIndex == index;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: isSelected
                    ? Colors.pinkAccent.withValues(alpha: 0.1)
                    : const Color(0xFF1E293B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: isSelected ? Colors.pinkAccent : Colors.white10,
                    width: 1.5,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  onTap: () {
                    notifier.selectDua(index);
                    DefaultTabController.of(context).animateTo(0);
                  },
                  title: Text(
                    dua.arabic,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 22,
                      fontFamily: 'serif',
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        dua.name,
                        style: const TextStyle(
                          color: Colors.pinkAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dua.translation,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (dua.isCustom)
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.redAccent,
                            size: 20,
                          ),
                          onPressed: () => notifier.removeCustomDua(dua.id),
                        ),
                      isSelected
                          ? const Icon(
                              Icons.check_circle,
                              color: Colors.pinkAccent,
                            )
                          : const Icon(
                              Icons.radio_button_off,
                              color: Colors.white24,
                            ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showAddCustomDuaDialog(
    BuildContext context,
    TasbeehNotifier notifier,
    AppLocalizations l10n,
  ) {
    final name = TextEditingController();
    final arabic = TextEditingController();
    final trans = TextEditingController();
    final target = TextEditingController(text: '33');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Add Adhkar', style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogField(name, 'Name (e.g. My Dua)'),
              const SizedBox(height: 12),
              _buildDialogField(arabic, 'Arabic Text', align: TextAlign.right),
              const SizedBox(height: 12),
              _buildDialogField(trans, 'Translation'),
              const SizedBox(height: 12),
              _buildDialogField(
                target,
                'Daily Target',
                type: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              if (name.text.isNotEmpty && arabic.text.isNotEmpty) {
                notifier.addCustomDua(
                  name: name.text,
                  arabic: arabic.text,
                  transliteration: name.text,
                  translation: trans.text,
                  target: int.tryParse(target.text) ?? 33,
                );
                Navigator.pop(ctx);
              }
            },
            child: Text(
              l10n.save,
              style: const TextStyle(color: Colors.pinkAccent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogField(
    TextEditingController controller,
    String hint, {
    TextAlign align = TextAlign.left,
    TextInputType type = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      textAlign: align,
      keyboardType: type,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24),
        filled: true,
        fillColor: const Color(0xFF0F172A),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.filledTonal(
          onPressed: onPressed,
          icon: Icon(icon),
          style: IconButton.styleFrom(
            backgroundColor: const Color(0xFF1E293B),
            foregroundColor: Colors.pinkAccent,
            padding: const EdgeInsets.all(16),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 12),
        ),
      ],
    );
  }
}
