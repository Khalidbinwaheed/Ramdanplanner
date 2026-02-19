import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramadan_planner/features/planner/presentation/providers/planner_view_model.dart';
import 'package:ramadan_planner/features/settings/settings_view_model.dart';
import 'package:ramadan_planner/features/planner/presentation/widgets/header.dart';
import 'package:ramadan_planner/features/planner/presentation/widgets/day_chips.dart';
import 'package:ramadan_planner/features/planner/presentation/widgets/ashra_tabs.dart';
import 'package:ramadan_planner/features/planner/presentation/widgets/ibadah_checklist.dart';
import 'package:ramadan_planner/features/planner/presentation/widgets/evening_reflection.dart';
import 'package:ramadan_planner/features/planner/presentation/widgets/prayer_times_card.dart';
import 'package:ramadan_planner/l10n/app_localizations.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(plannerViewModelProvider);
    final settings = ref.watch(settingsViewModelProvider);
    final viewModel = ref.read(plannerViewModelProvider.notifier);

    if (state.currentEntry == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final entry = state.currentEntry!;

    return ListView(
      children: [
        const RamadanHeader(),
        const SizedBox(height: 16),
        const PrayerTimesCard(),
        const SizedBox(height: 16),
        DayChips(
          selectedDay: state.selectedDay,
          onDaySelected: (day) => viewModel.loadDay(day),
        ),
        AshraTabs(
          selectedAshra: (state.selectedDay - 1) ~/ 10 + 1,
          onAshraSelected: (ashra) => viewModel.loadDay((ashra - 1) * 10 + 1),
        ),
        const SizedBox(height: 16),
        IbadahChecklist(
          prayers: entry.prayers,
          fastKept: entry.fastKept,
          taraweeh: entry.taraweeh,
          istighfar1000x:
              false, // Deprecated/Unused in new logic but kept for param
          durood100x:
              false, // Deprecated/Unused in new logic but kept for param
          istighfarCount: entry.istighfarCount,
          duroodCount: entry.duroodCount,
          sadaqahAmount: entry.sadaqahAmount,
          currency: settings.currency,
          tilawat: entry.tilawat,
          dars: entry.dars,
          adhkar: entry.adhkar,
          surahMulk: entry.surahMulk,
          customItems: entry.customItems,
          onPrayerToggle: viewModel.togglePrayer,
          onFastingToggle: viewModel.toggleFast,
          onTaraweehChanged: viewModel.toggleTaraweeh,
          onIstighfarToggle: viewModel.toggleIstighfarGoal,
          onDuroodToggle: viewModel.toggleDuroodGoal,
          onIstighfarCountChanged: viewModel.updateIstighfarCount,
          onDuroodCountChanged: viewModel.updateDuroodCount,
          subhanAllahCount: entry.subhanAllahCount,
          onSubhanAllahCountChanged: viewModel.updateSubhanAllahCount,
          onSadaqahChanged: viewModel.setSadaqah,
          onTilawatToggle: viewModel.toggleTilawat,
          onDarsToggle: viewModel.toggleDars,
          onAdhkarToggle: viewModel.toggleAdhkar,
          onSurahMulkChanged: viewModel.toggleSurahMulk,
          onAddCustomItem: viewModel.addCustomItem,
          onRemoveCustomItem: viewModel.removeCustomItem,
        ),
        EveningReflection(
          reflections: entry.reflections,
          onReflectionChanged: (key, val) =>
              viewModel.updateReflection(key, val),
        ),
        const SizedBox(height: 32),
        // SadaqahCounter removed as it is now in DashboardStats
        const _TasbihCounter(),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => viewModel.updateCurrentEntry(entry),
                  icon: const Icon(Icons.save),
                  label: Text(AppLocalizations.of(context)!.saveProgress),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton.filledTonal(
                onPressed: () =>
                    _confirmReset(context, viewModel, state.selectedDay),
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  void _confirmReset(
    BuildContext context,
    PlannerViewModel viewModel,
    int day,
  ) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.resetDay),
        content: Text(l10n.resetDayContent(day.toString())),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              viewModel.resetDay(day);
              Navigator.pop(context);
            },
            child: Text(l10n.reset, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _TasbihCounter extends ConsumerWidget {
  const _TasbihCounter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsViewModelProvider);
    final viewModel = ref.read(settingsViewModelProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.fingerprint),
                const SizedBox(width: 8),
                Text(
                  settings.tasbihName ?? l10n.tasbihName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 16),
                  tooltip: l10n.edit,
                  onPressed: () async {
                    final controller = TextEditingController(
                      text: settings.tasbihName,
                    );
                    final name = await showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(l10n.tasbihName),
                        content: TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            labelText: l10n.name,
                            hintText: l10n.tasbihNameHint,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(l10n.cancel),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context, controller.text),
                            child: Text(l10n.save),
                          ),
                        ],
                      ),
                    );
                    if (name != null && name.isNotEmpty) {
                      viewModel.updateTasbihName(name);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: viewModel.incrementTasbih,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 4,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${settings.tasbihCount}',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: viewModel.resetTasbih,
              child: Text(l10n.reset),
            ),
          ],
        ),
      ),
    );
  }
}
