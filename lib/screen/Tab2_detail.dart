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

  List<double> Latlnglist = [];

  @override
  Widget build(BuildContext context) {
    print(widget.trailName);
    print(widget.trailNickname);


    return AlertDialog(
        contentPadding: EdgeInsets.all(5.0),
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
                        Latlnglist = _getStringData(widget.trailName) as List<double>;
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
                  _showReviewDialog();
                },
                child: Text(
                  '리뷰 등록하기',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Text(
                '[ 등록된 리뷰 ]',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF0B421A),
                ),
              ),
              Center(
                child: Column(
                  children: [
                    FutureBuilder<List<String>?>(
                      future: _getRevJsonData(widget.trailName),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting){
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError){
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else {
                          List<String> trailReviews = snapshot.data ?? [];
                          print(trailReviews);
                          return Theme(
                            data: ThemeData(
                              cardTheme: const CardTheme(
                                color: Colors.transparent,
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(20.0),
                              height: 650,
                              child: ListView.builder(
                                itemCount: ((trailReviews.length)/2).round(),
                                itemBuilder: (context, index) {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                              child: Column(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(
                                                        '작성자: '+trailReviews[index*2 + 1],
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      SizedBox(height: 10,),
                                                      Text(
                                                        trailReviews[index*2],
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Divider(),
                                                ],
                                              ),

                                            ),
                                        SizedBox(height: 10,),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
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

  Future<List<double>?> _getStringData(String trailName) async {
    try{
      dynamic jsonData = await _getJsonData(trailName);

      if (jsonData != null && jsonData is List){
        List<String> latlngList = [];
        List<double> doubleList = [];

        for (var row in jsonData){
          if (row is Map<String, dynamic>){
            String stringData = jsonData.toString();
            latlngList = splitAndCleanData(stringData);
            print(latlngList);
          }

          for(int i=0; i<latlngList.length; i++){
            doubleList.add(double.parse(latlngList[i]));
          }

          print(doubleList);
        }
        return doubleList;
      } else {
        return null;
      }
    } catch (e){
      print('Error getting latlngList: $e');
      return null;
    }
  }

  List<String> splitAndCleanData(String data) {
    List<String> items = data
        .replaceAll('}]', '')
        .replaceAll('[{positions: ', '')
        .replaceAll('LatLng(', '')
        .replaceAll(')', '')
        .split(', ');

    return items;
  }

  Future<List<String>?> _getRevJsonData(String trailName) async{
    try {
      // 이메일 주소를 인코딩하여 URI에 추가
      String encodedName = Uri.encodeComponent(trailName);

      List<String> reviews = [];

      final response = await http.get(Uri.parse('http://15.164.95.87:5000/getReview?encodedName=$encodedName'));
      // 응답을 JSON으로 디코딩하여 반환
      var userJson = json.decode(response.body);

      dynamic json_row_from_trailName = await userJson;

      for(int i=0; i<json_row_from_trailName.length; i++){
        String revFromName = '';
        String nicFromName = '';

        if(json_row_from_trailName[i] != null && json_row_from_trailName[i] is Map<String, dynamic>){
          if(json_row_from_trailName[i].containsKey('review')){
            String tmpRev = json_row_from_trailName[i]['review'];
            revFromName = tmpRev;
          }
          if(json_row_from_trailName[i].containsKey('rev_nickname')){
            String tmpNickname = json_row_from_trailName[i]['rev_nickname'];
            nicFromName = tmpNickname;
          }
        }

        reviews.add(revFromName);
        reviews.add(nicFromName);
      }


      return reviews;
    } catch (e) {
      print('Error getting JSON data - getReview: $e');
      return null;
    }
  }

  insertDataToRev(String trailName, String review, String nickname) async {
    dynamic data = {'trail_name': trailName, 'review': review, 'rev_nickname': nickname,};
    String jsonString = jsonEncode(data);
    try {
      final response = await http.post(Uri.parse('http://15.164.95.87:5000/sendReview'),
          headers: {"Content-Type": "application/json"}, body: jsonString);
      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");
    } catch (e) {
      print("Error: $e");
    }
  }

  void _showReviewDialog() {
    showDialog(
        context: context,
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
                    if(str.length > 15 || str == '' || str == null){
                      _showErrMsg();
                    }
                    else{
                      _review = str;
                      print(_review);
                    }
                  },
                ),
              ],
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text("등록"),
                onPressed: () {
                  insertDataToRev(widget.trailName, _review, widget.trailNickname);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void _showErrMsg() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: Text('입력 글자 수가 15자를 초과했거나, 리뷰를 입력하지 않았습니다.',
            style: TextStyle(
              fontSize: 13,
            ),
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text("창 닫기"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}