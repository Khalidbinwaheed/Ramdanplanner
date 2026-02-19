import 'package:flutter/material.dart';

class PersonalDuaList extends StatefulWidget {
  final List<Map<String, dynamic>> duas;
  final Function(String) onAddDua;
  final Function(int) onDeleteDua;
  final Function(int, bool) onToggleAnswered;

  const PersonalDuaList({
    super.key,
    required this.duas,
    required this.onAddDua,
    required this.onDeleteDua,
    required this.onToggleAnswered,
  });

  @override
  State<PersonalDuaList> createState() => _PersonalDuaListState();
}

class _PersonalDuaListState extends State<PersonalDuaList> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor =
        Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.volunteer_activism, color: Colors.amber, size: 20),
              SizedBox(width: 8),
              Text(
                'Personal Duas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (widget.duas.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'No duas added yet. Start by adding your heartfelt duas below.',
                  style: TextStyle(color: Colors.grey[500]),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            ...widget.duas.asMap().entries.map((entry) {
              final index = entry.key;
              final dua = entry.value;
              final isAnswered = dua['answered'] == true;

              return Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: IconButton(
                      icon: Icon(
                        isAnswered ? Icons.check_circle : Icons.circle_outlined,
                        color: isAnswered ? Colors.green : Colors.grey,
                      ),
                      onPressed: () =>
                          widget.onToggleAnswered(index, !isAnswered),
                    ),
                    title: Text(
                      dua['text'] ?? '',
                      style: TextStyle(
                        decoration: isAnswered
                            ? TextDecoration.lineThrough
                            : null,
                        color: isAnswered ? Colors.grey : null,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.grey,
                      ),
                      onPressed: () => widget.onDeleteDua(index),
                    ),
                  ),
                  if (index < widget.duas.length - 1)
                    const Divider(height: 1, indent: 48),
                ],
              );
            }),

          const SizedBox(height: 16),

          // Add Dua Input
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Add Dua',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: isDark ? Colors.black26 : Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 0,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber),
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.amber),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      widget.onAddDua(_controller.text);
                      _controller.clear();
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
