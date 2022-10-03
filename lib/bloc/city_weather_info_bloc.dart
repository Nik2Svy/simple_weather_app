import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app_weather/bloc/events/city_weather_info_event.dart';
import 'package:test_app_weather/bloc/states/city_weather_info_state.dart';
import 'package:test_app_weather/data/data_service.dart';
import 'package:test_app_weather/models/city_weather_info.dart';

/// BLoC для получения всей информации о погоде
class CityWeatherBloc extends Bloc<CityWeatherEvent, CityWeatherState> {
  String city;

  CityWeatherBloc(this.city) : super(CityWeatherEmptyState()) {
    on<CityWeatherLoadEvent>((event, emit) async {
      emit(CityWeatherLoadingState());
      try {
        final CityWeatherInfo loadedCityWeather =
            await getCityWeatherInfo(city);
        emit(CityWeatherLoadedState(loadedCityWeather: loadedCityWeather));
      } catch (e) {
        emit(CityWeatherErrorState(e.toString()));
      }
    });
  }
}





















//////////////////////////////////////
// enum FormStateBloc { event_empty, event_filled }

// abstract class FormScreenEvent {}

// /// Event
// class FormScreenEventSubmit extends FormScreenEvent {
//   final String cityName;
//   FormScreenEventSubmit(this.cityName);
// }

// /// State
// class FormScreenState {
//   final bool isBusy;
//   // final FormState fildState;
//   final bool submissionSuccess;
//   FormScreenState({
//     this.isBusy = false,
//     // this.fildState = FormState.event_empty,
//     this.submissionSuccess = false,
//   });
// }

// class FormBloc extends Bloc<FormScreenEvent, FormScreenState> {
//   FormBloc() : super(FormScreenState());

//   @override

//   /// Первоначальное состояние виджета
//   FormScreenState get initialState => FormScreenState();

//   @override

//   /// В зависимости от события создает новый state
//   Stream<FormScreenState> mapEventToState(FormScreenEvent event) async* {
//     if (event is FormScreenEventSubmit) {
//       yield FormScreenState(isBusy: true);

//       if (event.cityName.isEmpty) {
//         yield FormScreenState(submissionSuccess: false);
//         return;
//       }
//       yield FormScreenState(submissionSuccess: true);
//     }
//   }
// }
