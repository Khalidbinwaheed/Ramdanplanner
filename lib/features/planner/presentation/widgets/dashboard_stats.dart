import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramadan_planner/features/planner/presentation/providers/planner_view_model.dart';
import 'package:ramadan_planner/features/settings/settings_view_model.dart';
import 'package:ramadan_planner/l10n/app_localizations.dart';

class DashboardStats extends ConsumerWidget {
  const DashboardStats({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(plannerViewModelProvider);
    final viewModel = ref.read(plannerViewModelProvider.notifier);
    final settings = ref.watch(settingsViewModelProvider);
    final entry = state.currentEntry;
    final l10n = AppLocalizations.of(context)!;

    if (entry == null) return const SizedBox.shrink();

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        _StatCard(
          label: l10n.streak.toUpperCase(),
          value: '${state.streak}',
          icon: Icons.local_fire_department,
          color: Colors.orange,
        ),
        _StatCard(
          label: l10n.daysFull.toUpperCase(),
          value: '${state.daysFull}',
          icon: Icons.check_circle_outline,
          color: Colors.green,
        ),
        _StatCard(
          label: l10n.sadaqah.toUpperCase(),
          value:
              '${settings.currency} ${entry.sadaqahAmount.toStringAsFixed(0)}',
          icon: Icons.favorite_border,
          color: Theme.of(context).primaryColor,
          onTap: () {
            _showUpdateDialog(
              context,
              l10n.sadaqah,
              entry.sadaqahAmount.toInt(),
              (val) => viewModel.setSadaqah(val.toDouble()),
            );
          },
        ),
        _StatCard(
          label: l10n.istighfar.toUpperCase(),
          value: '${entry.istighfarCount}',
          icon: Icons.cached,
          color: Colors.blue,
          onTap: () {
            _showUpdateDialog(
              context,
              l10n.istighfar,
              entry.istighfarCount,
              viewModel.updateIstighfarCount,
            );
          },
        ),
        _StatCard(
          label: l10n.durood.toUpperCase(),
          value: '${entry.duroodCount}',
          icon: Icons.star_border,
          color: Colors.purple,
          onTap: () {
            _showUpdateDialog(
              context,
              l10n.durood,
              entry.duroodCount,
              viewModel.updateDuroodCount,
            );
          },
        ),
        _StatCard(
          label: l10n.subhanAllah.toUpperCase(),
          value: '${entry.subhanAllahCount}',
          icon: Icons.brightness_high,
          color: Colors.teal,
          onTap: () {
            _showUpdateDialog(
              context,
              l10n.subhanAllah,
              entry.subhanAllahCount,
              viewModel.updateSubhanAllahCount,
            );
          },
        ),
      ],
    );
  }

  void _showUpdateDialog(
    BuildContext context,
    String title,
    int currentValue,
    Function(int) onSave,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: currentValue.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${l10n.update} $title'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: l10n.valueLabel,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final val = int.tryParse(controller.text);
              if (val != null) {
                onSave(val);
              }
              Navigator.pop(context);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor =
        Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
