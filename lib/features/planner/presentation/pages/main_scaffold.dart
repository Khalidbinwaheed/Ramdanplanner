import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramadan_planner/features/planner/presentation/pages/dashboard_screen.dart';
import 'package:ramadan_planner/features/quran/presentation/pages/quran_screen.dart';
import 'package:ramadan_planner/features/tasbeeh/tasbeeh_screen.dart';
import 'package:ramadan_planner/features/routine/presentation/routine_screen.dart';
import 'package:ramadan_planner/features/goals/presentation/goals_screen.dart';
import 'package:ramadan_planner/features/settings/settings_screen.dart';

final navigationIndexProvider = StateProvider<int>((ref) => 0);

class MainScaffold extends ConsumerStatefulWidget {
  const MainScaffold({super.key});

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  @override
  Widget build(BuildContext context) {
    final index = ref.watch(navigationIndexProvider);
    final isWide = MediaQuery.of(context).size.width > 600;

    final List<Widget> screens = [
      const DashboardScreen(),
      const QuranScreen(),
      const TasbeehScreen(),
      const RoutineScreen(),
      const GoalsScreen(),
      const SettingsScreen(),
    ];

    const destinations = [
      NavigationDestination(
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard),
        label: 'Daily',
      ),
      NavigationDestination(
        icon: Icon(Icons.menu_book_outlined),
        selectedIcon: Icon(Icons.menu_book),
        label: 'Quran',
      ),
      NavigationDestination(
        icon: Icon(Icons.fingerprint_outlined),
        selectedIcon: Icon(Icons.fingerprint),
        label: 'Tasbeeh',
      ),
      NavigationDestination(
        icon: Icon(Icons.checklist_outlined),
        selectedIcon: Icon(Icons.checklist),
        label: 'Routine',
      ),
      NavigationDestination(
        icon: Icon(Icons.flag_outlined),
        selectedIcon: Icon(Icons.flag),
        label: 'Goals',
      ),
      NavigationDestination(
        icon: Icon(Icons.settings_outlined),
        selectedIcon: Icon(Icons.settings),
        label: 'Settings',
      ),
    ];

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              extended: MediaQuery.of(context).size.width > 900,
              selectedIndex: index,
              onDestinationSelected: (val) =>
                  ref.read(navigationIndexProvider.notifier).state = val,
              destinations: destinations
                  .map(
                    (d) => NavigationRailDestination(
                      icon: d.icon,
                      selectedIcon: d.selectedIcon,
                      label: Text(d.label),
                    ),
                  )
                  .toList(),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: screens[index],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: IndexedStack(index: index, children: screens),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (val) =>
            ref.read(navigationIndexProvider.notifier).state = val,
        destinations: destinations,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      ),
    );
  }
}
