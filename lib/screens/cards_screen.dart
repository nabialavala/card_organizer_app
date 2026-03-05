import 'package:flutter/material.dart';
import '../repositories/card_repository.dart';
import '../models/card.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  final CardRepository _cardRepository = CardRepository();
  List<PlayingCard> _cards = [];

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async{
    final cards = await _cardRepository.getAllCards();
    setState(() {
      _cards = cards;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cards"),
      ),
      body: _cards.isEmpty
        ? const Center(child: Text("Cards not found"))
        : ListView.builder(
          itemCount: _cards.length,
          itemBuilder: (context, index) {
            final card = _cards[index];
            return ListTile(
              leading: Image.asset(
                card.imageUrl ?? '',
                width: 40,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image);
                },
              ),
              title: Text(card.cardName),
              subtitle: Text(card.suit),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      //go to the edit screen
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      //delete logic
                    },
                  ),
                ],
              ),
            );
          },
        )
    );
  }
}
