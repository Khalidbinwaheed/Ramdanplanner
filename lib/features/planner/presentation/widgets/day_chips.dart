import 'package:flutter/material.dart';
import 'package:ramadan_planner/l10n/app_localizations.dart';

class DayChips extends StatelessWidget {
  final int selectedDay;
  final Function(int) onDaySelected;

  const DayChips({
    super.key,
    required this.selectedDay,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 30,
        itemBuilder: (context, index) {
          final day = index + 1;
          final isSelected = day == selectedDay;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              label: Text('${AppLocalizations.of(context)!.day} $day'),
              selected: isSelected,
              onSelected: (_) => onDaySelected(day),
              selectedColor: Theme.of(context).primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade300,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
