import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

const List<Map<String, dynamic>> _allConditions = [
  {
    'name': 'Осліплений',
    'icon': '👁',
    'desc':
        'Не може бачити. Провалює перевірки що потребують зору. Атаки проти нього з перевагою, його атаки з вадою.',
  },
  {
    'name': 'Зачарований',
    'icon': '💫',
    'desc':
        'Не може атакувати того хто зачарував. Той має перевагу на соціальні перевірки.',
  },
  {
    'name': 'Приголомшений',
    'icon': '⚡',
    'desc':
        'Не може діяти чи реагувати. Падає якщо летить. Атаки проти нього з перевагою, його атаки провалюються.',
  },
  {
    'name': 'Наляканий',
    'icon': '😨',
    'desc':
        'Вада на перевірки та атаки поки джерело страху в полі зору. Не може наближатись до джерела страху.',
  },
  {
    'name': 'Схоплений',
    'icon': '🤝',
    'desc':
        'Швидкість 0. Закінчується якщо той хто схопив недієздатний або істота виривається.',
  },
  {'name': 'Недієздатний', 'icon': '💤', 'desc': 'Не може діяти чи реагувати.'},
  {
    'name': 'Невидимий',
    'icon': '👻',
    'desc':
        'Неможливо побачити без спеціальних засобів. Атаки проти нього з вадою, його атаки з перевагою.',
  },
  {
    'name': 'Паралізований',
    'icon': '🧊',
    'desc':
        'Недієздатний. Не може рухатись чи говорити. Атаки проти нього з перевагою. Влучання з 5 футів — крит.',
  },
  {
    'name': 'Скам\'янілий',
    'icon': '🗿',
    'desc':
        'Перетворений на тверду речовину. Недієздатний, не знає про оточення. Стійкість до всієї шкоди, імунітет до отрути.',
  },
  {
    'name': 'Отруєний',
    'icon': '☠️',
    'desc': 'Вада на кидки атаки та перевірки здібностей.',
  },
  {
    'name': 'Лежачий',
    'icon': '⬇️',
    'desc':
        'Може лише повзти. Атаки проти нього з перевагою якщо поряд, з вадою здалека. Його атаки з вадою.',
  },
  {
    'name': 'Приборканий',
    'icon': '⛓️',
    'desc':
        'Швидкість 0. Атаки проти нього і його атаки з вадою. Вада на рятівні кидки Спритності.',
  },
  {
    'name': 'Оглушений',
    'icon': '🌀',
    'desc':
        'Недієздатний, не може рухатись. Вада на рятівні кидки Сили та Спритності. Атаки проти нього з перевагою.',
  },
  {
    'name': 'Несвідомий',
    'icon': '💀',
    'desc':
        'Недієздатний. Падає. Провалює рятівні кидки Сили та Спритності. Атаки з перевагою, влучання з 5 футів — крит.',
  },
];

class CombatScreen extends StatelessWidget {
  const CombatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    // Синхронізація зброї з інвентарем
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final inventoryNames = state.inventory
          .where((i) => i['category'] == 2)
          .map((i) => i['name'].toString())
          .toSet();

      final toRemove = state.weapons.where((w) {
        final fromInventory = w['fromInventory'] == true;
        return fromInventory && !inventoryNames.contains(w['name'].toString());
        
      }).toList();

