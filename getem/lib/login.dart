import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'game.dart';
import 'main.dart';

/*class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log in'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Log in!'),
          onPressed: () {
            Navigator.pushNamed(context, '/game');
          },
        ),
      ),
    );
  }
}*/

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 166, 25, 25),
        centerTitle: true,
        title: Text("Welcome to Get Em!"),
      ),
      body: loginPage(title: "Log in"),
    );
  }
}

class loginPage extends StatefulWidget {
  const loginPage({super.key, required this.title});

  final String title;

  @override
  State<loginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<loginPage> {
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
      var user = await _googleSignIn.signIn();
      setState(() {
        _currentUser = user;
      });
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
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildBody()),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _handleSignOut() async {
    _googleSignIn.disconnect();
    setState(() {
      _currentUser = null;
    });
  }

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
      widgets.add(ElevatedButton(
          onPressed: () {
            String id = _currentUser!.id;
            if (kDebugMode) {
              print("Logged in... Google User id: $id");
            }
            Navigator.pushNamed(context, '/game', arguments: id);
          },
          child: Text("Start Playing!")));
      widgets.add(
          ElevatedButton(onPressed: _handleSignOut, child: Text("Sign Out")));
    }
    return widgets;
  }
}

Widget get getfirstroute {
  return FirstRoute();
}
