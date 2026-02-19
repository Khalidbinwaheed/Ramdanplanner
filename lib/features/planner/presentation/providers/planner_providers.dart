import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramadan_planner/features/planner/data/repositories/planner_repository.dart';

export 'package:ramadan_planner/features/settings/settings_view_model.dart';

final plannerRepositoryProvider = Provider<PlannerRepository>((ref) {
  return PlannerRepository();
});
