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
  // Метод toJson для преобразования объекта в Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': (image.image as NetworkImage).url, // Извлекаем URL из NetworkImage
      'name': name,
      'description': description,
      'price': 1000
    };
  }

  // Метод fromJson для создания объекта из Map
  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['ID'],
      image: Image.network(json['ImageURL']),
      // Создаем Image из URL
      name: json['Name'],
      description: json['Description'],
      favourite: json['favourite'] ?? false,
    );
  }
}
