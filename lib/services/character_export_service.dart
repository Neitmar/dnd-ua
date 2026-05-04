import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../providers/app_state.dart';

class CharacterExportService {
  /// Экспортировать персонажа как JSON (для ссылки)
  static String exportAsJson(AppState state) {
    return jsonEncode({
      'name': state.name,
      'characterClass': state.characterClass,
      'race': state.race,
      'gender': state.gender,
      'level': state.level,
      'stats': state.stats,
      'maxHp': state.maxHp,
      'currentHp': state.currentHp,
      'tempHp': state.tempHp,
      'proficientSkills': state.proficientSkills.toList(),
      'expertiseSkills': state.expertiseSkills.toList(),
      'armorClass': state.armorClass,
      'initiative': state.initiative,
      'speed': state.speed,
      'weapons': state.weapons,
      'inventory': state.inventory,
      'copper': state.copper,
      'silver': state.silver,
      'gold': state.gold,
      'platinum': state.platinum,
      'spellSlots': state.spellSlots,
    });
  }

  /// Экспортировать персонажа как URL-safe строка (для ссылки)
  static String exportAsEncodedUrl(AppState state) {
    final json = exportAsJson(state);
    final encoded = base64Url.encode(utf8.encode(json));
    return 'dnd-ua://character/$encoded';
  }

  /// Импортировать персонажа из JSON
  static Map<String, dynamic>? importFromJson(String jsonString) {
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error importing character: $e');
      return null;
    }
  }

  /// Импортировать персонажа из URL-safe строки
  static Map<String, dynamic>? importFromEncodedUrl(String encoded) {
    try {
      final decoded = utf8.decode(base64Url.decode(encoded));
      return jsonDecode(decoded) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error importing from URL: $e');
      return null;
    }
  }

  /// Сгенерировать текстовый файл для PDF
  static String generateCharacterSheet(AppState state) {
    final buffer = StringBuffer();

    buffer.writeln('═══════════════════════════════════════════');
    buffer.writeln('       АРКУШ ПЕРСОНАЖА D&D 5e');
    buffer.writeln('═══════════════════════════════════════════\n');

    // Основна інформація
    buffer.writeln('ОСНОВНА ІНФОРМАЦІЯ');
    buffer.writeln('─────────────────────────────────────────');
    buffer.writeln('Ім\'я: ${state.name}');
    buffer.writeln('Клас: ${state.characterClass}');
    buffer.writeln('Раса: ${state.race}');
    buffer.writeln('Стать: ${state.gender ?? 'Не вибрано'}');
    buffer.writeln('Рівень: ${state.level}');
    buffer.writeln('');

    // Здоров'я
    buffer.writeln('ЗДОРОВ\'Я');
    buffer.writeln('─────────────────────────────────────────');
    buffer.writeln('Макс ХП: ${state.maxHp}');
    buffer.writeln('Поточні ХП: ${state.currentHp}');
    buffer.writeln('Тимчасові ХП: ${state.tempHp}');
    buffer.writeln('КЗ: ${state.armorClass}');
    buffer.writeln('');

    // Характеристики
    buffer.writeln('ХАРАКТЕРИСТИКИ');
    buffer.writeln('─────────────────────────────────────────');
    state.stats.forEach((stat, value) {
      final mod = ((value - 10) / 2).floor();
      final modStr = mod >= 0 ? '+$mod' : '$mod';
      buffer.writeln('$stat: $value ($modStr)');
    });
    buffer.writeln('');

    // Навички та зброя
    buffer.writeln('НАВИЧКИ ТА ЗБРОЯ');
    buffer.writeln('─────────────────────────────────────────');
    if (state.proficientSkills.isNotEmpty) {
      buffer.writeln('Навички: ${state.proficientSkills.join(', ')}');
    }
    if (state.weapons.isNotEmpty) {
      buffer.writeln('Зброя:');
      for (final weapon in state.weapons) {
        buffer.writeln('  • ${weapon['name']} (${weapon['damage']})');
      }
    }
    buffer.writeln('');

    // Інвентар
    if (state.inventory.isNotEmpty) {
      buffer.writeln('ІНВЕНТАР');
      buffer.writeln('─────────────────────────────────────────');
      for (final item in state.inventory) {
        buffer.writeln('  • ${item['name']} (${item['quantity']} шт.)');
      }
      buffer.writeln('');
    }

    // Гроші
    buffer.writeln('ГРОШІ');
    buffer.writeln('─────────────────────────────────────────');
    buffer.writeln('Платин: ${state.platinum}');
    buffer.writeln('Золото: ${state.gold}');
    buffer.writeln('Срібло: ${state.silver}');
    buffer.writeln('Мідь: ${state.copper}');
    buffer.writeln('');

    buffer.writeln('═══════════════════════════════════════════');

    return buffer.toString();
  }
}
