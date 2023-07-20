import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

class Mapping extends StatefulWidget {
  const Mapping({Key? key}) : super(key: key);

  @override
  State<Mapping> createState() => _MappingState();
}

late GoogleMapController _controller;
Future<Position> getUserCurrentLocation() async {
  await Geolocator.requestPermission().then((value){
  }).onError((error, stackTrace) async {
    await Geolocator.requestPermission();
    print("ERROR"+error.toString());
  });
  return await Geolocator.getCurrentPosition();
}

final CameraPosition _initialPosition =
CameraPosition(
    target: LatLng(37.296765, 126.835247),
    zoom: 20 );




class _MappingState extends State<Mapping> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("mapping")),
      body: Container(
        child: GoogleMap(
          initialCameraPosition: _initialPosition,
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,

        ),
      ),
    );
  }
}
