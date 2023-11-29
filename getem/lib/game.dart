import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'main.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'inventory.dart';
import 'settings.dart';
import 'social.dart';

class GameRoute extends StatelessWidget {
  const GameRoute({super.key});

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('Arguments: ${ModalRoute.of(context)!.settings.arguments}');
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Get Em!"),
      ),
      body: GamePage(title: "Get Em!"),
    );
  }
}

class GamePage extends StatefulWidget {
  GamePage({super.key, required this.title});

  final String title;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: () {
              Navigator.pushNamed(context, '/socials');
            },
            iconSize: 40,
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Navigator.pushNamed(context, '/inventory',
                  arguments:
                      ModalRoute.of(context)!.settings.arguments as String);
            },
            iconSize: 40,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings',
                  arguments:
                      ModalRoute.of(context)!.settings.arguments as String);
            },
            iconSize: 40,
          )
        ], // This trailing comma makes auto-formatting nicer for build methods.
      ),
    ); //map
  }
}
