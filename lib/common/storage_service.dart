import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _tokenKey = 'user_token';
  static const String _buildHashesKey = 'build_hashes';

  // Сохранение токена
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Получение токена
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Сохранение хэша сборки
  static Future<void> saveBuildHash(String buildHash) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> buildHashes = prefs.getStringList(_buildHashesKey) ?? [];
    buildHashes.add(buildHash);
    await prefs.setStringList(_buildHashesKey, buildHashes);
  }

  // Получение всех хэшей сборок
  static Future<List<String>> getBuildHashes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_buildHashesKey) ?? [];
  }

  // Очистка данных
  static Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
