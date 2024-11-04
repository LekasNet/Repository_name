import 'package:flutter/material.dart';
import 'package:adyshkin_pcs/models/CardModel.dart';
import 'package:adyshkin_pcs/api_service.dart';

class FavouritesPage extends StatefulWidget {
  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  final ApiService _apiService = ApiService();
  List<CardModel> _favouriteCards = [];

  @override
  void initState() {
    super.initState();
    _loadFavouriteCards();
  }

  Future<void> _loadFavouriteCards() async {
    try {
      final cards = await _apiService.fetchCards();
      setState(() {
        _favouriteCards = cards.where((card) => card.favourite).toList();
      });
    } catch (e) {
      print('Failed to load favourite cards: $e');
    }
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
            trailing: IconButton(
              icon: Icon(
                card.favourite ? Icons.favorite : Icons.favorite_border,
                color: card.favourite ? Colors.red : Colors.grey,
              ),
              onPressed: () async {
                setState(() {
                  card.favourite = !card.favourite;
                });
                try {
                  await _apiService.updateCard(card);
                } catch (e) {
                  print('Failed to update card: $e');
                }
              },
            ),
          );
        },
      ),
    );
  }
}
