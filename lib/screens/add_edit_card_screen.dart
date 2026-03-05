import 'package:flutter/material.dart';

class AddEditCardScreen extends StatefulWidget {
  const AddEditCardScreen({super.key});

  @override
  State<AddEditCardScreen> createState() => _AddEditCardScreenState();
}

class _AddEditCardScreenState extends State<AddEditCardScreen> {
  final TextEditingController _nameController = TextEditingController();

  // Defaults for now (we’ll wire folders/suits properly in the next layer)
  String _selectedSuit = 'Hearts';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add / Edit Card"),
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

            ElevatedButton(
              onPressed: () {
                // save comes later
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Save logic next layer')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}