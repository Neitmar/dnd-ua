const int _categoryArmor = 1;
const int _categoryWeapon = 2;
const int _categoryUseful = 3;

Map<String, dynamic> _startingItem(
  String name,
  String type, {
  int quantity = 1,
  double weight = 0.0,
  String description = '',
  String subcategory = '',
}) {
  final category = switch (type) {
    'armor' => _categoryArmor,
    'weapon' => _categoryWeapon,
    _ => _categoryUseful,
  };

  return {
    'name': name,
    'quantity': quantity,
    'weight': weight,
    'description': description,
    'isEquipped': false,
    'category': category,
    'subcategory': subcategory,
  };
}

List<Map<String, dynamic>> getStartingItemsForClass(String className) {
  switch (className) {
    case 'Воїн':
      return [
        _startingItem(
          'Латний обладунок',
          'armor',
          weight: 65,
          subcategory: 'chest',
        ),
        _startingItem(
          'Довгий меч',
          'weapon',
          weight: 3,
          subcategory: 'mainHand',
        ),
        _startingItem('Щит', 'weapon', weight: 6, subcategory: 'offHand'),
        _startingItem(
          'Легкий арбалет',
          'weapon',
          weight: 5,
          subcategory: 'ranged',
        ),
        _startingItem(
          'Болти',
          'item',
          quantity: 20,
          weight: 0.03,
          subcategory: 'quiver',
        ),
        _startingItem(
          'Експлорерський пак',
          'item',
          weight: 5,
          subcategory: 'extraSlot',
        ),
      ];
    case 'Маг':
      return [
        _startingItem('Кинджал', 'weapon', weight: 1, subcategory: 'backup'),
        _startingItem(
          'Компонентна сумка',
          'item',
          weight: 2,
          subcategory: 'focus',
        ),
        _startingItem(
          'Вчений пак',
          'item',
          weight: 5,
          subcategory: 'extraSlot',
        ),
        _startingItem(
          'Заклинання книга',
          'item',
          weight: 3,
          subcategory: 'book',
        ),
      ];
    case 'Жрець':
      return [
        _startingItem(
          'Латний обладунок',
          'armor',
          weight: 55,
          subcategory: 'chest',
        ),
        _startingItem('Булава', 'weapon', weight: 4, subcategory: 'mainHand'),
        _startingItem('Щит', 'weapon', weight: 6, subcategory: 'offHand'),
        _startingItem(
          'Священний символ',
          'item',
          weight: 1,
          subcategory: 'focus',
        ),
        _startingItem(
          'Жрецький пак',
          'item',
          weight: 5,
          subcategory: 'extraSlot',
        ),
      ];
    case 'Розбійник':
      return [
        _startingItem(
          'Шкіряний обладунок',
          'armor',
          weight: 10,
          subcategory: 'chest',
        ),
        _startingItem(
          'Кинджал',
          'weapon',
          quantity: 2,
          weight: 1,
          subcategory: 'backup',
        ),
        _startingItem(
          'Воринські інструменти',
          'item',
          weight: 1,
          subcategory: 'tools',
        ),
        _startingItem(
          'Короткий лук',
          'weapon',
          weight: 2,
          subcategory: 'ranged',
        ),
        _startingItem(
          'Стріли',
          'item',
          quantity: 20,
          weight: 0.05,
          subcategory: 'quiver',
        ),
        _startingItem(
          'Експлорерський пак',
          'item',
          weight: 5,
          subcategory: 'extraSlot',
        ),
      ];
    case 'Варвар':
      return [
        _startingItem(
          'Експлорерський обладунок',
          'armor',
          weight: 10,
          subcategory: 'chest',
        ),
        _startingItem(
          'Велика сокира',
          'weapon',
          weight: 7,
          subcategory: 'twoHanded',
        ),
        _startingItem(
          'Ручна сокира',
          'weapon',
          quantity: 2,
          weight: 2,
          subcategory: 'backup',
        ),
        _startingItem(
          'Експлорерський пак',
          'item',
          weight: 5,
          subcategory: 'extraSlot',
        ),
      ];
    case 'Бард':
      return [
        _startingItem(
          'Шкіряний обладунок',
          'armor',
          weight: 10,
          subcategory: 'chest',
        ),
        _startingItem('Рапіра', 'weapon', weight: 2, subcategory: 'mainHand'),
        _startingItem('Довгий лук', 'weapon', weight: 2, subcategory: 'ranged'),
        _startingItem(
          'Стріли',
          'item',
          quantity: 20,
          weight: 0.05,
          subcategory: 'quiver',
        ),
        _startingItem(
          'Розбійницький пак',
          'item',
          weight: 5,
          subcategory: 'extraSlot',
        ),
        _startingItem('Лютня', 'item', weight: 2, subcategory: 'tools'),
      ];
    case 'Паладін':
      return [
        _startingItem(
          'Латний обладунок',
          'armor',
          weight: 65,
          subcategory: 'chest',
        ),
        _startingItem('Щит', 'weapon', weight: 6, subcategory: 'offHand'),
        _startingItem(
          'Довгий меч',
          'weapon',
          weight: 3,
          subcategory: 'mainHand',
        ),
        _startingItem('Булава', 'weapon', weight: 4, subcategory: 'backup'),
        _startingItem(
          'Священний символ',
          'item',
          weight: 1,
          subcategory: 'focus',
        ),
        _startingItem(
          'Жрецький пак',
          'item',
          weight: 5,
          subcategory: 'extraSlot',
        ),
      ];
    case 'Друїд':
      return [
        _startingItem(
          'Шкіряний обладунок',
          'armor',
          weight: 10,
          subcategory: 'chest',
        ),
        _startingItem(
          'Дерев\'яний щит',
          'weapon',
          weight: 6,
          subcategory: 'offHand',
        ),
        _startingItem('Клуба', 'weapon', weight: 2, subcategory: 'mainHand'),
        _startingItem(
          'Друїдичний фокус',
          'item',
          weight: 1,
          subcategory: 'focus',
        ),
        _startingItem(
          'Експлорерський пак',
          'item',
          weight: 5,
          subcategory: 'extraSlot',
        ),
      ];
    case 'Монах':
      return [
        _startingItem(
          'Короткий меч',
          'weapon',
          weight: 2,
          subcategory: 'mainHand',
        ),
        _startingItem(
          'Дартс',
          'weapon',
          quantity: 10,
          weight: 0.25,
          subcategory: 'ranged',
        ),
        _startingItem(
          'Експлорерський пак',
          'item',
          weight: 5,
          subcategory: 'extraSlot',
        ),
      ];
    case 'Слідопит':
      return [
        _startingItem(
          'Шкіряний обладунок',
          'armor',
          weight: 10,
          subcategory: 'chest',
        ),
        _startingItem(
          'Кинджал',
          'weapon',
          quantity: 2,
          weight: 1,
          subcategory: 'backup',
        ),
        _startingItem('Довгий лук', 'weapon', weight: 2, subcategory: 'ranged'),
        _startingItem(
          'Стріли',
          'item',
          quantity: 20,
          weight: 0.05,
          subcategory: 'quiver',
        ),
        _startingItem(
          'Експлорерський пак',
          'item',
          weight: 5,
          subcategory: 'extraSlot',
        ),
      ];
    case 'Чаклун':
      return [
        _startingItem(
          'Легкий обладунок',
          'armor',
          weight: 10,
          subcategory: 'chest',
        ),
        _startingItem(
          'Кинджал',
          'weapon',
          quantity: 2,
          weight: 1,
          subcategory: 'backup',
        ),
        _startingItem(
          'Компонентна сумка',
          'item',
          weight: 2,
          subcategory: 'focus',
        ),
        _startingItem(
          'Вчений пак',
          'item',
          weight: 5,
          subcategory: 'extraSlot',
        ),
        _startingItem(
          'Заклинання книга',
          'item',
          weight: 3,
          subcategory: 'book',
        ),
      ];
    case 'Чародій':
      return [
        _startingItem('Кинджал', 'weapon', weight: 1, subcategory: 'backup'),
        _startingItem(
          'Експлорерський пак',
          'item',
          weight: 5,
          subcategory: 'extraSlot',
        ),
        _startingItem(
          'Заклинання книга',
          'item',
          weight: 3,
          subcategory: 'book',
        ),
      ];
    default:
      return [];
  }
}

int getStartingGold(String className) {
  return 100; // Simplified, all classes start with 100 gold
}
