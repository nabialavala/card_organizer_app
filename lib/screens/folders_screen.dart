import 'package:flutter/material.dart';
import 'package:card_organizer_app/models/folder.dart';
import 'package:card_organizer_app/repositories/folder_repository.dart';

class FoldersScreen extends StatefulWidget {
  const FoldersScreen({super.key});

  @override
  State<FoldersScreen> createState() => _FoldersScreenState();
}

class _FoldersScreenState extends State<FoldersScreen> {

  final FolderRepository folderRepo = FolderRepository();
  List<Folder> folders = [];

  @override
  void initState() {
    super.initState();
    loadFolders();
  }

  Future<void> loadFolders() async {
    final data = await folderRepo.getAllFolders();
    if (!mounted) return;

    setState(() {
      folders = data;
    });
  }

  void confirmDelete(Folder folder) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Delete Folder"),
          content: Text(
            "Are you sure you want to delete '${folder.folderName}'?\n\n"
            "All cards inside this folder will also be deleted because of CASCADE deletion.",
          ),
          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                await folderRepo.deleteFolder(folder.id!);

                Navigator.pop(dialogContext);
                loadFolders();
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  IconData getSuitIcon(String suit) {
    switch (suit) {
      case "Hearts":
        return Icons.favorite;
      case "Spades":
        return Icons.change_history;
      case "Diamonds":
        return Icons.diamond;
      case "Clubs":
        return Icons.grass;
      default:
        return Icons.folder;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Suit Folders"),
      ),

      body: ListView.builder(
        itemCount: folders.length,
        itemBuilder: (context, index) {

          final folder = folders[index];

          return ListTile(

            leading: Icon(
              getSuitIcon(folder.folderName),
              size: 32,
              color: Colors.red,
            ),

            title: Text(folder.folderName),

            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),

              onPressed: () {
                confirmDelete(folder);
              },
            ),

            onTap: () {
              // Later you will open the cards screen here
            },
          );
        },
      ),
    );
  }
}