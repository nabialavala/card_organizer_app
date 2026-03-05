import 'package:flutter/material.dart';
import '../models/card.dart';
import '../repositories/card_repository.dart';
import 'add_edit_card_screen.dart';

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

  Future<void> _loadCards() async {
    try {
      final cards = await _cardRepository.getAllCards();
      if (!mounted) return;
      setState(() => _cards = cards);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not load the cards.")),
      );
    }
  }

  Future<void> _deleteCard(PlayingCard card) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete this card?"),
        content: Text('You are about to delete "${card.cardName}".'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete Card"),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (card.id == null) return;

    try {
      await _cardRepository.deleteCard(card.id!);
      await _loadCards();
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Card deleted")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not delete")),
      );
    }
  }

  Future<void> _goToAddCard() async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditCardScreen(),
      ),
    );

    if (changed == true) {
      _loadCards();
    }
  }

  Future<void> _goToEditCard(PlayingCard card) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditCardScreen(existingCard: card),
      ),
    );

    if (changed == true) {
      _loadCards();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cards"),
        actions: [
          IconButton(
            onPressed: _loadCards,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _cards.isEmpty
          ? const Center(child: Text("No cards found"))
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
                        onPressed: () => _goToEditCard(card),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteCard(card),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddCard,
        child: const Icon(Icons.add),
      ),
    );
  }
}