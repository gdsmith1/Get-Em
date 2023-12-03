import 'package:flutter/material.dart';
import 'package:getem/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SocialRoute extends StatelessWidget {
  const SocialRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social'),
      ),
      body: SocialPage(title: "Social"),
    );
  }
}

class SocialPage extends StatefulWidget {
  SocialPage({super.key, required this.title});

  final String title;
  final FireStorage storage = FireStorage();

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  late Future<List<Map<String, dynamic>>> futureData;
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
    //id = ModalRoute.of(context)!.settings.arguments as String;
    futureData = fetchSocial();
  }

  Future<List<Map<String, dynamic>>> fetchSocial() async {
    try {
      if (!widget.storage.isInitialized) {
        await widget.storage.initializeDefault();
      }

      FirebaseFirestore firestore = FirebaseFirestore.instance;

      QuerySnapshot qs = await firestore.collection("allusers").get();
      if (qs.docs.isNotEmpty) {
        List<Map<String, dynamic>> data = [];
        qs.docs.forEach((element) {
          if (element.id == "mostrecent") {
            return;
          }
          data.add(element.data() as Map<String,
              dynamic>); //this will break the app if any file besides usersettings does not have the same format
          if (kDebugMode) {
            print(element.data());
          }
        });
        return data;
      } else {
        await createCollection(id);
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
