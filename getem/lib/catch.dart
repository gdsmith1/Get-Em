import 'package:flutter/material.dart';
import 'package:getem/main.dart';
import 'package:getem/login.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'main.dart';

import 'dart:math';
class Animal {
  final int id;
  final String type;
  final String img;
  final int weight;
  final int height;

  Animal({
    required this.id,
    required this.type,
    required this.img,
    required this.weight,
    required this.height,
  });
}
class CatchRoute extends StatelessWidget {
  const CatchRoute({super.key});
 @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: CatchPage(title: "Catch"),
    );
  }
}

class CatchPage extends StatefulWidget {
  CatchPage({super.key, required this.title});

  final String title;
  final FireStorage storage = FireStorage();

  @override
  State<CatchPage> createState() => _CatchPageState();
}



// ... (your existing imports)

class _CatchPageState extends State<CatchPage> {
  late Future<Map<String, dynamic>> futureDif; // difficulty integer
  String id = "";
  int lives = 3;
   FireStorage ?firevar;
 
late Animal currentAnimal;
   List<Animal> animals = [
    Animal(id: 0, type: 'Lion', weight: 200, height: 3,img:'assets/animals/lion.webp'),
    Animal(id: 1, type: 'Elephant', weight: 5000, height: 10,img: 'assets/animals/elephant.jpg'),
    // Add more animals as needed
  ];

  @override
  void initState() {
    super.initState();
    // Set the initial state for the currentAnimal when the page is loaded
    currentAnimal = animals[Random().nextInt(animals.length)];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    id = ModalRoute.of(context)!.settings.arguments as String;
    futureDif = fetchDifficulty(id);
  }
  

  Future<Map<String, dynamic>> fetchDifficulty(String id) async {
    try {
      if (!widget.storage.isInitialized) {
        await widget.storage.initializeDefault();
      }

      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentSnapshot ds =
          await firestore.collection(id).doc("usersettings").get();
      if (ds.exists && ds.data() != null) {
        Map<String, dynamic> data = (ds.data() as Map<String, dynamic>);
        if (kDebugMode) {
          print(data.toString());
        }
        return {'difficulty': data["difficulty"]};
      } else {
        await createCollection(id);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return {};
  }
  
Future<bool> writeCatch(String type, int weight, int height) async {
    try {
   
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      firestore.collection(id).doc().set({
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
  void tryToCatch(int playerDifficulty,Animal currentAnimal) {
    if (lives > 0) {
      Random random = Random();
      int randomNumber = random.nextInt(21); // Generate a random number between 0 and 20

      int result = playerDifficulty - randomNumber;

      if (result < 10) {
        print("You didn't catch it! Try again.");

        // Remove a red dot (life)
        lives--;

        // Update the UI
        setState(() {});
      } else {
        print("You caught it!");
       writeCatch(currentAnimal.type, currentAnimal.weight, currentAnimal.height);///////////
      }
    } else {
      print("Game over! You've run out of lives.");
    }
  }

   @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Catch'),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              // Your existing content
            ),
          ),
          SizedBox(height: 16),
          Column(
            children: [
              // Display the initial animal information
              Text("${currentAnimal.type}"),
              Image.asset(
                currentAnimal.img, // Replace with your actual image path
                width: 250,
                height: 500,
              ),
              
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              lives,
              (index) => Container(
                width: 50,
                height: 50,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              // Fetch the difficulty and try to catch
              Map<String, dynamic> difficultyData = await fetchDifficulty(id);
              int playerDifficulty = difficultyData['difficulty'];
              tryToCatch(playerDifficulty,currentAnimal);
            },
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              primary: Colors.red,
              padding: EdgeInsets.all(20),
            ),
            child: Text(
              'Catch!',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    ),
  );
}
}