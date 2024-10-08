import 'package:flutter/material.dart';

class CardModel {
  final int id;
  final Image image;
  final String name;
  final String description;
  bool favourite;

  CardModel({
    required this.id,
    required this.image,
    required this.name,
    required this.description,
    this.favourite = false,
  });

  // Метод для конвертации объекта в Map для сохранения в SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'favourite': favourite,
    };
  }

  // Метод для создания объекта из Map
  factory CardModel.fromMap(Map<String, dynamic> map) {
    return CardModel(
      id: map['id'],
      image: Image.asset(''), // Image нельзя сохранить в SharedPreferences, заглушка
      name: map['name'],
      description: map['description'],
      favourite: map['favourite'] ?? false,
    );
  }
}
