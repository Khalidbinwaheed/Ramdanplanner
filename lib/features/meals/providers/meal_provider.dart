import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MealState {
  final int waterGlasses; // target: 8
  final Map<String, bool> suhoorChecked;
  final Map<String, bool> iftarChecked;

  const MealState({
    this.waterGlasses = 0,
    this.suhoorChecked = const {},
    this.iftarChecked = const {},
  });

  MealState copyWith({
    int? waterGlasses,
    Map<String, bool>? suhoorChecked,
    Map<String, bool>? iftarChecked,
  }) {
    return MealState(
      waterGlasses: waterGlasses ?? this.waterGlasses,
      suhoorChecked: suhoorChecked ?? this.suhoorChecked,
      iftarChecked: iftarChecked ?? this.iftarChecked,
    );
  }
}

const List<String> defaultSuhoorItems = [
  'Dates (3–5)',
  'Water (large glass)',
  'Eggs (boiled or scrambled)',
  'Oatmeal with honey',
  'Whole wheat bread',
  'Yogurt / Lassi',
  'Fruits (banana, apple)',
  'Nuts (almonds, walnuts)',
];

const List<String> defaultIftarItems = [
  'Break fast with dates',
  'Water (2+ glasses)',
  'Fruit salad',
  'Shorba (soup)',
  'Light protein',
  'Salad / veggies',
  'Rice or bread (moderate)',
  'Avoid fried foods',
];

const List<String> healthyTips = [
  'Drink 8 glasses of water between Iftar and Suhoor',
  'Avoid salty, spicy, and fried foods – they increase thirst',
  'Eat suhoor as late as possible before Fajr',
  "Don't overeat at Iftar - eat slowly and mindfully",
  'Light exercise after Taraweeh is great for digestion',
  'Sleep 6–8 hours – rest is part of ibadah',
  'Avoid caffeinated drinks that cause dehydration',
  'Prioritize fruits, vegetables, and complex carbs',
];

class MealNotifier extends StateNotifier<MealState> {
  MealNotifier() : super(const MealState()) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _todayStr();
    final lastDate = prefs.getString('meal_last_date') ?? '';

    if (lastDate != today) {
      // Reset daily data
      await prefs.setString('meal_last_date', today);
      state = const MealState();
      return;
    }

    final water = prefs.getInt('meal_water') ?? 0;
    final suhoor = <String, bool>{};
    final iftar = <String, bool>{};

    for (final item in defaultSuhoorItems) {
      suhoor[item] = prefs.getBool('suhoor_$item') ?? false;
    }
    for (final item in defaultIftarItems) {
      iftar[item] = prefs.getBool('iftar_$item') ?? false;
    }

    state = MealState(
      waterGlasses: water,
      suhoorChecked: suhoor,
      iftarChecked: iftar,
    );
  }

  Future<void> addWaterGlass() async {
    if (state.waterGlasses >= 8) return;
    final prefs = await SharedPreferences.getInstance();
    final newVal = state.waterGlasses + 1;
    await prefs.setInt('meal_water', newVal);
    state = state.copyWith(waterGlasses: newVal);
  }

  Future<void> removeWaterGlass() async {
    if (state.waterGlasses <= 0) return;
    final prefs = await SharedPreferences.getInstance();
    final newVal = state.waterGlasses - 1;
    await prefs.setInt('meal_water', newVal);
    state = state.copyWith(waterGlasses: newVal);
  }

  Future<void> toggleSuhoor(String item) async {
    final prefs = await SharedPreferences.getInstance();
    final updated = Map<String, bool>.from(state.suhoorChecked);
    updated[item] = !(updated[item] ?? false);
    await prefs.setBool('suhoor_$item', updated[item]!);
    state = state.copyWith(suhoorChecked: updated);
  }

  Future<void> toggleIftar(String item) async {
    final prefs = await SharedPreferences.getInstance();
    final updated = Map<String, bool>.from(state.iftarChecked);
    updated[item] = !(updated[item] ?? false);
    await prefs.setBool('iftar_$item', updated[item]!);
    state = state.copyWith(iftarChecked: updated);
  }

  String _todayStr() {
    final t = DateTime.now();
    return '${t.year}-${t.month}-${t.day}';
  }
}

final mealProvider = StateNotifierProvider<MealNotifier, MealState>((ref) {
  return MealNotifier();
});
