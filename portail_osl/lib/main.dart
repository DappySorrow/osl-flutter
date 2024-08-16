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

  Widget buildButton(String url, String imagePath) {
    return SizedBox(
      width: 250, // Set the desired width
      height: 250, // Set the desired height
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
                buildButton("https://online.adp.com/signin/v1/?APPID=WFNPortal&productId=80e309c3-7085-bae1-e053-3505430b5495&returnURL=https://workforcenow.adp.com/&callingAppId=WFN", "assets/adp_logo.png"),
                buildButton("https://oslfuse.app.appery.io/app/splash.html", "assets/fuse_logo.png"),
                buildButton("https://oslu.docebosaas.com/learn", "assets/learn_logo.png"),
                buildButton("https://forms.office.com/Pages/ResponsePage.aspx?id=es0_dyoyeE6GrpSGWm1E72XgZS4ni5JJkYW4pJFRjqpUMUlCSzBOQlQ3VzRCQkpIU01RUkdRWDdZMi4u", "assets/mastercard.png"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [       
                buildButton("https://oslperx.rewardsnation.com/#/login", "assets/perx_logo.png"),
                buildButton("msteams://", "assets/microsoft_teams_logo.png"),
                buildButton("https://outlook.office.com/", "assets/outlook_logo.png"),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
}