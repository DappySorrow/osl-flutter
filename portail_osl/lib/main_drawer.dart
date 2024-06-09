import 'package:flutter/material.dart';
import 'package:portail_osl/screens/screen_games.dart';
import 'package:portail_osl/screens/screen_items.dart';
import 'package:portail_osl/screens/screen_televisions.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFF212121),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF0aa8d0),
              ),
              child: Center(
                child: Text(
                  'Options',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            ListTile(
              title: const Text(
                'Jeux Vidéos',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ScreenGames()),
                );
              },
            ),

            ListTile(
              title: const Text(
                'Télévisions',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ScreenTelevisions()),
                );
              },
            ),

            ListTile(
              title: const Text(
                'Items',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ScreenItems()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
