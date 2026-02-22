import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramadan_planner/features/planner/presentation/providers/planner_view_model.dart';
import 'package:ramadan_planner/features/settings/settings_view_model.dart';
import 'package:ramadan_planner/features/planner/presentation/widgets/header.dart';
import 'package:ramadan_planner/features/planner/presentation/widgets/day_chips.dart';
import 'package:ramadan_planner/features/planner/presentation/widgets/ashra_tabs.dart';
import 'package:ramadan_planner/features/planner/presentation/widgets/ibadah_checklist.dart';
import 'package:ramadan_planner/features/planner/presentation/widgets/dhikr_card.dart';
import 'package:ramadan_planner/features/planner/presentation/widgets/sadaqah_card.dart';
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
        const SizedBox(height: 16),
        DhikrCard(
          istighfarCount: entry.istighfarCount,
          duroodCount: entry.duroodCount,
          subhanAllahCount: entry.subhanAllahCount,
          personalDuas: entry.personalDuas,
          onIstighfarCountChanged: viewModel.updateIstighfarCount,
          onDuroodCountChanged: viewModel.updateDuroodCount,
          onSubhanAllahCountChanged: viewModel.updateSubhanAllahCount,
          onAddPersonalDua: viewModel.addPersonalDua,
          onDeletePersonalDua: viewModel.deletePersonalDua,
          onToggleDuaAnswered: viewModel.toggleDuaAnswered,
        ),
        SadaqahCard(
          amount: entry.sadaqahAmount,
          currency: settings.currency,
          onChanged: viewModel.setSadaqah,
        ),
        const SizedBox(height: 16),
        IbadahChecklist(
          prayers: entry.prayers,
          fastKept: entry.fastKept,
          taraweeh: entry.taraweeh,
          subhanAllahCount: entry.subhanAllahCount,
          currency: settings.currency,
          tilawat: entry.tilawat,
          dars: entry.dars,
          adhkar: entry.adhkar,
          surahMulk: entry.surahMulk,
          customItems: entry.customItems,
          onPrayerToggle: viewModel.togglePrayer,
          onFastingToggle: viewModel.toggleFast,
          onTaraweehChanged: viewModel.toggleTaraweeh,
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
        const SizedBox(height: 32),
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
            child: Text(
              l10n.reset,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
