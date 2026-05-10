import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  static const _key = 'app_state';
  static const _onboardingKey = 'onboarding_done';
  static const Map<String, int> _defaultStats = {
    'Сила': 10,
    'Спритність': 10,
    'Статура': 10,
    'Інтелект': 10,
    'Мудрість': 10,
    'Харизма': 10,
  };
  static const Map<int, int> _defaultSpellSlots = {
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

  Future<void> _saveQueue = Future.value();

  bool onboardingDone = false;
  String languageCode = 'uk';
  bool isLightTheme = false;

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
  String gender = 'male';
  String characterClass = 'Воїн';
  String race = 'Людина';
  int level = 1;

  Map<String, int> stats = Map<String, int>.from(_defaultStats);

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
  int electrum = 0;
  int gold = 0;
  int platinum = 0;

  // --- Заклинання ---
  String spellcastingAbility = 'Інтелект';
  List<Map<String, dynamic>> preparedSpells = [];
  List<Map<String, dynamic>> knownSpells = [];
  Map<int, int> spellSlots = Map<int, int>.from(_defaultSpellSlots);
  Map<int, int> usedSpellSlots = Map<int, int>.from(_defaultSpellSlots);

  // --- Екіпіровка (Арморі) ---
  Map<String, String?> equipment = {
    'head': null,
    'neck': null,
    'chest': null,
    'belt': null,
    'legs': null,
    'boots': null,
    'cloak': null,
    'mainHand': null,
    'offHand': null,
    'ranged': null,
    'gloves': null,
    'ring1': null,
    'ring2': null,
    'extraSlot': null,
    'backup': null,
    'quiver': null,
    'focus': null,
    'tools': null,
    'book': null,
    'artifact1': null,
    'artifact2': null,
    'artifact3': null,
    'artifact4': null,
    'potion1': null,
    'potion2': null,
    'scroll': null,
  };

  static const int categoryPotion = 0;
  static const int categoryArmor = 1;
  static const int categoryWeapon = 2;
  static const int categoryUseful = 3;
  static const int categoryAccessory = 5;

  void fillTestInventory() {
    inventory = [
      for (var i = 1; i <= 10; i++)
        {
          'name': 'Кільце $i',
          'quantity': 1,
          'weight': 0.1,
          'description': 'Тестове кільце $i',
          'isEquipped': i <= 2,
          'category': categoryAccessory,
          'subcategory': 'ring',
        },
      {
        'name': 'Амулет Сили',
        'quantity': 1,
        'weight': 0.2,
        'description': 'Містичний амулет на шию',
        'isEquipped': true,
        'category': categoryAccessory,
        'subcategory': 'amulet',
      },
      {
        'name': 'Сабля одноручна',
        'quantity': 1,
        'weight': 3.0,
        'description': 'Одноручна зброя для швидких атак',
        'isEquipped': true,
        'category': categoryWeapon,
        'subcategory': 'oneHanded',
      },
      {
        'name': 'Дворучний меч',
        'quantity': 1,
        'weight': 6.5,
        'description': 'Потужна дворучна зброя',
        'isEquipped': false,
        'category': categoryWeapon,
        'subcategory': 'twoHanded',
      },
      {
        'name': 'Щит клинковий',
        'quantity': 1,
        'weight': 5.0,
        'description': 'Надійний щит для оборони',
        'isEquipped': true,
        'category': categoryWeapon,
        'subcategory': 'offHand',
      },
      {
        'name': 'Лук дальній',
        'quantity': 1,
        'weight': 2.5,
        'description': 'Дальнє озброєння для бою на відстані',
        'isEquipped': true,
        'category': categoryWeapon,
        'subcategory': 'ranged',
      },
      {
        'name': 'Кинджал запасний',
        'quantity': 1,
        'weight': 1.0,
        'description': 'Запасна коротка зброя',
        'isEquipped': false,
        'category': categoryWeapon,
        'subcategory': 'backup',
      },
      {
        'name': 'Шолом тест',
        'quantity': 1,
        'weight': 1.5,
        'description': 'Тестовий шолом',
        'isEquipped': true,
        'category': categoryArmor,
        'subcategory': 'head',
      },
      {
        'name': 'Броня титану',
        'quantity': 1,
        'weight': 8.0,
        'description': 'Тестова броня',
        'isEquipped': true,
        'category': categoryArmor,
        'subcategory': 'chest',
      },
      {
        'name': 'Поясний мішок',
        'quantity': 1,
        'weight': 0.7,
        'description': 'Пояс для зберігання речей',
        'isEquipped': true,
        'category': categoryArmor,
        'subcategory': 'belt',
      },
      {
        'name': 'Поножі шкіряні',
        'quantity': 1,
        'weight': 1.2,
        'description': 'Зручні поножі',
        'isEquipped': true,
        'category': categoryArmor,
        'subcategory': 'legs',
      },
      {
        'name': 'Чоботи праці',
        'quantity': 1,
        'weight': 1.0,
        'description': 'Міцні чоботи',
        'isEquipped': true,
        'category': categoryArmor,
        'subcategory': 'boots',
      },
      {
        'name': 'Плащ невидимості',
        'quantity': 1,
        'weight': 0.8,
        'description': 'Магічний плащ',
        'isEquipped': true,
        'category': categoryArmor,
        'subcategory': 'cloak',
      },
      {
        'name': 'Рукавиці майстра',
        'quantity': 1,
        'weight': 0.4,
        'description': 'Зручні рукавиці',
        'isEquipped': true,
        'category': categoryArmor,
        'subcategory': 'gloves',
      },
      {
        'name': 'Місткий мішок',
        'quantity': 1,
        'weight': 1.3,
        'description': 'Додатковий слот для речей',
        'isEquipped': true,
        'category': categoryUseful,
        'subcategory': 'extraSlot',
      },
      {
        'name': 'Набір інструментів',
        'quantity': 1,
        'weight': 2.0,
        'description': 'Корисні інструменти',
        'isEquipped': true,
        'category': categoryUseful,
        'subcategory': 'tools',
      },
      {
        'name': 'Книга заклять',
        'quantity': 1,
        'weight': 2.2,
        'description': 'Книга з магічними формулами',
        'isEquipped': true,
        'category': categoryUseful,
        'subcategory': 'book',
      },
      {
        'name': 'Кристал фокус',
        'quantity': 1,
        'weight': 0.5,
        'description': 'Магічний фокус',
        'isEquipped': true,
        'category': categoryUseful,
        'subcategory': 'focus',
      },
      {
        'name': 'Сагайдак зі стрілами',
        'quantity': 1,
        'weight': 1.8,
        'description': 'Стріли для дальньої зброї',
        'isEquipped': true,
        'category': categoryUseful,
        'subcategory': 'quiver',
      },
      {
        'name': 'Артефакт 1',
        'quantity': 1,
        'weight': 0.6,
        'description': 'Містичний артефакт',
        'isEquipped': true,
        'category': categoryUseful,
        'subcategory': 'artifact',
      },
      {
        'name': 'Артефакт 2',
        'quantity': 1,
        'weight': 0.6,
        'description': 'Містичний артефакт',
        'isEquipped': true,
        'category': categoryUseful,
        'subcategory': 'artifact',
      },
      {
        'name': 'Артефакт 3',
        'quantity': 1,
        'weight': 0.6,
        'description': 'Містичний артефакт',
        'isEquipped': true,
        'category': categoryUseful,
        'subcategory': 'artifact',
      },
      {
        'name': 'Артефакт 4',
        'quantity': 1,
        'weight': 0.6,
        'description': 'Містичний артефакт',
        'isEquipped': true,
        'category': categoryUseful,
        'subcategory': 'artifact',
      },
      {
        'name': 'Зілля лікування',
        'quantity': 1,
        'weight': 0.5,
        'description': 'Потрібне для відновлення здоров’я',
        'isEquipped': true,
        'category': categoryPotion,
        'subcategory': '',
      },
      {
        'name': 'Зілля сили',
        'quantity': 1,
        'weight': 0.5,
        'description': 'Додає тимчасову силу',
        'isEquipped': true,
        'category': categoryPotion,
        'subcategory': '',
      },
      {
        'name': 'Сувій вогняної кулі',
        'quantity': 1,
        'weight': 0.2,
        'description': 'Одноразовий магічний сувій',
        'isEquipped': true,
        'category': categoryUseful,
        'subcategory': 'scroll',
      },
    ];

    equipment = {
      'head': 'Шолом тест',
      'neck': 'Амулет Сили',
      'chest': 'Броня титану',
      'belt': 'Поясний мішок',
      'legs': 'Поножі шкіряні',
      'boots': 'Чоботи праці',
      'cloak': 'Плащ невидимості',
      'mainHand': 'Сабля одноручна',
      'offHand': 'Щит клинковий',
      'ranged': 'Лук дальній',
      'gloves': 'Рукавиці майстра',
      'ring1': 'Кільце 1',
      'ring2': 'Кільце 2',
      'extraSlot': 'Місткий мішок',
      'backup': 'Кинджал запасний',
      'quiver': 'Сагайдак зі стрілами',
      'focus': 'Кристал фокус',
      'tools': 'Набір інструментів',
      'book': 'Книга заклять',
      'artifact1': 'Артефакт 1',
      'artifact2': 'Артефакт 2',
      'artifact3': 'Артефакт 3',
      'artifact4': 'Артефакт 4',
      'potion1': 'Зілля лікування',
      'potion2': 'Зілля сили',
      'scroll': 'Сувій вогняної кулі',
    };
  }

  // --- Завантаження ---
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);
    if (json == null) return;

    Map<String, dynamic> data;
    try {
      final decoded = jsonDecode(json);
      if (decoded is! Map) {
        debugPrint('AppState.load: invalid persisted payload type.');
        return;
      }
      data = Map<String, dynamic>.from(decoded);
    } catch (e) {
      debugPrint('AppState.load: failed to decode persisted state: $e');
      return;
    }

    name = _readString(data['name'], fallback: 'Новий герой');
    gender = _readString(data['gender'], fallback: 'male');
    characterClass = _readString(data['characterClass'], fallback: 'Воїн');
    languageCode = _readString(data['languageCode'], fallback: 'uk');
    race = _readString(data['race'], fallback: 'Людина');
    isLightTheme = _readBool(data['isLightTheme']);
    level = _readInt(data['level'], fallback: 1);
    stats = _readStats(data['stats']);
    maxHp = _readInt(data['maxHp'], fallback: 10);
    currentHp = _readInt(data['currentHp'], fallback: 10);
    tempHp = _readInt(data['tempHp'], fallback: 0);
    deathSuccesses = _readInt(data['deathSuccesses'], fallback: 0);
    deathFailures = _readInt(data['deathFailures'], fallback: 0);
    proficientSkills = _readStringSet(data['proficientSkills']);
    expertiseSkills = _readStringSet(data['expertiseSkills']);
    armorClass = _readInt(data['armorClass'], fallback: 10);
    initiative = _readInt(data['initiative'], fallback: 0);
    speed = _readInt(data['speed'], fallback: 30);
    weapons = _readMapList(data['weapons']);
    combatConditions = _readMapList(data['combatConditions']);
    inventory = _readMapList(data['inventory']);
    copper = _readInt(data['copper'], fallback: 0);
    silver = _readInt(data['silver'], fallback: 0);
    electrum = _readInt(data['electrum'], fallback: 0);
    gold = _readInt(data['gold'], fallback: 0);
    platinum = _readInt(data['platinum'], fallback: 0);
    spellcastingAbility = _readString(
      data['spellcastingAbility'],
      fallback: 'Інтелект',
    );
    preparedSpells = _readMapList(data['preparedSpells']);
    knownSpells = _readMapList(data['knownSpells']);
    spellSlots = _readSpellSlots(data['spellSlots']);
    usedSpellSlots = _readSpellSlots(data['usedSpellSlots']);
    equipment = _readEquipment(data['equipment']);

    notifyListeners();
  }

  // --- Збереження ---
  Future<void> save() async {
    final snapshot = _toJsonPayload();
    _saveQueue =
        _saveQueue
            .catchError((_) {})
            .then((_) => _persistSnapshot(snapshot));
    await _saveQueue;
  }

  // --- Хелпери ---
  void update(VoidCallback fn) {
    fn();
    notifyListeners();
    unawaited(save());
  }

  void setLanguage(String code) {
    update(() => languageCode = code);
  }

  void setThemeMode(bool light) {
    update(() => isLightTheme = light);
  }

  Future<void> _persistSnapshot(Map<String, dynamic> snapshot) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(snapshot));
  }

  Map<String, dynamic> _toJsonPayload() {
    return {
      'name': name,
      'gender': gender,
      'languageCode': languageCode,
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
      'electrum': electrum,
      'gold': gold,
      'platinum': platinum,
      'spellcastingAbility': spellcastingAbility,
      'preparedSpells': preparedSpells,
      'knownSpells': knownSpells,
      'spellSlots': spellSlots.map((k, v) => MapEntry(k.toString(), v)),
      'usedSpellSlots': usedSpellSlots.map((k, v) => MapEntry(k.toString(), v)),
      'equipment': equipment,
      'isLightTheme': isLightTheme,
    };
  }

  String _readString(dynamic value, {required String fallback}) {
    final text = value?.toString().trim();
    if (text == null || text.isEmpty) return fallback;
    return text;
  }

  bool _readBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    return false;
  }

  int _readInt(dynamic value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  Set<String> _readStringSet(dynamic value) {
    if (value is! Iterable) return <String>{};
    return value.map((item) => item.toString()).toSet();
  }

  List<Map<String, dynamic>> _readMapList(dynamic value) {
    if (value is! Iterable) return <Map<String, dynamic>>[];
    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Map<String, int> _readStats(dynamic value) {
    final merged = Map<String, int>.from(_defaultStats);
    if (value is! Map) return merged;
    for (final entry in value.entries) {
      final key = entry.key.toString();
      final fallback = merged[key];
      if (fallback == null) continue;
      merged[key] = _readInt(entry.value, fallback: fallback);
    }
    return merged;
  }

  Map<int, int> _readSpellSlots(dynamic value) {
    final slots = Map<int, int>.from(_defaultSpellSlots);
    if (value is! Map) return slots;
    for (final entry in value.entries) {
      final key = int.tryParse(entry.key.toString());
      if (key == null || key < 1 || key > 9) continue;
      slots[key] = _readInt(entry.value, fallback: 0).clamp(0, 99);
    }
    return slots;
  }

  Map<String, String?> _readEquipment(dynamic value) {
    final parsed = <String, String?>{};
    if (value is! Map) return parsed;
    for (final entry in value.entries) {
      parsed[entry.key.toString()] = entry.value?.toString();
    }
    return parsed;
  }
}
