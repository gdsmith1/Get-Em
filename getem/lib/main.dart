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
      '/': (context) => const FirstRoute(), //login

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

  //writes to a single entry in the database
  Future<bool> writeEntry(String displayString) async {
    try {
      if (!isInitialized) {
        await initializeDefault();
      }
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      firestore.collection("testuser1").doc("charizard").set({
        "type": displayString,
      }).then((value) {
        if (kDebugMode) {
          print("writetoFirebase: $displayString");
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

  //reads a single entry from the database
  Future<String> readEntry() async {
    try {
      if (!isInitialized) {
        await initializeDefault();
      }
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentSnapshot ds =
          await firestore.collection("testuser1").doc("charizard").get();
      if (ds.exists && ds.data() != null) {
        Map<String, dynamic> data = (ds.data() as Map<String, dynamic>);
        if (data.containsKey("type")) {
          return data["type"];
        }
      }
      bool writeSuccess = await writeEntry("");
      if (writeSuccess) {
        return "";
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return "NULL";
  }
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
