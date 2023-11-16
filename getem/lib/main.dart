import 'package:flutter/material.dart';
import 'package:getem/game.dart';
import 'login.dart';
import 'inventory.dart';
import 'settings.dart';
import 'social.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_core/firebase_core.dart";
import 'firebase_options.dart';
import 'package:flutter/foundation.dart';

void main() {
  runApp(MaterialApp(
    title: 'Get-em routing',
    initialRoute: '/',
    routes: {
      '/': (context) => FirstRoute(), //login

      '/game': (context) => GameRoute(), //game
      '/inventory': (context) => InventoryRoute(),
      '/settings': (context) => SettingsRoute(),
      '/socials': (context) => SocialRoute(),
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

  Future<bool> writeCatch(String type, int weight, int height) async {
    try {
      if (!isInitialized) {
        await initializeDefault();
      }
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      firestore.collection("testuser1").doc().set({
        "type": type,
        "weight": weight,
        "height": height,
      }).then((value) {
        if (kDebugMode) {
          //print("writetoFirebase: $.id");
        }
        return true;
      }).catchError((error) {
        if (kDebugMode) {
          print("writetoFirebase: $error");
        }
        return false;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return false;
  }
}
