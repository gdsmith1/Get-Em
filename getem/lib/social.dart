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
        backgroundColor: const Color.fromARGB(255, 166, 25, 25),
        centerTitle: true,
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

        int mostRecentValue = 0;
        // Get the most recent value
        if (qs.docs.length > 9) {
          if (kDebugMode) {
            Map<String, dynamic> mostrecent =
                qs.docs[10].data() as Map<String, dynamic>;
            mostRecentValue = mostrecent['value'];
          } //mostrecent
        }
        //read all from most recent to 0
        for (int i = mostRecentValue; i >= 0; i--) {
          if (qs.docs[i].id == "mostrecent") {
            continue;
          }
          data.add(qs.docs[i].data() as Map<String, dynamic>);
          if (kDebugMode) {
            print(qs.docs[i].data());
          }
        }
        //read all from 9 to most recent
        for (int i = 9; i > mostRecentValue; i--) {
          if (qs.docs[i].id == "mostrecent") {
            continue;
          }
          data.add(qs.docs[i].data() as Map<String, dynamic>);
          if (kDebugMode) {
            print(qs.docs[i].data());
          }
        }
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
