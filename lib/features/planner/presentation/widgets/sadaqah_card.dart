import 'package:flutter/material.dart';
import 'package:ramadan_planner/l10n/app_localizations.dart';

class SadaqahCard extends StatelessWidget {
  final double amount;
  final String currency;
  final Function(double) onChanged;

  const SadaqahCard({
    super.key,
    required this.amount,
    required this.currency,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cardColor =
        Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.sadaqah,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.volunteer_activism_outlined,
                color: Colors.grey,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Daily Sadaqah Contribution',
                  style: TextStyle(color: Colors.grey[400], fontSize: 13),
                ),
              ),
              _buildCircleButton(Icons.remove, () {
                if (amount >= 10) {
                  onChanged(amount - 10);
                }
              }),
              SizedBox(
                width: 80,
                child: Text(
                  '$currency ${amount.toInt()}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                  ),
                ),
              ),
              _buildCircleButton(Icons.add, () => onChanged(amount + 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white10,
        ),
        child: Icon(icon, size: 16, color: Colors.grey),
      ),
    );
  }
}
