// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:portail_osl/classes/game.dart';
import 'package:barcode_widget/barcode_widget.dart';

class ScreenGames extends StatelessWidget {
  const ScreenGames({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Jeux Vidéos",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0aa8d0),
      ),
      body: Container(
        color: const Color(0xFF212121),
        child: const GamesContainer(),
      ),
    );
  }
}

class GamesContainer extends StatefulWidget {
  const GamesContainer({super.key});

  @override
  GamesContainerState createState() => GamesContainerState();
}

class GamesContainerState extends State<GamesContainer> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late Future<List<Game>> _gamesFuture;

  @override
  void initState() {
    super.initState();
    _gamesFuture = _loadGames();
  }

  void _refreshGames() {
    setState(() {
      _gamesFuture = _loadGames();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Nom du jeu...',
              hintStyle: const TextStyle(color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            style: const TextStyle(color: Colors.white),
          ),
        ),
        Expanded(
          flex: 9,
          child: GamesContainerGames(
            searchQuery: _searchQuery,
            gamesFuture: _gamesFuture,
            onGameAdded: _refreshGames,
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF0aa8d0),
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  _addGameToFile(context);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<List<Game>> _loadGames() async {
  try {
    //final directory = await getApplicationDocumentsDirectory();
    final file = File('./files/games.txt');

    if (!file.existsSync()) {
      return [];
    }

    String content = await file.readAsString();
    List<String> lines = content.split('\n');
    List<Game> games = lines
        .where((line) => line.isNotEmpty)
        .map((line) => Game.fromString(line))
        .toList();

    return games;
  } catch (e) {
    return [];
  }
}


Future<void> _addGameToFile(BuildContext context) async {
  TextEditingController nameController = TextEditingController();
  TextEditingController consoleController = TextEditingController();
  TextEditingController articleNumController = TextEditingController();

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nom'),
              ),
              TextField(
                controller: consoleController,
                decoration: const InputDecoration(labelText: 'Console'),
              ),
              TextField(
                controller: articleNumController,
                decoration: const InputDecoration(labelText: "CUP"),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // Generate a unique ID for the game
                      String gameId = const Uuid().v4();
                      String name = nameController.text.trim();
                      String console = consoleController.text.trim();
                      String articleNum = articleNumController.text.trim();

                      // Validate input
                      if (name.isEmpty || console.isEmpty || articleNum.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Merci de remplir tous les champs')),
                        );
                        return;
                      }

                      if(articleNum.length != 12){
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Le CUP doit être de 12 caractères')),
                            );
                            return;
                          }

                      // Add the game to the file
                      //final directory = await getApplicationDocumentsDirectory();
                      final file = File('./files/games.txt');
                      await file.writeAsString('$gameId;$name;$console;$articleNum\n', mode: FileMode.append);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Jeu ajouté avec succès')),
                      );

                      _refreshGames();
                      Navigator.pop(context); // Close the dialog
                    },
                    child: const Text('Ajouter un jeu'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
}

class GamesContainerGames extends StatelessWidget {
  final String searchQuery;
  final Future<List<Game>> gamesFuture;
  final VoidCallback onGameAdded;

  const GamesContainerGames({
    super.key,
    required this.searchQuery,
    required this.gamesFuture,
    required this.onGameAdded,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Game>>(
      future: gamesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Game> games = snapshot.data ?? [];
          List<Game> filteredGames = games
              .where((game) =>
                  game.name.toLowerCase().contains(searchQuery.toLowerCase()))
              .toList();
          return ListView.builder(
            itemCount: filteredGames.length,
            itemBuilder: (context, index) {
              Game game = filteredGames[index];

              return ListTile(
                title: Text(
                  game.name,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'Console: ${game.console}',
                  style: const TextStyle(color: Colors.white70),
                ),
                onTap: () {
                  _showGameDetails(context, game);
                },
              );
            },
          );
        }
      },
    );
  }

  void _showGameDetails(BuildContext context, Game game) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(game.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Console: ${game.console}'),
              const SizedBox(height: 10),
              BarcodeWidget(
                barcode: Barcode.upcA(), // Choose the type of barcode
                data: game.articleNum,
                width: 300,
                height: 100,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Supprimer'),
              onPressed: () async {
                await _deleteGame(context, game);
                Navigator.of(context).pop();
                onGameAdded();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteGame(BuildContext context, Game game) async {
  try {
    //final directory = await getApplicationDocumentsDirectory();
    final file = File('./files/games.txt');

    if (file.existsSync()) {
      List<String> lines = await file.readAsLines();

      // Show confirmation dialog
      bool confirmDelete = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmation'),
            content: const Text('Êtes-vous sûr de vouloir supprimer ce jeu ?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Don't delete
                },
                child: const Text('Non'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Delete
                },
                child: const Text('Oui'),
              ),
            ],
          );
        },
      );

      if (confirmDelete == true) {
        // Remove the specific game by comparing IDs
        lines.removeWhere((line) {
          Game currentGame = Game.fromString(line.trim());
          return currentGame.id == game.id;
        });

        // Write the updated list back to the file
        await file.writeAsString(lines.join('\n') + (lines.isNotEmpty ? '\n' : ''));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jeu supprimé avec succès')),
        );
      }
    } else {
      // Debugging: Print if the file does not exist
      print('Fichier ne existe pas');
    }
  } catch (e) {
    // Debugging: Print the error message
    print('Error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Erreur lors de la suppression du jeu')),
    );
  }
}



}

