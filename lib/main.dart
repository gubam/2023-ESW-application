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

  // 현재위치 가져오는 함수 리턴값이 존재하지 않고 함수 실행시 마커로 현재위치를 표현 + 카메라 이동
   getCurrentLocation() async{
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    LatLng currentLatLng = LatLng(position.latitude,position.longitude);

    setState(() {

      markers.add(
          Marker(

            markerId: MarkerId('current_location'),
            position: currentLatLng,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
          ),
        );
              _controller?.animateCamera(CameraUpdate.newLatLngZoom(currentLatLng,20));
    });
    return position;
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
                  getCurrentLocation();
                  print("f");


                });
              },
              icon:const Icon(Icons.autorenew)),
        ),

        body: GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
          },
          initialCameraPosition: _initialPosition,
          mapType: MapType.normal,
          markers: markers,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,

        ),
      ),
    );
  }
}


