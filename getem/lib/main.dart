import 'package:flutter/material.dart';
import 'package:getem/game.dart';
import 'login.dart';
import 'inventory.dart';
import 'settings.dart';
import 'social.dart';


void main() {
  runApp(MaterialApp(
    title: 'Get-em routing',
    initialRoute: '/',
    routes: {
      '/': (context)=>FirstRoute(),//login
      
      '/game':(context) => GameRoute(),//game
      '/inventory':(context) => InventoryRoute(),
      '/settings':(context) => SettingsRoute(),
      '/socials':(context) => SocialRoute(),
    },

  ));


}


