import 'package:adyshkin_pcs/di/cardsStorage.dart';
import 'package:adyshkin_pcs/models/CardModel.dart';
import 'package:flutter/material.dart';
import 'package:adyshkin_pcs/pages/card_detail.dart';

class Listing extends StatefulWidget {
  @override
  _ListingState createState() => _ListingState();
}

class _ListingState extends State<Listing> {
  final CardModelStorage _storage = CardModelStorage();
  List<CardModel> _cardModels = [];

  @override
  void initState() {
    super.initState();
    _loadCardModels();
  }

  Future<void> _loadCardModels() async {
    final cards = await _storage.getAllCardModels();
    setState(() {
      _cardModels = cards;
    });
  }

  void _addCard(String imageUrl, String name, String description) async {
    final newCard = CardModel(
      id: DateTime.now().millisecondsSinceEpoch, // Простая генерация уникального ID
      image: Image.network(imageUrl),
      name: name,
      description: description,
    );
    await _storage.addCardModel(newCard);
    await _loadCardModels(); // Обновление списка после добавления
  }

  void _showAddCardBottomSheet(BuildContext context) {
    final TextEditingController imageController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: imageController,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _addCard(
                    imageController.text,
                    nameController.text,
                    descriptionController.text,
                  );
                  Navigator.pop(context); // Закрытие меню после добавления
                },
                child: Text('Add Card'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Card Listing'),
      ),
      body: _cardModels.isEmpty
          ? Center(child: Text('No cards available.'))
          : GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.75,
        ),
        itemCount: _cardModels.length,
          itemBuilder: (context, index) {
            final card = _cardModels[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CardDetail(card: card),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        child: card.image, // Отображение изображения
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        card.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        card.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              card.favourite ? Icons.favorite : Icons.favorite_border,
                              color: card.favourite ? Colors.red : Colors.grey,
                            ),
                            onPressed: () async {

                            },
                          ),
                          Text(
                            'ID: ${card.id}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
      ),
          floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCardBottomSheet(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
