import 'dart:async';
import 'dart:typed_data';
//import 'dart:html';

import 'package:custom_marker/marker_icon.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();//to control the map
  TextEditingController _destinationController = TextEditingController();//for user's string destination
  late double latitudeDestination;
  late double longitudeDestination;
  late Map<String,dynamic> chosenType;
  bool weatherFilter = false;
  late int weatherCondition;
  //late Map<String,dynamic> nearbyPlaces;
  List<String> filter = [];
  late Map<String,dynamic> icon;
  bool FilterRowIsVisible =  false;
  final Map<String,List<String>> foodAndDrink = {'Food and drink': ['restaurant','bar','cafe','meal_takeway']};
  final Map<String,List<String>> thingsToDo = {'Things to do': ['amusement_park', 'aquarium', 'art_gallery', 'bowling_alley', 'campground', 'casino', 'movie_rental', 'movie_theater', 'museum', 'night_club', 'park', 'stadium', 'zoo']};
  final Map<String,List<String>> shopping = {'Shopping': ['book_store', 'clothing_store', 'convenience_store', 'department_store', 'electronics_store', 'furniture_store', 'grocery_or_supermarket', 'home_goods_store', 'jewelry_store', 'liquor_store', 'pet_store', 'shoe_store', 'shopping_mall']};
  final Map<String,List<String>> services = {'Services': ['airport', 'atm', 'bank', 'bus_station', 'car_rental', 'car_repair', 'car_wash', 'courthouse', 'dentist', 'doctor', 'electrician', 'embassy', 'fire_station', 'funeral_home', 'gas_station', 'gym', 'hair_care', 'hospital', 'insurance_agency', 'laundry', 'lawyer', 'library', 'local_government_office', 'locksmith', 'lodging', 'moving_company', 'painter', 'pharmacy', 'physiotherapist', 'plumber', 'police', 'post_office', 'real_estate_agency', 'roofing_contractor', 'rv_park', 'school', 'storage', 'subway_station', 'supermarket', 'synagogue', 'taxi_stand', 'train_station', 'transit_station', 'travel_agency', 'veterinary_care']};
  late List<Map<String,List<String>>> preferences;
  int selectedPreferenceIndex = 0;//to change color of container preferences when user choose

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
      preferences = [foodAndDrink,thingsToDo,shopping,services];
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

  void _setMarkerAttractions(String name,String vicinity,String photoUri, LatLng latlng) async{//adds the marker to the set of markers (sets of markers are the variables located above)

      _markers.add(//add is a function on class sets
        Marker(//adding the marker object (which are from the google class) to the _marker sets
          markerId: MarkerId(name),
          position: latlng,
          icon: await MarkerIcon.downloadResizePictureCircle(LocationService().getPhoto(photoUri), size: 150, addBorder: true, borderColor: Colors.white, borderSize: 15),//BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(
              title: name,
              snippet: vicinity),
        ),
      );
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

    setState(() {
      _polylines.add(
        Polyline(
          polylineId: PolylineId(polylineIdVal),
          width: 3,
          color:Colors.blue,
          points:points.map((point)=>LatLng(point.latitude,point.longitude)).toList(),//the lat and lng is from the variable diterima
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:false,//so that bila keyboard appears dia tak kecikkan container preferences
      body: Column(
        children: [
            Row(
              children: [
                  Expanded(
                    flex: 1,
                      child: TextFormField(
                          controller: _destinationController,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(hintText: "Search by location"),
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
                  setState((){
                    _markers.clear();
                    _polylines.clear();
                  }
                  );
                  _goToThePlace(placeDetails);
                  latitudeDestination=placeDetails['geometry']['location']['lat'];
                  longitudeDestination=placeDetails['geometry']['location']['lng'];
                  print(latitudeDestination);
                  print(longitudeDestination);
                  var weatherDetails = await WeatherService().getWeather(latitudeDestination, longitudeDestination);
                  var nearbyPlaces = await LocationService().getNearbyPlaces(latitudeDestination, longitudeDestination,preferences[selectedPreferenceIndex]);
                  showModalBottomSheet(context: context, builder: (context)=>buildSheet(weatherDetails,nearbyPlaces),);
                },icon:Icon(Icons.search),),
              ],
            ),
          preferencesWidget(),
          //what loads the google map
          Expanded(
            flex:15,
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
            ),
          ),
        ],
      ),
      //moves 1st camrea position to 2nd
    );
  }

  Future<void> _goToThePlace(Map<String, dynamic> place) async {//change camera position to the one we searched for and then create a new marker there (ni dulu)
      // updates camera position to include both origin and destination while making marker for the origin
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
    _setMarker(LatLng(lat, lng));
  }

  Future<void> _goToThePlaceIcon(double lat, double lng) async {//change camera position to the one we searched for and then create a new marker there (ni dulu)
    //updates camera position to include both origin and destination while making marker for the origin
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(//ni x pakai since we need origin and destination but this bascially moves the camera to the position
        CameraPosition(
            bearing: 0,
            target: LatLng(lat, lng),
            tilt: 59.440717697143555,
            zoom: 12)
    ));
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
      debugPrint(e.toString());
    });
  }

  Widget preferencesWidget()=>Expanded(
      flex: 1,
    child:Container(
      child: ListView.builder(
        itemCount: preferences.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          String categoryName = preferences[index].keys.first;
          return Container(
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(2),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  filter.add(preferences[index].keys.toString());
                  selectedPreferenceIndex = index;
                });
                print("attraction pressed: "+ preferences[index].toString());
              },
              child: Text(categoryName),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                backgroundColor: selectedPreferenceIndex == index ? Colors.teal : Colors.cyan,
              ),
            ),
          );
        },
      ),
    )
  );

  Widget buildSheet(Map<String, dynamic> weatherDetails,List<dynamic> nearbyPlaces)=>Container(

    child: Column(
      children:[
        weatherWidget(weatherDetails),
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
                                Container(
                                  child:Text(icon['weather'],
                                    style:TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
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


    bool user_ratings_total = false;
    bool opening_hours =false;
  Widget nearbyPlacesWidget(List<dynamic> nearbyPlaces)=>
      Expanded(
        flex:4,
        child: ListView.builder(
          itemCount: nearbyPlaces.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index){
            if(nearbyPlaces[index]['opening_hours']==null){
              opening_hours=false;
            }else if(nearbyPlaces[index]['opening_hours']==false){
              opening_hours=false;
            }else{
              opening_hours=true;
            };
            if(nearbyPlaces[index]['user_ratings_total']==null){
              user_ratings_total = false;
            }else{
              user_ratings_total = true;
            };

            var location = nearbyPlaces[index]['geometry']['location'];
            LatLng latlng = LatLng(location['lat'], location['lng']);
            print("LATLNG IS: "+latlng.toString());

            _setMarkerAttractions(nearbyPlaces[index]['name'], nearbyPlaces[index]['vicinity'],nearbyPlaces[index]['photos'][0]['photo_reference'], latlng);

            // _markers.add(//add is a function on class sets
            //   Marker(//adding the marker object (which are from the google class) to the _marker sets
            //       markerId: MarkerId(nearbyPlaces[index]['name']),
            //       position: latlng,
            //       icon:BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            //       infoWindow: InfoWindow(
            //         title: nearbyPlaces[index]['name'],
            //         snippet: nearbyPlaces[index]['vicinity']),
            //   ),
            // );
            print("Markers are: "+_markers.toString());
            return InkWell(
              child: Container(
                margin:EdgeInsets.fromLTRB(5, 5, 5, 5),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child:Row(
                  children:[
                    Expanded(
                      child: Column(
                        children:[
                          Container(
                            alignment: Alignment.centerLeft,
                            padding:EdgeInsets.all(10),
                              child: Text(nearbyPlaces[index]['name'],
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ),
                          Container(
                            child:Row(
                              children: [
                                Container(
                                  padding:EdgeInsets.all(10),
                                  alignment: Alignment.centerLeft,
                                  child: Text('Rating: '+nearbyPlaces[index]['rating'].toString()+"/5",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  child: Visibility(
                                    visible:user_ratings_total,
                                    child: Text(" ("+nearbyPlaces[index]['user_ratings_total'].toString()+")",
                                      textAlign: TextAlign.center,),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding:EdgeInsets.all(10),
                              child: Visibility(
                                visible:opening_hours,
                                  child: Text(opening_hours ? 'open now':'closed',
                                    textAlign: TextAlign.center),
                              ),
                          ),
                        ]
                      ),
                    ),
                    Expanded(
                      child: nearbyPlaces[index]['photos'] != null && nearbyPlaces[index]['photos'].isNotEmpty ? Image.network(
                        LocationService().getPhoto(nearbyPlaces[index]['photos'][0]['photo_reference']),
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                          return Image.asset('assets/images/placeholder.png', fit: BoxFit.cover);
                        },
                      )
                          : Image.network('https://www.northernlightspizza.com/wp-content/uploads/2017/01/image-placeholder.jpg', fit: BoxFit.cover),
                    ),
                  ]
                ),
              ),

              onTap: () async{
                _getCurrentPosition();
                //setState((){
                  _polylines.clear();
                  //_markers.clear();// COMMENT THIS OUT KALAU NAK TUNJUK ALL THE OTHER MARKERS.. I uncomment CAUSE I CANT MANAGE TO LET THE THING PRINT OUT THE WHOLE LIST INSTEAD OF JUST A FEW WHEN PRESSING DIFFERENT LEVELS
                  // _markers.add(//add is a function on class sets
                  //   Marker(//adding the marker object (which are from the google class) to the _marker sets
                  //     markerId:  MarkerId(nearbyPlaces[index]['name']),
                  //     position: latlng,
                  //     icon://BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                  //     await MarkerIcon.downloadResizePictureCircle(LocationService().getPhoto(nearbyPlaces[index]['photos'][0]['photo_reference']), size: 150, addBorder: true, borderColor: Colors.white, borderSize: 15),
                  //     infoWindow: InfoWindow(title: nearbyPlaces[index]['name'], snippet: nearbyPlaces[index]['vicinity']),
                  //   ),
                  // );
                //});

                var directions = await LocationService().getDirections((_currentPosition?.latitude).toString()+","+(_currentPosition?.longitude).toString(), nearbyPlaces[index]['geometry']['location']['lat'].toString()+","+nearbyPlaces[index]['geometry']['location']['lng'].toString());
                _goToThePlaceIcon(directions['start_location']['lat'],directions['start_location']['lng']);
                _setPolyline(directions['polyline_decoded']);
              },
            );
          }
        )
      );

}