      if (toRemove.isNotEmpty) {
        state.update(() {
          for (final w in toRemove) {
            state.weapons.remove(w);
          }
        });
      }
    });
    
    return Scaffold(
      appBar: AppBar(title: const Text('Бойові'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCombatStats(context, state),
            const SizedBox(height: 16),
            _buildWeapons(context, state),
            const SizedBox(height: 16),
            _buildConditions(context, state),
          ],
        ),
      ),
    );
  }

  // --- Бойові параметри ---
  Widget _buildCombatStats(BuildContext context, AppState state) {
    final dexMod = ((state.stats['Спритність'] ?? 10) - 10) ~/ 2;
    final profBonus = state.level < 5
        ? 2
        : state.level < 9
        ? 3
        : state.level < 13
        ? 4
        : state.level < 17
        ? 5
        : 6;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Параметри бою',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatEditor(
                  context,
                  state,
                  'КЗ',
                  state.armorClass,
                  min: 1,
                  max: 30,
                  onMinus: () => state.update(() => state.armorClass--),
                  onPlus: () => state.update(() => state.armorClass++),
                ),
                _buildStatEditor(
                  context,
                  state,
                  'Ініціатива',
                  dexMod >= 0 ? dexMod : dexMod,
                  showSign: true,
                  readOnly: true,
                  hint: 'з Спр',
                  onMinus: null,
                  onPlus: null,
                ),
                _buildStatEditor(
                  context,
                  state,
                  'Швидкість',
                  state.speed,
                  min: 0,
                  max: 120,
                  suffix: 'фт',
                  onMinus: () => state.update(() {
                    if (state.speed >= 5) state.speed -= 5;
                  }),
                  onPlus: () => state.update(() => state.speed += 5),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.info_outline, size: 14, color: Colors.grey.shade500),
                const SizedBox(width: 6),
                Text(
                  'Бонус майстерності: +$profBonus',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatEditor(
    BuildContext context,
    AppState state,
    String label,
    int value, {
    bool showSign = false,
    bool readOnly = false,
    String? suffix,
    String? hint,
    int min = 0,
    int max = 999,
    VoidCallback? onMinus,
    VoidCallback? onPlus,
  }) {
    final displayValue = showSign
        ? (value >= 0 ? '+$value' : '$value')
        : '$value${suffix != null ? ' $suffix' : ''}';

    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
        ),
        const SizedBox(height: 4),
        Text(
          displayValue,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        if (hint != null)
          Text(
            hint,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
          ),
        if (!readOnly) ...[
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: value > min ? onMinus : null,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.remove,
                    size: 18,
                    color: value > min ? null : Colors.grey.shade700,
                  ),
                ),
              ),
              GestureDetector(
                onTap: value < max ? onPlus : null,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.add,
                    size: 18,
                    color: value < max ? null : Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  // --- Зброя ---
  Widget _buildWeapons(BuildContext context, AppState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Зброя та атаки',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (state.weapons.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Немає зброї. Натисни + щоб додати.',
                style: TextStyle(color: Colors.grey.shade500),
              ),
            ),
          )
        else
          ...state.weapons.asMap().entries.map(
            (e) => _buildWeaponCard(context, state, e.value, e.key),
          ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _showWeaponDialog(context, state),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Додати зброю'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeaponCard(
    BuildContext context,
    AppState state,
    Map<String, dynamic> weapon,
    int index,
  ) {
    final strMod = ((state.stats['Сила'] ?? 10) - 10) ~/ 2;
    final dexMod = ((state.stats['Спритність'] ?? 10) - 10) ~/ 2;
    final profBonus = state.level < 5
        ? 2
        : state.level < 9
        ? 3
        : state.level < 13
        ? 4
        : state.level < 17
        ? 5
        : 6;

    final isFinesse = weapon['finesse'] == true;
    final isRanged = weapon['ranged'] == true;
    final isProficient = weapon['proficient'] == true;

    final abilityMod = (isFinesse || isRanged) ? dexMod : strMod;
    final attackBonus = abilityMod + (isProficient ? profBonus : 0);
    final attackStr = attackBonus >= 0 ? '+$attackBonus' : '$attackBonus';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                isRanged ? Icons.gps_fixed : Icons.hardware_outlined,
                size: 18,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    weapon['name'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    'Атака: $attackStr · ${weapon['damage'] ?? ''} ${weapon['damageType'] ?? ''}',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                  ),
                  if ((weapon['notes'] ?? '').isNotEmpty)
                    Text(
                      weapon['notes'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                ],
              ),
            ),
            // Кнопка кидка атаки
            IconButton(
              icon: const Icon(Icons.casino_outlined),
              tooltip: 'Кинути атаку',
              onPressed: () =>
                  _rollAttack(context, weapon['name'], attackBonus),
            ),
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                size: 18,
                color: Colors.red.shade400,
              ),
              onPressed: () =>
                  state.update(() => state.weapons.removeAt(index)),
            ),
          ],
        ),
      ),
    );
  }

  void _rollAttack(BuildContext context, String? weaponName, int bonus) {
    final roll = (DateTime.now().millisecondsSinceEpoch % 20) + 1;
    final total = roll + bonus;
    final isCrit = roll == 20;
    final isFail = roll == 1;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Атака: ${weaponName ?? ''}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$total',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: isCrit
                    ? Colors.green
                    : isFail
                    ? Colors.red
                    : null,
              ),
            ),
            Text(
              'd20($roll) ${bonus >= 0 ? '+' : ''}$bonus',
              style: TextStyle(color: Colors.grey.shade400),
            ),
            if (isCrit)
              const Text(
                'КРИТИЧНЕ ВЛУЧАННЯ!',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (isFail)
              const Text(
                'КРИТИЧНИЙ ПРОМАХ',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрити'),
          ),
        ],
      ),
    );
  }

  void _showWeaponDialog(BuildContext context, AppState state, {int? editIndex}) {
  final weapon = editIndex != null ? state.weapons[editIndex] : null;
  final nameController = TextEditingController(text: weapon?['name'] ?? '');
  final notesController = TextEditingController(text: weapon?['notes'] ?? '');
  String damageDice = weapon?['damage'] ?? '1d6';
  String damageType = weapon?['damageType'] ?? 'рубляча';
  bool proficient = weapon?['proficient'] ?? true;
  bool finesse = weapon?['finesse'] ?? false;
  bool ranged = weapon?['ranged'] ?? false;

  final inventoryWeapons = state.inventory
      .where((i) => i['category'] == 2)
      .toList();

  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setDialogState) => AlertDialog(
        title: Text(editIndex != null ? 'Редагувати зброю' : 'Додати зброю'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- З ІНВЕНТАРЮ ---
              if (editIndex == null && inventoryWeapons.isNotEmpty) ...[
                const Text('З інвентарю',
                    style: TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: inventoryWeapons.map((item) {
                    final alreadyAdded = state.weapons
                        .any((w) => w['name'] == item['name']);
                    return GestureDetector(
                      onTap: alreadyAdded ? null : () {
                        // ← ТУТ fromInventory: true
                        state.update(() => state.weapons.add({
                          'name': item['name'],
                          'damage': '1d6',
                          'damageType': 'рубляча',
                          'proficient': true,
                          'finesse': false,
                          'ranged': false,
                          'notes': item['description'] ?? '',
                          'fromInventory': true,
                        }));
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: alreadyAdded
                              ? Colors.grey.shade800
                              : Theme.of(context)
                                  .colorScheme
                                  .primaryContainer
                                  .withOpacity(0.3),
                          border: Border.all(
                            color: alreadyAdded
                                ? Colors.grey.shade700
                                : Theme.of(context).colorScheme.primary,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          item['name'],
                          style: TextStyle(
                            fontSize: 13,
                            color: alreadyAdded
                                ? Colors.grey.shade600
                                : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                const Text('Нова зброя',
                    style: TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 8),
              ],

              // --- НОВА ЗБРОЯ (форма) ---
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Назва',
                  border: OutlineInputBorder(),
                ),
                maxLength: 40,
                autofocus: editIndex != null,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: damageDice,
                      decoration: const InputDecoration(
                        labelText: 'Кубик шкоди',
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                      ),
                      items: [
                        '1d4','1d6','1d8','1d10','1d12',
                        '2d6','2d8','2d10','2d12',
                      ]
                          .map((d) => DropdownMenuItem(
                              value: d, child: Text(d)))
                          .toList(),
                      onChanged: (v) =>
                          setDialogState(() => damageDice = v!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: damageType,
                      decoration: const InputDecoration(
                        labelText: 'Тип шкоди',
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                      ),
                      menuMaxHeight: 200,
                      items: [
                        'рубляча','колюча','дробляча',
                        'вогняна','холодна','блискавкова',
                        'кислотна','некротична','силова',
                        'отруйна','психічна','громова','променева',
                      ]
                          .map((t) => DropdownMenuItem(
                              value: t, child: Text(t)))
                          .toList(),
                      onChanged: (v) =>
                          setDialogState(() => damageType = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              CheckboxListTile(
                title: const Text('Вміння з цією зброєю'),
                value: proficient,
                onChanged: (v) =>
                    setDialogState(() => proficient = v!),
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
              CheckboxListTile(
                title: const Text('Фінесова (Спр замість Сили)'),
                value: finesse,
                onChanged: (v) =>
                    setDialogState(() => finesse = v!),
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
              CheckboxListTile(
                title: const Text('Дальнобійна'),
                value: ranged,
                onChanged: (v) =>
                    setDialogState(() => ranged = v!),
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Нотатки (необов\'язково)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                maxLength: 100,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Скасувати'),
          ),
          if (editIndex != null)
            TextButton(
              onPressed: () {
                state.update(() => state.weapons.removeAt(editIndex));
                Navigator.pop(context);
              },
              child: Text('Видалити',
                  style: TextStyle(color: Colors.red.shade400)),
            ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) return;
              // ← ТУТ fromInventory: false (додано вручну)
              final w = {
                'name': nameController.text.trim(),
                'damage': damageDice,
                'damageType': damageType,
                'proficient': proficient,
                'finesse': finesse,
                'ranged': ranged,
                'notes': notesController.text.trim(),
                'fromInventory': false,
              };
              state.update(() {
                if (editIndex != null) {
                  state.weapons[editIndex] = w;
                } else {
                  state.weapons.add(w);
                }
              });
              Navigator.pop(context);
            },
            child: Text(editIndex != null ? 'Зберегти' : 'Додати'),
          ),
        ],
      ),
    ),
  );
}

  // --- Стани ---
  Widget _buildConditions(BuildContext context, AppState state) {
    final active = state.combatConditions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Стани',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _allConditions.map((cond) {
            final isActive = active.any((c) => c['name'] == cond['name']);
            return GestureDetector(
              onTap: () {
                state.update(() {
                  if (isActive) {
                    state.combatConditions.removeWhere(
                      (c) => c['name'] == cond['name'],
                    );
                  } else {
                    state.combatConditions.add(Map.from(cond));
                  }
                });
              },
              onLongPress: () => _showConditionInfo(context, cond),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                      : Colors.transparent,
                  border: Border.all(
                    color: isActive
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade700,
                    width: isActive ? 1.5 : 0.5,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${cond['icon']} ${cond['name']}',
                  style: TextStyle(
                    fontSize: 13,
                    color: isActive
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade400,
                    fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (active.isNotEmpty) ...[
          const SizedBox(height: 12),
          ...active.map(
            (cond) => Card(
              margin: const EdgeInsets.only(bottom: 6),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              child: ListTile(
                dense: true,
                leading: Text(
                  cond['icon'] ?? '',
                  style: const TextStyle(fontSize: 20),
                ),
                title: Text(
                  cond['name'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  cond['desc'] ?? '',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  onPressed: () => state.update(() {
                    state.combatConditions.removeWhere(
                      (c) => c['name'] == cond['name'],
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _showConditionInfo(BuildContext context, Map<String, dynamic> cond) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${cond['icon']} ${cond['name']}'),
        content: Text(cond['desc'] ?? ''),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Зрозуміло'),
          ),
        ],
      ),
    );
  }
}
