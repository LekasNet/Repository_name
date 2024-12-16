import 'dart:convert';
import 'package:http/http.dart' as http;

import '../common/storage_service.dart';

class BuildRequest {
  static const String createUrl = 'http://192.168.1.70:8080/create_build';
  static const String baseUrl = 'http://192.168.1.70:8080/get_build';
  static const String shareUrl = 'http://192.168.1.70:8080/get_shared_link';
  static const String baseUrl2 = 'http://192.168.1.70:8080';

  static Future<String> createBuild() async {
    try {
      var token = await StorageService.getToken();
      if (token == null) {
        throw Exception('No token found. Please create a temporary user first.');
      }
      else {
        token = token.replaceAll('TU_', '');
        print(token);
      }

      final response = await http.post(
        Uri.parse(createUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final buildHash = response.body;
        await StorageService.saveBuildHash(buildHash); // Сохраняем хэш сборки
        return buildHash;
      } else {
        throw Exception('Failed to create build: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating build: $e');
    }
  }

  // Метод для получения списка компонентов в сборке
  static Future<List<Map<String, dynamic>>> fetchBuildComponents(String buildHash, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?hash=$buildHash'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((e) => e as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to fetch build components: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw Exception('Error fetching build components: $e');
    }
  }

  static Future<String> fetchSharedLink(String buildHash, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl2/get_shared_link?hash=$buildHash'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['shared'];
    } else {
      throw Exception('Failed to fetch shared link: ${response.body}');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchSharedBuild(String sharedHash) async {
    final response = await http.get(
      Uri.parse('$baseUrl/get_shared_build?shared=$sharedHash'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body)['components']);
    } else {
      throw Exception('Failed to fetch components: ${response.body}');
    }
  }
}

