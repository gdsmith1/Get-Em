import 'package:flutter/material.dart';
import 'game.dart';
import 'main.dart';

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log in'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Log in!'),
          onPressed: () {
            Navigator.pushNamed(context, '/game');
          },
        ),
      ),
    );
  }
}

Widget get getfirstroute {
  return FirstRoute();
}
