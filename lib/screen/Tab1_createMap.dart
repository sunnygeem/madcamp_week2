import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>{

  late StreamSubscription<Position> _positionStreamSubcription;
  late LatLng _currentPosition;
  late BitmapDescriptor _markerIcon;
  late BitmapDescriptor _pointIcon;

  void onMapCreated(GoogleMapController controller){
    googleMapController = controller;
    if (!completer.isCompleted){
      completer.complete(controller);
    }
  }

  List<Marker> markers = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  late GoogleMapController googleMapController;
  final Completer<GoogleMapController> completer = Completer();

  List<LatLng> result_LatLng = [];

  addMarker(latLng, newSetState){
    markers.add(
      Marker(
        consumeTapEvents: false,
        markerId: MarkerId(latLng.toString()),
        position: latLng,
        icon: _pointIcon,
    ));
    if(markers.length > 1){
      getDirections(markers, newSetState);

      googleMapController.animateCamera(
          CameraUpdate.newLatLngZoom(markers.last.position, 18.5),
      );
    }
    newSetState(() {});
  }

  getDirections(List<Marker> markers, newSetState) async{
    print('getDirections function run');
    List<LatLng> polylineCoordinates = [];

    // List<PolylineWayPoint> polylineWayPoints = [];
    // for(var i=0; i<markers.length; i++){
    //   polylineWayPoints.add(PolylineWayPoint(location:
    //   "${markers[i].position.latitude.toString()},${markers[i].position.longitude.toString()}",stopOver: true));
    // }

    for (var i=0; i<markers.length; i++){
      polylineCoordinates.add(markers[i].position);
    }

    addPolyLine(polylineCoordinates, newSetState);

    // try{
    //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    //       "AIzaSyA2UNVzsvPGUMmhXUb56oMyDCC4e40TqXk",
    //       PointLatLng(markers.first.position.latitude, markers.first.position.longitude),
    //       PointLatLng(markers.last.position.latitude, markers.last.position.longitude),
    //       travelMode: TravelMode.,
    //       wayPoints: polylineWayPoints
    //   );
    //   if(result.status == 'OK'){
    //     polylineCoordinates = result.points.map((point) => LatLng(point.latitude, point.longitude)).toList();
    //   } else{
    //     print('No valid route found');
    //   }
    // } catch (e){
    //   print('Error getting route: $e');
    // }
    //
    // newSetState(() {});
    // addPolyLine(polylineCoordinates, newSetState);
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
  void initState(){
    super.initState();
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high,).then((Position initialPosition) {
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

  void _initMarkerIcon() async{
    _markerIcon = await getMarkerIcon();
    _pointIcon = await getMarkerIcon2();
  }

  void _initPositionStream() {
    const updateInterval = Duration(seconds: 5);

    _positionStreamSubcription = Geolocator.getPositionStream().listen((Position position){
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

  Future<BitmapDescriptor> getMarkerIcon() async{
    return BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      'assets/pin_mini.png',
    );
  }

  Future<BitmapDescriptor> getMarkerIcon2() async{
    return BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      'assets/pin_point.png',
    );
  }

  @override
  Widget build(BuildContext context){
    return Stack(
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
          left: MediaQuery.of(context).size.width/2 - 100,
          child: ElevatedButton(
            onPressed: () {
              dispose();

              for(var i=0; i<markers.length; i++){
                result_LatLng.add(markers[i].position);
              }
              print(result_LatLng.toString());

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
      ],
    );
  }
}
