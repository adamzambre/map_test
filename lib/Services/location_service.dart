import 'dart:ffi';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

//Handles connection to the places api

class LocationService{//gets data of the place from the json
  final String key = 'AIzaSyDhvydgqumkaJiN17EQ6eHEiHH4nipmWPo';

  Future<String> getPlaceId(String input) async{//getting the place id for the other uses in the api urls

    //url to get place from text
    final String url = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';

    var response = await http.get(Uri.parse(url));//make http req to the api using the above url

    var json = convert.jsonDecode(response.body);//convert the response to json

    var placeId = json['candidates'][0]['place_id'] as String;//take only certain parts of the json

    print("THIS IS THE PLACE ID:"+ placeId);

    return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String input) async{//get the actual place punya info from just the place id from the method above
    //kalau nak return json memang kena pakai Map<String, dynamic> (kalau print the map it looks just like a json)
    final placeId = await getPlaceId(input);

    //url to get details from text
    final String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    print('getPlace vartype in function is: '+ json.runtimeType.toString());

    var results = json['result'] as Map<String,dynamic>;//casting the result as a map

    print("THIS IS THE RESULT OF THE JSON:"+ results.toString());

    return results;
  }

  Future<Map<String, dynamic>> getDirections(String origin, String destination) async{//get polylines for the direction
    final String url = "https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$key";

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    print(json.toString());

    var results = {//how a map looks like for dart
      'bounds_ne':json['routes'][0]['bounds']['northeast'],
      'bounds_sw':json['routes'][0]['bounds']['southwest'],
      'start_location':json['routes'][0]['legs'][0]['start_location'],
      'end_location':json['routes'][0]['legs'][0]['end_location'],
      'polyline':json['routes'][0]['overview_polyline']['points'],
      'polyline_decoded':PolylinePoints().decodePolyline(json['routes'][0]['overview_polyline']['points']),//polyline data ada cuma encoded so kena decode that thing bruv
    };
    print(json);

    return results;
  }

  Future<List<dynamic>> getNearbyPlaces(double latitude, double longitude,Map<String,List<String>> type) async{//get the url to get data from nearby place
    int radius = 50000;
    String joinedTypes = type.values.join(",");
    String myString = joinedTypes.replaceAll(RegExp(r'[\[\]\s]+'), '');
    print("joinedTypes: "+myString);

    final String url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude%2C$longitude&radius=$radius&key=$key&type=$myString';
    print("url: "+url);

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    print('nearbyPlaces vartype in function is: '+ json.runtimeType.toString());

    var results = json['results'] as List<dynamic>;//cant cast as a map since it returns a list of maps actually

    print("THIS IS THE RESULT OF THE JSON NearbyPlaces:"+ results.toString());
    print('nearbyPlaces vartype in function is: '+ json.runtimeType.toString());

    return results;
  }

  String getPhoto(String photoReference){//get the url to get data from nearby place
    var photo = 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$photoReference&key=$key';
    return photo;
  }
}