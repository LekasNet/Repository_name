import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/product_model.dart';


class ProductRequest {
  static const String baseUrl = 'http://192.168.1.70:8080/components';

  // Метод для получения списка товаров
  static Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}
