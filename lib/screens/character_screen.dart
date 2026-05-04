import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../data/classes_data.dart';
import '../data/items_data.dart';
import '../services/localization_service.dart';
import '../widgets/settings_dialog.dart';

class CharacterScreen extends StatefulWidget {
  const CharacterScreen({super.key});

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  late TextEditingController _nameController;

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

  bool _hasExpertise(String cls) => cls == 'Розбійник' || cls == 'Бард';

  Set<String> _classDefaultSaves(String cls) {
    switch (cls) {
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

  void _generateName(AppState state) {
    final random = DateTime.now().millisecondsSinceEpoch;
    final allNames = state.gender == 'female' ? _femaleNames : _maleNames;
    final firstName = allNames[random % allNames.length];
    final lastName = _lastNames[(random ~/ 7) % _lastNames.length];
    final newName = '$firstName $lastName';
    _nameController.text = newName;
    state.update(() => state.name = newName);
  }

  // --- Hold логіка ---
  int _holdToken = 0;

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

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(tr(context, 'character')),
          centerTitle: true,
          actions: settingsAction(context),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Основне'),
              Tab(text: 'Статистика'),
              Tab(text: 'Навички'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPortraitPlaceholder(),
                  const SizedBox(height: 16),
                  _buildBasicInfo(state),
                ],
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_buildStatsGrid(state)],
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSavingThrows(state),
                  const SizedBox(height: 16),
                  _buildSkills(state),
                ],
              ),
            ),
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
                  onPressed: () => _generateName(state),
                  icon: const Icon(Icons.casino_outlined),
                  tooltip: 'Випадкове ім\'я',
                ),
              ),
              onChanged: (v) => state.update(() => state.name = v),
            ),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'male',
                  icon: Icon(Icons.male),
                  label: Text('Чоловік'),
                ),
                ButtonSegment(
                  value: 'female',
                  icon: Icon(Icons.female),
                  label: Text('Жінка'),
                ),
              ],
              selected: {state.gender},
              onSelectionChanged: (value) {
                state.update(() => state.gender = value.first);
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: state.characterClass,
              decoration: const InputDecoration(
                labelText: 'Клас',
                border: OutlineInputBorder(),
              ),
              menuMaxHeight: 180,
              items: _classes
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  state.update(() {
                    state.characterClass = v;
                    // Авто встановлюємо характеристику для заклинань
                    final classData = getClassData(v);
                    if (classData != null && classData.isSpellcaster) {
                      state.spellcastingAbility = classData.spellcastingAbility;
                    }
                    // Авто рахуємо HP якщо ще дефолтний
                    if (state.maxHp == 10 && state.level == 1) {
                      final conMod = ((state.stats['Статура'] ?? 10) - 10) ~/ 2;
                      state.maxHp = getStartingHp(v, conMod);
                      state.currentHp = state.maxHp;
                    }
                  });
                }
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: state.race,
              decoration: const InputDecoration(
                labelText: 'Раса',
                border: OutlineInputBorder(),
              ),
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
                Text(
                  '${state.level}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                _holdButton(
                  icon: Icons.add_circle_outline,
                  onTap: state.level < 20
                      ? () => state.update(() => state.level++)
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                final items = getStartingItemsForClass(state.characterClass);
                final gold = getStartingGold(state.characterClass);
                state.update(() {
                  state.inventory.addAll(items);
                  state.gold += gold;
                });
              },
              icon: const Icon(Icons.inventory_2_outlined),
              label: const Text('Отримати стартовий набір'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortraitPlaceholder() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 112,
              height: 144,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade700),
                color: Colors.black.withValues(alpha: 0.18),
              ),
              padding: const EdgeInsets.all(16),
              child: SvgPicture.asset(
                'assets/character_silhouette.svg',
                colorFilter: ColorFilter.mode(
                  Colors.grey.shade500,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 18),
            const Expanded(child: SizedBox(height: 144)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(AppState state) {
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
                      ? () => state.update(() => state.stats[name] = value - 1)
                      : null,
                ),
                const SizedBox(width: 6),
                Text('$value', style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                _holdButton(
                  icon: Icons.add,
                  onTap: value < 30
                      ? () => state.update(() => state.stats[name] = value + 1)
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
                    'Майстерність: +$prof',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...state.stats.keys.map((ability) {
              final isProficient = defaultSaves.contains('save_$ability');
              final mod = _modifier(state.stats[ability]!);
              final bonus = isProficient ? mod + prof : mod;
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
            const Text(
              'Навички',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ..._skillAbility.entries.map((entry) {
              final skillName = entry.key;
              final abilityName = entry.value;
              final isProficient = state.proficientSkills.contains(skillName);
              final isExpertise = state.expertiseSkills.contains(skillName);
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
                    if (hasExp && state.expertiseSkills.length < maxExp) {
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
}
