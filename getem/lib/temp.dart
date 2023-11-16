import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_core/firebase_core.dart";
import 'firebase_options.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Inventory'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;
  final FireStorage storage = FireStorage();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late var _textController;
  late Future<List<Map<String, dynamic>>> futureData;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _newCatch(String type) async {
    //uses writeCatch()
    if (kDebugMode) {
      print("Texfield text: ${_textController.text}");
    }
    //randomly generate variables here
    await widget.storage.writeCatch(type, 3, 5);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    futureData = fetchInventory();
    _textController = TextEditingController();
  }

  Future<List<Map<String, dynamic>>> fetchInventory() async {
    try {
      if (!widget.storage.isInitialized) {
        await widget.storage.initializeDefault();
      }
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot qs = await firestore.collection("testuser1").get();
      if (qs.docs.isNotEmpty) {
        List<Map<String, dynamic>> data = [];
        qs.docs.forEach((element) {
          if (element.id == "usersettings") {
            return;
          }
          data.add(element.data() as Map<String,
              dynamic>); //this will break the app if any file besides usersettings does not have the same format
          if (kDebugMode) {
            print(element.data());
          }
        });
        return data;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text("Type")),
                  DataColumn(label: Text("Weight")),
                  DataColumn(label: Text("Height")),
                ],
                rows: snapshot.data!
                    .map((data) => DataRow(cells: [
                          DataCell(Text(data["type"])),
                          DataCell(Text(data["weight"].toString())),
                          DataCell(Text(data["height"].toString())),
                        ]))
                    .toList(),
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
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
