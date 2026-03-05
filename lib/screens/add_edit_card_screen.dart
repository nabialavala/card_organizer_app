import 'package:flutter/material.dart';
import '../models/card.dart';
import '../repositories/card_repository.dart';

class AddEditCardScreen extends StatefulWidget {
  final PlayingCard? existingCard;

  const AddEditCardScreen({super.key, this.existingCard});

  @override
  State<AddEditCardScreen> createState() => _AddEditCardScreenState();
}

class _AddEditCardScreenState extends State<AddEditCardScreen> {
  final CardRepository _cardRepository = CardRepository();

  final TextEditingController _nameController = TextEditingController();
  String _selectedSuit = 'Hearts';

  bool get _isEditMode => widget.existingCard != null;

  @override
  void initState() {
    super.initState();

    if (_isEditMode) {
      _nameController.text = widget.existingCard!.cardName;
      _selectedSuit = widget.existingCard!.suit;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool _validate() {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Card name required")),
      );
      return false;
    }

    return true;
  }

  Future<void> _saveCard() async {
    if (!_validate()) return;

    final name = _nameController.text.trim();

    try {
      if (_isEditMode) {
        final oldCard = widget.existingCard!;

        final updatedCard = oldCard.copyWith(
          cardName: name,
          suit: _selectedSuit,
        );

        await _cardRepository.updateCard(updatedCard);
      } else {
        final newCard = PlayingCard(
          cardName: name,
          suit: _selectedSuit,
          imageUrl: '',
          folderId: 1,
        );

        await _cardRepository.insertCard(newCard);
      }

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Save failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? "Edit Card" : "Add Card"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Card Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedSuit,
              items: const [
                DropdownMenuItem(value: 'Hearts', child: Text('Hearts')),
                DropdownMenuItem(value: 'Diamonds', child: Text('Diamonds')),
                DropdownMenuItem(value: 'Clubs', child: Text('Clubs')),
                DropdownMenuItem(value: 'Spades', child: Text('Spades')),
              ],
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  _selectedSuit = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Suit',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveCard,
                    child: const Text("Save"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}