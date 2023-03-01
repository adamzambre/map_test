import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_test/Services/location_service.dart';
import 'package:geolocator/geolocator.dart';//get current location


class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();//to control the map
  TextEditingController _originController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();

  //current initial position
  String? _currentAddress;
  Position? _currentPosition;

  //store sets markers, polygons, and the lists of  lat and long of the polygons
  Set<Marker> _markers = Set<Marker>();
  Set<Polygon> _polygons = Set<Polygon>();
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polygonLatLng = <LatLng>[];


  //cause storing of more than 1 polygon
  // to change the polygon id
  int _polygonIdCounter = 1;
  int _polylineIdCounter = 1;

  //two camera objects (googleplex and lake)
  static CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(0, 0),
    zoom: 14.4746,
  );

    @override
    void initState(){
      super.initState();
      _getCurrentPosition();
    }

    //mengisi set set yg telah dibuat dengan method
    void _setMarker(LatLng point){//adds the marker to the set of markers (sets of markers are the variables located above)
      setState((){
        _markers.add(//add is a function on class sets
          Marker(//adding the marker object (which are from the google class) to the _marker sets
              markerId: MarkerId('marker'),
              position:point
          ),
        );
      });
    }

    void _setPolygon(){//setiap kali on tap screen, tambah lines on map (NOT POLYLINES)
      final String polygonIdVal = 'polygon_$_polygonIdCounter';
      _polygonIdCounter++;

      _polygons.add(
        Polygon(
          polygonId: PolygonId(polygonIdVal),
          points: polygonLatLng,
          fillColor: Colors.transparent,
          strokeWidth: 2,
        )
      );
    }

  void _setPolyline(List<PointLatLng> points){//the variable yg diterima is from the polyline_decoded
    final String polylineIdVal = 'polyline_$_polylineIdCounter';
    _polylineIdCounter++;

    _polylines.add(
      Polyline(
        polylineId: PolylineId(polylineIdVal),
        width: 2,
        color:Colors.blue,
        points:points.map((point)=>LatLng(point.latitude,point.longitude)).toList(),//the lat and lng is from the variable diterima
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title:Text('Chicken Soups'),),
      body: Column(
        children: [
          Row(
            children: [
                Expanded(
                  child: Column(
                    children:[
                      TextFormField(
                        controller: _originController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(hintText: "Search by heart origin"),
                        onChanged: (value){
                          print(value);
                        },
                      ),
                      // IconButton(onPressed: () async{
                      //   var place = await LocationService().getPlace(_searchController.text);
                      //   _goToThePlace(place);
                      // },icon:Icon(Icons.search),),
                      TextFormField(
                        controller: _destinationController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(hintText: "Search by heart destination"),
                        onChanged: (value){
                          print(value);
                        },
                      ),
                    ],
                  ),
                ),
              IconButton(onPressed: () async{
                var directions = await LocationService().getDirections(_originController.text, _destinationController.text);

                _goToThePlace(
                    directions['start_location']['lat'],
                    directions['start_location']['lng'],
                    directions['bounds_ne'],
                    directions['bounds_sw'],
                );

                _setPolyline(directions['polyline_decoded']);
              },icon:Icon(Icons.search),),
            ],
          ),
          //what loads the google map
          Expanded(
            child: GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              markers: _markers,
              polygons:_polygons,
              polylines: _polylines,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onTap: (point){//mmng function google yg trima latlng
                setState(() {
                  polygonLatLng.add(point);//add to the list
                  _setPolygon();//drops the polygon on the map
                });
              },
            ),
          ),
        ],
      ),
      //moves 1st camrea position to 2nd
    );
  }

  Future<void> _goToThePlace(double lat, double lng,Map<String,dynamic> boundsNe,Map<String,dynamic> boundsSw) async {//change camera position to the one we searched for and then create a new marker there (ni dulu)
                                                                                                                      //updates camera position to include both origin and destination while making marker for the origin
    //final double lat = place['geometry']['location']['lat'];
    //final double lng = place['geometry']['location']['lng'];

    final GoogleMapController controller = await _controller.future;

    // controller.animateCamera(CameraUpdate.newCameraPosition(//ni x pakai since we need origin and destination but this bascially moves the camera to the position
    //     CameraPosition(
    //         bearing: 0,
    //         target: LatLng(lat, lng),
    //         tilt: 59.440717697143555,
    //         zoom: 12)
    // ));
    
    controller.animateCamera(CameraUpdate.newLatLngBounds(//animation of the camera macam dalam google map bila tekan recenter but in this case dia bukak the map to be more larger
        LatLngBounds(
            southwest: LatLng(boundsSw['lat'],boundsSw['lng']),
            northeast: LatLng(boundsNe['lat'],boundsNe['lng']),
        ),
        25)
    );

    _setMarker(LatLng(lat, lng));
  }

  Future<void> _getCurrentPosition() async {
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _kGooglePlex = CameraPosition(
          target: LatLng(_currentPosition?.latitude ?? 0, _currentPosition?.longitude ?? 0),
          zoom: 14.4746,
        );
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }
}
