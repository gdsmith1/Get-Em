class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Login Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GoogleSignInAccount? _currentUser;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '137533668291-tm12iglv88qqjsjr36sel83dmbfj3vdb.apps.googleusercontent.com',
    scopes: [
      'email',
      'profile',
    ],
  );

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        if (kDebugMode) {
          print(_currentUser);
        }
      }
    });
    _googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildBody()),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  List<Widget> _buildBody() {
    List<Widget> widgets = [];
    if (_currentUser == null) {
      widgets.add(const Text("You are not currently signed in"));
      widgets.add(ElevatedButton(
          onPressed: _handleSignIn, child: const Text("Sign In")));
    } else {
      widgets.add(ListTile(
        leading: GoogleUserCircleAvatar(identity: _currentUser!),
        title: Text(_currentUser!.displayName ?? ''),
        subtitle: Text(_currentUser!.email),
      ));
      widgets.add(
          ElevatedButton(onPressed: _handleSignOut, child: Text("Sign Out")));
    }
    return widgets;
  }
}



















/*import 'package:flutter/material.dart';
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
*/