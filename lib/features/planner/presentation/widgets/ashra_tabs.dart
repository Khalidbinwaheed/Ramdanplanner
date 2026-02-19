import 'package:flutter/material.dart';
import 'package:ramadan_planner/l10n/app_localizations.dart';

class AshraTabs extends StatelessWidget {
  final int selectedAshra;
  final Function(int) onAshraSelected;

  const AshraTabs({
    super.key,
    required this.selectedAshra,
    required this.onAshraSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          _buildTab(context, 1, l10n.ashra1Title, l10n.ashra1Subtitle),
          const SizedBox(width: 8),
          _buildTab(context, 2, l10n.ashra2Title, l10n.ashra2Subtitle),
          const SizedBox(width: 8),
          _buildTab(context, 3, l10n.ashra3Title, l10n.ashra3Subtitle),
        ],
      ),
    );
  }

  Widget _buildTab(
    BuildContext context,
    int index,
    String title,
    String subtitle,
  ) {
    final isSelected = index == selectedAshra;
    return Expanded(
      child: GestureDetector(
        onTap: () => onAshraSelected(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
            ],
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade300,
            ),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white70 : Colors.grey,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
