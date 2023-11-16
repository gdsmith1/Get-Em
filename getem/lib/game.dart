import 'package:flutter/material.dart';
import 'package:getem/main.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class GameRoute extends StatelessWidget {
  const GameRoute({super.key});

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
   }, iconSize: 40,
      ),
      IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
            Navigator.pushNamed(context, '/inventory');
        },iconSize: 40,
      ),
      IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () {
            Navigator.pushNamed(context, '/settings');
        }, iconSize: 40,
      )
    ], // This trailing comma makes auto-formatting nicer for build methods.
  ),
       );//map
     
    
  }
}