import 'package:test_app_weather/models/city_weather_info.dart';

abstract class CityWeatherState {}

/// Состояние отсутсвия данных
class CityWeatherEmptyState extends CityWeatherState {}

/// Данные находятся в процессе загрузки
class CityWeatherLoadingState extends CityWeatherState {}

/// Данные успешно загруженны
class CityWeatherLoadedState extends CityWeatherState {
  CityWeatherInfo loadedCityWeather;
  CityWeatherLoadedState({required this.loadedCityWeather});
}

/// Состояние, когда произошла ошибка
class CityWeatherErrorState extends CityWeatherState {
  final String? exception;

  CityWeatherErrorState(this.exception);
}
