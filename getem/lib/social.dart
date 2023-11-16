import 'package:flutter/material.dart';
import 'package:getem/main.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'login.dart';
import 'game.dart';

class SocialRoute extends StatelessWidget {
  const SocialRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social'),
      ),
      body: Center(),
       

    bottomNavigationBar: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
  Navigator.popAndPushNamed(context, '/game');        },
      ),
      
    ], // This trailing comma makes auto-formatting nicer for build methods.
  ),
    );
  }
}