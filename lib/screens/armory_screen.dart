import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../providers/app_state.dart';
import '../services/localization_service.dart';
import '../widgets/settings_dialog.dart';

class ArmoryScreen extends StatelessWidget {
  const ArmoryScreen({super.key});

  static const int _maxRingsPerHand = 5;
  static const String _ringSeparator = '\x1F';

  // Назви слотів
  static const Map<String, String> _slotLabels = {
    'head': 'Голова',
    'neck': 'Шия/Амулет',
    'chest': 'Доспех',
    'belt': 'Пояс',
    'legs': 'Поножі',
    'boots': 'Чоботи',
    'cloak': 'Плащ',
    'mainHand': 'Осн. зброя',
    'offHand': 'Щит/2-е',
    'ranged': 'Дальнє',
    'gloves': 'Рукавиці',
    'ring1': 'Кільце Л',
    'ring2': 'Кільце П',
    'extraSlot': 'Доп. слот',
    'backup': 'Запасна',
    'quiver': 'Сагайдак',
    'focus': 'Маг. фокус',
    'tools': 'Інструменти',
    'book': 'Книга',
    'artifact1': 'Артефакт 1',
    'artifact2': 'Артефакт 2',
    'artifact3': 'Артефакт 3',
    'artifact4': 'Артефакт 4',
    'potion1': 'Зілля 1',
    'potion2': 'Зілля 2',
    'scroll': 'Сувій',
  };

  // Які предмети з інвентарю підходять для кожного слоту
  static const Map<String, int> _slotCategory = {
    'head': 1, // броня
    'neck': 5, // аксесуари
    'chest': 1,
    'belt': 1,
    'legs': 1,
    'boots': 1,
    'cloak': 1,
    'mainHand': 2, // зброя
    'offHand': 2,
    'ranged': 2,
    'gloves': 1,
    'ring1': 5,
    'ring2': 5,
    'extraSlot': 3,
    'backup': 2,
    'quiver': 3,
    'focus': 3,
    'tools': 3,
    'book': 3,
    'artifact1': 3,
    'artifact2': 3,
    'artifact3': 3,
    'artifact4': 3,
    'potion1': 0, // зілля
    'potion2': 0,
    'scroll': 3,
  };

  static const Map<String, List<String>> _slotSubcategories = {
    'head': ['head'],
    'neck': ['amulet'],
    'chest': ['chest'],
    'belt': ['belt'],
    'legs': ['legs'],
    'boots': ['boots'],
    'cloak': ['cloak'],
    'mainHand': ['mainHand', 'oneHanded', 'twoHanded'],
    'offHand': ['offHand', 'oneHanded'],
    'ranged': ['ranged'],
    'gloves': ['gloves'],
    'ring1': ['ring'],
    'ring2': ['ring'],
    'extraSlot': ['extraSlot'],
    'backup': ['backup'],
    'quiver': ['quiver'],
    'focus': ['focus'],
    'tools': ['tools'],
    'book': ['book'],
    'artifact1': ['artifact'],
    'artifact2': ['artifact'],
    'artifact3': ['artifact'],
    'artifact4': ['artifact'],
    'scroll': ['scroll'],
  };

  bool _matchesSlot(Map<String, dynamic> item, String slotKey) {
    final category = _slotCategory[slotKey] ?? 3;
    final subcategories = _slotSubcategories[slotKey];

    if (_itemCategoryIndex(item) != category) return false;
    if (subcategories == null) return true;

    return subcategories.contains(item['subcategory']);
  }

  int? _itemCategoryIndex(Map<String, dynamic> item) {
    final value = item['category'];
    return value is int ? value : int.tryParse(value?.toString() ?? '');
  }

  Map<String, dynamic>? _inventoryItemByName(AppState state, String? name) {
    if (name == null || name.isEmpty) return null;

    for (final item in state.inventory) {
      if (item['name']?.toString() == name) return item;
    }

    return null;
  }

  bool _isTwoHandedMainEquipped(AppState state) {
    final mainHandItem = _inventoryItemByName(
      state,
      state.equipment['mainHand'],
    );

    return mainHandItem?['subcategory'] == 'twoHanded';
  }

  bool _isSlotBlocked(AppState state, String slotKey) {
    return slotKey == 'offHand' && _isTwoHandedMainEquipped(state);
  }

  bool _isRingSlot(String slotKey) => slotKey == 'ring1' || slotKey == 'ring2';

