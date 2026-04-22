import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  static const _key = 'app_state';
  static const _onboardingKey = 'onboarding_done';

bool onboardingDone = false;

Future<void> checkOnboarding() async {
  final prefs = await SharedPreferences.getInstance();
  onboardingDone = prefs.getBool(_onboardingKey) ?? false;
}

Future<void> completeOnboarding() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_onboardingKey, true);
  onboardingDone = true;
  notifyListeners();
}

  // --- Персонаж ---
  String name = 'Новий герой';
  String characterClass = 'Воїн';
  String race = 'Людина';
  int level = 1;

  Map<String, int> stats = {
    'Сила': 10,
    'Спритність': 10,
    'Статура': 10,
    'Інтелект': 10,
    'Мудрість': 10,
    'Харизма': 10,
  };

  int maxHp = 10;
  int currentHp = 10;
  int tempHp = 0;
  int deathSuccesses = 0;
  int deathFailures = 0;
  Set<String> proficientSkills = {};
  Set<String> expertiseSkills = {};

  // --- Бойові ---
  int armorClass = 10;
  int initiative = 0;
  int speed = 30;
  List<Map<String, dynamic>> weapons = [];
  List<Map<String, dynamic>> combatConditions = [];

  // --- Інвентар ---
  List<Map<String, dynamic>> inventory = [];
  int copper = 0;
  int silver = 0;
  int gold = 0;
  int platinum = 0;

  // --- Заклинання ---
  String spellcastingAbility = 'Інтелект';
  List<Map<String, dynamic>> preparedSpells = [];
  List<Map<String, dynamic>> knownSpells = [];
  Map<int, int> spellSlots = {
    1: 0,
    2: 0,
    3: 0,
    4: 0,
    5: 0,
    6: 0,
    7: 0,
    8: 0,
    9: 0,
  };
  Map<int, int> usedSpellSlots = {
    1: 0,
    2: 0,
    3: 0,
    4: 0,
    5: 0,
    6: 0,
    7: 0,
    8: 0,
    9: 0,
  };

  // --- Завантаження ---
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);
    if (json == null) return;

    final data = jsonDecode(json);

    name = data['name'] ?? 'Новий герой';
    characterClass = data['characterClass'] ?? 'Воїн';
    race = data['race'] ?? 'Людина';
    level = data['level'] ?? 1;
    stats = Map<String, int>.from(data['stats'] ?? {});
    maxHp = data['maxHp'] ?? 10;
    currentHp = data['currentHp'] ?? 10;
    tempHp = data['tempHp'] ?? 0;
    deathSuccesses = data['deathSuccesses'] ?? 0;
    deathFailures = data['deathFailures'] ?? 0;
    proficientSkills = Set<String>.from(data['proficientSkills'] ?? []);
    expertiseSkills = Set<String>.from(data['expertiseSkills'] ?? []);
    armorClass = data['armorClass'] ?? 10;
    initiative = data['initiative'] ?? 0;
    speed = data['speed'] ?? 30;
    weapons = List<Map<String, dynamic>>.from(
      (data['weapons'] ?? []).map((i) => Map<String, dynamic>.from(i)),
    );
    combatConditions = List<Map<String, dynamic>>.from(
      (data['combatConditions'] ?? []).map((i) => Map<String, dynamic>.from(i)),
    );
    inventory = List<Map<String, dynamic>>.from(
      (data['inventory'] ?? []).map((i) => Map<String, dynamic>.from(i)),
    );
    copper = data['copper'] ?? 0;
    silver = data['silver'] ?? 0;
    gold = data['gold'] ?? 0;
    platinum = data['platinum'] ?? 0;
    spellcastingAbility = data['spellcastingAbility'] ?? 'Інтелект';
    preparedSpells = List<Map<String, dynamic>>.from(
      (data['preparedSpells'] ?? []).map((i) => Map<String, dynamic>.from(i)),
    );
    knownSpells = List<Map<String, dynamic>>.from(
      (data['knownSpells'] ?? []).map((i) => Map<String, dynamic>.from(i)),
    );
    spellSlots =
        (data['spellSlots'] as Map?)?.map(
          (k, v) => MapEntry(int.parse(k.toString()), v as int),
        ) ??
        {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0};
    usedSpellSlots =
        (data['usedSpellSlots'] as Map?)?.map(
          (k, v) => MapEntry(int.parse(k.toString()), v as int),
        ) ??
        {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0};

    notifyListeners();
  }

  // --- Збереження ---
  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode({
        'name': name,
        'characterClass': characterClass,
        'race': race,
        'level': level,
        'stats': stats,
        'maxHp': maxHp,
        'currentHp': currentHp,
        'tempHp': tempHp,
        'deathSuccesses': deathSuccesses,
        'deathFailures': deathFailures,
        'proficientSkills': proficientSkills.toList(),
        'expertiseSkills': expertiseSkills.toList(),
        'inventory': inventory,
        'armorClass': armorClass,
        'initiative': initiative,
        'speed': speed,
        'weapons': weapons,
        'combatConditions': combatConditions,
        'copper': copper,
        'silver': silver,
        'gold': gold,
        'platinum': platinum,
        'spellcastingAbility': spellcastingAbility,
        'preparedSpells': preparedSpells,
        'knownSpells': knownSpells,
        'spellSlots': spellSlots.map((k, v) => MapEntry(k.toString(), v)),
        'usedSpellSlots': usedSpellSlots.map(
          (k, v) => MapEntry(k.toString(), v),
        ),
      }),
    );
  }

  // --- Хелпери ---
  void update(VoidCallback fn) {
    fn();
    notifyListeners();
    save();
  }
}
