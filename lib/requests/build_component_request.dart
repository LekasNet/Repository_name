import 'dart:convert';
import 'package:http/http.dart' as http;

import '../common/storage_service.dart';

class BuildComponentRequest {
  static const String addComponentUrl = 'http://192.168.1.70:8080/add_component';
  static const String removeComponentUrl = 'http://192.168.1.70:8080/remove_component';

  static Future<void> addComponent(String buildHash, int componentId) async {
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
        Uri.parse(addComponentUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'build_hash': buildHash,
          'component_id': componentId,
        }),
      );

      if (response.statusCode == 200) {
        print('Component added successfully.');
      } else if (response.statusCode == 418) {
        throw Exception('Incompatible components: ${response.body}');
      } else {
        throw Exception('Failed to add component: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding component: $e');
    }
  }

  static Future<void> removeComponent(String buildHash, int componentId) async {
    try {
      var token = await StorageService.getToken();
      if (token == null) {
        throw Exception('No token found. Please create a temporary user first.');
      }
      else {
        token = token.replaceAll('TU_', '');
        print(token);
      }

      final response = await http.delete(
        Uri.parse(removeComponentUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'build_hash': buildHash,
          'component_id': componentId,
        }),
      );

      if (response.statusCode == 200) {
        print('Component removed successfully.');
      } else {
        throw Exception('Failed to remove component: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error removing component: $e');
    }
  }
}
