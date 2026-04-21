import 'dart:async';
import '../models/character_model.dart';
import '../services/storage_service.dart';
import 'package:flutter/material.dart';

class CharacterScreen extends StatefulWidget {
  const CharacterScreen({super.key});

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  final _nameController = TextEditingController(text: 'Новий герой');
  String _selectedClass = 'Воїн';
  String _selectedRace = 'Людина';
  int _level = 1;

  final Map<String, int> _stats = {
    'Сила': 10,
    'Спритність': 10,
    'Статура': 10,
    'Інтелект': 10,
    'Мудрість': 10,
    'Харизма': 10,
  };

  // Бонус майстерності залежно від рівня
  int get _proficiencyBonus {
    if (_level < 5) return 2;
    if (_level < 9) return 3;
    if (_level < 13) return 4;
    if (_level < 17) return 5;
    return 6;
  }

  int get _maxProficiencies {
    switch (_selectedClass) {
      case 'Розбійник':
        return 4;
      case 'Бард':
        return 3;
      case 'Слідопит':
        return 3;
      default:
        return 2;
    }
  }

  bool get _hasExpertise {
    return _selectedClass == 'Розбійник' || _selectedClass == 'Бард';
  }

  int get _maxExpertise {
    return _hasExpertise ? 2 : 0;
  }

  Set<String> get _classDefaultSaves {
    switch (_selectedClass) {
      case 'Воїн':
        return {'save_Сила', 'save_Статура'};
      case 'Маг':
        return {'save_Інтелект', 'save_Мудрість'};
      case 'Жрець':
        return {'save_Мудрість', 'save_Харизма'};
      case 'Розбійник':
        return {'save_Спритність', 'save_Інтелект'};
      case 'Варвар':
        return {'save_Сила', 'save_Статура'};
      case 'Бард':
        return {'save_Спритність', 'save_Харизма'};
      case 'Паладін':
        return {'save_Мудрість', 'save_Харизма'};
      case 'Друїд':
        return {'save_Інтелект', 'save_Мудрість'};
      case 'Монах':
        return {'save_Сила', 'save_Спритність'};
      case 'Слідопит':
        return {'save_Сила', 'save_Спритність'};
      case 'Чаклун':
        return {'save_Мудрість', 'save_Харизма'};
      case 'Чародій':
        return {'save_Статура', 'save_Харизма'};
      default:
        return {};
    }
  }

  // Навички: назва -> яка характеристика
  final Map<String, String> _skillAbility = {
    'Акробатика': 'Спритність',
    'Виживання': 'Мудрість',
    'Виступ': 'Харизма',
    'Залякування': 'Харизма',
    'Зцілення': 'Мудрість',
    'Історія': 'Інтелект',
    'Магія': 'Інтелект',
    'Маніпуляція': 'Харизма',
    'Містика': 'Інтелект',
    'Навчання': 'Інтелект',
    'Переконання': 'Харизма',
    'Перехоплення': 'Мудрість',
    'Природа': 'Інтелект',
    'Проникнення': 'Мудрість',
    'Релігія': 'Інтелект',
    'Спритність рук': 'Спритність',
    'Стелс': 'Спритність',
    'Тварини': 'Мудрість',
  };

  // Які навички має вміння (proficiency)
  final Set<String> _proficientSkills = {};

  // Які навички мають подвійне вміння (expertise)
  final Set<String> _expertiseSkills = {};
  int _maxHp = 10;
  int _currentHp = 10;
  int _tempHp = 0;
  final _hpInputController = TextEditingController();

  int _deathSuccesses = 0;
  int _deathFailures = 0;

  final List<String> _classes = [
    'Воїн',
    'Маг',
    'Жрець',
    'Розбійник',
    'Варвар',
    'Бард',
    'Паладін',
    'Друїд',
    'Монах',
    'Слідопит',
    'Чаклун',
    'Чародій',
  ];

  final List<String> _races = [
    'Людина',
    'Ельф',
    'Дварф',
    'Напіврослик',
    'Гном',
    'Тифлінг',
    'Драконороджений',
    'Напівельф',
  ];

