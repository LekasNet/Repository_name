import 'package:flutter/material.dart';
import 'package:adyshkin_pcs/models/CardModel.dart';
import 'package:adyshkin_pcs/di/cardsStorage.dart';

class FavouritesPage extends StatefulWidget {
  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  final CardModelStorage _storage = CardModelStorage();
  List<CardModel> _favouriteCards = [];

  @override
  void initState() {
    super.initState();
    _loadFavouriteCards();
  }

  Future<void> _loadFavouriteCards() async {
    final cards = await _storage.getAllCardModels();
    setState(() {
      _favouriteCards = cards.where((card) => card.favourite).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourite Cards'),
      ),
      body: _favouriteCards.isEmpty
          ? Center(child: Text('No favourites yet.'))
          : ListView.builder(
        itemCount: _favouriteCards.length,
        itemBuilder: (context, index) {
          final card = _favouriteCards[index];
          return ListTile(
            title: Text(card.name),
            subtitle: Text(card.description),
            leading: card.image,
          );
        },
      ),
    );
  }
}
