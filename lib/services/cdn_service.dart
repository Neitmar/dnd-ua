import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'localization_service.dart';

class CDNService {
  // Для тестирования используем assets
  static const Map<String, String> _languageFiles = {
    'ru': 'assets/translations/ru.json',
    'en': 'assets/translations/en.json',
  };

  /// Загрузить переводы из assets (для тестирования)
  static Future<Map<String, dynamic>?> fetchTranslations(String language) async {
    if (language == 'uk') return null; // Оригинальный украинский

    final assetPath = _languageFiles[language];
    if (assetPath == null) {
      debugPrint('Language $language not supported');
      return null;
    }

    try {
      final jsonString = await rootBundle.loadString(assetPath);
      final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
      return decoded;
    } catch (e) {
      debugPrint('Error loading translations from assets: $e');
      return null;
    }
  }

  /// Загрузить все необходимые переводы
  static Future<void> loadTranslationsForLanguage(String language) async {
    if (language == 'uk') return;

    // Попробовать загрузить с CDN
    final translations = await fetchTranslations(language);
    if (translations != null) {
      await LocalizationService.saveTranslations({language: translations});
      debugPrint('Translations for $language loaded from CDN');
    } else {
      debugPrint('Could not load translations for $language');
    }
  }

  /// Проверить, есть ли обновления переводов
  static Future<bool> checkForUpdates(String language) async {
    if (language == 'uk') return false;

    final shouldUpdate = await LocalizationService.shouldUpdateTranslations();
    if (shouldUpdate) {
      await loadTranslationsForLanguage(language);
      return true;
    }
    return false;
  }

  /// Загрузить переводы для всех языков (кроме оригинального uk)
  static Future<void> loadAllTranslations() async {
    for (final lang in _languageFiles.keys) {
      await loadTranslationsForLanguage(lang);
    }
  }
}
