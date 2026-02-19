import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramadan_planner/features/planner/presentation/pages/dashboard_screen.dart';
import 'package:ramadan_planner/features/planner/presentation/pages/duas_screen.dart';
import 'package:ramadan_planner/features/planner/presentation/pages/analytics_screen.dart';
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
      const DuasScreen(),
      const AnalyticsScreen(),
      const SettingsScreen(),
    ];

    final destinations = const [
      NavigationDestination(
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard),
        label: 'Daily',
      ),
      NavigationDestination(
        icon: Icon(Icons.menu_book_outlined),
        selectedIcon: Icon(Icons.menu_book),
        label: 'Duas',
      ),
      NavigationDestination(
        icon: Icon(Icons.analytics_outlined),
        selectedIcon: Icon(Icons.analytics),
        label: 'Analytics',
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
      ),
    );
  }
}
