import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'dart:math';

class GameRoute extends StatelessWidget {
  const GameRoute({super.key});

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('Arguments: ${ModalRoute.of(context)!.settings.arguments}');
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 166, 25, 25),
        centerTitle: true,
        title: const Text("Get Em!"),
      ),
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
  final Completer<GoogleMapController> _googleMapController = Completer();
  CameraPosition? _cameraPosition;
  Location? _location;
  LocationData? _currentLocation;
  List<Marker> _markers = [];
  Completer<BitmapDescriptor>? _customMarkerCompleter;
  // List<MarkerId> _markerIds = []; // Track marker ids
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _init();
    _startTimer();
    _loadCustomMarker();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  _init() async {
    _location = Location();
    _cameraPosition = const CameraPosition(
        target: LatLng(
            0, 0), // this is just the example lat and lng for initializing
        zoom: 15);
    _initLocation();
  }

  void _startTimer() {
    const duration = Duration(seconds: 60);
    _timer = Timer.periodic(duration, (timer) {
      _removeAllMarkers();
      _addRandomMarkers();
    });
  }

  void _removeAllMarkers() {
    setState(() {
      _markers.clear();
    });
  }

  //function to listen when we move position
  _initLocation() {
    //use this to go to current location instead
    _location?.getLocation().then((location) {
      _currentLocation = location;
    });
    _location?.onLocationChanged.listen((newLocation) {
      _currentLocation = newLocation;
      _updateButtonVisibility();
      moveToPosition(LatLng(
          _currentLocation?.latitude ?? 0, _currentLocation?.longitude ?? 0));
    });
  }

  moveToPosition(LatLng latLng) async {
    GoogleMapController mapController = await _googleMapController.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 18)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _isButtonVisible ? _buildActionButton() : null,
    );
  }

  bool _isButtonVisible = false; // Initially hide the button
  Widget _buildBody() {
    return _getMap();
  }

  Widget _getMap() {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _cameraPosition!,
          mapType: MapType.normal,
          markers: Set<Marker>.of(_markers),
          onMapCreated: (GoogleMapController controller) {
            if (!_googleMapController.isCompleted) {
              _googleMapController.complete(controller);
            }
            _addRandomMarkers(); // Add random markers on map creation
          },
          onTap: (LatLng latLng) {
            _removeMarker(); // Remove marker on map tap
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

  void _addRandomMarkers() {
    if (_currentLocation != null && _customMarkerCompleter != null) {
      final int numberOfMarkers = 1;
      final double quarterRadius = 0.002; // Modify this radius as needed

      Random random = Random();
      _customMarkerCompleter!.future.then((customMarkerImage) {
        for (int i = 0; i < numberOfMarkers; i++) {
          double latOffset = (random.nextDouble() - 0.5) * quarterRadius * 2;
          double lngOffset = (random.nextDouble() - 0.5) * quarterRadius * 2;

          double newLat = _currentLocation!.latitude! + latOffset;
          double newLng = _currentLocation!.longitude! + lngOffset;

          LatLng randomLocation = LatLng(
            newLat,
            newLng,
          );

          _markers.add(
            Marker(
              markerId: MarkerId('marker_$i'),
              position: randomLocation,
              infoWindow: InfoWindow(title: 'Creature $i'),
              icon: customMarkerImage, // Set the custom marker icon
            ),
          );
        }
        setState(() {});
      });
    }
  }

  void _loadCustomMarker() async {
    final BitmapDescriptor customMarkerImage =
        await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(1, 1)), // Set the image size
      'assets/icon.png',
    );

    setState(() {
      _customMarkerCompleter = Completer<BitmapDescriptor>()
        ..complete(customMarkerImage);
    });
  }

  Widget _getMarker() {
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    String? profilePictureUrl = arguments['picture'];
    profilePictureUrl ??= 'assets/profile.png';
    if (kDebugMode) {
      print("Profile Picture URL: ");
      print(profilePictureUrl);
    }
    return Container(
      width: 60,
      height: 60,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 166, 25, 25),
          borderRadius: BorderRadius.circular(100),
          boxShadow: const [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 3),
                spreadRadius: 4,
                blurRadius: 6)
          ]),
      child: ClipOval(
        child: profilePictureUrl != null
            ? Image.network(profilePictureUrl)
            : Image.asset('assets/profile.png'),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    String id = arguments['id'];
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
            Navigator.pushNamed(context, '/inventory', arguments: id);
          },
          iconSize: 40,
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.pushNamed(context, '/settings', arguments: id);
          },
          iconSize: 40,
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    String id = arguments['id'];
    return Align(
      alignment: Alignment.bottomCenter,
      child: FloatingActionButton(
        onPressed: () {
          _removeMarker();
          Navigator.pushNamed(context, '/catch', arguments: id);
        },
        backgroundColor: const Color.fromARGB(
            255, 118, 22, 15), // Set the background color to maroon
        child: const Icon(Icons.add),
      ),
    );
  }

  void _removeMarker() {
    if (_markers.isNotEmpty) {
      int randomIndex = Random().nextInt(_markers.length); // Get a random index
      setState(() {
        _markers.removeAt(randomIndex); // Remove the marker at the random index
      });
    }
  }

  bool _shouldShowButton() {
    if (_currentLocation != null) {
      for (Marker marker in _markers) {
        double distance = _calculateDistance(
          _currentLocation!.latitude!,
          _currentLocation!.longitude!,
          marker.position.latitude,
          marker.position.longitude,
        );
        if (distance <= 100) {
          return true;
        }
      }
    }
    return false;
  }

  double _calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    const int earthRadius = 6371000; // in meters
    double lat1 = startLatitude * pi / 180.0;
    double lon1 = startLongitude * pi / 180.0;
    double lat2 = endLatitude * pi / 180.0;
    double lon2 = endLongitude * pi / 180.0;

    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  void _updateButtonVisibility() {
    bool showButton = _shouldShowButton();
    setState(() {
      _isButtonVisible = showButton;
    });
  }
}
