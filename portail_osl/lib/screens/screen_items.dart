// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:portail_osl/classes/Item.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:barcode_widget/barcode_widget.dart';

class ScreenItems extends StatelessWidget {
  const ScreenItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Items",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0aa8d0),
      ),
      body: Container(
        color: const Color(0xFF212121),
        child: const ItemsContainer(),
      ),
    );
  }
}

class ItemsContainer extends StatefulWidget {
  const ItemsContainer({super.key});

  @override
  ItemsContainerState createState() => ItemsContainerState();
}

class ItemsContainerState extends State<ItemsContainer> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late Future<List<Item>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = _loadItems();
  }

  void _refreshItems() {
    setState(() {
      _itemsFuture = _loadItems();
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
              hintText: "Nom de l'item...",
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
          child: ItemsContainerItems(
            searchQuery: _searchQuery,
            itemsFuture: _itemsFuture,
            onItemAdded: _refreshItems,
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
                  _addItemToFile(context);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<List<Item>> _loadItems() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/items.txt');

    if (!file.existsSync()) {
      return [];
    }

    String content = await file.readAsString();
    List<String> lines = content.split('\n');
    List<Item> items = lines
        .where((line) => line.isNotEmpty)
        .map((line) => Item.fromString(line))
        .toList();

    return items;
  } catch (e) {
    return [];
  }
}


Future<void> _addItemToFile(BuildContext context) async {
  TextEditingController nameController = TextEditingController();
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
                controller: articleNumController,
                decoration: const InputDecoration(labelText: "Numéro d'article"),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // Generate a unique ID for the game
                      String itemId = const Uuid().v4();
                      String name = nameController.text.trim();
                      String articleNum = articleNumController.text.trim();

                      // Validate input
                      if (name.isEmpty || articleNum.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Merci de remplir tous les champs')),
                        );
                        return;
                      }

                      // Add the game to the file
                      final directory = await getApplicationDocumentsDirectory();
                      final file = File('${directory.path}/items.txt');
                      await file.writeAsString('$itemId;$name;$articleNum\n', mode: FileMode.append);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Item ajouté avec succès')),
                      );

                      _refreshItems();
                      Navigator.pop(context); // Close the dialog
                    },
                    child: const Text('Ajouter un Item'),
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

class ItemsContainerItems extends StatelessWidget {
  final String searchQuery;
  final Future<List<Item>> itemsFuture;
  final VoidCallback onItemAdded;

  const ItemsContainerItems({
    super.key,
    required this.searchQuery,
    required this.itemsFuture,
    required this.onItemAdded,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Item>>(
      future: itemsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Item> items = snapshot.data ?? [];
          List<Item> filteredItems = items
              .where((game) =>
                  game.name.toLowerCase().contains(searchQuery.toLowerCase()))
              .toList();
          return ListView.builder(
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              Item item = filteredItems[index];

              return ListTile(
                title: Text(
                  item.name,
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  _showItemDetails(context, item);
                },
              );
            },
          );
        }
      },
    );
  }

  void _showItemDetails(BuildContext context, Item item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(item.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BarcodeWidget(
                barcode: Barcode.code128(), // Choose the type of barcode
                data: item.articleNum,
                width: 200,
                height: 80,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Supprimer'),
              onPressed: () async {
                await _deleteItem(context, item);
                Navigator.of(context).pop();
                onItemAdded();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteItem(BuildContext context, Item item) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/items.txt');

    if (file.existsSync()) {
      List<String> lines = await file.readAsLines();

      // Show confirmation dialog
      bool confirmDelete = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmation'),
            content: const Text('Êtes-vous sûr de vouloir supprimer cet item ?'),
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
        // Remove the specific item by comparing IDs
        lines.removeWhere((line) {
          Item currentGame = Item.fromString(line.trim());
          return currentGame.id == item.id;
        });

        // Write the updated list back to the file
        await file.writeAsString(lines.join('\n') + (lines.isNotEmpty ? '\n' : ''));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item supprimé avec succès')),
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
      const SnackBar(content: Text("Erreur lors de la suppression de l'item")),
    );
  }
}



}

