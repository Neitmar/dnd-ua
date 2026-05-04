import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../providers/app_state.dart';
import '../services/localization_service.dart';

/// Хелпер для использования переводов в UI
class TranslationHelper {
  /// Получить переведенное значение для класса
  static String translateClass(
    BuildContext context,
    String classKey,
    String fieldName,
    String defaultValue,
  ) {
    final language = context.read<AppState>().language;
    if (language == 'uk') return defaultValue;

    final translationKey = 'classes_${classKey}_$fieldName';
    return LocalizationService.translate(
      translationKey,
      language,
      defaultValue: defaultValue,
    );
  }

  /// Получить переведенное значение для расы
  static String translateRace(
    BuildContext context,
    String raceKey,
    String fieldName,
    String defaultValue,
  ) {
    final language = context.read<AppState>().language;
    if (language == 'uk') return defaultValue;

    final translationKey = 'races_${raceKey}_$fieldName';
    return LocalizationService.translate(
      translationKey,
      language,
      defaultValue: defaultValue,
    );
  }

  /// Получить переведенное значение для предмета
  static String translateItem(
    BuildContext context,
    String itemKey,
    String fieldName,
    String defaultValue,
  ) {
    final language = context.read<AppState>().language;
    if (language == 'uk') return defaultValue;

    final translationKey = 'items_${itemKey}_$fieldName';
    return LocalizationService.translate(
      translationKey,
      language,
      defaultValue: defaultValue,
    );
  }

  /// Получить переведенное значение для UI элемента
  static String translateUI(
    BuildContext context,
    String uiKey,
    String defaultValue,
  ) {
    final language = context.read<AppState>().language;
    if (language == 'uk') return defaultValue;

    final translationKey = 'ui_$uiKey';
    return LocalizationService.translate(
      translationKey,
      language,
      defaultValue: defaultValue,
    );
  }

  /// Получить переведенное значение для заклинания
  static String translateSpell(
    BuildContext context,
    String spellKey,
    String fieldName,
    String defaultValue,
  ) {
    final language = context.read<AppState>().language;
    if (language == 'uk') return defaultValue;

    final translationKey = 'spells_${spellKey}_$fieldName';
    return LocalizationService.translate(
      translationKey,
      language,
      defaultValue: defaultValue,
    );
  }
}
