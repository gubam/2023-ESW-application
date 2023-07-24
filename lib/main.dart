import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {

//위치정보 허용 메세지
  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      print('Location permission granted.');
    } else {
      print('Location permission denied.');
    }
  }

  DatabaseReference ref = FirebaseDatabase.instance.ref();

  Object? b;
  List<Map<String, double>> gpsData =[];

  Future readData() async {
    final marker = await ref.child("numberMarker").get();
    final gps = await ref.child("gps").get();

    var number = marker.value;
    var _gps= gps.value as List<dynamic>?;
    if (_gps != null) {
      gpsData.clear();

    for(var data in _gps){
      double lati = data['lati'] as double;
      double long = data['long'] as double;
      gpsData.add({'lati': lati, 'long': long});
    }
    }

    setState(() {
      for (int i = 0; i < int.parse(number.toString()); i++) {
        markers.add(
          Marker(
            position: LatLng(gpsData[i]["lati"]!.toDouble(), gpsData[i]["long"]!.toDouble()),
            markerId: MarkerId(i.toString()),
          ),
        );
      }
      print(gpsData.toString());
    });

  }
  // 현재위치 가져오는 함수 리턴값이 존재하지 않고 함수 실행시 마커로 현재위치를 표현 + 카메라 이동
   getCurrentLocation() async{
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    LatLng currentLatLng = LatLng(position.latitude,position.longitude);
    setState(() {
              _controller?.animateCamera(CameraUpdate.newLatLngZoom(currentLatLng,20));
    });
  }

  //mapping controller
  GoogleMapController? _controller;
  //markers
  Set<Marker> markers = Set();
  //initial camera position
  final CameraPosition _initialPosition = CameraPosition(
      target: LatLng(36.2967660, 126.8352470),
      zoom: 20,

  );
  //initState


  @override
  void initState() {
    super.initState();
    requestLocationPermission();
    getCurrentLocation();

  }


  //application start
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Scaffold(
        appBar: AppBar(
          title: const Text('mapping'),
          leading: IconButton(
              onPressed: (){
                setState(() {
                  readData();
                  getCurrentLocation();
                  print(gpsData.toString());

                });
              },
              icon:const Icon(Icons.autorenew)),
        ),



        body: StreamBuilder<Object>(
          stream: null,
          builder: (context, snapshot) {
            return GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
              initialCameraPosition: _initialPosition,
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              markers: markers,
              onTap: (LatLng latLng) {
                // 지도를 탭했을 때 마커를 추가하거나 다른 작업을 수행할 수 있습니다.
                print('Map tapped at: $latLng');
              },


            );
          }
        ),
      ),
    );
  }
}


