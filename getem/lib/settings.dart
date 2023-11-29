import 'package:flutter/material.dart';
import 'package:getem/main.dart';
import 'package:getem/login.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SettingsRoute extends StatelessWidget {
  const SettingsRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SettingsPage(title: "Settings"),
    );
  }
}

class SettingsPage extends StatefulWidget {
  SettingsPage({super.key, required this.title});

  final String title;
  final FireStorage storage = FireStorage();

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Future<Map<String, dynamic>> futureDif; //difficulty integer
  String id = "";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            ListTile(),
            FutureBuilder<Map<String, dynamic>>(
              future: futureDif,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListTile(
                    title: Text("Difficulty: ${snapshot.data!["difficulty"]}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            //TODO: add difficulty editing
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            //TODO: add difficulty editing
                          },
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return ListTile(
                    title: Text("${snapshot.error}"),
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
            ListTile(
              title: const Text('Log out of your Google account:'),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(
                      context, (route) => route.settings.name == '/');
                },
                child: const Text('Log out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
