import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/localization_service.dart';
import '../services/cdn_service.dart';

class AppState extends ChangeNotifier {
  static const _key = 'app_state';
  static const _onboardingKey = 'onboarding_done';
  static const _languageKey = 'language';

  bool onboardingDone = false;
  String language = 'uk'; // uk, ru, en

  Future<void> checkOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    onboardingDone = prefs.getBool(_onboardingKey) ?? false;
    language = prefs.getString(_languageKey) ?? 'uk';
    
    // Загрузить кэш локализации
    await LocalizationService.loadCachedTranslations();
    
    // Проверить необходимость обновления переводов (в фоне, не блокируя UI)
    _checkTranslationUpdates();
  }

  void _checkTranslationUpdates() {
    // Запустить в фоне
    Future.microtask(() async {
      if (language != 'uk') {
        await CDNService.checkForUpdates(language);
      }
    });
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
  String? gender; // Мужской или Женский
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
    language = prefs.getString(_languageKey) ?? 'uk';
    final json = prefs.getString(_key);
    if (json == null) return;

    final data = jsonDecode(json);

    name = data['name'] ?? 'Новий герой';
    characterClass = data['characterClass'] ?? 'Воїн';
    race = data['race'] ?? 'Людина';
    gender = data['gender'];
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
    equipment = Map<String, String?>.from(
      (data['equipment'] as Map?)?.map(
            (k, v) => MapEntry(k.toString(), v?.toString()),
          ) ??
          {},
    );

    notifyListeners();
  }

  // --- Збереження ---
  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language);
    await prefs.setString(
      _key,
      jsonEncode({
        'name': name,
        'characterClass': characterClass,
        'race': race,
        'gender': gender,
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
        'equipment': equipment,
      }),
    );
  }

  // --- Хелпери ---
  void update(VoidCallback fn) {
    fn();
    notifyListeners();
    save();
  }

  Future<void> changeLanguage(String newLanguage) async {
    if (newLanguage == language) return;

    language = newLanguage;
    await save();
    notifyListeners();

    // Загрузить переводы для выбранного языка (в фоне)
    if (newLanguage != 'uk') {
      await CDNService.loadTranslationsForLanguage(newLanguage);
    }
  }
}
