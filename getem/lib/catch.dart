import 'package:flutter/material.dart';
import 'package:getem/main.dart';
import 'package:getem/login.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'main.dart';
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



// ... (your existing imports)

class _CatchPageState extends State<CatchPage> {
  late Future<Map<String, dynamic>> futureDif; // difficulty integer
  String id = "";
  int lives = 3;
   FireStorage ?firevar;
   bool didcatch = false;
 
late Animal currentAnimal;
   List<Animal> animals = [
    Animal(id: 0, type: 'alliclaw',img:'assets/animals/alliclaw.webp'),
     Animal(id: 1, type: 'wieneroam',img:'assets/animals/wieneroam.webp'),
      Animal(id: 2, type: 'Aquapanda',img:'assets/animals/Aquapanda.webp'),
      Animal(id: 3, type: 'Drakeon',img:'assets/animals/Drakeon.webp'),
       Animal(id: 4, type: 'flananana',img:'assets/animals/flananana.webp'),
         Animal(id: 5, type: 'galeodon',img:'assets/animals/galeodon.webp'),
         Animal(id: 6, type: 'insectiant',img:'assets/animals/insectiant.webp'),
           Animal(id: 7, type: 'moownicorn',img:'assets/animals/moownicorn.webp'),
           Animal(id: 8, type: 'roaragon',img:'assets/animals/roaragon.webp'),
           Animal(id: 9, type: 'samuronic',img:'assets/animals/samuronic.webp'),
            Animal(id: 10, type: 'tyranomight',img:'assets/animals/tyranomight.webp'),
            Animal(id: 11, type: 'venomorph',img:'assets/animals/venomorph.webp'),

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
  }
  
Future <String?> getLocation() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
  //print('YOU LIVE IN: ${placemarks[0].locality}');
   String ?location = placemarks[0].locality;
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
  
Future<bool> writeCatch(String type, String ?location, String date) async {
    try {
   
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      Random random = Random();
      int xp  = random.nextInt(100);
      
      
      firestore.collection(id).doc().set({
        "type": type,
        "xp": xp,
        "Caught in":location,
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
  String getDate(){
     DateTime date = DateTime.now();
     String formattedDate =DateFormat('yyyy-MM-dd').format(date);
     return formattedDate;
    
  }
  void tryToCatch(int playerDifficulty,Animal currentAnimal) async{
    
    if (lives > 0 && didcatch==false) {
      Random random = Random();
      int randomNumber = random.nextInt(21); // Generate a random number between 0 and 20
        
        
      int result =  randomNumber+(playerDifficulty);
      print(result);

      if (result > 15) {
       // print("You didn't catch it! Try again.");
        //print(DateTime.now());
        // Remove a red dot (life)
        catchResult = "You didn't catch it! Try again.";
        lives--;

        // Update the UI
        //setState(() {});
      } else {
        //print("You caught it!");
        
        catchResult = "You caught the ${currentAnimal.type}!";
        String? location = await getLocation();
        String date= getDate();
        //print(date);
        //print(location);
        didcatch=true;
         lives=0;

        

       writeCatch(currentAnimal.type,location,date);///////////
       //setState(() {});
      
      }
    } else if(lives==0 && didcatch==false) {
              catchResult = "Game over! You've run out of lives.";
             setState(() {});
      print("Game over! You've run out of lives.");
    }

    else if(lives==0 && didcatch==true) {
              catchResult = "You caught the ${currentAnimal.type}!";
             setState(() {});
      print("Game over! You've already won.");
    }
    
  setState(() {});
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
             
            ),
          ),
          SizedBox(height: 9), // Move content up by 7 pixels
          Column(
            children: [
              Text(
                catchResult, // Display catch result
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                "Pokemon: ${currentAnimal.type}",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              // Removed SizedBox to move the text closer to the image

              Image.asset(
                currentAnimal.img,
                width: 250,
                height: 500,
              ),
            ],
          ),
          SizedBox(height: 9), // Move content up by 7 pixels
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              lives,
              (index) => Container(
                width: 25,
                height: 35,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          SizedBox(height: 9), // Move content up by 7 pixels
          ElevatedButton(
            onPressed: () async {
              Map<String, dynamic> difficultyData = await fetchDifficulty(id);
              int playerDifficulty = difficultyData['difficulty'];
              tryToCatch(playerDifficulty, currentAnimal);
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