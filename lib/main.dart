import 'package:flutter/material.dart';
import 'screens/folders_screen.dart';

void main() {
  runApp(const CardOrganizerApp());
}

class CardOrganizerApp extends StatelessWidget {
  const CardOrganizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Organizer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.red,
      ),
      home: const FoldersScreen(),  // ← changed this line
    );
  }
}


//remove after full app is working
class PlaceholderHome extends StatelessWidget {
  const PlaceholderHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Organizer'),
      ),
      body: const Center(
        child: Text('Sorry we\'re still working ;).'),
      ),
    );
  }
}