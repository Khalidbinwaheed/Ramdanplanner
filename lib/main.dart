import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ramadan_planner/core/theme/app_theme.dart';
import 'package:ramadan_planner/features/planner/presentation/pages/main_scaffold.dart';
import 'package:ramadan_planner/features/planner/data/models/settings_model.dart';
import 'package:ramadan_planner/features/planner/data/models/day_entry_model.dart';
import 'package:ramadan_planner/core/constants/app_constants.dart';
import 'package:ramadan_planner/features/settings/settings_view_model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ramadan_planner/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(ShellUserSettingsAdapter());
  Hive.registerAdapter(DayEntryAdapter());

  await Hive.openBox(AppConstants.settingsBox);
  await Hive.openBox(AppConstants.plannerBox);
  await Hive.openBox(AppConstants.cacheBox);

  runApp(const ProviderScope(child: RamadanPlannerApp()));
}

class RamadanPlannerApp extends ConsumerStatefulWidget {
  const RamadanPlannerApp({super.key});

  @override
  ConsumerState<RamadanPlannerApp> createState() => _RamadanPlannerAppState();
}

class _RamadanPlannerAppState extends ConsumerState<RamadanPlannerApp> {
  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsViewModelProvider);

    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      locale: Locale(settings.language),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ar'), Locale('ur')],
      home: const MainScaffold(),
      debugShowCheckedModeBanner: false,
    );
  }
}
