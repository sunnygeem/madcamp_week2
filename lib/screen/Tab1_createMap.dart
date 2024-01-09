import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

class MapScreen extends StatefulWidget {
  final GoogleSignInAccount? user;
  const MapScreen({super.key, required this.user});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  late StreamSubscription<Position> _positionStreamSubcription;
  late LatLng _currentPosition;
  late BitmapDescriptor _markerIcon;
  late BitmapDescriptor _pointIcon;
  late String _trailName = '';

  void onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
    if (!completer.isCompleted) {
      completer.complete(controller);
    }
  }

  List<Marker> markers = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  late GoogleMapController googleMapController;
  final Completer<GoogleMapController> completer = Completer();

  List<String> total_location = [];

  addMarker(latLng, newSetState) {
    markers.add(
        Marker(
          consumeTapEvents: false,
          markerId: MarkerId(latLng.toString()),
          position: latLng,
          icon: _pointIcon,
        ));
    if (markers.length > 1) {
      getDirections(markers, newSetState);

      googleMapController.animateCamera(
        CameraUpdate.newLatLngZoom(markers.last.position, 18.5),
      );
    }
    newSetState(() {});
  }

  getDirections(List<Marker> markers, newSetState) async {
    print('getDirections function run');
    List<LatLng> polylineCoordinates = [];

    for (var i = 0; i < markers.length; i++) {
      polylineCoordinates.add(markers[i].position);
    }

    addPolyLine(polylineCoordinates, newSetState);
  }

  addPolyLine(List<LatLng> polylineCoordinates, newSetState) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Color(0xFF0B421A),
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    newSetState(() {});
  }

  @override
  void initState() {
    super.initState();
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high,)
        .then((Position initialPosition) {
      setState(() {
        _currentPosition =
            LatLng(initialPosition.latitude, initialPosition.longitude);
        markers.add(
            Marker(
              consumeTapEvents: true,
              markerId: MarkerId('start'),
              position: _currentPosition,
              icon: _markerIcon,
            ));
      });
    });
    _initMarkerIcon();
    _initPositionStream();
  }

  void _initMarkerIcon() async {
    _markerIcon = await getMarkerIcon();
    _pointIcon = await getMarkerIcon2();
  }

  void _initPositionStream() {

    _positionStreamSubcription =
        Geolocator.getPositionStream(
          locationSettings: AndroidSettings(
            accuracy: LocationAccuracy.high,
            // distanceFilter: 5,
            intervalDuration: Duration(seconds: 30),
          ),
        ).listen((Position position) {
          setState(() {
            _currentPosition = LatLng(position.latitude, position.longitude);
            addMarker(_currentPosition, setState);
          });
        });
  }

  @override
  void dispose() {
    _positionStreamSubcription.cancel();
    super.dispose();
  }

  Future<BitmapDescriptor> getMarkerIcon() async {
    return BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      'assets/pin_mini.png',
    );
  }

  Future<BitmapDescriptor> getMarkerIcon2() async {
    return BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      'assets/pin_point.png',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            child: Container(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _currentPosition,
                  zoom: 18.5,
                ),
                markers: markers.toSet(),
                mapToolbarEnabled: false,
                onMapCreated: onMapCreated,
                polylines: Set<Polyline>.of(polylines.values),

              ),
            ),
          ),
          Positioned(
            bottom: 60,
            left: MediaQuery
                .of(context)
                .size
                .width / 2 - 100,
            child: ElevatedButton(
              onPressed: () {
                dispose();

                for (var i = 0; i < 5; i++) {
                  if (i == 0) {
                    total_location.add(
                      markers[(i * (markers.length / 4)).round()].position
                          .toString(),
                    );
                  } else {
                    total_location.add(
                      markers[(i * (markers.length / 4)).round() - 1].position
                          .toString(),
                    );
                  }
                }

                print(total_location);

                // upload total_location to db
                insertDataToPos();
                insertDataToTrail('${widget.user?.email}');
                //

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF0B421A),
                onPrimary: Colors.white,
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                fixedSize: Size(200, 50),
                elevation: 8,
              ),
              child: const Text('STOP'),
            ),
          ),
          Positioned(
            top: 50, // 적절한 위치로 조정
            left: 0,
            right: 0,
            child: Container(
              width: 300,
              height: 300,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  isDense: true,
                  hintText: '새로운 산책로의 이름을 입력하세요.',
                ),
                textAlign: TextAlign.center,
                onSubmitted: (str) {
                  _trailName = str;
                  print(_trailName);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  insertDataToPos() async {
    dynamic data = {'trail_name': _trailName, 'location1': total_location[0], 'location2': total_location[1], 'location3': total_location[2], 'location4': total_location[3], 'location5': total_location[4], };
    String jsonString = jsonEncode(data);
    print('!!!!!!!!!!'+jsonString+'!!!!!!!!!!!!');
    try {
      final response = await http.post(Uri.parse('http://15.164.95.87:5000/sendPosition'),
          headers: {"Content-Type": "application/json"}, body: jsonString);
      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");
    } catch (e) {
      print("Error: $e");
    }
  }

  insertDataToTrail(String email) async {
    dynamic data = {'trail_name': _trailName, 'user_email': email};
    String jsonString = jsonEncode(data);
    print('??????????'+jsonString+'????????????');
    try {
      final response = await http.post(Uri.parse('http://15.164.95.87:5000/sendTrail'),
          headers: {"Content-Type": "application/json"}, body: jsonString);
      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");
    } catch (e) {
      print("Error: $e");
    }
  }
}



