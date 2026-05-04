import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService {
  static const String _translationsKey = 'translations_cache';
  static const String _lastUpdateKey = 'translations_last_update';

  // Структура переводов: язык -> категория -> id -> перевод
  static final Map<String, Map<String, dynamic>> _cachedTranslations = {};

  /// Ключевые моменты для перевода
  static const Map<String, Map<String, dynamic>> supportedLanguages = {
    'uk': {'name': 'Українська', 'flag': '🇺🇦'},
    'ru': {'name': 'Русский', 'flag': '🇷🇺'},
    'en': {'name': 'English', 'flag': '🇬🇧'},
  };

  /// Загрузить переводы из локального кэша
  static Future<void> loadCachedTranslations() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_translationsKey);
    if (cached != null) {
      final decoded = jsonDecode(cached) as Map<String, dynamic>;
      decoded.forEach((lang, data) {
        _cachedTranslations[lang] = data as Map<String, dynamic>;
      });
    }
  }

  /// Получить перевод текста
  static String translate(
    String key,
    String currentLanguage, {
    String defaultValue = '',
  }) {
    if (currentLanguage == 'uk') return defaultValue; // Оригинальный украинский
    final translations = _cachedTranslations[currentLanguage];
    if (translations == null) return defaultValue;
    return translations[key] ?? defaultValue;
  }

  /// Получить перевод объекта (для классов, рас, итд)
  static Map<String, dynamic> translateObject(
    Map<String, dynamic> object,
    String currentLanguage,
    List<String> fieldsToTranslate,
  ) {
    if (currentLanguage == 'uk') return object;

    final translated = Map<String, dynamic>.from(object);
    final translations = _cachedTranslations[currentLanguage];

    if (translations != null) {
      for (final field in fieldsToTranslate) {
        if (object.containsKey(field)) {
          final key = '${object['_id'] ?? object['name']}_$field';
          if (translations.containsKey(key)) {
            translated[field] = translations[key];
          }
        }
      }
    }

    return translated;
  }

  /// Сохранить переводы в кэш (будут загружены из CDN)
  static Future<void> saveTranslations(Map<String, Map<String, dynamic>> translations) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Объединить с существующими
    final existing = _cachedTranslations;
    existing.addAll(translations);
    
    await prefs.setString(_translationsKey, jsonEncode(existing));
    await prefs.setString(
      _lastUpdateKey,
      DateTime.now().toIso8601String(),
    );
  }

  /// Получить последнее обновление переводов
  static Future<DateTime?> getLastUpdateTime() async {
    final prefs = await SharedPreferences.getInstance();
    final lastUpdate = prefs.getString(_lastUpdateKey);
    return lastUpdate != null ? DateTime.parse(lastUpdate) : null;
  }

  /// Очистить кэш переводов
  static Future<void> clearTranslations() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_translationsKey);
    await prefs.remove(_lastUpdateKey);
    _cachedTranslations.clear();
  }

  /// Проверить, нужно ли обновить переводы
  static Future<bool> shouldUpdateTranslations() async {
    final lastUpdate = await getLastUpdateTime();
    if (lastUpdate == null) return true;

    final daysSinceUpdate = DateTime.now().difference(lastUpdate).inDays;
    return daysSinceUpdate >= 7; // Обновлять раз в неделю
  }
}
