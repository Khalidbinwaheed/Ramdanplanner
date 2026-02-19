import 'package:flutter/material.dart';

class DuaPanel extends StatelessWidget {
  final Map<String, String> dua;

  const DuaPanel({super.key, required this.dua});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 0,
      color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Daily Dua',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              dua['arabic'] ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Arabic', // TODO: Add an Arabic font asset
              ),
            ),
            const SizedBox(height: 12),
            Text(
              dua['transliteration'] ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 12),
            Text(
              dua['translation'] ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
