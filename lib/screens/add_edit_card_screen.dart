import 'package:flutter/material.dart';
import '../models/card.dart';

class AddEditCardScreen extends StatefulWidget {
  final PlayingCard? existingCard;
  const AddEditCardScreen({super.key, this.existingCard});

  @override
  State<AddEditCardScreen> createState() => _AddEditCardScreenState();
}

class _AddEditCardScreenState extends State<AddEditCardScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedSuit = 'Hearts';
  bool get _isEditMode => widget.existingCard != null;

  @override
  void initState(){
    super.initState();
    if(_isEditMode) {
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
        const SnackBar(content: Text("Card Name Required!!")),
      );
      return false;
    }
    return true;
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
                    child: const Text ("Cancel"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                  onPressed: () {
                    if (!_validate()) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Save logic next layer')),
                    );
                  },
                  child: const Text('Save'),
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