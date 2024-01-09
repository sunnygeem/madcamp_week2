import 'dart:async';
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class Tab2DetailScreen extends StatefulWidget{
  final String trailName;
  final String trailNickname;

  Tab2DetailScreen({required this.trailName, required this.trailNickname});

  @override
  State<Tab2DetailScreen> createState() => _Tab2DetailScreenState();
}

class _Tab2DetailScreenState extends State<Tab2DetailScreen> {
  late GoogleSignInAccount?  user;

  late LatLng _currentPosition = LatLng(0.0,0.0);

  PolylinePoints polylinePoints = PolylinePoints();

  Map<PolylineId, Polyline> polylines = {};

  late GoogleMapController googleMapController;

  final Completer<GoogleMapController> completer = Completer();

  List<String> total_location = [];

  String _review = '';

  List<Marker> markers = [];

  late BitmapDescriptor _pointIcon;
  late BitmapDescriptor _markerIcon;

  List<LatLng> Latlnglist = [];

  @override
  Widget build(BuildContext context) {
    print(widget.trailName);
    print(widget.trailNickname);

    return AlertDialog(
        contentPadding: EdgeInsets.all(5.0),
      title: Text(''),
      content: Scaffold(
        backgroundColor: Colors.transparent,
        body:
        SingleChildScrollView(
          child: Column(
            children: [
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
              Text('등록자: ${widget.trailNickname}',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
              SizedBox(height: 5,),
              Text('${widget.trailName}',
                style: TextStyle(
                  color: Color(0xFF0B421A),
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFF0B421A),
                  elevation: 5.0,
                  fixedSize: Size(130, 10),
                ),
                onPressed: (){
                  _getStringData(widget.trailName);
                  _showReviewDialog();
                },
                child: Text(
                  '리뷰 등록하기',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          child: Text('닫기'),
        )
      ]
    );
  }

  Future<dynamic> _getJsonData(String trailName) async{
    try {
      // 이메일 주소를 인코딩하여 URI에 추가
      String encodedName = Uri.encodeComponent(trailName);
      final response = await http.get(Uri.parse('http://15.164.95.87:5000/getPosition?encodedName=$encodedName'));
      // 응답을 JSON으로 디코딩하여 반환
      var userJson = json.decode(response.body);
      return userJson;
    } catch (e) {
      print('Error getting JSON data - getPosition: $e');
      return null;
    }
  }
  //

  Future<List<String>?> _getStringData(String trailName) async {

  }

  void _showReviewDialog() {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                new Text("리뷰 등록"),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    hintText: '리뷰를 입력하세요.\n(15자 이내)',
                  ),
                  textAlign: TextAlign.center,
                  onSubmitted: (str) {
                    _review = str;
                    print(_review);
                  },
                ),
              ],
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text("등록"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}