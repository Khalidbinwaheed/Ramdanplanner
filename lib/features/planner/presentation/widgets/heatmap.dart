import 'package:flutter/material.dart';

class ProgressHeatmap extends StatelessWidget {
  final List<double> progresses; // Length 30
  final Function(int) onDaySelected;

  const ProgressHeatmap({
    super.key,
    required this.progresses,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              '30-Day Progress Heatmap',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 30,
              itemBuilder: (context, index) {
                final progress = progresses[index];
                final color = _getColor(progress);

                return GestureDetector(
                  onTap: () => onDaySelected(index + 1),
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: progress > 50 ? Colors.white : Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getColor(double progress) {
    if (progress == 0) return Colors.grey.shade200;
    if (progress <= 25) return Colors.orange.shade200;
    if (progress <= 50) return Colors.orange.shade400;
    if (progress <= 75) return Colors.orange.shade700;
    return Colors.green;
  }
}
