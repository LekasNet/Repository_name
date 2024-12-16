import 'dart:convert';
import 'package:adyshkin_pcs/common/storage_service.dart';
import 'package:http/http.dart' as http;


class TemporaryUserRequest {
  static const String baseUrl = 'http://192.168.1.70:8080/temporary_user';

  static Future<String> createTemporaryUser() async {
    try {
      final response = await http.post(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final token = response.body;
        await StorageService.saveToken(token); // Сохраняем токен
        return token;
      } else {
        throw Exception('Failed to create temporary user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating temporary user: $e');
    }
  }
}
