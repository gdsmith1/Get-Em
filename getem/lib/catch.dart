import 'package:flutter/material.dart';
import 'package:getem/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class Animal {
  final int id;
  final String type;
  final String img;

  Animal({
    required this.id,
    required this.type,
    required this.img,
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

class _CatchPageState extends State<CatchPage> {
  late Future<Map<String, dynamic>> futureDif; // difficulty integer
  late Future<Map<String, dynamic>> futureSoc; // mostrecent integer
  String id = "";
  int lives = 3;
  FireStorage? firevar;
  bool didcatch = false;

  late Animal currentAnimal;
  List<Animal> animals = [
    Animal(id: 0, type: 'Alliclaw', img: 'assets/animals/alliclaw.webp'),
    Animal(id: 1, type: 'Wieneroam', img: 'assets/animals/wieneroam.webp'),
    Animal(id: 2, type: 'Aquapanda', img: 'assets/animals/Aquapanda.webp'),
    Animal(id: 3, type: 'Drakeon', img: 'assets/animals/Drakeon.webp'),
    Animal(id: 4, type: 'Flananana', img: 'assets/animals/flananana.webp'),
    Animal(id: 5, type: 'Galeodon', img: 'assets/animals/galeodon.webp'),
    Animal(id: 6, type: 'Insectiant', img: 'assets/animals/insectiant.webp'),
    Animal(id: 7, type: 'Moownicorn', img: 'assets/animals/moownicorn.webp'),
    Animal(id: 8, type: 'Roaragon', img: 'assets/animals/roaragon.webp'),
    Animal(id: 9, type: 'Samuronic', img: 'assets/animals/samuronic.webp'),
    Animal(id: 10, type: 'Tyranomight', img: 'assets/animals/tyranomight.webp'),
    Animal(id: 11, type: 'Venomorph', img: 'assets/animals/venomorph.webp'),
  ];

  String catchResult = "";

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
    futureSoc = fetchSocialRecent();
  }

  Future<String?> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    String? location = placemarks[0].locality;
    return location;
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

  Future<Map<String, dynamic>> fetchSocialRecent() async {
    try {
      if (!widget.storage.isInitialized) {
        await widget.storage.initializeDefault();
      }

      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentSnapshot ds =
          await firestore.collection("allusers").doc("mostrecent").get();
      if (ds.exists && ds.data() != null) {
        Map<String, dynamic> data = (ds.data() as Map<String, dynamic>);
        if (kDebugMode) {
          print("Recent: $data");
        }
        return {'value': data["value"]};
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

  Future<bool> writeCatch(
      String type, String? location, String date, int xp) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      firestore.collection(id).doc().set({
        "type": type,
        "xp": xp,
        "Caught in": location,
        "date": date
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

  Future<bool> writeCatchSocial(String type, String? location, String date,
      int xp, Map<String, dynamic> mostrecent) async {
    if (kDebugMode) {
      print("updating social value: $mostrecent");
    }
    incrementMostRecent(mostrecent['value']);
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      firestore.collection("allusers").doc(mostrecent.toString()).set({
        "type": type,
        "xp": xp,
        "Caught in": location,
        "date": date
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

  String getDate() {
    DateTime date = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    return formattedDate;
  }

  void tryToCatch(int playerDifficulty, Animal currentAnimal) async {
    if (lives > 0 && didcatch == false) {
      Random random = Random();
      int randomNumber =
          random.nextInt(21); // Generate a random number between 0 and 20

      int result = randomNumber + (playerDifficulty);
      if (kDebugMode) {
        print("Random number: $randomNumber");
        print("Player difficulty: $playerDifficulty");
      }

      if (result > 15) {
        //You didn't catch it!
        // Remove a red dot (life)
        catchResult = "You didn't catch it! Try again.";
        lives--;

        // Update the UI
        setState(() {});
      } else {
        //You caught it!
        catchResult = "You caught the ${currentAnimal.type}!";
        String? location = await getLocation();
        String date = getDate();
        if (kDebugMode) {
          print(date);
          print(location);
        }
        didcatch = true;
        lives = 0;

        Map<String, dynamic> socialData = await fetchSocialRecent();
        if (kDebugMode) {
          print("Value: ${socialData['value']}");
        }
        Random random = Random();
        int xp = random.nextInt(100);
        if (kDebugMode) {
          print("Writing to Inventory...");
        }
        writeCatch(currentAnimal.type, location, date, xp);
        if (kDebugMode) {
          print("Writing to Social...");
        }
        writeCatchSocial(currentAnimal.type, location, date, xp, socialData);
        setState(() {});
      }
    } else if (lives == 0 && didcatch == false) {
      catchResult = "Game over! You've run out of lives.";
      setState(() {});
      if (kDebugMode) {
        print("Game over! You've run out of lives.");
      }
    } else if (lives == 0 && didcatch == true) {
      catchResult = "You caught the ${currentAnimal.type}!";
      setState(() {});
      if (kDebugMode) {
        print("You already caught the ${currentAnimal.type}!");
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(),
            ),
            const SizedBox(height: 9), // Move content up by 7 pixels
            Column(
              children: [
                Text(
                  catchResult, // Display catch result
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Creature: ${currentAnimal.type}",
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                // Removed SizedBox to move the text closer to the image

                Image.asset(
                  currentAnimal.img,
                  width: 250,
                  height: 500,
                ),
              ],
            ),
            const SizedBox(height: 9), // Move content up by 7 pixels
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                lives,
                (index) => Container(
                  width: 25,
                  height: 35,
                  margin: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 9), // Move content up by 7 pixels
            ElevatedButton(
              onPressed: () async {
                Map<String, dynamic> difficultyData = await fetchDifficulty(id);
                int playerDifficulty = difficultyData['difficulty'];
                tryToCatch(playerDifficulty, currentAnimal);
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: Colors.red,
                padding: const EdgeInsets.all(20),
              ),
              child: const Text(
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

void incrementMostRecent(int currentValue) {
  if (currentValue >= 0 && currentValue < 9) {
    FirebaseFirestore.instance
        .collection("allusers")
        .doc("mostrecent")
        .update({'value': FieldValue.increment(1)});
  } else if (currentValue == 9) {
    FirebaseFirestore.instance
        .collection("allusers")
        .doc("mostrecent")
        .update({'value': 0});
  }
}
