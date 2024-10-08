import 'package:flutter/material.dart';
import 'package:portail_osl/main_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

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
  void openDefaultBrowser(String url) async {
    try {
      Uri uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri); // Launches the default web browser on any platform
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  Widget buildButton(String url, String imagePath, String tooltipMessage) {
  return SizedBox(
    width: 250, // Set the desired width
    height: 250, // Set the desired height
    child: Tooltip(
      message: tooltipMessage, // Set the tooltip message
      child: ElevatedButton(
        onPressed: () {
          openDefaultBrowser(url);
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, 
          backgroundColor: const Color(0xFF0aa8d0), // Set the background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Set the border radius
          ),
          padding: const EdgeInsets.all(8.0),
        ),
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain, // Adjust this as needed
        ),
      ),
    ),
  );
}



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
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildButton("https://online.adp.com/signin/v1/?APPID=WFNPortal&productId=80e309c3-7085-bae1-e053-3505430b5495&returnURL=https://workforcenow.adp.com/&callingAppId=WFN", "assets/adp_logo.png", "ADP"),
                buildButton("msteams://", "assets/microsoft_teams_logo.png", "Microsoft Teams"),
                ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildButton("https://outlook.office.com/", "assets/outlook_logo.png", "Outlook"),
                buildButton("https://loop.cloud.microsoft/p/eyJ1IjoiaHR0cHM6Ly9vc2xycy5zaGFyZXBvaW50LmNvbS9jb250ZW50c3RvcmFnZS9DU1BfMzg1NWRhMDItN2UzMC00OTc3LTk0ZTItYjM5MjcxMjkwMTU5P25hdj1jejBsTWtaamIyNTBaVzUwYzNSdmNtRm5aU1V5UmtOVFVDVTFSak00TlRWa1lUQXlKVEpFTjJVek1DVXlSRFE1TnpjbE1rUTVOR1V5SlRKRVlqTTVNamN4TWprd01UVTVKbVE5WWlVeU1VRjBjRlpQUkVJbE1rUmtNRzFWTkhKUFUyTlRhMEpYWVZaM2RuVXljMFpxYkU5c2JsZFlkVlpyUTBOeVdqRjRSV1ptU1ZreVVWRTJkVEl3VDJneFFrVlhiQ1ptUFRBeFZFbFJUVEpOVEZkYVdrUkpWbHBYVFVsYVJVeFFWMUF5UkV4S1MxaFdOVmdtWXowbE1rWT0ifQ%3D%3D", "assets/loop.png", "Ronde de sécurité"),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
}