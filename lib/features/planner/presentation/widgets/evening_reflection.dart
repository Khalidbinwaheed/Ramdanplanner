import 'package:flutter/material.dart';
import 'package:ramadan_planner/l10n/app_localizations.dart';

class EveningReflection extends StatelessWidget {
  final Map<String, String> reflections;
  final Function(String, String) onReflectionChanged;

  const EveningReflection({
    super.key,
    required this.reflections,
    required this.onReflectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            l10n.eveningReflection,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildReflectionField(l10n.reflectionBest, 'best'),
              const SizedBox(height: 12),
              _buildReflectionField(l10n.reflectionShortfall, 'shortfall'),
              const SizedBox(height: 12),
              _buildReflectionField(l10n.reflectionSpecial, 'special'),
              const SizedBox(height: 12),
              _buildReflectionField(l10n.reflectionGratitude, 'gratitude'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReflectionField(String label, String key) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        alignLabelWithHint: true,
      ),
      maxLines: 2,
      onChanged: (val) => onReflectionChanged(key, val),
      controller: TextEditingController(text: reflections[key]),
    );
  }
}
