import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../services/localization_service.dart';
import '../widgets/settings_dialog.dart';

enum ItemCategory { potion, armor, weapon, useful, quest, accessory }

extension ItemCategoryExtension on ItemCategory {
  String get label {
    switch (this) {
      case ItemCategory.potion:
        return 'Зілля';
      case ItemCategory.armor:
        return 'Броня';
      case ItemCategory.weapon:
        return 'Зброя';
      case ItemCategory.useful:
        return 'Корисне';
      case ItemCategory.quest:
        return 'Квестові';
      case ItemCategory.accessory:
        return 'Аксесуари';
    }
  }

  IconData get icon {
    switch (this) {
      case ItemCategory.potion:
        return Icons.science_outlined;
      case ItemCategory.armor:
        return Icons.shield_outlined;
      case ItemCategory.weapon:
        return Icons.hardware_outlined;
      case ItemCategory.useful:
        return Icons.build_outlined;
      case ItemCategory.quest:
        return Icons.article_outlined;
      case ItemCategory.accessory:
        return Icons.diamond_outlined;
    }
  }

  Color get color {
    switch (this) {
      case ItemCategory.potion:
        return Colors.red.shade300;
      case ItemCategory.armor:
        return Colors.blue.shade300;
      case ItemCategory.weapon:
        return Colors.orange.shade300;
      case ItemCategory.useful:
        return Colors.green.shade300;
      case ItemCategory.quest:
        return Colors.purple.shade300;
      case ItemCategory.accessory:
        return Colors.cyan.shade300;
    }
  }
}

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  ItemCategory? _selectedCategory;
  ItemCategory? _lastSelectedCategory;
  Timer? _allPressTimer;
  bool _allPressTriggered = false;

  static const List<ItemCategory> _orderedCategories = [
    ItemCategory.armor,
    ItemCategory.weapon,
    ItemCategory.accessory,
    ItemCategory.potion,
    ItemCategory.useful,
    ItemCategory.quest,
  ];

  ItemCategory get _currentAddCategory =>
      _selectedCategory ?? _lastSelectedCategory ?? ItemCategory.useful;

  List<Map<String, String>> _getSubcategories(ItemCategory category) {
    switch (category) {
      case ItemCategory.armor:
        return [
          {'key': 'head', 'label': 'Голова'},
          {'key': 'chest', 'label': 'Доспех/Тіло'},
          {'key': 'belt', 'label': 'Пояс'},
          {'key': 'legs', 'label': 'Поножі'},
          {'key': 'boots', 'label': 'Чоботи'},
          {'key': 'cloak', 'label': 'Плащ'},
          {'key': 'gloves', 'label': 'Рукавиці'},
        ];
      case ItemCategory.weapon:
        return [
          {'key': 'mainHand', 'label': 'Основна зброя'},
          {'key': 'oneHanded', 'label': 'Одноручна'},
          {'key': 'twoHanded', 'label': 'Дворучна'},
          {'key': 'offHand', 'label': 'Щит/2-е'},
          {'key': 'ranged', 'label': 'Дальнє'},
          {'key': 'backup', 'label': 'Запасна'},
        ];
      case ItemCategory.useful:
        return [
          {'key': 'focus', 'label': 'Маг. фокус'},
          {'key': 'quiver', 'label': 'Сагайдак'},
          {'key': 'tools', 'label': 'Інструменти'},
          {'key': 'book', 'label': 'Книга/Інстр.'},
          {'key': 'artifact', 'label': 'Артефакт'},
          {'key': 'scroll', 'label': 'Сувій'},
          {'key': 'extraSlot', 'label': 'Доп. слот'},
        ];
      case ItemCategory.accessory:
        return [
          {'key': 'ring', 'label': 'Кільце'},
          {'key': 'amulet', 'label': 'Амулет/Шия'},
          {'key': 'other', 'label': 'Інше'},
        ];
      case ItemCategory.potion:
      case ItemCategory.quest:
        return [];
    }
  }

  ItemCategory _categoryFromIndex(dynamic value) {
    final index = value is int ? value : int.tryParse(value?.toString() ?? '');
    if (index == null || index < 0 || index >= ItemCategory.values.length) {
      return ItemCategory.useful;
    }
    return ItemCategory.values[index];
  }

  void _startAllPressTimer(AppState state) {
    _allPressTriggered = false;
    _allPressTimer?.cancel();
    _allPressTimer = Timer(const Duration(seconds: 5), () {
      _allPressTriggered = true;
      state.update(state.fillTestInventory);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Тестовий інвентар заповнено')),
      );
    });
  }

  void _stopAllPressTimer({bool activateTap = true}) {
    _allPressTimer?.cancel();
    if (_allPressTriggered) {
      _allPressTriggered = false;
      return;
    }
    if (activateTap) {
      setState(() {
        _selectedCategory = null;
      });
    }
  }

  List<Map<String, dynamic>> get _filteredItems {
    final state = context.read<AppState>();
    if (_selectedCategory == null) return state.inventory;
    return state.inventory
        .where((i) => _categoryFromIndex(i['category']) == _selectedCategory)
        .toList();
  }

  double _totalWeight(AppState state) => state.inventory.fold(
    0.0,
    (sum, item) =>
        sum + (item['weight'] as num).toDouble() * (item['quantity'] as int),
  );

  void _showItemDialog({int? editIndex}) {
    final state = context.read<AppState>();
    final item = editIndex != null ? state.inventory[editIndex] : null;

    final nameController = TextEditingController(text: item?['name'] ?? '');
    final quantityController = TextEditingController(
      text: (item?['quantity'] ?? 1).toString(),
    );
    final weightController = TextEditingController(
      text: (item?['weight'] ?? 0).toString(),
    );
    final descController = TextEditingController(
      text: item?['description'] ?? '',
    );
    String selectedSubcategory = item?['subcategory'] ?? '';
    ItemCategory selectedCategory = item != null
        ? _categoryFromIndex(item['category'])
        : _currentAddCategory;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            editIndex != null ? 'Редагувати предмет' : 'Новий предмет',
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Категорія',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _orderedCategories.map((cat) {
                    final isSelected = selectedCategory == cat;
                    return GestureDetector(
                      onTap: () => setDialogState(() {
                        selectedCategory = cat;
                        selectedSubcategory = '';
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? cat.color.withOpacity(0.2)
                              : Colors.transparent,
                          border: Border.all(
                            color: isSelected ? cat.color : Colors.grey,
                            width: isSelected ? 1.5 : 0.5,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(cat.icon, size: 14, color: cat.color),
                            const SizedBox(width: 4),
                            Text(
                              cat.label,
                              style: TextStyle(fontSize: 12, color: cat.color),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                if (_getSubcategories(selectedCategory).isNotEmpty) ...[
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value:
                        _getSubcategories(
                          selectedCategory,
                        ).any((s) => s['key'] == selectedSubcategory)
                        ? selectedSubcategory
                        : null,
                    decoration: const InputDecoration(
                      labelText: 'Підкатегорія',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: _getSubcategories(selectedCategory)
                        .map(
                          (s) => DropdownMenuItem(
                            value: s['key'],
                            child: Text(s['label']!),
                          ),
                        )
                        .toList(),
                    onChanged: (v) =>
                        setDialogState(() => selectedSubcategory = v ?? ''),
                  ),
                ],
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Назва',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 50,
                  autofocus: editIndex == null,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: quantityController,
                        decoration: const InputDecoration(
                          labelText: 'Кількість',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: weightController,
                        decoration: const InputDecoration(
                          labelText: 'Вага (кг)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d{0,3}\.?\d{0,2}'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'Опис (необов\'язково)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  maxLength: 200,
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
                  state.update(() => state.inventory.removeAt(editIndex));
                  Navigator.pop(context);
                },
                child: Text(
                  'Видалити',
                  style: TextStyle(color: Colors.red.shade400),
                ),
              ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty) return;
                final newItem = {
                  'name': nameController.text.trim(),
                  'quantity': int.tryParse(quantityController.text) ?? 1,
                  'weight': double.tryParse(weightController.text) ?? 0.0,
                  'description': descController.text.trim(),
                  'isEquipped': item?['isEquipped'] ?? false,
                  'category': selectedCategory.index,
                  'subcategory': selectedSubcategory,
                };
                state.update(() {
                  if (editIndex != null) {
                    state.inventory[editIndex] = newItem;
                  } else {
                    state.inventory.add(newItem);
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

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final totalWeight = _totalWeight(state);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr(context, 'inventory')),
        centerTitle: true,
        actions: settingsAction(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showItemDialog(),
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWallet(state),
            const SizedBox(height: 16),
            _buildWeightBar(totalWeight),
            const SizedBox(height: 16),
            _buildCategoryFilter(state),
            const SizedBox(height: 12),
            _buildItemsList(state),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _allPressTimer?.cancel();
    super.dispose();
  }

  Widget _buildWallet(AppState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Гаманець',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCoin(
                  'МД',
                  state.copper,
                  Colors.brown.shade400,
                  (v) => state.update(() => state.copper = v),
                ),
                _buildCoin(
                  'СД',
                  state.silver,
                  Colors.grey.shade400,
                  (v) => state.update(() => state.silver = v),
                ),
                _buildCoin(
                  'ЗД',
                  state.gold,
                  Colors.amber.shade400,
                  (v) => state.update(() => state.gold = v),
                ),
                _buildCoin(
                  'ПД',
                  state.platinum,
                  Colors.cyan.shade300,
                  (v) => state.update(() => state.platinum = v),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoin(
    String label,
    int value,
    Color color,
    Function(int) onChanged,
  ) {
    final controller = TextEditingController(text: value.toString());
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color,
          radius: 20,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 64,
          child: TextField(
            controller: controller,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(7),
            ],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            ),
            onChanged: (v) => onChanged(int.tryParse(v) ?? 0),
          ),
        ),
      ],
    );
  }

  Widget _buildWeightBar(double totalWeight) {
    const maxWeight = 50.0;
    final ratio = (totalWeight / maxWeight).clamp(0.0, 1.0);
    final isOverloaded = totalWeight > maxWeight;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Вага',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${totalWeight.toStringAsFixed(1)} / $maxWeight кг',
                  style: TextStyle(
                    fontSize: 14,
                    color: isOverloaded ? Colors.red : Colors.grey,
                    fontWeight: isOverloaded ? FontWeight.bold : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 10,
                backgroundColor: Colors.grey.shade800,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isOverloaded ? Colors.red : Colors.green,
                ),
              ),
            ),
            if (isOverloaded)
              const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text(
                  'Перевантажений!',
                  style: TextStyle(color: Colors.red, fontSize: 13),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(AppState state) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildAllFilterChip(state),
          const SizedBox(width: 8),
          ..._orderedCategories.map(
            (cat) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildFilterChip(
                cat,
                cat.label,
                cat.icon,
                color: cat.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    ItemCategory? cat,
    String label,
    IconData icon, {
    Color? color,
    VoidCallback? onTap,
  }) {
    final isSelected = _selectedCategory == cat;
    final chipColor = color ?? Colors.grey;
    return GestureDetector(
      onTap:
          onTap ??
          () {
            setState(() {
              _selectedCategory = isSelected ? null : cat;
              if (_selectedCategory != null) {
                _lastSelectedCategory = _selectedCategory;
              }
            });
          },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? chipColor.withOpacity(0.2) : Colors.transparent,
          border: Border.all(
            color: isSelected ? chipColor : Colors.grey.shade700,
            width: isSelected ? 1.5 : 0.5,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: isSelected ? chipColor : Colors.grey),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isSelected ? chipColor : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllFilterChip(AppState state) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _startAllPressTimer(state),
      onTapUp: (_) => _stopAllPressTimer(activateTap: !_allPressTriggered),
      onTapCancel: () => _stopAllPressTimer(activateTap: false),
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: _buildFilterChip(
          null,
          'Всі',
          Icons.apps,
          color: Colors.grey,
          onTap: () {
            setState(() {
              _selectedCategory = null;
            });
          },
        ),
      ),
    );
  }

  Widget _buildItemsList(AppState state) {
    final items = _filteredItems;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedCategory?.label ?? 'Всі предмети',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '${items.length} шт.',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (items.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'Тут порожньо\nНатисни + щоб додати предмет',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final realIndex = state.inventory.indexOf(item);
              final cat = _categoryFromIndex(item['category']);
              final isEquipped = item['isEquipped'] as bool;
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: GestureDetector(
                    onTap: () => state.update(
                      () => state.inventory[realIndex]['isEquipped'] =
                          !isEquipped,
                    ),
                    child: CircleAvatar(
                      backgroundColor: isEquipped
                          ? cat.color.withOpacity(0.3)
                          : Colors.grey.shade800,
                      child: Icon(
                        cat.icon,
                        size: 18,
                        color: isEquipped ? cat.color : Colors.grey,
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item['name'],
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      if (isEquipped)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: cat.color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'екіп.',
                            style: TextStyle(fontSize: 10, color: cat.color),
                          ),
                        ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'x${item['quantity']} · ${item['weight']} кг · ${((item['weight'] as num).toDouble() * (item['quantity'] as int)).toStringAsFixed(1)} кг загалом',
                      ),
                      if ((item['description'] as String).isNotEmpty)
                        Text(
                          item['description'],
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  onTap: () => _showItemDialog(editIndex: realIndex),
                  isThreeLine: (item['description'] as String).isNotEmpty,
                ),
              );
            },
          ),
      ],
    );
  }
}
