import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Tab2DetailScreen extends StatefulWidget{
  @override
  State<Tab2DetailScreen> createState() => _Tab2DetailScreenState();
}

class _Tab2DetailScreenState extends State<Tab2DetailScreen> {
  late GoogleSignInAccount?  user;

  late StreamSubscription<Position> _positionStreamSubcription;

  late LatLng _currentPosition = LatLng(0.0,0.0);

  late BitmapDescriptor _markerIcon;

  late BitmapDescriptor _pointIcon;

  PolylinePoints polylinePoints = PolylinePoints();

  Map<PolylineId, Polyline> polylines = {};

  late GoogleMapController googleMapController;

  final Completer<GoogleMapController> completer = Completer();

  List<String> total_location = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 600,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
                color: Color(0xFFF6F3F0),
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 400,),
                    Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      height: 200,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: _currentPosition,
                            zoom: 18.5,
                          ),
                          onMapCreated: (controller) {
                            setState(() {
                              googleMapController = controller;
                            });
                          },
                          mapToolbarEnabled: false,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}