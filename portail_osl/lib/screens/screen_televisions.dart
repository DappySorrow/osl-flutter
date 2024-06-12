// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:portail_osl/classes/Television.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class ScreenTelevisions extends StatelessWidget {
  const ScreenTelevisions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Télévisions",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0aa8d0),
      ),
      body: Container(
        color: const Color(0xFF212121),
        child: const TelevisionsContainer(),
      ),
    );
  }
}

class TelevisionsContainer extends StatefulWidget {
  const TelevisionsContainer({super.key});

  @override
  TelevisionsContainerState createState() => TelevisionsContainerState();
}

class TelevisionsContainerState extends State<TelevisionsContainer> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late Future<List<Television>> _listFuture;

  @override
  void initState() {
    super.initState();
    _listFuture = _load();
  }

  void _refresh() {
    setState(() {
      _listFuture = _load();
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
              hintText: 'Marque de la télévision...',
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
          child: TelevisionsContainerTelevisions(
            searchQuery: _searchQuery,
            listFuture: _listFuture,
            onAdded: _refresh,
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
                  _addToFile(context);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

Future<List<Television>> _load() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/televisions.txt');

    if (!file.existsSync()) {
      print('File does not exist');
      return [];
    }

    String content = await file.readAsString();

    List<String> lines = content.split('\n');
    List<Television> televisions = lines
        .where((line) => line.isNotEmpty)
        .map((line) {
          try {
            return Television.fromString(line);
          } catch (e) {
            print('Error parsing line: $e');
            return null; // Skip invalid lines
          }
        })
        .where((tv) => tv != null) // Filter out null values
        .cast<Television>()
        .toList();

    return televisions;
  } catch (e) {
    print('Error: $e'); // Debug print
    return [];
  }
}



  Future<void> _addToFile(BuildContext context) async {
    TextEditingController brandController = TextEditingController();
    TextEditingController modelController = TextEditingController();
    TextEditingController sizeController = TextEditingController();
    TextEditingController heightController = TextEditingController();
    TextEditingController widthController = TextEditingController();
    TextEditingController depthController = TextEditingController();
    TextEditingController legsController = TextEditingController();
    TextEditingController resolutionController = TextEditingController();
    TextEditingController refreshRateController = TextEditingController();
    TextEditingController articleNumController = TextEditingController();
    TextEditingController bluetoothController = TextEditingController();
    TextEditingController linkController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(brandController, 'Marque'),
                  _buildTextField(modelController, 'Modèle'),
                  _buildTextField(sizeController, 'Taille'),
                  _buildTextField(heightController, 'Hauteur'),
                  _buildTextField(widthController, 'Largeur'),
                  _buildTextField(depthController, 'Profondeur'),
                  _buildTextField(legsController, 'Distance entre les pattes'),
                  _buildTextField(resolutionController, 'Résolution'),
                  _buildTextField(refreshRateController, 'Vitesse de rafraichissement'),
                  _buildTextField(articleNumController, "Numéro d'article"),
                  _buildTextField(bluetoothController, "Bluetooth"),
                  _buildTextField(linkController, 'Lien'),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          // Generate a unique ID for the television
                          String tvId = const Uuid().v4();
                          String brand = brandController.text.trim();
                          String model = modelController.text.trim();
                          String size = sizeController.text.trim();
                          String height = heightController.text.trim();
                          String width = widthController.text.trim();
                          String depth = depthController.text.trim();
                          String legs = legsController.text.trim();
                          String resolution = resolutionController.text.trim();
                          String refreshRate = refreshRateController.text.trim();
                          String articleNum = articleNumController.text.trim();
                          String bluetooth = bluetoothController.text.trim();
                          String link = linkController.text.trim();

                          // Validate input
                          if (brand.isEmpty ||
                              model.isEmpty ||
                              size.isEmpty ||
                              height.isEmpty ||
                              width.isEmpty ||
                              depth.isEmpty ||
                              legs.isEmpty ||
                              resolution.isEmpty ||
                              refreshRate.isEmpty ||
                              articleNum.isEmpty ||
                              bluetooth.isEmpty ||
                              link.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please fill all fields')),
                            );
                            return;
                          }

                          // Add the television to the file
                          final directory = await getApplicationDocumentsDirectory();
                          final file = File('${directory.path}/televisions.txt');
                          await file.writeAsString(
                            '$tvId;$brand;$model;$size;$height;$width;$depth;$legs;$resolution;$refreshRate;$articleNum;$bluetooth;$link\n',
                            mode: FileMode.append,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Television added successfully')),
                          );

                          // Refresh the UI or perform any additional actions
                          if (context.mounted) {
                            _refresh();
                            Navigator.pop(context); // Close the dialog
                          }
                        },
                        child: const Text('Add Television'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }
}

