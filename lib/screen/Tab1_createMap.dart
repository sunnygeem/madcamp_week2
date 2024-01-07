import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main(){
  runApp(const CreateMap());
}

class CreateMap extends StatelessWidget {
  const CreateMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);

  Future<LatLng> getLocation() async{
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return LatLng(position.latitude, position.longitude);
    }catch (e) {
      print("Error: $e");
      return LatLng(132, 37);
    }
  }

  Future<BitmapDescriptor> getMarkerIcon() async{
    return BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      'assets/pin.png',
    );
  }

  @override
  Widget build(BuildContext context){
    return FutureBuilder(
      future: Future.wait([getLocation(), getMarkerIcon()]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          LatLng position = snapshot.data![0] as LatLng;
          BitmapDescriptor markerIcon = snapshot.data![1] as BitmapDescriptor;

          return Scaffold(
            body: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: position,
                zoom: 17.0,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('Me'),
                  position: position,
                  icon: markerIcon,
                )
              },
            ),
          );
        }
      },
    );
  }
}
