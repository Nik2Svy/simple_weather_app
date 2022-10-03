import 'package:flutter/material.dart';
import 'package:test_app_weather/screens/information_page.dart';
import 'package:test_app_weather/screens/selection_page.dart';
import 'package:test_app_weather/screens/weather_for_a_few_days_page.dart';

// Страницы всего приложения

const String selectionPage = '/selectionPage';
const String informationPage = '/informationPage';
const String weatherForThreeDaysPage = '/weatherForThreeDaysPage';

generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case selectionPage:
      return MaterialPageRoute(builder: (context) => SelectionPage());
    case informationPage:
      return MaterialPageRoute(
          builder: (context) => InformationPage(
                cityName: settings.arguments.toString(),
              ));
    case weatherForThreeDaysPage:
      return MaterialPageRoute(
          builder: (context) => WeatherForThreeDaysPage(
                cityName: settings.arguments.toString(),
              ));
  }
}
