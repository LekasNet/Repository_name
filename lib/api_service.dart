import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:adyshkin_pcs/models/CardModel.dart';

class ApiService {
  final String baseUrl = 'http://192.168.1.70:8080';

  Future<List<CardModel>> fetchCards() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => CardModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load cards');
    }
  }

  Future<void> addCard(CardModel card) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products/create'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(card.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add card');
    }
  }

  Future<void> updateCard(CardModel card) async {
    final response = await http.put(
      Uri.parse('$baseUrl/products/update/${card.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(card.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update card');
    }
  }

  Future<void> deleteCard(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/products/delete/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete card');
    }
  }
}
