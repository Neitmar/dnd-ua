import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../data/default_spells.dart';

class SpellsScreen extends StatefulWidget {
  const SpellsScreen({super.key});

  @override
  State<SpellsScreen> createState() => _SpellsScreenState();
}

class _SpellsScreenState extends State<SpellsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _abilities = ['Інтелект', 'Мудрість', 'Харизма'];

  // Слоти по класах і рівнях (спрощена таблиця D&D 5e)
  final Map<String, Map<int, List<int>>> _slotTable = {
    'Маг': {
      1: [2, 0, 0, 0, 0, 0, 0, 0, 0],
      2: [3, 0, 0, 0, 0, 0, 0, 0, 0],
      3: [4, 2, 0, 0, 0, 0, 0, 0, 0],
      4: [4, 3, 0, 0, 0, 0, 0, 0, 0],
      5: [4, 3, 2, 0, 0, 0, 0, 0, 0],
      6: [4, 3, 3, 0, 0, 0, 0, 0, 0],
      7: [4, 3, 3, 1, 0, 0, 0, 0, 0],
      8: [4, 3, 3, 2, 0, 0, 0, 0, 0],
      9: [4, 3, 3, 3, 1, 0, 0, 0, 0],
      10: [4, 3, 3, 3, 2, 0, 0, 0, 0],
      11: [4, 3, 3, 3, 2, 1, 0, 0, 0],
      12: [4, 3, 3, 3, 2, 1, 0, 0, 0],
      13: [4, 3, 3, 3, 2, 1, 1, 0, 0],
      14: [4, 3, 3, 3, 2, 1, 1, 0, 0],
      15: [4, 3, 3, 3, 2, 1, 1, 1, 0],
      16: [4, 3, 3, 3, 2, 1, 1, 1, 0],
      17: [4, 3, 3, 3, 2, 1, 1, 1, 1],
      18: [4, 3, 3, 3, 3, 1, 1, 1, 1],
      19: [4, 3, 3, 3, 3, 2, 1, 1, 1],
      20: [4, 3, 3, 3, 3, 2, 2, 1, 1],
    },
    'Жрець': {
      1: [2, 0, 0, 0, 0, 0, 0, 0, 0],
      2: [3, 0, 0, 0, 0, 0, 0, 0, 0],
      3: [4, 2, 0, 0, 0, 0, 0, 0, 0],
      4: [4, 3, 0, 0, 0, 0, 0, 0, 0],
      5: [4, 3, 2, 0, 0, 0, 0, 0, 0],
      6: [4, 3, 3, 0, 0, 0, 0, 0, 0],
      7: [4, 3, 3, 1, 0, 0, 0, 0, 0],
      8: [4, 3, 3, 2, 0, 0, 0, 0, 0],
      9: [4, 3, 3, 3, 1, 0, 0, 0, 0],
      10: [4, 3, 3, 3, 2, 0, 0, 0, 0],
      11: [4, 3, 3, 3, 2, 1, 0, 0, 0],
      12: [4, 3, 3, 3, 2, 1, 0, 0, 0],
      13: [4, 3, 3, 3, 2, 1, 1, 0, 0],
      14: [4, 3, 3, 3, 2, 1, 1, 0, 0],
      15: [4, 3, 3, 3, 2, 1, 1, 1, 0],
      16: [4, 3, 3, 3, 2, 1, 1, 1, 0],
      17: [4, 3, 3, 3, 2, 1, 1, 1, 1],
      18: [4, 3, 3, 3, 3, 1, 1, 1, 1],
      19: [4, 3, 3, 3, 3, 2, 1, 1, 1],
      20: [4, 3, 3, 3, 3, 2, 2, 1, 1],
    },
    'Друїд': {
      1: [2, 0, 0, 0, 0, 0, 0, 0, 0],
      2: [3, 0, 0, 0, 0, 0, 0, 0, 0],
      3: [4, 2, 0, 0, 0, 0, 0, 0, 0],
      4: [4, 3, 0, 0, 0, 0, 0, 0, 0],
      5: [4, 3, 2, 0, 0, 0, 0, 0, 0],
      6: [4, 3, 3, 0, 0, 0, 0, 0, 0],
      7: [4, 3, 3, 1, 0, 0, 0, 0, 0],
      8: [4, 3, 3, 2, 0, 0, 0, 0, 0],
      9: [4, 3, 3, 3, 1, 0, 0, 0, 0],
      10: [4, 3, 3, 3, 2, 0, 0, 0, 0],
      11: [4, 3, 3, 3, 2, 1, 0, 0, 0],
      12: [4, 3, 3, 3, 2, 1, 0, 0, 0],
      13: [4, 3, 3, 3, 2, 1, 1, 0, 0],
      14: [4, 3, 3, 3, 2, 1, 1, 0, 0],
      15: [4, 3, 3, 3, 2, 1, 1, 1, 0],
      16: [4, 3, 3, 3, 2, 1, 1, 1, 0],
      17: [4, 3, 3, 3, 2, 1, 1, 1, 1],
      18: [4, 3, 3, 3, 3, 1, 1, 1, 1],
      19: [4, 3, 3, 3, 3, 2, 1, 1, 1],
      20: [4, 3, 3, 3, 3, 2, 2, 1, 1],
    },
    'Бард': {
      1: [2, 0, 0, 0, 0, 0, 0, 0, 0],
      2: [3, 0, 0, 0, 0, 0, 0, 0, 0],
      3: [4, 2, 0, 0, 0, 0, 0, 0, 0],
      4: [4, 3, 0, 0, 0, 0, 0, 0, 0],
      5: [4, 3, 2, 0, 0, 0, 0, 0, 0],
      6: [4, 3, 3, 0, 0, 0, 0, 0, 0],
      7: [4, 3, 3, 1, 0, 0, 0, 0, 0],
      8: [4, 3, 3, 2, 0, 0, 0, 0, 0],
      9: [4, 3, 3, 3, 1, 0, 0, 0, 0],
      10: [4, 3, 3, 3, 2, 0, 0, 0, 0],
      11: [4, 3, 3, 3, 2, 1, 0, 0, 0],
      12: [4, 3, 3, 3, 2, 1, 0, 0, 0],
      13: [4, 3, 3, 3, 2, 1, 1, 0, 0],
      14: [4, 3, 3, 3, 2, 1, 1, 0, 0],
      15: [4, 3, 3, 3, 2, 1, 1, 1, 0],
      16: [4, 3, 3, 3, 2, 1, 1, 1, 0],
      17: [4, 3, 3, 3, 2, 1, 1, 1, 1],
      18: [4, 3, 3, 3, 3, 1, 1, 1, 1],
      19: [4, 3, 3, 3, 3, 2, 1, 1, 1],
      20: [4, 3, 3, 3, 3, 2, 2, 1, 1],
    },
    'Паладін': {
      1: [0, 0, 0, 0, 0, 0, 0, 0, 0],
      2: [2, 0, 0, 0, 0, 0, 0, 0, 0],
      3: [3, 0, 0, 0, 0, 0, 0, 0, 0],
      4: [3, 0, 0, 0, 0, 0, 0, 0, 0],
      5: [4, 2, 0, 0, 0, 0, 0, 0, 0],
      6: [4, 2, 0, 0, 0, 0, 0, 0, 0],
      7: [4, 3, 0, 0, 0, 0, 0, 0, 0],
      8: [4, 3, 0, 0, 0, 0, 0, 0, 0],
      9: [4, 3, 2, 0, 0, 0, 0, 0, 0],
      10: [4, 3, 2, 0, 0, 0, 0, 0, 0],
      11: [4, 3, 3, 0, 0, 0, 0, 0, 0],
      12: [4, 3, 3, 0, 0, 0, 0, 0, 0],
      13: [4, 3, 3, 1, 0, 0, 0, 0, 0],
      14: [4, 3, 3, 1, 0, 0, 0, 0, 0],
      15: [4, 3, 3, 2, 0, 0, 0, 0, 0],
      16: [4, 3, 3, 2, 0, 0, 0, 0, 0],
      17: [4, 3, 3, 3, 1, 0, 0, 0, 0],
      18: [4, 3, 3, 3, 1, 0, 0, 0, 0],
      19: [4, 3, 3, 3, 2, 0, 0, 0, 0],
      20: [4, 3, 3, 3, 2, 0, 0, 0, 0],
    },
    'Слідопит': {
      1: [0, 0, 0, 0, 0, 0, 0, 0, 0],
      2: [2, 0, 0, 0, 0, 0, 0, 0, 0],
      3: [3, 0, 0, 0, 0, 0, 0, 0, 0],
      4: [3, 0, 0, 0, 0, 0, 0, 0, 0],
      5: [4, 2, 0, 0, 0, 0, 0, 0, 0],
      6: [4, 2, 0, 0, 0, 0, 0, 0, 0],
      7: [4, 3, 0, 0, 0, 0, 0, 0, 0],
      8: [4, 3, 0, 0, 0, 0, 0, 0, 0],
      9: [4, 3, 2, 0, 0, 0, 0, 0, 0],
      10: [4, 3, 2, 0, 0, 0, 0, 0, 0],
      11: [4, 3, 3, 0, 0, 0, 0, 0, 0],
      12: [4, 3, 3, 0, 0, 0, 0, 0, 0],
      13: [4, 3, 3, 1, 0, 0, 0, 0, 0],
      14: [4, 3, 3, 1, 0, 0, 0, 0, 0],
      15: [4, 3, 3, 2, 0, 0, 0, 0, 0],
      16: [4, 3, 3, 2, 0, 0, 0, 0, 0],
      17: [4, 3, 3, 3, 1, 0, 0, 0, 0],
      18: [4, 3, 3, 3, 1, 0, 0, 0, 0],
      19: [4, 3, 3, 3, 2, 0, 0, 0, 0],
      20: [4, 3, 3, 3, 2, 0, 0, 0, 0],
    },
    'Чаклун': {
      1: [1, 0, 0, 0, 0, 0, 0, 0, 0],
      2: [2, 0, 0, 0, 0, 0, 0, 0, 0],
      3: [0, 2, 0, 0, 0, 0, 0, 0, 0],
      4: [0, 2, 0, 0, 0, 0, 0, 0, 0],
      5: [0, 0, 2, 0, 0, 0, 0, 0, 0],
      6: [0, 0, 2, 0, 0, 0, 0, 0, 0],
      7: [0, 0, 0, 2, 0, 0, 0, 0, 0],
      8: [0, 0, 0, 2, 0, 0, 0, 0, 0],
      9: [0, 0, 0, 0, 2, 0, 0, 0, 0],
      10: [0, 0, 0, 0, 2, 0, 0, 0, 0],
      11: [0, 0, 0, 0, 3, 0, 0, 0, 0],
      12: [0, 0, 0, 0, 3, 0, 0, 0, 0],
      13: [0, 0, 0, 0, 3, 0, 0, 0, 0],
      14: [0, 0, 0, 0, 3, 0, 0, 0, 0],
      15: [0, 0, 0, 0, 3, 0, 0, 0, 0],
      16: [0, 0, 0, 0, 3, 0, 0, 0, 0],
      17: [0, 0, 0, 0, 4, 0, 0, 0, 0],
      18: [0, 0, 0, 0, 4, 0, 0, 0, 0],
      19: [0, 0, 0, 0, 4, 0, 0, 0, 0],
      20: [0, 0, 0, 0, 4, 0, 0, 0, 0],
    },
    'Чародій': {
      1: [2, 0, 0, 0, 0, 0, 0, 0, 0],
      2: [3, 0, 0, 0, 0, 0, 0, 0, 0],
      3: [4, 2, 0, 0, 0, 0, 0, 0, 0],
      4: [4, 3, 0, 0, 0, 0, 0, 0, 0],
      5: [4, 3, 2, 0, 0, 0, 0, 0, 0],
      6: [4, 3, 3, 0, 0, 0, 0, 0, 0],
      7: [4, 3, 3, 1, 0, 0, 0, 0, 0],
      8: [4, 3, 3, 2, 0, 0, 0, 0, 0],
      9: [4, 3, 3, 3, 1, 0, 0, 0, 0],
      10: [4, 3, 3, 3, 2, 0, 0, 0, 0],
      11: [4, 3, 3, 3, 2, 1, 0, 0, 0],
      12: [4, 3, 3, 3, 2, 1, 0, 0, 0],
      13: [4, 3, 3, 3, 2, 1, 1, 0, 0],
      14: [4, 3, 3, 3, 2, 1, 1, 0, 0],
      15: [4, 3, 3, 3, 2, 1, 1, 1, 0],
      16: [4, 3, 3, 3, 2, 1, 1, 1, 0],
      17: [4, 3, 3, 3, 2, 1, 1, 1, 1],
      18: [4, 3, 3, 3, 3, 1, 1, 1, 1],
      19: [4, 3, 3, 3, 3, 2, 1, 1, 1],
      20: [4, 3, 3, 3, 3, 2, 2, 1, 1],
    },
  };

  bool get _isSpellcaster {
    const casters = [
      'Маг',
      'Жрець',
      'Друїд',
      'Бард',
      'Паладін',
      'Слідопит',
      'Чаклун',
      'Чародій',
    ];
    return casters.contains(context.read<AppState>().characterClass);
  }

  int get level => context.read<AppState>().level;

  int _proficiencyBonusForLevel(int level) {
    if (level < 5) return 2;
    if (level < 9) return 3;
    if (level < 13) return 4;
    if (level < 17) return 5;
    return 6;
  }

  int _abilityModifier(AppState state) {
    final score = (state.stats[state.spellcastingAbility] ?? 10) as int;
    return (score - 10) ~/ 2;
  }

  List<int> _getSlotsForClass(String cls, int level) {
    return _slotTable[cls]?[level] ?? List.filled(9, 0);
  }

  void _normalizeUsedSpellSlots(AppState state) {
    final slots = _getSlotsForClass(state.characterClass, state.level);

    state.update(() {
      for (var i = 0; i < 9; i++) {
        final slotLevel = i + 1;
        final total = slots[i];
        final used = state.usedSpellSlots[slotLevel] ?? 0;

        if (total <= 0) {
          state.usedSpellSlots[slotLevel] = 0;
        } else {
          state.usedSpellSlots[slotLevel] = used.clamp(0, total);
        }
      }
    });
  }

  int _spellSaveDC(AppState state) {
    return 8 + _proficiencyBonusForLevel(level) + _abilityModifier(state);
  }

  int _spellAttackBonus(AppState state) {
    return _proficiencyBonusForLevel(level) + _abilityModifier(state);
  }

  void _loadDefaultSpells(AppState state) {
    final spells = defaultSpells[state.characterClass];
    if (spells == null) return;

    state.update(() {
      for (final spell in spells) {
        final exists = state.preparedSpells.any(
          (s) =>
              (s['name'] ?? '').toString() == (spell['name'] ?? '').toString(),
        );
        if (!exists) {
          state.preparedSpells.add(Map<String, dynamic>.from(spell));
        }
      }
    });
  }

  int _safeSpellLevel(Map<String, dynamic> spell) {
    final raw = spell['level'];
    final parsed = raw is int ? raw : int.tryParse(raw?.toString() ?? '');
    return (parsed ?? 0).clamp(0, 9);
  }

  String _safeSpellString(Map<String, dynamic> spell, String key) {
    return (spell[key] ?? '').toString().trim();
  }

  bool _safeSpellBool(Map<String, dynamic> spell, String key) {
    return spell[key] == true;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _normalizeUsedSpellSlots(context.read<AppState>());
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addSpell(AppState state, bool isPrepared) {
    final nameController = TextEditingController();
    final levelController = TextEditingController(text: '1');
    final schoolController = TextEditingController();
    final descController = TextEditingController();
    String castingTime = '1 дія';
    bool concentration = false;
    bool ritual = false;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: Text(
            isPrepared
                ? 'Додати підготовлене закляття'
                : 'Додати відоме закляття',
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Назва заклинання',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 50,
                  autofocus: true,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: levelController,
                        decoration: const InputDecoration(
                          labelText: 'Рівень (0-9)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: schoolController,
                        decoration: const InputDecoration(
                          labelText: 'Школа',
                          border: OutlineInputBorder(),
                        ),
                        maxLength: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: castingTime,
                        decoration: const InputDecoration(
                          labelText: 'Час читання',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        items:
                            [
                                  '1 дія',
                                  'Бонусна дія',
                                  'Реакція',
                                  '1 хвилина',
                                  '10 хвилин',
                                  '1 година',
                                ]
                                .map(
                                  (t) => DropdownMenuItem<String>(
                                    value: t,
                                    child: Text(t),
                                  ),
                                )
                                .toList(),
                        onChanged: (v) {
                          if (v != null) {
                            setDialogState(() => castingTime = v);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'Опис',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  maxLength: 500,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text(
                          'Концентрація',
                          style: TextStyle(fontSize: 13),
                        ),
                        value: concentration,
                        onChanged: (v) =>
                            setDialogState(() => concentration = v ?? false),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text(
                          'Ритуал',
                          style: TextStyle(fontSize: 13),
                        ),
                        value: ritual,
                        onChanged: (v) =>
                            setDialogState(() => ritual = v ?? false),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Скасувати'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isEmpty) return;

                final parsedLevel =
                    int.tryParse(levelController.text.trim()) ?? 1;
                final safeLevel = parsedLevel.clamp(0, 9);

                final spell = <String, dynamic>{
                  'name': name,
                  'level': safeLevel,
                  'school': schoolController.text.trim(),
                  'castingTime': castingTime,
                  'description': descController.text.trim(),
                  'concentration': concentration,
                  'ritual': ritual,
                };

                state.update(() {
                  if (isPrepared) {
                    state.preparedSpells.add(spell);
                  } else {
                    state.knownSpells.add(spell);
                  }
                });

                Navigator.pop(dialogContext);
              },
              child: const Text('Додати'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _normalizeUsedSpellSlots(state);
      }
    });

    if (!_isSpellcaster) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Вміння'),
      centerTitle: true,
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.info_outline,
                      color: Colors.grey.shade400, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${state.characterClass} не використовує магію, але може мати бойові вміння, крики, пози або техніки.',
                      style: TextStyle(
                          fontSize: 13, color: Colors.grey.shade400),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildSpellList(state, state.preparedSpells, 'Вміння', true),
        ],
      ),
    ),
  );
}

    final slots = _getSlotsForClass(state.characterClass, state.level);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Заклинання'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Слоти та підготовлені'),
            Tab(text: 'Відомі'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildPreparedTab(state, slots), _buildKnownTab(state)],
      ),
    );
  }

  Widget _buildPreparedTab(AppState state, List<int> slots) {
    final dc = _spellSaveDC(state);
    final attack = _spellAttackBonus(state);
    final attackStr = attack >= 0 ? '+$attack' : '$attack';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Параметри заклинань',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: state.spellcastingAbility,
                          decoration: const InputDecoration(
                            labelText: 'Характеристика',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          items: _abilities
                              .map(
                                (a) => DropdownMenuItem<String>(
                                  value: a,
                                  child: Text(a),
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            if (v != null) {
                              state.update(() => state.spellcastingAbility = v);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatChip('Складність спасу', 'КС $dc'),
                      _buildStatChip('Бонус атаки', attackStr),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (state.preparedSpells.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Стартовий набір',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Завантаж базові заклинання для ${state.characterClass}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => _loadDefaultSpells(state),
                      icon: const Icon(Icons.download_outlined),
                      label: const Text('Завантажити базові заклинання'),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Слоти заклинань',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => state.update(() {
                          state.usedSpellSlots = {
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
                        }),
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text('Відпочинок'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(9, (i) {
                    final slotLevel = i + 1;
                    final total = slots[i];
                    if (total == 0) return const SizedBox.shrink();

                    final used = (state.usedSpellSlots[slotLevel] ?? 0).clamp(
                      0,
                      total,
                    );
                    final available = total - used;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 60,
                            child: Text(
                              '$slotLevel рівень',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: List.generate(total, (j) {
                                final isUsed = j >= available;

                                return GestureDetector(
                                  onTap: () => state.update(() {
                                    final currentUsed =
                                        (state.usedSpellSlots[slotLevel] ?? 0)
                                            .clamp(0, total);

                                    if (isUsed) {
                                      state.usedSpellSlots[slotLevel] =
                                          (currentUsed - 1).clamp(0, total);
                                    } else {
                                      state.usedSpellSlots[slotLevel] =
                                          (currentUsed + 1).clamp(0, total);
                                    }
                                  }),
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    margin: const EdgeInsets.only(right: 6),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isUsed
                                          ? Colors.grey.shade800
                                          : Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                      border: Border.all(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$slotLevel',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: isUsed
                                              ? Colors.grey
                                              : Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          Text(
                            '$available/$total',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildSpellList(
            state,
            state.preparedSpells,
            'Підготовлені заклинання',
            true,
          ),
        ],
      ),
    );
  }

  Widget _buildKnownTab(AppState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _buildSpellList(
        state,
        state.knownSpells,
        'Відомі заклинання',
        false,
      ),
    );
  }

  Widget _buildStatChip(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSpellList(
    AppState state,
    List<Map<String, dynamic>> spells,
    String title,
    bool isPrepared,
  ) {
    final Map<int, List<Map<String, dynamic>>> grouped = {};
    for (final spell in spells) {
      final lvl = _safeSpellLevel(spell);
      grouped.putIfAbsent(lvl, () => []).add(spell);
    }
    final sortedLevels = grouped.keys.toList()..sort();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '${spells.length} заклинань',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (spells.isNotEmpty)
          ...sortedLevels.map((lvl) {
            final levelSpells = grouped[lvl]!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    lvl == 0 ? 'Заговори' : '$lvl рівень',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                ...levelSpells.map((spell) {
                  final realIndex = spells.indexOf(spell);
                  return _buildSpellCard(state, spell, realIndex, isPrepared);
                }),
              ],
            );
          }),
        const SizedBox(height: 8),
        // Кнопка додати — завжди внизу списку
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _addSpell(state, isPrepared),
            icon: const Icon(Icons.add, size: 18),
            label: Text(isPrepared ? 'Додати заклинання' : 'Додати до відомих'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpellCard(
    AppState state,
    Map<String, dynamic> spell,
    int index,
    bool isPrepared,
  ) {
    final name = _safeSpellString(spell, 'name');
    final school = _safeSpellString(spell, 'school');
    final castingTime = _safeSpellString(spell, 'castingTime');
    final description = _safeSpellString(spell, 'description');
    final concentration = _safeSpellBool(spell, 'concentration');
    final ritual = _safeSpellBool(spell, 'ritual');

    final subtitleParts = <String>[];
    if (school.isNotEmpty) subtitleParts.add(school);
    if (castingTime.isNotEmpty) subtitleParts.add(castingTime);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Row(
          children: [
            Expanded(
              child: Text(
                name.isNotEmpty ? name : 'Без назви',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            if (concentration) _buildTag('К', Colors.blue, 'Концентрація'),
            if (ritual) _buildTag('Р', Colors.green, 'Ритуал'),
          ],
        ),
        subtitle: subtitleParts.isEmpty
            ? null
            : Text(
                subtitleParts.join(' · '),
                style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
              ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                size: 18,
                color: Colors.red.shade400,
              ),
              onPressed: () => state.update(() {
                if (isPrepared) {
                  if (index >= 0 && index < state.preparedSpells.length) {
                    state.preparedSpells.removeAt(index);
                  }
                } else {
                  if (index >= 0 && index < state.knownSpells.length) {
                    state.knownSpells.removeAt(index);
                  }
                }
              }),
            ),
            const Icon(Icons.expand_more),
          ],
        ),
        children: [
          if (description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(description, style: const TextStyle(fontSize: 14)),
            ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, Color color, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: Container(
        margin: const EdgeInsets.only(right: 4),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color, width: 0.5),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
