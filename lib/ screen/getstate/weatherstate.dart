import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:weather/weather.dart';

import '../../model/weathermodel.dart';

//import 'package:location/location.dart';
class WeatherControlloer extends GetxController {
  String _key = '856822fd8e22db5e1ba48c0e7d69844a';
  WeatherFactory? ws;
  //List<Weather> _data = [];
  //geolocator써서 현재 디바이스의 위경도 받아오기
  double? lat, lon;

  //코드에 따른 현 날씨
  //https://openweathermap.org/weather-conditions#Icon-list

  Widget? weatherIcon;
  Weather? w;
  double? degree;
  List<Weather>? forecastT;
  // Location? loc;
  // LocationData? currentLocation;
  //ws = new WeatherFactory(key, language: Language.KOREAN);
  void queryWeather() async {
    // await locc!.getLocation().then((value) {
    //   currentLocation = value;

    // });

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // Location loc = loc.
    lat = position.latitude;
    lon = position.longitude;

    ws = WeatherFactory(_key, language: Language.KOREAN);
    Weather weather = await ws!.currentWeatherByLocation(lat!, lon!);
    List<Weather> forecast = await ws!.fiveDayForecastByLocation(lat!, lon!);
    //Weather weather = await ws!.currentWeatherByLocation(currentLocation!.latitude as double, currentLocation!.longitude as double);
    w = weather;
    forecastT = forecast;
    //미세먼지도 해볼것
    weatherIcon = WeatherModel.getWeatherIcon(w!.weatherConditionCode);
    update();
  }
}
