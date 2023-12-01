import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';

class GameRoute extends StatelessWidget {
  const GameRoute({Key? key});

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('Arguments: ${ModalRoute.of(context)!.settings.arguments}');
    }
    return Scaffold(
      body: GamePage(title: "Get Em!"),
    );
  }
}

class GamePage extends StatefulWidget {
  GamePage({Key? key, required this.title});

  final String title;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  Completer<GoogleMapController> _googleMapController = Completer();
  CameraPosition? _cameraPosition;
  Location? _location;
  LocationData? _currentLocation;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    _location = Location();
    _cameraPosition = CameraPosition(
        target: LatLng(
            0, 0), // this is just the example lat and lng for initializing
        zoom: 15);
    _initLocation();
  }

  //function to listen when we move position
  _initLocation() {
    //use this to go to current location instead
    _location?.getLocation().then((location) {
      _currentLocation = location;
    });
    _location?.onLocationChanged.listen((newLocation) {
      _currentLocation = newLocation;
      moveToPosition(LatLng(
          _currentLocation?.latitude ?? 0, _currentLocation?.longitude ?? 0));
    });
  }

  moveToPosition(LatLng latLng) async {
    GoogleMapController mapController = await _googleMapController.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 15)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBody() {
    return _getMap();
  }

  Widget _getMap() {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _cameraPosition!,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            if (!_googleMapController.isCompleted) {
              _googleMapController.complete(controller);
            }
          },
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: _getMarker(),
          ),
        ),
      ],
    );
  }

  Widget _getMarker() {
    return Container(
      width: 60,
      height: 60,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 3),
                spreadRadius: 4,
                blurRadius: 6)
          ]),
      child: ClipOval(child: Image.asset("assets/profile.jpg")),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.people),
          onPressed: () {
            Navigator.pushNamed(context, '/socials');
          },
          iconSize: 40,
        ),
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Navigator.pushNamed(context, '/inventory',
                arguments:
                    ModalRoute.of(context)!.settings.arguments as String);
          },
          iconSize: 40,
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.pushNamed(context, '/settings',
                arguments:
                    ModalRoute.of(context)!.settings.arguments as String);
          },
          iconSize: 40,
        ),
      ],
    );
  }
}