  final List<String> _maleNames = [
    'Аларік',
    'Боррін',
    'Кассіан',
    'Дарен',
    'Ельдар',
    'Фаррел',
    'Горан',
    'Гавін',
    'Ідріс',
    'Джорен',
    'Кален',
    'Леон',
    'Міррен',
    'Нарін',
    'Орін',
    'Перін',
    'Квінн',
    'Рован',
    'Сторм',
    'Торін',
    'Ульрік',
    'Вален',
    'Врін',
    'Ксандер',
    'Єрін',
    'Зефір',
  ];

  final List<String> _femaleNames = [
    'Аріна',
    'Бріела',
    'Кассіра',
    'Дара',
    'Елара',
    'Фаєна',
    'Горіла',
    'Гелена',
    'Іара',
    'Джорін',
    'Кіра',
    'Ліана',
    'Міра',
    'Нара',
    'Оріна',
    'Перла',
    'Квінна',
    'Ровена',
    'Сільва',
    'Таліна',
    'Ульра',
    'Валена',
    'Врія',
    'Ксара',
    'Єрія',
    'Зара',
  ];

  final List<String> _lastNames = [
    'Буревій',
    'Залізний',
    'Кам\'яний',
    'Темний',
    'Світлий',
    'Золотий',
    'Срібний',
    'Вогняний',
    'Крижаний',
    'Лісовий',
    'Морський',
    'Гірський',
    'Степовий',
    'Нічний',
    'Денний',
    'Швидкий',
    'Тихий',
    'Гучний',
    'Мудрий',
    'Сміливий',
  ];

  void _generateName() {
    final random = DateTime.now().millisecondsSinceEpoch;
    final allNames = [..._maleNames, ..._femaleNames];
    final firstName = allNames[random % allNames.length];
    final lastName = _lastNames[(random ~/ 7) % _lastNames.length];
    setState(() {
      _nameController.text = '$firstName $lastName';
    });
  }

  int _modifier(int score) => ((score - 10) / 2).floor();

  String _modifierString(int score) {
    final mod = _modifier(score);
    return mod >= 0 ? '+$mod' : '$mod';
  }

  int _holdToken = 0;

  void _beginHold(VoidCallback action) {
    _holdToken++;
    final myToken = _holdToken;
    _scheduleRepeat(action, myToken);
  }

  void _scheduleRepeat(VoidCallback action, int token) {
    Future.delayed(const Duration(milliseconds: 150), () {
      if (_holdToken == token && mounted) {
        setState(() => action());
        _scheduleRepeat(action, token);
      }
    });
  }

  void _endHold() {
    _holdToken++;
  }

  @override
  void initState() {
    super.initState();
    _loadCharacter();
  }

  void setState(VoidCallback fn) {
    super.setState(fn);
    _saveCharacter();
  }

  Future<void> _loadCharacter() async {
    final character = await StorageService.loadCharacter();
    print('LOAD: character = $character');
    if (character != null) {
      print('LOAD: name = ${character.name}');
      setState(() {
        _nameController.text = character.name;
        _selectedClass = character.characterClass;
        _selectedRace = character.race;
        _level = character.level;
        _stats.addAll(character.stats);
        _maxHp = character.maxHp;
        _currentHp = character.currentHp;
        _tempHp = character.tempHp;
        _deathSuccesses = character.deathSuccesses;
        _deathFailures = character.deathFailures;
        _proficientSkills.addAll(character.proficientSkills);
        _expertiseSkills.addAll(character.expertiseSkills);
      });
    }
  }

  void _saveCharacter() {
    print('SAVE: name = ${_nameController.text}');
    StorageService.saveCharacter(
      CharacterModel(
        name: _nameController.text,
        characterClass: _selectedClass,
        race: _selectedRace,
        level: _level,
        stats: Map.from(_stats),
        maxHp: _maxHp,
        currentHp: _currentHp,
        tempHp: _tempHp,
        deathSuccesses: _deathSuccesses,
        deathFailures: _deathFailures,
        proficientSkills: Set.from(_proficientSkills),
        expertiseSkills: Set.from(_expertiseSkills),
      ),
    );
  }

