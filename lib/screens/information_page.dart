import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:test_app_weather/bloc/city_weather_info_bloc.dart';
import 'package:test_app_weather/bloc/states/city_weather_info_state.dart';
import 'package:test_app_weather/data/data_service.dart';
import 'package:test_app_weather/models/city_weather_info.dart';
import 'package:test_app_weather/utils/constants.dart';
import 'package:test_app_weather/utils/pages.dart';
import 'package:test_app_weather/widgets/my_snack_bar.dart';

/// Страница с подробной информацией о погоде в городе
class InformationPage extends StatelessWidget {
  final String cityName;
  InformationPage({Key? key, required this.cityName}) : super(key: key);

  late Future<CityWeatherInfo> weatherInfo = getCityWeatherInfo(cityName);

  /// Количество временных меток, отображаемое на странице
  /// Не должно превышать cnt из JSON
  // static const int numberOfTimestampsInRow = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cityName.toUpperCase()),
        centerTitle: true,
        leading: IconButton(
          tooltip: 'Выбор города',
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              selectionPage,
            );
          },
        ),
        actions: [
          IconButton(
            tooltip: 'Прогноз на три дня',
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.pushNamed(context, weatherForThreeDaysPage,
                  arguments: cityName);
            },
          ),
        ],
      ),
      body: BodyInfoPage(cityName: cityName),
    );
  }
}

/// Виджет, помещающийся в [body] у Scaffold
/// Принимает [cityName] — название города. Вводится в Form на первом экране [SelectionPage]
class BodyInfoPage extends StatelessWidget {
  final String cityName;

  const BodyInfoPage({super.key, required this.cityName});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
        final description =
            state.loadedCityWeather.list![0].weather![0].description.toString();

        final temp = state.loadedCityWeather.list![0].main!.temp.toString();
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    cityName.toUpperCase(),
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('$temp˚C | $description',
                      style: Theme.of(context).textTheme.subtitle1)
                ],
              ),
            ),
            SizedBox(
              width: size.width,
              height: 220,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.custom(
                  scrollDirection: Axis.horizontal,
                  childrenDelegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: hourlyWeather(
                        state.loadedCityWeather.list![index],
                      ),
                    ),
                    childCount: 5,
                  ),
                ),
              ),
            ),
            SizedBox(
                height: size.height / 2,
                width: size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: dridDetailedWeather(
                    // подробные характеристи для текущего времени
                    state.loadedCityWeather.list![0],
                  ),
                ))
          ],
        );
      }
      if (state is CityWeatherErrorState) {
        return mySnackBar(context, state.exception);
      }
      return const SizedBox();
    });
  }
}

/// Основная информация о погоде (дата, время, температура)
/// Принимает listWeather — snapshot.data!.list![index], полученное из JSON
/// Возвращает TextButton() с датой, картинкой и температурой, расположенные в Column()
hourlyWeather(ListWeather listWeather) {
  // конвертирует дату из Unix в формат "dd/MM HH a"
  String dayTime = DateFormat("dd/MM").format(
      DateTime.fromMillisecondsSinceEpoch(listWeather.dt!.toInt() * 1000));
  String hourTime = DateFormat("HH a").format(
      DateTime.fromMillisecondsSinceEpoch(listWeather.dt!.toInt() * 1000));

  String temperature = listWeather.main!.temp.toString();

  return Container(
    width: 100,
    decoration: BoxDecoration(
      color: kAccentColor.withOpacity(0.6),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          hourTime,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(dayTime),
        const SizedBox(
          height: 20,
        ),
        Image.network(
            'http://openweathermap.org/img/wn/${listWeather.weather![0].icon}@2x.png'),
        const SizedBox(
          height: 20,
        ),
        Text(
          '$temperature˚C',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    ),
  );
}

/// Возвращает GridView, содержащий дополнительную информацию о погоде в городе
/// Принимает listWeather — snapshot.data!.list![index], полученное из JSON
/// Возвращает GridView(), сформированный из dridDetailedWeatherCard()
dridDetailedWeather(ListWeather listWeather) {
  return GridView(
    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: 200,
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
    ),
    children: [
      dridDetailedWeatherCard(
          'Ощущается как', '${listWeather.main!.feelsLike.toString()}˚C'),
      dridDetailedWeatherCard(
          'Вероятность осадков', '${listWeather.pop! * 100} %'), //////
      dridDetailedWeatherCard(
          'Скорость ветра', '${listWeather.wind!.speed} м/с'),
      dridDetailedWeatherCard('Влажность', '${listWeather.main!.humidity} %'),
      dridDetailedWeatherCard('Атмосферное давление',
          '${listWeather.main!.pressure! * 100 ~/ 133.3} мм.рт.ст'),
      dridDetailedWeatherCard(
          'Видимость', '${listWeather.visibility! ~/ 1000} км'),
    ],
  );
}

/// Макет плитки для представления дополнительной информации о погоде в городе.
/// Принимает description — характеристика погоды; value — значение, полученное из JSON
/// Возвращает Container() с текстом внутри
dridDetailedWeatherCard(String description, String value) {
  return Padding(
    padding: const EdgeInsets.all(18.0),
    child: Container(
      // height: 100,
      //width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: kAccentColor,
            blurRadius: 12.0,
            offset: Offset(
              0.0,
              3.0,
            ),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            description,
            textAlign: TextAlign.center,
          ),
          Text(value),
        ],
      ),
    ),
  );
}
