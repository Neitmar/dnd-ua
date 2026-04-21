import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class CharacterScreen extends StatefulWidget {
  const CharacterScreen({super.key});

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  late TextEditingController _nameController;
  final _hpInputController = TextEditingController();

  final List<String> _classes = [
    'Воїн', 'Маг', 'Жрець', 'Розбійник',
    'Варвар', 'Бард', 'Паладін', 'Друїд',
    'Монах', 'Слідопит', 'Чаклун', 'Чародій',
  ];

  final List<String> _races = [
    'Людина', 'Ельф', 'Дварф', 'Напіврослик',
    'Гном', 'Тифлінг', 'Драконороджений', 'Напівельф',
  ];

  final List<String> _maleNames = [
    'Аларік', 'Боррін', 'Кассіан', 'Дарен', 'Ельдар',
    'Фаррел', 'Горан', 'Гавін', 'Ідріс', 'Джорен',
    'Кален', 'Леон', 'Міррен', 'Нарін', 'Орін',
    'Перін', 'Квінн', 'Рован', 'Сторм', 'Торін',
    'Ульрік', 'Вален', 'Врін', 'Ксандер', 'Єрін', 'Зефір',
  ];

  final List<String> _femaleNames = [
    'Аріна', 'Бріела', 'Кассіра', 'Дара', 'Елара',
    'Фаєна', 'Горіла', 'Гелена', 'Іара', 'Джорін',
    'Кіра', 'Ліана', 'Міра', 'Нара', 'Оріна',
    'Перла', 'Квінна', 'Ровена', 'Сільва', 'Таліна',
    'Ульра', 'Валена', 'Врія', 'Ксара', 'Єрія', 'Зара',
  ];

  final List<String> _lastNames = [
    'Буревій', 'Залізний', 'Кам\'яний', 'Темний', 'Світлий',
    'Золотий', 'Срібний', 'Вогняний', 'Крижаний', 'Лісовий',
    'Морський', 'Гірський', 'Степовий', 'Нічний', 'Денний',
    'Швидкий', 'Тихий', 'Гучний', 'Мудрий', 'Сміливий',
  ];

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

  @override
  void initState() {
    super.initState();
    final state = context.read<AppState>();
    _nameController = TextEditingController(text: state.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hpInputController.dispose();
    super.dispose();
  }

  int _modifier(int score) => ((score - 10) / 2).floor();

  String _modifierString(int score) {
    final mod = _modifier(score);
    return mod >= 0 ? '+$mod' : '$mod';
  }

  int _proficiencyBonus(int level) {
    if (level < 5) return 2;
    if (level < 9) return 3;
    if (level < 13) return 4;
    if (level < 17) return 5;
    return 6;
  }

  int _maxProficiencies(String cls) {
    switch (cls) {
      case 'Розбійник': return 4;
      case 'Бард': return 3;
      case 'Слідопит': return 3;
      default: return 2;
    }
  }

  bool _hasExpertise(String cls) =>
      cls == 'Розбійник' || cls == 'Бард';

  Set<String> _classDefaultSaves(String cls) {
    switch (cls) {
      case 'Воїн':      return {'save_Сила', 'save_Статура'};
      case 'Маг':       return {'save_Інтелект', 'save_Мудрість'};
      case 'Жрець':     return {'save_Мудрість', 'save_Харизма'};
      case 'Розбійник': return {'save_Спритність', 'save_Інтелект'};
      case 'Варвар':    return {'save_Сила', 'save_Статура'};
      case 'Бард':      return {'save_Спритність', 'save_Харизма'};
      case 'Паладін':   return {'save_Мудрість', 'save_Харизма'};
      case 'Друїд':     return {'save_Інтелект', 'save_Мудрість'};
      case 'Монах':     return {'save_Сила', 'save_Спритність'};
      case 'Слідопит':  return {'save_Сила', 'save_Спритність'};
      case 'Чаклун':    return {'save_Мудрість', 'save_Харизма'};
      case 'Чародій':   return {'save_Статура', 'save_Харизма'};
      default:          return {};
    }
  }

  void _generateName(AppState state) {
    final random = DateTime.now().millisecondsSinceEpoch;
    final allNames = [..._maleNames, ..._femaleNames];
    final firstName = allNames[random % allNames.length];
    final lastName = _lastNames[(random ~/ 7) % _lastNames.length];
    final newName = '$firstName $lastName';
    _nameController.text = newName;
    state.update(() => state.name = newName);
  }

  // --- Hold логіка ---
  int _holdToken = 0;

  void _beginHold(VoidCallback action) {
    _holdToken++;
    final myToken = _holdToken;
    _scheduleRepeat(action, myToken);
  }

  void _scheduleRepeat(VoidCallback action, int token) {
    Future.delayed(const Duration(milliseconds: 150), () {
      if (_holdToken == token && mounted) {
        action();
        _scheduleRepeat(action, token);
      }
    });
  }

  void _endHold() => _holdToken++;

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
        Future.delayed(const Duration(milliseconds: 150), () {
          _repeatHold(onTap, myToken);
        });
      },
      onLongPressEnd: (_) => _endHold(),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, size: 20),
      ),
    );
  }

  void _repeatHold(VoidCallback action, int token) {
    if (_holdToken == token && mounted) {
      action();
      Future.delayed(const Duration(milliseconds: 150), () {
        _repeatHold(action, token);
      });
    }
  }

  // --- HP ---
  void _applyDamage(AppState state) {
    final value = int.tryParse(_hpInputController.text) ?? 0;
    if (value <= 0) return;
    state.update(() {
      if (state.tempHp > 0) {
        final absorbed = value > state.tempHp ? state.tempHp : value;
        state.tempHp -= absorbed;
        final remaining = value - absorbed;
        state.currentHp = (state.currentHp - remaining).clamp(0, state.maxHp);
      } else {
        state.currentHp = (state.currentHp - value).clamp(0, state.maxHp);
      }
    });
    _hpInputController.clear();
  }

  void _applyHeal(AppState state) {
    final value = int.tryParse(_hpInputController.text) ?? 0;
    if (value <= 0) return;
    state.update(() {
      state.currentHp = (state.currentHp + value).clamp(0, state.maxHp);
    });
    _hpInputController.clear();
  }

  Color _hpColor(AppState state) {
    if (state.currentHp == 0) return Colors.red.shade700;
    final ratio = state.currentHp / state.maxHp;
    if (ratio <= 0.25) return Colors.red.shade400;
    if (ratio <= 0.5) return Colors.orange.shade400;
    return Colors.green.shade400;
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Персонаж'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBasicInfo(state),
            const SizedBox(height: 16),
            _buildHpBlock(state),
            const SizedBox(height: 16),
            _buildStatsGrid(state),
            const SizedBox(height: 16),
            _buildSavingThrows(state),
            const SizedBox(height: 16),
            _buildSkills(state),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfo(AppState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Основне',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Ім'я персонажа",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () => _generateName(state),
                  icon: const Icon(Icons.casino_outlined),
                  tooltip: 'Випадкове ім\'я',
                ),
              ),
              onChanged: (v) => state.update(() => state.name = v),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: state.characterClass,
              decoration: const InputDecoration(
                  labelText: 'Клас', border: OutlineInputBorder()),
              menuMaxHeight: 180,
              items: _classes
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => state.update(() {
                state.characterClass = v!;
                state.proficientSkills.clear();
                state.expertiseSkills.clear();
              }),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: state.race,
              decoration: const InputDecoration(
                  labelText: 'Раса', border: OutlineInputBorder()),
              menuMaxHeight: 180,
              items: _races
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              onChanged: (v) => state.update(() => state.race = v!),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Рівень:', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 16),
                _holdButton(
                  icon: Icons.remove_circle_outline,
                  onTap: state.level > 1
                      ? () => state.update(() => state.level--)
                      : null,
                ),
                const SizedBox(width: 8),
                Text('${state.level}',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                _holdButton(
                  icon: Icons.add_circle_outline,
                  onTap: state.level < 20
                      ? () => state.update(() => state.level++)
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHpBlock(AppState state) {
    final isDead = state.currentHp == 0;
    final hpColor = _hpColor(state);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Здоров\'я',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildHpCounter('Макс', state.maxHp,
                    color: Colors.grey.shade400,
                    onMinus: () => state.update(() {
                          if (state.maxHp > 1) {
                            state.maxHp--;
                            if (state.currentHp > state.maxHp)
                              state.currentHp = state.maxHp;
                          }
                        }),
                    onPlus: () => state.update(() => state.maxHp++)),
                _buildHpCounter('Поточні', state.currentHp,
                    color: hpColor,
                    onMinus: () => state
                        .update(() { if (state.currentHp > 0) state.currentHp--; }),
                    onPlus: () => state.update(
                        () { if (state.currentHp < state.maxHp) state.currentHp++; })),
                _buildHpCounter('Тимчасові', state.tempHp,
                    color: Colors.blue.shade300,
                    onMinus: () => state
                        .update(() { if (state.tempHp > 0) state.tempHp--; }),
                    onPlus: () => state.update(() => state.tempHp++)),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: state.maxHp > 0
                    ? (state.currentHp / state.maxHp).clamp(0.0, 1.0)
                    : 0,
                minHeight: 12,
                backgroundColor: Colors.grey.shade800,
                valueColor: AlwaysStoppedAnimation<Color>(hpColor),
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
                  onPressed: () => _applyDamage(state),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade800),
                  child: const Text('Пошкодження'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _applyHeal(state),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade800),
                  child: const Text('Зцілення'),
                ),
              ],
            ),
            if (isDead) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              const Text('Кидки смерті',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Успіх: ',
                      style: TextStyle(color: Colors.green)),
                  ...List.generate(3, (i) => GestureDetector(
                    onTap: () => state.update(() {
                      state.deathSuccesses =
                          i < state.deathSuccesses ? i : i + 1;
                    }),
                    child: Icon(
                      i < state.deathSuccesses
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.green,
                      size: 28,
                    ),
                  )),
                  const SizedBox(width: 24),
                  const Text('Провал: ',
                      style: TextStyle(color: Colors.red)),
                  ...List.generate(3, (i) => GestureDetector(
                    onTap: () => state.update(() {
                      state.deathFailures =
                          i < state.deathFailures ? i : i + 1;
                    }),
                    child: Icon(
                      i < state.deathFailures
                          ? Icons.close_rounded
                          : Icons.circle_outlined,
                      color: Colors.red,
                      size: 28,
                    ),
                  )),
                ],
              ),
              if (state.deathFailures >= 3)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text('Персонаж загинув...',
                      style: TextStyle(color: Colors.red, fontSize: 16)),
                )
              else if (state.deathSuccesses >= 3)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text('Стабілізований!',
                      style: TextStyle(color: Colors.green, fontSize: 16)),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHpCounter(String label, int value,
      {Color? color, VoidCallback? onMinus, VoidCallback? onPlus}) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
        const SizedBox(height: 4),
        Text('$value',
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: color)),
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

  Widget _buildStatsGrid(AppState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Характеристики',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.95,
          children: state.stats.entries
              .map((e) => _buildStatCard(state, e.key, e.value))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildStatCard(AppState state, String name, int value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(name,
                style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(_modifierString(value),
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _holdButton(
                  icon: Icons.remove,
                  onTap: value > 1
                      ? () => state
                          .update(() => state.stats[name] = value - 1)
                      : null,
                ),
                const SizedBox(width: 6),
                Text('$value', style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                _holdButton(
                  icon: Icons.add,
                  onTap: value < 30
                      ? () => state
                          .update(() => state.stats[name] = value + 1)
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavingThrows(AppState state) {
    final prof = _proficiencyBonus(state.level);
    final defaultSaves = _classDefaultSaves(state.characterClass);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Рятівні кидки',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Майстерність: +$prof',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...state.stats.keys.map((ability) {
              final isProficient =
                  defaultSaves.contains('save_$ability');
              final mod = _modifier(state.stats[ability]!);
              final bonus = isProficient ? mod + prof : mod;
              final bonusStr = bonus >= 0 ? '+$bonus' : '$bonus';
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      isProficient
                          ? Icons.circle
                          : Icons.circle_outlined,
                      size: 14,
                      color: isProficient
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 36,
                      child: Text(bonusStr,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                    ),
                    Text(ability,
                        style: const TextStyle(fontSize: 14)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSkills(AppState state) {
    final prof = _proficiencyBonus(state.level);
    final maxProf = _maxProficiencies(state.characterClass);
    final hasExp = _hasExpertise(state.characterClass);
    final maxExp = hasExp ? 2 : 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Навички',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ..._skillAbility.entries.map((entry) {
              final skillName = entry.key;
              final abilityName = entry.value;
              final isProficient =
                  state.proficientSkills.contains(skillName);
              final isExpertise =
                  state.expertiseSkills.contains(skillName);
              final mod = _modifier(state.stats[abilityName]!);
              int bonus = mod;
              if (isExpertise) {
                bonus = mod + prof * 2;
              } else if (isProficient) {
                bonus = mod + prof;
              }
              final bonusStr = bonus >= 0 ? '+$bonus' : '$bonus';
              return InkWell(
                onTap: () => state.update(() {
                  if (isExpertise) {
                    state.expertiseSkills.remove(skillName);
                  } else if (isProficient) {
                    if (hasExp &&
                        state.expertiseSkills.length < maxExp) {
                      state.expertiseSkills.add(skillName);
                    } else {
                      state.proficientSkills.remove(skillName);
                    }
                  } else {
                    if (state.proficientSkills.length < maxProf) {
                      state.proficientSkills.add(skillName);
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
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 36,
                        child: Text(bonusStr,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Text(skillName,
                            style: const TextStyle(fontSize: 14)),
                      ),
                      Text(
                        abilityName.substring(0, 3).toUpperCase(),
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500),
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
}