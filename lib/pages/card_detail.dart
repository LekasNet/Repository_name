import 'package:flutter/material.dart';
import 'package:adyshkin_pcs/models/CardModel.dart';
import 'package:adyshkin_pcs/di/cardsStorage.dart';

class CardDetail extends StatefulWidget {
  final CardModel card;

  const CardDetail({required this.card});

  @override
  _CardDetailState createState() => _CardDetailState();
}

class _CardDetailState extends State<CardDetail> {
  final CardModelStorage _storage = CardModelStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.card.name),
        actions: [
          IconButton(
            icon: Icon(
              widget.card.favourite ? Icons.star : Icons.star_border,
              color: widget.card.favourite ? Colors.yellow : Colors.white,
            ),
            onPressed: () async {
              setState(() {
                widget.card.favourite = !widget.card.favourite;
              });
              await _storage.toggleFavourite(widget.card.id);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 200,
                width: double.infinity,
                child: widget.card.image,
              ),
              SizedBox(height: 16),
              Text(
                widget.card.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(widget.card.description),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await _storage.removeCardModel(widget.card.id);
          Navigator.pop(context); // Возвращение на предыдущий экран после удаления
        },
        label: Text('Удалить'),
        icon: Icon(Icons.delete),
        backgroundColor: Colors.red,
      ),
    );
  }
}
