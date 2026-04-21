import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/character_model.dart';

class StorageService {
  static const _key = 'character';

  static Future<void> saveCharacter(CharacterModel character) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(character.toJson());
    await prefs.setString(_key, json);
  }

  static Future<CharacterModel?> loadCharacter() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);
    if (json == null) return null;
    return CharacterModel.fromJson(jsonDecode(json));
  }
}