  List<String> _equippedItems(String? value, String slotKey) {
    if (value == null || value.isEmpty) return [];
    if (!_isRingSlot(slotKey)) return [value];

    return value
        .split(_ringSeparator)
        .where((name) => name.trim().isNotEmpty)
        .toList();
  }

  String? _encodeRingItems(Iterable<String> items) {
    final names = items.where((name) => name.trim().isNotEmpty).toList();
    if (names.isEmpty) return null;

    return names.join(_ringSeparator);
  }

  void _clearItemFromOtherSlots(
    AppState state,
    String slotKey,
    String itemName,
  ) {
    for (final key in state.equipment.keys.toList()) {
      if (key != slotKey && state.equipment[key] == itemName) {
        state.equipment[key] = null;
      }
    }
  }

  String _slotItemLabel(String slotKey, String value) {
    final items = _equippedItems(value, slotKey);
    if (!_isRingSlot(slotKey)) return value;
    if (items.length == 1) return items.first;

    return '${items.length}/$_maxRingsPerHand: ${items.join(', ')}';
  }

  void _showSlotPicker(BuildContext context, AppState state, String slotKey) {
    if (_isSlotBlocked(state, slotKey)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Слот Щит/2-е заблокований, доки споряджена дворучна зброя',
          ),
        ),
      );
      return;
    }

    final items = state.inventory
        .where((item) => _matchesSlot(item, slotKey))
        .toList();
    final isRingSlot = _isRingSlot(slotKey);
    final selectedRings = _equippedItems(
      state.equipment[slotKey],
      slotKey,
    ).toSet();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A0A2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.75,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      _slotLabels[slotKey] ?? slotKey,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  if (isRingSlot)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 2),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Обрано ${selectedRings.length}/$_maxRingsPerHand',
                          style: TextStyle(color: Colors.grey.shade400),
                        ),
                      ),
                    ),
                  if (items.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(32),
                      child: Text(
                        'Немає підходящих предметів в інвентарі',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    ...items.map((item) {
                      final itemName = item['name']?.toString() ?? '';
                      final isSelected = isRingSlot
                          ? selectedRings.contains(itemName)
                          : state.equipment[slotKey] == itemName;

                      if (isRingSlot) {
                        return CheckboxListTile(
                          value: isSelected,
                          title: Text(itemName),
                          subtitle: Text('${item['weight']} кг'),
                          activeColor: Colors.amber,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (_) {
                            if (!isSelected &&
                                selectedRings.length >= _maxRingsPerHand) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'На одну руку можна одягнути максимум 5 кілець',
                                  ),
                                ),
                              );
                              return;
                            }

                            setSheetState(() {
                              if (isSelected) {
                                selectedRings.remove(itemName);
                              } else {
                                selectedRings.add(itemName);
                              }

                              state.update(
                                () => state.equipment[slotKey] =
                                    _encodeRingItems(selectedRings),
                              );
                            });
                          },
                        );
                      }

                      return ListTile(
                        title: Text(itemName),
                        subtitle: Text('${item['weight']} кг'),
                        trailing: isSelected
                            ? const Icon(
                                Icons.check_circle,
                                color: Colors.amber,
                              )
                            : null,
                        onTap: () {
                          state.update(() {
                            if (isSelected) {
                              state.equipment[slotKey] = null;
                            } else {
                              if (!_isRingSlot(slotKey)) {
                                _clearItemFromOtherSlots(
                                  state,
                                  slotKey,
                                  itemName,
                                );
                              }
                              state.equipment[slotKey] = itemName;
                              if (slotKey == 'mainHand' &&
                                  item['subcategory'] == 'twoHanded') {
                                state.equipment['offHand'] = null;
                              }
                            }
                          });
                          Navigator.pop(context);
                        },
                      );
                    }),
                  ListTile(
                    leading: const Icon(Icons.clear, color: Colors.red),
                    title: Text(
                      isRingSlot ? 'Зняти всі кільця' : 'Зняти предмет',
                      style: const TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      state.update(() => state.equipment[slotKey] = null);
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSlot(
    BuildContext context,
    AppState state,
    String slotKey, {
    double? width,
  }) {
    final label = _slotLabels[slotKey] ?? slotKey;
    final item = state.equipment[slotKey];
    final isEquipped = item != null;
    final isBlocked = _isSlotBlocked(state, slotKey);

    return GestureDetector(
      onTap: () => _showSlotPicker(context, state, slotKey),
      child: Container(
        width: width ?? 90,
        height: 56,
        decoration: BoxDecoration(
          color: isBlocked
              ? Colors.red.withOpacity(0.14)
              : isEquipped
              ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
              : Colors.black.withOpacity(0.3),
          border: Border.all(
            color: isBlocked
                ? Colors.red.withOpacity(0.5)
                : isEquipped
                ? Theme.of(context).colorScheme.primary
                : Colors.amber.withOpacity(0.4),
            width: isEquipped ? 1.5 : 0.5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                color: Colors.amber.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (isBlocked) ...[
              const SizedBox(height: 2),
              const Text(
                'Заблок.',
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ] else if (isEquipped) ...[
              const SizedBox(height: 2),
              Text(
                _slotItemLabel(slotKey, item),
                style: const TextStyle(
                  fontSize: 9,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ] else
              Icon(Icons.add, size: 14, color: Colors.amber.withOpacity(0.4)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final screenW = MediaQuery.of(context).size.width;
    final slotW = (screenW - 48) / 3 - 4;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr(context, 'armory')),
        centerTitle: true,
        actions: settingsAction(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // --- Головна секція з силуетом ---
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const Text(
                      'Екіпіровка',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- Ліва колонка ---
                        Column(
                          children: [
                            _buildSlot(context, state, 'cloak', width: slotW),
                            const SizedBox(height: 6),
                            _buildSlot(
                              context,
                              state,
                              'mainHand',
                              width: slotW,
                            ),
                            const SizedBox(height: 6),
                            _buildSlot(context, state, 'offHand', width: slotW),
                            const SizedBox(height: 6),
                            _buildSlot(context, state, 'ranged', width: slotW),
                            const SizedBox(height: 6),
                            _buildSlot(context, state, 'gloves', width: slotW),
                            const SizedBox(height: 6),
                            _buildSlot(context, state, 'ring1', width: slotW),
                            const SizedBox(height: 6),
                            _buildSlot(
                              context,
                              state,
                              'extraSlot',
                              width: slotW,
                            ),
                          ],
                        ),
                        const SizedBox(width: 6),
                        // --- Центр — силует ---
                        Expanded(
                          child: Column(
                            children: [
                              _buildSlot(
                                context,
                                state,
                                'head',
                                width: double.infinity,
                              ),
                              const SizedBox(height: 6),
                              _buildSlot(
                                context,
                                state,
                                'neck',
                                width: double.infinity,
                              ),
                              const SizedBox(height: 6),
                              SvgPicture.asset(
                                'assets/character_silhouette.svg',
                                height: 140,
                              ),
                              const SizedBox(height: 6),
                              _buildSlot(
                                context,
                                state,
                                'chest',
                                width: double.infinity,
                              ),
                              const SizedBox(height: 6),
                              _buildSlot(
                                context,
                                state,
                                'belt',
                                width: double.infinity,
                              ),
                              const SizedBox(height: 6),
                              _buildSlot(
                                context,
                                state,
                                'legs',
                                width: double.infinity,
                              ),
                              const SizedBox(height: 6),
                              _buildSlot(
                                context,
                                state,
                                'boots',
                                width: double.infinity,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        // --- Права колонка ---
                        Column(
                          children: [
                            _buildSlot(context, state, 'backup', width: slotW),
                            const SizedBox(height: 6),
                            _buildSlot(context, state, 'quiver', width: slotW),
                            const SizedBox(height: 6),
                            _buildSlot(context, state, 'focus', width: slotW),
                            const SizedBox(height: 6),
                            _buildSlot(context, state, 'tools', width: slotW),
                            const SizedBox(height: 6),
                            _buildSlot(context, state, 'book', width: slotW),
                            const SizedBox(height: 6),
                            _buildSlot(context, state, 'ring2', width: slotW),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- Артефакти, Зілля, Сувій ---
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Артефакти та витратне',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSlot(context, state, 'artifact1'),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: _buildSlot(context, state, 'artifact2'),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: _buildSlot(context, state, 'artifact3'),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: _buildSlot(context, state, 'artifact4'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(child: _buildSlot(context, state, 'potion1')),
                        const SizedBox(width: 6),
                        Expanded(child: _buildSlot(context, state, 'potion2')),
                        const SizedBox(width: 6),
                        Expanded(child: _buildSlot(context, state, 'scroll')),
                        const SizedBox(width: 6),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
