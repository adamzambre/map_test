import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(51.509364, -0.128928),
        zoom: 15.2,
      ),
      nonRotatedChildren: [
        //AttributionWidget.defaultWidget(
          //source: 'OpenStreetMap contributors',
          //onSourceTapped: null,
        //),
      ],
      children:[
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
      ],
    );
  }
}
