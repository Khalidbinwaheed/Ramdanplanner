import 'package:flutter/material.dart';
import 'package:ramadan_planner/l10n/app_localizations.dart';

class DuaListDialog extends StatelessWidget {
  final String title;
  final List<String> duas;

  const DuaListDialog({super.key, required this.title, required this.duas});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: duas.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                duas[index],
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Amiri', // Assuming Arabic font usage or generic
                ),
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            AppLocalizations.of(context)!.cancel,
          ), // Using 'Cancel' or 'Close'
        ),
      ],
    );
  }
}
