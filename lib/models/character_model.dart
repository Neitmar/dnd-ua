
class CharacterModel {
  String name;
  String characterClass;
  String race;
  int level;
  Map<String, int> stats;
  int maxHp;
  int currentHp;
  int tempHp;
  int deathSuccesses;
  int deathFailures;
  Set<String> proficientSkills;
  Set<String> expertiseSkills;

  CharacterModel({
    this.name = 'Новий герой',
    this.characterClass = 'Воїн',
    this.race = 'Людина',
    this.level = 1,
    Map<String, int>? stats,
    this.maxHp = 10,
    this.currentHp = 10,
    this.tempHp = 0,
    this.deathSuccesses = 0,
    this.deathFailures = 0,
    Set<String>? proficientSkills,
    Set<String>? expertiseSkills,
  })  : stats = stats ??
            {
              'Сила': 10,
              'Спритність': 10,
              'Статура': 10,
              'Інтелект': 10,
              'Мудрість': 10,
              'Харизма': 10,
            },
        proficientSkills = proficientSkills ?? {},
        expertiseSkills = expertiseSkills ?? {};

  Map<String, dynamic> toJson() => {
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
      };

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      name: json['name'] ?? 'Новий герой',
      characterClass: json['characterClass'] ?? 'Воїн',
      race: json['race'] ?? 'Людина',
      level: json['level'] ?? 1,
      stats: Map<String, int>.from(json['stats'] ?? {}),
      maxHp: json['maxHp'] ?? 10,
      currentHp: json['currentHp'] ?? 10,
      tempHp: json['tempHp'] ?? 0,
      deathSuccesses: json['deathSuccesses'] ?? 0,
      deathFailures: json['deathFailures'] ?? 0,
      proficientSkills: Set<String>.from(json['proficientSkills'] ?? []),
      expertiseSkills: Set<String>.from(json['expertiseSkills'] ?? []),
    );
  }
}