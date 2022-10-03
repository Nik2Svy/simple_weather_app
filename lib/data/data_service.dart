import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:test_app_weather/models/city_weather_info.dart';

/// Возвращает JSON с информацией о погоде в городе [city].
/// Информация берется с сайта https://openweathermap.org/
Future<CityWeatherInfo> getCityWeatherInfo(String city) async {
  final queryParameters = {
    'q': city,
    'appid': 'a128a704f4d0a644b020c6fa70e253f0',
    'cnt': '25',
    'units': 'metric',
    'lang': 'ru',
  };
  final uri = Uri.https(
      'api.openweathermap.org', '/data/2.5/forecast', queryParameters);

  debugPrint(uri.toString());
  final response = await http.get(uri);
  debugPrint(response.body);

  if (response.statusCode == 200) {
    return CityWeatherInfo.fromJson(json.decode(response.body));
  } else {
    throw Exception('${response.reasonPhrase}');
  }
}
