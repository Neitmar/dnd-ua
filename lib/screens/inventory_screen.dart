import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../constants/app_assets.dart';
import '../providers/app_state.dart';

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

  /// PNG-шлях залежно від теми: isLightTheme=true → темні іконки на світлому фоні
  String iconPath(bool isLightTheme) {
    final prefix = isLightTheme
        ? 'assets/icons/dark-theme-'
        : 'assets/icons/light-theme-';
    switch (this) {
      case ItemCategory.potion:    return '${prefix}potions.png';
      case ItemCategory.armor:     return '${prefix}armors.png';
      case ItemCategory.weapon:    return '${prefix}weapons.png';
      case ItemCategory.useful:    return '${prefix}useful.png';
      case ItemCategory.quest:     return '${prefix}quest.png';
      case ItemCategory.accessory: return '${prefix}accessories.png';
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

/// PNG-іконка категорії інвентаря, що автоматично обирає варіант для поточної теми.
class CategoryIcon extends StatelessWidget {
  final ItemCategory category;
  final double size;

  const CategoryIcon({
    super.key,
    required this.category,
    this.size = 14,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = context.watch<AppState>().isLightTheme;
    return Image.asset(
      category.iconPath(isLight),
      width: size,
      height: size,
    );
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
                              ? cat.color.withAlpha((0.2 * 255).round())
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
                            CategoryIcon(category: cat, size: 14),
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
                    initialValue:
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

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
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
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            onPressed: () => _showItemDialog(),
            child: const Icon(Icons.add),
          ),
        ),
      ],
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildCoin('МД', state.copper, const Color(0xFFB87333), (v) => state.update(() => state.copper = v), AppAssets.coinCopper)),
                const SizedBox(width: 4),
                Expanded(child: _buildCoin('СД', state.silver, const Color(0xFFC0C0C0), (v) => state.update(() => state.silver = v), AppAssets.coinSilver)),
                const SizedBox(width: 4),
                Expanded(child: _buildCoin('ЕД', state.electrum, const Color(0xFFE8E8AD), (v) => state.update(() => state.electrum = v), AppAssets.coinElectrum)),
                const SizedBox(width: 4),
                Expanded(child: _buildCoin('ЗД', state.gold, const Color(0xFFFFD700), (v) => state.update(() => state.gold = v), AppAssets.coinGold)),
                const SizedBox(width: 4),
                Expanded(child: _buildCoin('ПД', state.platinum, const Color(0xFFE5E4E2), (v) => state.update(() => state.platinum = v), AppAssets.coinPlatinum)),
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
    String iconPath,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(child: SvgPicture.asset(iconPath, width: 36, height: 36)),
        const SizedBox(height: 6),
        TextFormField(
          key: ValueKey('${label}_$value'),
          initialValue: value.toString(),
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(7),
          ],
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          ),
          onChanged: (v) => onChanged(int.tryParse(v) ?? 0),
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
                    color: isOverloaded ? Colors.red : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.75),
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
                backgroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.15),
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
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        children: [
          _buildAllFilterChip(state),
          ..._orderedCategories.map(
            (cat) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildFilterChip(cat, cat.label, cat.icon, color: cat.color),
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
    final isLight = context.read<AppState>().isLightTheme;
    final leadingIcon = cat != null
        ? CategoryIcon(category: cat, size: 14)
        : Image.asset(AppAssets.invIconAll(isLight), width: 14, height: 14);
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
          color: isSelected ? chipColor.withAlpha((0.18 * 255).round()) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            leadingIcon,
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isSelected ? chipColor : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllFilterChip(AppState state) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (_) => _startAllPressTimer(state),
      onTapUp: (_) => _stopAllPressTimer(activateTap: !_allPressTriggered),
      onTapCancel: () => _stopAllPressTimer(activateTap: false),
      // Скасовуємо таймер якщо користувач почав горизонтальний скрол
      onHorizontalDragStart: (_) => _stopAllPressTimer(activateTap: false),
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
              style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.75)),
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
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 15),
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
                          ? cat.color.withAlpha((0.3 * 255).round())
                          : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12),
                      child: Icon(
                        cat.icon,
                        size: 18,
                        color: isEquipped ? cat.color : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
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
                            color: cat.color.withAlpha((0.2 * 255).round()),
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
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.75),
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
