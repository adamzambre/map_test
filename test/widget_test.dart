// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/*class MapApp extends StatefulWidget {
  const MapApp({Key? key}) : super(key: key);

  @override
  State<MapApp> createState() => _MapAppState();
}

class _MapAppState extends State<MapApp> {
  double long = 49.5;
  double lat = -0.09;
  LatLng point = LatLng(49.5, -0.09);
  var location = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            onTap: (p) async {
              location = await Geocoder.local.findAddressesFromCoordinates(new Coordinates(p.latitude, p.longitude));

              setState(() {
                point = p;
                print(p);
              });

              print(
                  "${location.first.countryName} - ${location.first.featureName}");
            },
            center: LatLng(49.5, -0.09),
            zoom: 5.0,
          ),
          children:[
            TileLayer(
                  urlTemplate:"https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: point,
                  builder: (ctx) => Container(
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 34.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Card(
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(16.0),
                    hintText: "Search for your localisation",
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                          "${location.first.countryName},${location.first.locality}, ${location.first.featureName}"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}*/

