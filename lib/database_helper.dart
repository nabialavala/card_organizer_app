import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('card_organizer.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Create Folders table
    await db.execute('''
      CREATE TABLE folders(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        folder_name TEXT NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');

    // Create Cards table with foreign key
    await db.execute('''
      CREATE TABLE cards(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        card_name TEXT NOT NULL,
        suit TEXT NOT NULL,
        image_url TEXT,
        folder_id INTEGER,
        FOREIGN KEY (folder_id) REFERENCES folders (id)
          ON DELETE CASCADE
      )
    ''');

    // Prepopulate folders
    await _prepopulateFolders(db);
    
    // Prepopulate cards
    await _prepopulateCards(db);
  }

  Future<void> _prepopulateFolders(Database db) async {
    final folders = ['Hearts', 'Diamonds', 'Clubs', 'Spades'];
    for (int i = 0; i < folders.length; i++) {
      await db.insert('folders', {
        'folder_name': folders[i],
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<void> _prepopulateCards(Database db) async {
    final suits = ['Hearts', 'Diamonds', 'Clubs', 'Spades'];
    final ranks = [
      'Ace', '2', '3', '4', '5', '6', '7',
      '8', '9', '10', 'Jack', 'Queen', 'King'
    ];

    for (int folderId = 1; folderId <= suits.length; folderId++) {
      final suitName = suits[folderId - 1];
      final suitCode = _suitToCode(suitName);

      for (final rank in ranks) {
        final rankCode = _rankToCode(rank);
        final code = '$rankCode$suitCode'; // ex: AS, 0H, KD, 7C
        final imageUrl = 'https://deckofcardsapi.com/static/img/$code.png';

        await db.insert('cards', {
          'card_name': rank,
          'suit': suitName,
          'image_url': imageUrl,
          'folder_id': folderId,
        });
      }
    }
  }

  String _rankToCode(String rank) {
    switch (rank) {
      case 'Ace':
        return 'A';
      case 'Jack':
        return 'J';
      case 'Queen':
        return 'Q';
      case 'King':
        return 'K';
      case '10':
        return '0'; // IMPORTANT: 10 is "0" in this image set
      default:
        return rank; // '2'..'9'
    }
  }

  String _suitToCode(String suit) {
    switch (suit) {
      case 'Spades':
        return 'S';
      case 'Hearts':
        return 'H';
      case 'Diamonds':
        return 'D';
      case 'Clubs':
        return 'C';
      default:
        return 'S';
    }
  }
}