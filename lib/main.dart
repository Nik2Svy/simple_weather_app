import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app_weather/utils/pages.dart';
import 'package:test_app_weather/utils/theme.dart';
import 'package:test_app_weather/screens/selection_page.dart';

import 'bloc/city_weather_info_bloc.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => CityWeatherBloc(
          '',
        ),
      )
    ],
    child: const MyWeatherApp(),
  ));
}

class MyWeatherApp extends StatelessWidget {
  const MyWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: myTheme(),
      home: SelectionPage(),
      onGenerateRoute: (settings) => generateRoute(settings),
    );
  }
}