  Widget _holdButton({required IconData icon, required VoidCallback? onTap}) {
    if (onTap == null) {
      return Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, size: 20, color: Colors.grey.shade700),
      );
    }
    return GestureDetector(
      onTap: onTap,
      onLongPressStart: (_) {
        _holdToken++;
        final myToken = _holdToken;
        _scheduleDynamic(onTap, myToken);
      },
      onLongPressEnd: (_) => _endHold(),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, size: 20),
      ),
    );
  }

  void _scheduleDynamic(VoidCallback action, int token) {
    Future.delayed(const Duration(milliseconds: 150), () {
      if (_holdToken == token && mounted) {
        setState(action);
        _scheduleDynamic(action, token);
      }
    });
  }

  void _applyDamage() {
    final value = int.tryParse(_hpInputController.text) ?? 0;
    if (value <= 0) return;
    setState(() {
      if (_tempHp > 0) {
        final absorbed = value > _tempHp ? _tempHp : value;
        _tempHp -= absorbed;
        final remaining = value - absorbed;
        _currentHp = (_currentHp - remaining).clamp(0, _maxHp);
      } else {
        _currentHp = (_currentHp - value).clamp(0, _maxHp);
      }
    });
    _hpInputController.clear();
  }

  void _applyHeal() {
    final value = int.tryParse(_hpInputController.text) ?? 0;
    if (value <= 0) return;
    setState(() {
      _currentHp = (_currentHp + value).clamp(0, _maxHp);
    });
    _hpInputController.clear();
  }

  Color get _hpColor {
    if (_currentHp == 0) return Colors.red.shade700;
    final ratio = _currentHp / _maxHp;
    if (ratio <= 0.25) return Colors.red.shade400;
    if (ratio <= 0.5) return Colors.orange.shade400;
    return Colors.green.shade400;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Персонаж'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBasicInfo(),
            const SizedBox(height: 16),
            _buildHpBlock(),
            const SizedBox(height: 16),
            _buildStatsGrid(),
            const SizedBox(height: 16),
            _buildSavingThrows(),
            const SizedBox(height: 16),
            _buildSkills(),
          ],
        ),
      ),
    );
  }

  Widget _buildSavingThrows() {
    final abilities = _stats.keys.toList();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Рятівні кидки',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Майстерність: +$_proficiencyBonus',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...abilities.map((ability) {
              final isProficient = _classDefaultSaves.contains('save_$ability');
              final mod = _modifier(_stats[ability]!);
              final bonus = isProficient ? mod + _proficiencyBonus : mod;
              final bonusStr = bonus >= 0 ? '+$bonus' : '$bonus';
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      isProficient ? Icons.circle : Icons.circle_outlined,
                      size: 14,
                      color: isProficient
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 36,
                      child: Text(
                        bonusStr,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(ability, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSkills() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Навички',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ..._skillAbility.entries.map((entry) {
              final skillName = entry.key;
              final abilityName = entry.value;
              final isProficient = _proficientSkills.contains(skillName);
              final isExpertise = _expertiseSkills.contains(skillName);
              final mod = _modifier(_stats[abilityName]!);
              int bonus = mod;
              if (isExpertise) {
                bonus = mod + _proficiencyBonus * 2;
              } else if (isProficient) {
                bonus = mod + _proficiencyBonus;
              }
              final bonusStr = bonus >= 0 ? '+$bonus' : '$bonus';
              return InkWell(
                onTap: () => setState(() {
                  if (isExpertise) {
                    // скидаємо подвійне вміння → звичайне
                    _expertiseSkills.remove(skillName);
                  } else if (isProficient) {
                    // вміння → подвійне (тільки якщо клас дозволяє і ліміт не досягнутий)
                    if (_hasExpertise &&
                        _expertiseSkills.length < _maxExpertise) {
                      _expertiseSkills.add(skillName);
                    } else {
                      // скидаємо вміння
                      _proficientSkills.remove(skillName);
                    }
                  } else {
                    // немає → вміння (якщо ліміт не досягнутий)
                    if (_proficientSkills.length < _maxProficiencies) {
                      _proficientSkills.add(skillName);
                    }
                  }
                }),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        isExpertise
                            ? Icons.circle
                            : isProficient
                            ? Icons.circle_outlined
                            : Icons.radio_button_unchecked,
                        size: 14,
                        color: isExpertise
                            ? Colors.amber
                            : isProficient
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey,
                      ),
                      const SizedBox(height: 0, width: 8),
                      SizedBox(
                        width: 36,
                        child: Text(
                          bonusStr,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          skillName,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Text(
                        abilityName.substring(0, 3).toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Основне',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Ім'я персонажа",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: _generateName,
                  icon: const Icon(Icons.casino_outlined),
                  tooltip: 'Випадкове ім\'я',
                ),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedClass,
              decoration: const InputDecoration(
                labelText: 'Клас',
                border: OutlineInputBorder(),
              ),
              menuMaxHeight: 180,
              items: _classes
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() {
                _selectedClass = v!;
                _proficientSkills.clear();
                _expertiseSkills.clear();
              }),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedRace,
              decoration: const InputDecoration(
                labelText: 'Раса',
                border: OutlineInputBorder(),
              ),
              menuMaxHeight: 180,
              items: _races
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedRace = v!),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Рівень:', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 16),
                _holdButton(
                  icon: Icons.remove_circle_outline,
                  onTap: _level > 1 ? () => setState(() => _level--) : null,
                ),
                const SizedBox(width: 8),
                Text(
                  '$_level',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                _holdButton(
                  icon: Icons.add_circle_outline,
                  onTap: _level < 20 ? () => setState(() => _level++) : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHpBlock() {
    final isDead = _currentHp == 0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Здоров\'я',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildHpCounter(
                  'Макс',
                  _maxHp,
                  color: Colors.grey.shade400,
                  onMinus: () => setState(() {
                    if (_maxHp > 1) {
                      _maxHp--;
                      if (_currentHp > _maxHp) _currentHp = _maxHp;
                    }
                  }),
                  onPlus: () => setState(() => _maxHp++),
                ),
                _buildHpCounter(
                  'Поточні',
                  _currentHp,
                  color: _hpColor,
                  onMinus: () => setState(() {
                    if (_currentHp > 0) _currentHp--;
                  }),
                  onPlus: () => setState(() {
                    if (_currentHp < _maxHp) _currentHp++;
                  }),
                ),
                _buildHpCounter(
                  'Тимчасові',
                  _tempHp,
                  color: Colors.blue.shade300,
                  onMinus: () => setState(() {
                    if (_tempHp > 0) _tempHp--;
                  }),
                  onPlus: () => setState(() => _tempHp++),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: _maxHp > 0 ? (_currentHp / _maxHp).clamp(0.0, 1.0) : 0,
                minHeight: 12,
                backgroundColor: Colors.grey.shade800,
                valueColor: AlwaysStoppedAnimation<Color>(_hpColor),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _hpInputController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Значення',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _applyDamage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade800,
                  ),
                  child: const Text('Пошкодження'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _applyHeal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade800,
                  ),
                  child: const Text('Зцілення'),
                ),
              ],
            ),
            if (isDead) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'Кидки смерті',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Успіх: ', style: TextStyle(color: Colors.green)),
                  ...List.generate(
                    3,
                    (i) => GestureDetector(
                      onTap: () => setState(() {
                        _deathSuccesses = i < _deathSuccesses ? i : i + 1;
                      }),
                      child: Icon(
                        i < _deathSuccesses
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.green,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  const Text('Провал: ', style: TextStyle(color: Colors.red)),
                  ...List.generate(
                    3,
                    (i) => GestureDetector(
                      onTap: () => setState(() {
                        _deathFailures = i < _deathFailures ? i : i + 1;
                      }),
                      child: Icon(
                        i < _deathFailures
                            ? Icons.close_rounded
                            : Icons.circle_outlined,
                        color: Colors.red,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
              if (_deathFailures >= 3)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Персонаж загинув...',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                )
              else if (_deathSuccesses >= 3)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Стабілізований!',
                    style: TextStyle(color: Colors.green, fontSize: 16),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHpCounter(
    String label,
    int value, {
    Color? color,
    VoidCallback? onMinus,
    VoidCallback? onPlus,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
        ),
        const SizedBox(height: 4),
        Text(
          '$value',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            _holdButton(icon: Icons.remove, onTap: onMinus),
            const SizedBox(width: 8),
            _holdButton(icon: Icons.add, onTap: onPlus),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Характеристики',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.95,
          children: _stats.entries
              .map((e) => _buildStatCard(e.key, e.value))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildStatCard(String name, int value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              _modifierString(value),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _holdButton(
                  icon: Icons.remove,
                  onTap: value > 1
                      ? () => setState(() => _stats[name] = value - 1)
                      : null,
                ),
                const SizedBox(width: 6),
                Text('$value', style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                _holdButton(
                  icon: Icons.add,
                  onTap: value < 30
                      ? () => setState(() => _stats[name] = value + 1)
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
