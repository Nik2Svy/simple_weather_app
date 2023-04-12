import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:test_app_weather/bloc/city_weather_info_bloc.dart';
import 'package:test_app_weather/bloc/states/city_weather_info_state.dart';
import 'package:test_app_weather/models/city_weather_info.dart';
import 'package:test_app_weather/utils/constants.dart';
import 'package:test_app_weather/widgets/my_snack_bar.dart';

/// Страница с погодой на несколько дней
/// Дни отсортированны по увеличению температуры
class WeatherForThreeDaysPage extends StatelessWidget {
  final String cityName;
  WeatherForThreeDaysPage({Key? key, required this.cityName}) : super(key: key);

  late Future<CityWeatherInfo> weatherInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cityName.toUpperCase()),
        centerTitle: true,
      ),
      body: BodyWeatherFaFDPage(),
    );
  }
}

class BodyWeatherFaFDPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CityWeatherBloc, CityWeatherState>(
        builder: (context, state) {
      if (state is CityWeatherEmptyState) {
        return const Center(
          child: Text('No data received'),
        );
      }
      if (state is CityWeatherLoadingState) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (state is CityWeatherLoadedState) {
        /// Сортирует list в порядке увеличения текущей температуры
        state.loadedCityWeather.list!
            .sort((a, b) => a.main!.temp!.compareTo(b.main!.temp!));

        /// Создает прокручиваемый список виджетов с информцией о погоде
        return Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Погода на три дня в порядке увеличения температуры',
                  style: Theme.of(context).textTheme.headline3,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: ListView.custom(
                  childrenDelegate: SliverChildBuilderDelegate(
                (context, index) =>
                    listViewCard(state.loadedCityWeather.list![index]),
                childCount: state.loadedCityWeather.cnt!.toInt(),
              )),
            ),
          ],
        );
      }
      if (state is CityWeatherErrorState) {
        return showAlertDialog(context, state.exception);
      }
      return const SizedBox();
    });
  }
}

/// Содеражит основную информацию о погоде (дата, время, температура)
/// Принимает listWeather — snapshot.data!.list![index], полученное из JSON
/// Возвращает Container() с датой, картинкой и темпера, расположенные в Row()
listViewCard(ListWeather listWeather) {
  String dayTime = DateFormat("dd/MM").format(
      DateTime.fromMillisecondsSinceEpoch(listWeather.dt!.toInt() * 1000));
  String hourTime = DateFormat("HH a").format(
      DateTime.fromMillisecondsSinceEpoch(listWeather.dt!.toInt() * 1000));

  String temperature = listWeather.main!.temp.toString();

  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: kAccentColor.withOpacity(0.6),
      ),
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(hourTime),
              Text(dayTime),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Image.network(
              'http://openweathermap.org/img/wn/${listWeather.weather![0].icon}@2x.png'),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 100,
            child: Text(
              '$temperature˚C',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    ),
  );
}
