import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramadan_planner/features/meals/providers/meal_provider.dart';
import 'package:ramadan_planner/l10n/app_localizations.dart';

class MealPlannerScreen extends ConsumerWidget {
  const MealPlannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mealProvider);
    final notifier = ref.read(mealProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Water Intake Tracker
        _buildSectionHeader(l10n.waterIntake, const Color(0xFF0288D1)),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  '${state.waterGlasses} / 8 ${l10n.glasses}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: state.waterGlasses / 8,
                    backgroundColor: Colors.blue.shade100,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF0288D1),
                    ),
                    minHeight: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Water glass icons
                    Wrap(
                      spacing: 4,
                      children: List.generate(
                        8,
                        (i) => Icon(
                          i < state.waterGlasses
                              ? Icons.local_drink
                              : Icons.local_drink_outlined,
                          color: i < state.waterGlasses
                              ? const Color(0xFF0288D1)
                              : Colors.grey.shade300,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton.icon(
                      onPressed: state.waterGlasses > 0
                          ? notifier.removeWaterGlass
                          : null,
                      icon: const Icon(Icons.remove),
                      label: Text(l10n.remove),
                    ),
                    ElevatedButton.icon(
                      onPressed: state.waterGlasses < 8
                          ? notifier.addWaterGlass
                          : null,
                      icon: const Icon(Icons.add),
                      label: Text(l10n.addGlass),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0288D1),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                if (state.waterGlasses >= 8)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      l10n.waterGoalReached,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0288D1),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Suhoor Planner
        _buildSectionHeader(l10n.suhoor, const Color(0xFF5C6BC0)),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _buildMealItem(
                l10n.suhoorDates,
                'Dates (3–5)',
                state.suhoorChecked,
                notifier.toggleSuhoor,
                const Color(0xFF5C6BC0),
              ),
              _buildMealItem(
                l10n.suhoorWaterItem,
                'Water (large glass)',
                state.suhoorChecked,
                notifier.toggleSuhoor,
                const Color(0xFF5C6BC0),
              ),
              _buildMealItem(
                l10n.suhoorEggs,
                'Eggs (boiled or scrambled)',
                state.suhoorChecked,
                notifier.toggleSuhoor,
                const Color(0xFF5C6BC0),
              ),
              _buildMealItem(
                l10n.suhoorOatsItem,
                'Oatmeal with honey',
                state.suhoorChecked,
                notifier.toggleSuhoor,
                const Color(0xFF5C6BC0),
              ),
              _buildMealItem(
                l10n.suhoorBread,
                'Whole wheat bread',
                state.suhoorChecked,
                notifier.toggleSuhoor,
                const Color(0xFF5C6BC0),
              ),
              _buildMealItem(
                l10n.suhoorYogurtItem,
                'Yogurt / Lassi',
                state.suhoorChecked,
                notifier.toggleSuhoor,
                const Color(0xFF5C6BC0),
              ),
              _buildMealItem(
                l10n.suhoorFruits,
                'Fruits (banana, apple)',
                state.suhoorChecked,
                notifier.toggleSuhoor,
                const Color(0xFF5C6BC0),
              ),
              _buildMealItem(
                l10n.suhoorNuts,
                'Nuts (almonds, walnuts)',
                state.suhoorChecked,
                notifier.toggleSuhoor,
                const Color(0xFF5C6BC0),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Iftar Planner
        _buildSectionHeader(l10n.iftar, const Color(0xFFE64A19)),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _buildMealItem(
                l10n.iftarBreakDates,
                'Break fast with dates',
                state.iftarChecked,
                notifier.toggleIftar,
                const Color(0xFFE64A19),
              ),
              _buildMealItem(
                l10n.iftarWaterItem,
                'Water (2+ glasses)',
                state.iftarChecked,
                notifier.toggleIftar,
                const Color(0xFFE64A19),
              ),
              _buildMealItem(
                l10n.iftarFruitSalad,
                'Fruit salad',
                state.iftarChecked,
                notifier.toggleIftar,
                const Color(0xFFE64A19),
              ),
              _buildMealItem(
                l10n.iftarShorba,
                'Shorba (soup)',
                state.iftarChecked,
                notifier.toggleIftar,
                const Color(0xFFE64A19),
              ),
              _buildMealItem(
                l10n.iftarProtein,
                'Light protein',
                state.iftarChecked,
                notifier.toggleIftar,
                const Color(0xFFE64A19),
              ),
              _buildMealItem(
                l10n.iftarSalad,
                'Salad / veggies',
                state.iftarChecked,
                notifier.toggleIftar,
                const Color(0xFFE64A19),
              ),
              _buildMealItem(
                l10n.iftarRiceBread,
                'Rice or bread (moderate)',
                state.iftarChecked,
                notifier.toggleIftar,
                const Color(0xFFE64A19),
              ),
              _buildMealItem(
                l10n.iftarAvoidFried,
                'Avoid fried foods',
                state.iftarChecked,
                notifier.toggleIftar,
                const Color(0xFFE64A19),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Healthy Tips
        _buildSectionHeader(l10n.healthyTips, const Color(0xFF2E7D32)),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTip(l10n.tipWater),
                _buildTip(l10n.tipAvoidSalty),
                _buildTip(l10n.tipLateSuhoor),
                _buildTip(l10n.tipSlowIftar),
                _buildTip(l10n.tipExercise),
                _buildTip(l10n.tipSleep),
                _buildTip(l10n.tipNoCaffeine),
                _buildTip(l10n.tipHealthyFood),
              ],
            ),
          ),
        ),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildMealItem(
    String label,
    String key,
    Map<String, bool> checked,
    Function(String) onToggle,
    Color color,
  ) {
    return CheckboxListTile(
      value: checked[key] ?? false,
      onChanged: (_) => onToggle(key),
      title: Text(label),
      activeColor: color,
      controlAffinity: ListTileControlAffinity.leading,
      dense: true,
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text('• $text', style: const TextStyle(fontSize: 13, height: 1.5)),
    );
  }

  Widget _buildSectionHeader(String label, Color color) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(4, 8, 0, 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            color: color,
            margin: const EdgeInsetsDirectional.only(end: 8),
          ),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
