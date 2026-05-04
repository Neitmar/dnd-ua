class ClassData {
  final String name;
  final bool isSpellcaster;
  final String spellcastingAbility;
  final int hitDie;

  ClassData({
    required this.name,
    required this.isSpellcaster,
    required this.spellcastingAbility,
    required this.hitDie,
  });
}

const Map<String, Map<String, dynamic>> defaultClasses = {
  'Воїн': {
    'icon': '⚔️',
    'description': 'Майстер боју з мечем, щитом та броєю',
    'hitDie': 10,
    'primaryAbility': 'Сила',
    'savingThrows': ['Сила', 'Статура'],
    'skillProficiencies': ['Атлетика'],
    'maxSkillProficiencies': 2,
    'armorProficiencies': ['Легка броя', 'Середня броя', 'Важка броя', 'Щити'],
    'weaponProficiencies': ['Простої зброї', 'Бойові зброї'],
  },
  'Маг': {
    'icon': '🔮',
    'description': 'Учень магічних мистецтв та заклинаннєю',
    'hitDie': 6,
    'primaryAbility': 'Інтелект',
    'savingThrows': ['Інтелект', 'Мудрість'],
    'skillProficiencies': ['Магія', 'Історія', 'Візування', 'Релігія'],
    'maxSkillProficiencies': 2,
    'armorProficiencies': [],
    'weaponProficiencies': ['Простої зброї'],
    'spellcastingAbility': 'Інтелект',
    'spellSlots': {1: 2, 2: 0, 3: 0},
  },
  'Жрець': {
    'icon': '✨',
    'description': 'Служитель багів та божественної магії',
    'hitDie': 8,
    'primaryAbility': 'Мудрість',
    'savingThrows': ['Мудрість', 'Харизма'],
    'skillProficiencies': ['Зцілення', 'Розуміння', 'Розпізнавання', 'Релігія'],
    'maxSkillProficiencies': 2,
    'armorProficiencies': ['Легка броя', 'Середня броя', 'Щити'],
    'weaponProficiencies': ['Простої зброї', 'Бойові зброї'],
    'spellcastingAbility': 'Мудрість',
  },
  'Розбійник': {
    'icon': '🗡️',
    'description': 'Майстер підступу та швидкості',
    'hitDie': 8,
    'primaryAbility': 'Спритність',
    'savingThrows': ['Спритність', 'Інтелект'],
    'skillProficiencies': ['Акробатика', 'Атлетика', 'Обман', 'Проникнення', 'Переконання', 'Залякування', 'Спритність рук', 'Стелс'],
    'maxSkillProficiencies': 4,
    'armorProficiencies': ['Легка броя'],
    'weaponProficiencies': ['Простої зброї', 'Бойові зброї'],
  },
  'Варвар': {
    'icon': '🪓',
    'description': 'Дикий воїн з нестримною люттю',
    'hitDie': 12,
    'primaryAbility': 'Сила',
    'savingThrows': ['Сила', 'Статура'],
    'skillProficiencies': ['Атлетика', 'Тварини', 'Виживання', 'Залякування'],
    'maxSkillProficiencies': 2,
    'armorProficiencies': ['Легка броя', 'Середня броя', 'Щити'],
    'weaponProficiencies': ['Простої зброї', 'Бойові зброї'],
  },
  'Бард': {
    'icon': '🎵',
    'description': 'Майстер слів та музики',
    'hitDie': 8,
    'primaryAbility': 'Харизма',
    'savingThrows': ['Спритність', 'Харизма'],
    'skillProficiencies': ['Акробатика', 'Атлетика', 'Історія', 'Магія', 'Зцілення', 'Маніпуляція', 'Природа', 'Переконання', 'Релігія', 'Тварини', 'Проникнення'],
    'maxSkillProficiencies': 3,
    'armorProficiencies': ['Легка броя'],
    'weaponProficiencies': ['Простої зброї', 'Бойові зброї'],
    'spellcastingAbility': 'Харизма',
  },
  'Паладін': {
    'icon': '⚖️',
    'description': 'Святий воїн з божественною силою',
    'hitDie': 10,
    'primaryAbility': 'Сила',
    'savingThrows': ['Мудрість', 'Харизма'],
    'skillProficiencies': ['Атлетика', 'Зцілення', 'Залякування', 'Маніпуляція', 'Переконання', 'Релігія'],
    'maxSkillProficiencies': 2,
    'armorProficiencies': ['Легка броя', 'Середня броя', 'Важка броя', 'Щити'],
    'weaponProficiencies': ['Простої зброї', 'Бойові зброї'],
    'spellcastingAbility': 'Харизма',
  },
  'Друїд': {
    'icon': '🌿',
    'description': 'Охоронець природи та її таємниць',
    'hitDie': 8,
    'primaryAbility': 'Мудрість',
    'savingThrows': ['Інтелект', 'Мудрість'],
    'skillProficiencies': ['Атлетика', 'Тварини', 'Природа', 'Зцілення', 'Релігія', 'Виживання'],
    'maxSkillProficiencies': 2,
    'armorProficiencies': ['Легка броя', 'Середня броя', 'Щити'],
    'weaponProficiencies': ['Клуби', 'Дарти', 'Кинджали', 'Джерела', 'Посохи', 'Списки', 'Луки'],
    'spellcastingAbility': 'Мудрість',
  },
  'Монах': {
    'icon': '🥋',
    'description': 'Майстер бойових мистецтв',
    'hitDie': 8,
    'primaryAbility': 'Спритність',
    'savingThrows': ['Сила', 'Спритність'],
    'skillProficiencies': ['Акробатика', 'Атлетика', 'Історія', 'Зцілення', 'Залякування', 'Природа', 'Релігія', 'Стелс'],
    'maxSkillProficiencies': 2,
    'armorProficiencies': [],
    'weaponProficiencies': ['Простої зброї', 'Короткі мечі'],
  },
  'Слідопит': {
    'icon': '🏹',
    'description': 'Майстер стрільби та вистежування',
    'hitDie': 10,
    'primaryAbility': 'Спритність',
    'savingThrows': ['Сила', 'Спритність'],
    'skillProficiencies': ['Атлетика', 'Тварини', 'Виживання', 'Природа', 'Проникнення', 'Стелс'],
    'maxSkillProficiencies': 3,
    'armorProficiencies': ['Легка броя', 'Середня броя', 'Щити'],
    'weaponProficiencies': ['Простої зброї', 'Бойові зброї'],
  },
  'Чаклун': {
    'icon': '🔥',
    'description': 'Носій містичної сили',
    'hitDie': 8,
    'primaryAbility': 'Харизма',
    'savingThrows': ['Мудрість', 'Харизма'],
    'skillProficiencies': ['Магія', 'Історія', 'Залякування', 'Маніпуляція', 'Природа', 'Релігія'],
    'maxSkillProficiencies': 2,
    'armorProficiencies': ['Легка броя'],
    'weaponProficiencies': ['Простої зброї'],
    'spellcastingAbility': 'Харизма',
  },
  'Чародій': {
    'icon': '❄️',
    'description': 'Майстер вродженої магії',
    'hitDie': 6,
    'primaryAbility': 'Харизма',
    'savingThrows': ['Статура', 'Харизма'],
    'skillProficiencies': ['Магія', 'Історія', 'Залякування', 'Маніпуляція', 'Переконання', 'Релігія'],
    'maxSkillProficiencies': 2,
    'armorProficiencies': ['Легка броя'],
    'weaponProficiencies': ['Кинджали', 'Дарти', 'Клуби', 'Посохи'],
    'spellcastingAbility': 'Харизма',
  },
};

ClassData? getClassData(String className) {
  final data = defaultClasses[className];
  if (data == null) return null;
  return ClassData(
    name: className,
    isSpellcaster: data.containsKey('spellcastingAbility'),
    spellcastingAbility: data['spellcastingAbility'] ?? 'Інтелект',
    hitDie: data['hitDie'] ?? 8,
  );
}

bool isSpellcaster(String className) {
  return getClassData(className)?.isSpellcaster ?? false;
}

String getSpellcastingAbility(String className) {
  return getClassData(className)?.spellcastingAbility ?? 'Інтелект';
}

String getHitDie(String className) {
  final hitDie = getClassData(className)?.hitDie ?? 8;
  return 'd$hitDie';
}

int getStartingHp(String className, int conModifier) {
  final hitDie = getClassData(className)?.hitDie ?? 8;
  return hitDie + conModifier;
}