class TelevisionsContainerTelevisions extends StatelessWidget {
  final String searchQuery;
  final Future<List<Television>> listFuture;
  final VoidCallback onAdded;

  const TelevisionsContainerTelevisions({
    super.key,
    required this.searchQuery,
    required this.listFuture,
    required this.onAdded,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Television>>(
      future: listFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No televisions found'));
        } else {
          List<Television> televisions = snapshot.data!;

          List<Television> filtered = televisions
              .where((television) =>
                  television.brand.toLowerCase().contains(searchQuery.toLowerCase()))
              .toList();

          return ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              Television television = filtered[index];

              return ListTile(
                title: Text(
                  '${television.brand} ${television.model} ${television.size}',
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  _showDetails(context, television);
                },
              );
            },
          );
        }
      },
    );
  }

void openDefaultBrowser(String url) async {
  try {
    Uri uri = Uri.parse(url);

    if (await canLaunchUrl (uri)) {
      await Process.run('explorer', [url]); // Launches the default web browser on Windows
    } else {
      throw 'Could not launch $url';
    }
  } catch (e) {
    print('Error launching URL: $e');
  }
}

void _showDetails(BuildContext context, Television television) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('${television.brand} ${television.model} ${television.size}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Marque: ${television.brand}'),
            Text('Modèle: ${television.model}'),
            Text('Taille: ${television.size}″'),
            Text('Hauteur: ${television.height}″'),
            Text('Largeur: ${television.width}″'),
            Text('Profondeur: ${television.depth}″'),
            Text('Distance entre les pattes: ${television.legs}″'),
            Text('Résolution: ${television.resolution}'),
            Text('Vitesse de rafraichissement: ${television.refreshRate}Hz'),
            RichText(
              text: TextSpan(
                text: 'Lien: ',
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: television.link,
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Handle link click
                        openDefaultBrowser(television.link);
                      },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16), // Add some space between the specs and the barcode
            Center( child: BarcodeWidget(
              barcode: Barcode.upcA(), // Choose the type of barcode
              data: television.articleNumber,
              width: 200,
              height: 80,
            ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Supprimer'),
            onPressed: () async {
              await _delete(context, television);
              Navigator.of(context).pop();
              onAdded();
            },
          ),
        ],
      );
    },
  );
}


  Future<void> _delete(BuildContext context, Television television) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/televisions.txt');

      if (file.existsSync()) {
        List<String> lines = await file.readAsLines();

        // Show confirmation dialog
        bool confirmDelete = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirmation'),
              content: const Text('Êtes-vous sûr de vouloir supprimer cette television ?'),
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
          // Remove the specific television by comparing IDs
          lines.removeWhere((line) {
            Television current = Television.fromString(line.trim());
            return current.id == television.id;
          });

          // Write the updated list back to the file
          await file.writeAsString(lines.join('\n') + (lines.isNotEmpty ? '\n' : ''));

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Television supprimée avec succès')),
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
        const SnackBar(content: Text('Erreur lors de la suppression de la television')),
      );
    }
  }
}
