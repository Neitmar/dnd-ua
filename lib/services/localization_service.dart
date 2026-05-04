import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';

const Map<String, Map<String, String>> _strings = {
  'uk': {
    'settings': 'Налаштування',
    'language': 'Мова',
    'english': 'Англійська',
    'russian': 'Російська',
    'ukrainian': 'Українська',
    'googleAccount': 'Підключити Google акаунт',
    'shareCharacter': 'Поділитися персонажем',
    'printPdf': 'Роздрукувати PDF файл',
    'shareLink': 'Посилання на персонажа',
    'close': 'Закрити',
    'comingSoon': 'Скоро буде доступно',
    'character': 'Персонаж',
    'armory': 'Арморі',
    'combat': 'Бойові',
    'spells': 'Заклинання',
    'abilities': 'Вміння',
    'inventory': 'Інвентар',
    'dice': 'Кубики',
  },
  'ru': {
    'settings': 'Настройки',
    'language': 'Язык',
    'english': 'Английский',
    'russian': 'Русский',
    'ukrainian': 'Украинский',
    'googleAccount': 'Подключить Google аккаунт',
    'shareCharacter': 'Поделиться персонажем',
    'printPdf': 'Распечатать PDF файл',
    'shareLink': 'Ссылка на персонажа',
    'close': 'Закрыть',
    'comingSoon': 'Скоро будет доступно',
    'character': 'Персонаж',
    'armory': 'Армори',
    'combat': 'Боевые',
    'spells': 'Заклинания',
    'abilities': 'Умения',
    'inventory': 'Инвентарь',
    'dice': 'Кубики',
  },
  'en': {
    'settings': 'Settings',
    'language': 'Language',
    'english': 'English',
    'russian': 'Russian',
    'ukrainian': 'Ukrainian',
    'googleAccount': 'Connect Google account',
    'shareCharacter': 'Share character',
    'printPdf': 'Print PDF file',
    'shareLink': 'Character link',
    'close': 'Close',
    'comingSoon': 'Coming soon',
    'character': 'Character',
    'armory': 'Armory',
    'combat': 'Combat',
    'spells': 'Spells',
    'abilities': 'Abilities',
    'inventory': 'Inventory',
    'dice': 'Dice',
  },
};

String tr(BuildContext context, String key) {
  final code = context.watch<AppState>().languageCode;
  return _strings[code]?[key] ?? _strings['uk']![key] ?? key;
}

String trRead(BuildContext context, String key) {
  final code = context.read<AppState>().languageCode;
  return _strings[code]?[key] ?? _strings['uk']![key] ?? key;
}
