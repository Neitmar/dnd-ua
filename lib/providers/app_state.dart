import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  static const _key = 'app_state';

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

  // --- Інвентар ---
  List<Map<String, dynamic>> inventory = [];
  int copper = 0;
  int silver = 0;
  int gold = 0;
  int platinum = 0;

  // --- Збереження ---
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
    inventory = List<Map<String, dynamic>>.from(
        (data['inventory'] ?? []).map((i) => Map<String, dynamic>.from(i)));
    copper = data['copper'] ?? 0;
    silver = data['silver'] ?? 0;
    gold = data['gold'] ?? 0;
    platinum = data['platinum'] ?? 0;

    notifyListeners();
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode({
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
      'copper': copper,
      'silver': silver,
      'gold': gold,
      'platinum': platinum,
    }));
  }

  // --- Хелпери ---
  void update(VoidCallback fn) {
    fn();
    notifyListeners();
    save();
  }
}