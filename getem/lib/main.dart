import 'package:flutter/material.dart';
import 'package:getem/game.dart';
import 'login.dart';
import 'inventory.dart';
import 'settings.dart';
import 'social.dart';
import 'catch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_core/firebase_core.dart";
import 'firebase_options.dart';
import 'package:flutter/foundation.dart';

void main() {
  runApp(MaterialApp(
    title: 'Get-em routing',
    initialRoute: '/',
    routes: {
      '/': (context) => const FirstRoute(), //login
      '/catch': (context) => const CatchRoute(),
      '/game': (context) => const GameRoute(), //game
      '/inventory': (context) => const InventoryRoute(),
      '/settings': (context) => const SettingsRoute(),
      '/socials': (context) => const SocialRoute(),
    },
  ));
}

class FireStorage {
  bool _initialized = false;

  FireStorage();

  Future<void> initializeDefault() async {
    FirebaseApp app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _initialized = true;
    if (kDebugMode) {
      print("Initialized default app $app");
    }
  }

  bool get isInitialized => _initialized;
}

Future<void> createCollection(String id) async {
  //use this if a user doesnt exist or has no data
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Specify the collection and document
  DocumentReference docRef = firestore.collection(id).doc('usersettings');
  // Set the data of the document
  await docRef.set({
    'difficulty': 1,
  });
}
