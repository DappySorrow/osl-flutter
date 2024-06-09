import 'package:flutter/material.dart';
import 'package:portail_osl/main_drawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'OSL Portal'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white), // Set the title text color to white
        ),
        backgroundColor: const Color(0xFF0aa8d0),
        iconTheme: const IconThemeData(color: Colors.white), // Set the hamburger menu icon color to white
      ),
      body: Container(
        color: const Color(0xFF212121), // Set your desired background color here
        child: const Center(
          child: Text(
            "",
            style: TextStyle(color: Colors.white, fontSize: 30), // Set the text color to white
          ),
        ),
      ),
    );
  }
}
