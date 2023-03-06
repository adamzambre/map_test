import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:weather_icons/weather_icons.dart';

class WeatherService{

  final String key = 'a2714ebd3124f49b5c5ea2b19efd8dfe';

  Future<Map<String, dynamic>> getWeather(double lat, double lng) async{

    final String url = 'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lng&hourly=weathercode,temperature_2m';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    var results = {
      'date':json['hourly']['time'],
      'temperature_2m':json['hourly']['temperature_2m'],
      'weathercode':json['hourly']['weathercode'],
    };//casting the result as a map

    print("THIS IS THE RESULT OF THE JSON Weather:"+ results.toString());

    return results;
  }

  String getHour(String isoDate){

    String hourAndMinutes = DateFormat.jm().format(DateTime.parse(isoDate));

    return hourAndMinutes;
  }

  Map<String,dynamic> getIcon(int weatherCode, String hour){

    DateTime halfFormat = DateFormat("hh:mm a").parse(hour);
    String fullFormat = DateFormat("HH:mm").format(halfFormat);
    List<String> hourFullFormat = fullFormat.split(":");
    int hourInt = int.parse(hourFullFormat[0]);
    Map<String,dynamic> result = {};

    if(hourInt<=19){//siang
      if(weatherCode==0 ||weatherCode==1){
        return result ={
          'icon':WeatherIcons.day_sunny,
          'weather':"clear",
        };
      }else if (weatherCode==2 ||weatherCode==3){
        return result ={
          'icon':WeatherIcons.day_cloudy,
          'weather':"cloudy",
        };
      }else if(weatherCode==45 ||weatherCode==48){
        return result ={
          'icon':WeatherIcons.day_fog,
          'weather':"fog",
        };//
      }else if(weatherCode==51 ||weatherCode==52||weatherCode==53){
        return result ={
          'icon':WeatherIcons.day_sprinkle,
          'weather':"drizzle",
        };;
      }else if(weatherCode==61 ||weatherCode==63||weatherCode==65||weatherCode==80 ||weatherCode==81||weatherCode==82){
        return result ={
          'icon':WeatherIcons.day_rain,
          'weather':"rain",
        };;//
      }else if(weatherCode==95 ||weatherCode==96||weatherCode==99){
        return result ={
          'icon':WeatherIcons.day_thunderstorm,
          'weather':"thunderstrom",
        };;
      }else if(weatherCode==71 ||weatherCode==73||weatherCode==75||weatherCode==85 ||weatherCode==86){
        return result ={
          'icon':WeatherIcons.day_snow,
          'weather':"snow",
        };;//
      }
    }else{//malam
      if(weatherCode==0 ||weatherCode==1){
        return result ={
          'icon':WeatherIcons.night_clear,
          'weather':"clear",
        };;
      }else if (weatherCode==2 ||weatherCode==3){
        return result ={
          'icon':WeatherIcons.night_alt_cloudy,
          'weather':"cloudy",
        };;
      }else if(weatherCode==45 ||weatherCode==48){
        return result ={
          'icon':WeatherIcons.night_fog,
          'weather':"fog",
        };;//
      }else if(weatherCode==51 ||weatherCode==52||weatherCode==53){
        return result ={
          'icon':WeatherIcons.night_alt_sprinkle,
          'weather':"drizzle",
        };;
      }else if(weatherCode==61 ||weatherCode==63||weatherCode==65||weatherCode==80 ||weatherCode==81||weatherCode==82){
        return result ={
          'icon':WeatherIcons.night_rain,
          'weather':"rain",
        };;//
      }else if(weatherCode==95 ||weatherCode==96||weatherCode==99){
        return result ={
          'icon':WeatherIcons.night_alt_thunderstorm,
          'weather':"thunderstrom",
        };;
      }else if(weatherCode==71 ||weatherCode==73||weatherCode==75||weatherCode==85 ||weatherCode==86){
        return result ={
          'icon':WeatherIcons.night_alt_snow,
          'weather':"snow",
        };;//
      };
    };

    return result = {
      'icon':WeatherIcons.alien,
      'weather':'wadadogdoin',
    };
  }


}