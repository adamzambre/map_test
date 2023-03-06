import 'dart:async';
//import 'dart:html';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_test/Services/location_service.dart';
import 'package:geolocator/geolocator.dart';//get current location
import 'package:map_test/Services/weather_service.dart';
import 'package:slider_button/slider_button.dart';
import 'package:weather/weather.dart';
import 'package:weather_icons/weather_icons.dart';


class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();//to control the map
  TextEditingController _destinationController = TextEditingController();//for user's string destination
  late double latitudeDestination;
  late double longitudeDestination;
  late String chosenType;
  bool weatherFilter = false;
  late int weatherCondition;
  //late Map<String,dynamic> nearbyPlaces;
  List<String> filter = [];
  late Map<String,dynamic> icon;
  bool FilterRowIsVisible =  false;

  //types of attractions
  List<String> attractions = ['tourist attraction','restaurant','lodging','park','shopping mall'];

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
      appBar:AppBar(title:Text('Chicken Soupz'),),
      body: Column(
        children: [
          Row(
            children: [
                Expanded(
                    child: TextFormField(
                        controller: _destinationController,
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
                ),
              IconButton(onPressed: () async{
                var placeDetails = await LocationService().getPlace(_destinationController.text);//get details of destination
                print('placeDetails vartype is: '+ placeDetails.runtimeType.toString());
                _goToThePlace(placeDetails);
                latitudeDestination=placeDetails['geometry']['location']['lat'];
                longitudeDestination=placeDetails['geometry']['location']['lng'];
                print(latitudeDestination);
                print(longitudeDestination);
                var weatherDetails = await WeatherService().getWeather(latitudeDestination, longitudeDestination);
                var nearbyPlaces = await LocationService().getNearbyPlaces(latitudeDestination, longitudeDestination);
                print('nearbyPlaces vartype is: '+ nearbyPlaces.runtimeType.toString());
                showModalBottomSheet(context: context, builder: (context)=>buildSheet(weatherDetails,nearbyPlaces),);

                // var directions = await LocationService().getDirections(_originController.text, _destinationController.text);
                //
                // _goToThePlace(
                //     directions['start_location']['lat'],
                //     directions['start_location']['lng'],
                //     directions['bounds_ne'],
                //     directions['bounds_sw'],
                // );
                //
                // _setPolyline(directions['polyline_decoded']);
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

  Future<void> _goToThePlace(Map<String, dynamic> place) async {//change camera position to the one we searched for and then create a new marker there (ni dulu)
                                                            //updates camera position to include both origin and destination while making marker for the origin
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];

    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(//ni x pakai since we need origin and destination but this bascially moves the camera to the position
        CameraPosition(
            bearing: 0,
            target: LatLng(lat, lng),
            tilt: 59.440717697143555,
            zoom: 12)
    ));
    
    // controller.animateCamera(CameraUpdate.newLatLngBounds(//animation of the camera macam dalam google map bila tekan recenter but in this case dia bukak the map to be more larger
    //     LatLngBounds(
    //         southwest: LatLng(boundsSw['lat'],boundsSw['lng']),
    //         northeast: LatLng(boundsNe['lat'],boundsNe['lng']),
    //     ),
    //     25)
    // );

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

  Widget buildSheet(Map<String, dynamic> weatherDetails,List<dynamic> nearbyPlaces)=>Container(

    child: Column(
      children:[
        Flexible(//tukar this widget to drop down
          flex:1,
          child:Container(
            height:50,
            child: ListView.builder(
              itemCount: attractions.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(2),
                  child: ElevatedButton(
                      onPressed: () {
                        print("attraction pressed");
                        chosenType=attractions[index];
                      },
                      child: Text(attractions[index]),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: Colors.cyan,
                      ),
                    ),
                );
              },
            ),
          ),
        ),
        //SliderButtonWeather(),
        weatherWidget(weatherDetails),
        //WidgetShowingWhatisFiltered(),
        nearbyPlacesWidget(nearbyPlaces),
      ]
    )
  );


    Widget weatherWidget(Map<String, dynamic> weatherDetails)=> 
        Flexible(
          flex:2,
          child: Container(
            height:150,
            child: ListView.builder(
                itemCount: 24,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index){
                  String hour = WeatherService().getHour(weatherDetails['date'][index]);
                  icon = WeatherService().getIcon(weatherDetails['weathercode'][index], hour);
                    return InkWell(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(10,10,10,5),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Colors.blue,
                                  Colors.red,
                                ],
                              ),
                            ),
                            child: Column(
                              children: [
                                BoxedIcon(icon['icon']),
                                Container(
                                    margin:EdgeInsets.all(5),
                                    child: Text(
                                    weatherDetails['temperature_2m'][index].toString()+"℃",
                                  style:TextStyle(
                                      fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )
                                ),
                              ],
                            ),
                          ),
                          Container(
                              child: Text(
                                  hour,
                              style:TextStyle(
                                fontWeight: FontWeight.w600,
                              )),
                          )
                        ],
                      ),
                      onTap: () {
                        print("The icon is clicked");
                        filter.add(icon['weather']);
                        FilterRowIsVisible = true;
                        print(FilterRowIsVisible);
                        print(filter.toString());
                      },
                    );
                }
            ),
          ),
        );


    // Widget WidgetShowingWhatisFiltered()=>
    //     Expanded(
    //       child: Visibility(
    //         visible:FilterRowIsVisible,
    //         child: ListView.builder(
    //             itemCount: filter.length,
    //             scrollDirection: Axis.horizontal,
    //             itemBuilder: (context, index){
    //               final item = filter[index];
    //               return Dismissible(
    //                   key: Key(item),
    //                   child: Container(
    //                     margin:EdgeInsets.fromLTRB(10, 10, 10, 5),
    //                     child:Text(icon['weather']),
    //                   ),
    //                   onDismissed: (direction) {
    //                     // Remove the item from the data source.
    //                     setState(() {
    //                       filter.removeAt(index);
    //                     });
    //                   });
    //                 // margin:EdgeInsets.fromLTRB(10, 10, 10, 5),
    //                 //   child: Column(
    //                 //     crossAxisAlignment: CrossAxisAlignment.center,
    //                 //     children: [
    //                 //       Container(
    //                 //         alignment: FractionalOffset.topRight,
    //                 //         child: IconButton(
    //                 //           onPressed: () {
    //                 //             Navigator.pop(context);
    //                 //             filter.remove(filter[index]);
    //                 //             print(filter.toString());
    //                 //           },
    //                 //           icon: const Icon(Icons.clear),
    //                 //         ),
    //                 //       ),
    //                 //       Text(icon['weather']),
    //                 //     ],
    //                 //   ),
    //                 // );
    //             }
    //         ),
    //       ),
    //     );

  Widget nearbyPlacesWidget(List<dynamic> nearbyPlaces)=>
      Expanded(
        flex:4,
        child: ListView.builder(
          itemCount: nearbyPlaces.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index){
            return Container(
              child:Text("test: "+nearbyPlaces[index]['name']),
            );
          }
        )
      );

}
