import 'dart:convert';
import 'package:adyshkin_pcs/models/CardModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Обработчик для работы с SharedPreferences
class CardModelStorage {
  static const String _cardModelsKey = 'card_models';

  // Добавление объекта в SharedPreferences
  Future<void> addCardModel(CardModel model) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cardModelsList = prefs.getStringList(_cardModelsKey) ?? [];
    cardModelsList.add(jsonEncode(model.toMap()));
    await prefs.setStringList(_cardModelsKey, cardModelsList);
  }

  // Удаление объекта из SharedPreferences по id
  Future<void> removeCardModel(int id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cardModelsList = prefs.getStringList(_cardModelsKey) ?? [];
    cardModelsList.removeWhere((modelString) {
      final modelMap = jsonDecode(modelString) as Map<String, dynamic>;
      return modelMap['id'] == id;
    });
    await prefs.setStringList(_cardModelsKey, cardModelsList);
  }

  // Получение всех объектов из SharedPreferences
  Future<List<CardModel>> getAllCardModels() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cardModelsList = prefs.getStringList(_cardModelsKey) ?? [];
    return cardModelsList
        .map((modelString) => CardModel.fromMap(jsonDecode(modelString)))
        .toList();
  }

  // Обновление состояния "избранное" у объекта
  Future<void> toggleFavourite(int id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cardModelsList = prefs.getStringList(_cardModelsKey) ?? [];

    for (int i = 0; i < cardModelsList.length; i++) {
      final modelMap = jsonDecode(cardModelsList[i]) as Map<String, dynamic>;
      if (modelMap['id'] == id) {
        modelMap['favourite'] = !(modelMap['favourite'] ?? false);
        cardModelsList[i] = jsonEncode(modelMap);
        break;
      }
    }

    await prefs.setStringList(_cardModelsKey, cardModelsList);
  }
}