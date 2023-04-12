import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app_weather/bloc/city_weather_info_bloc.dart';
import 'package:test_app_weather/bloc/events/city_weather_info_event.dart';
import 'package:test_app_weather/utils/pages.dart';

class SelectionPage extends StatefulWidget {
  SelectionPage({Key? key}) : super(key: key);

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  final _checkboxFormKey = GlobalKey<FormState>();

  late String cityName;

  bool _isTextFormFieldFull = true;

  void setCityName() {
    setState(() {
      cityName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CityWeatherBloc>(
      create: (context) => CityWeatherBloc(cityName),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Погода в городах Земли'),
          centerTitle: true,
        ),
        body: Center(
          child: Form(
            key: _checkboxFormKey,
            autovalidateMode: AutovalidateMode.disabled,
            onChanged: () {
              Form.of(primaryFocus!.context!)!.save();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textFormField('Название города'),
                const SizedBox(
                  height: 20,
                ),
                confirmationButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Форма для ввода названия города
  /// Принимает labelText — текст, который будет отображаться в параметре labelText у [InputDecoration]
  /// Возвращает форму для ввода названия города
  textFormField(String labelText) {
    return ConstrainedBox(
      constraints: BoxConstraints.tight(const Size(200, 100)),
      child: TextFormField(
        onChanged: (value) => cityName = value,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: labelText,
        ),
        validator: (value) {
          return emptyValidator(value);
        },
      ),
    );
  }

  /// Кнопка «Найти»
  /// При нажатии проверяется заполненность поля [textFormField] => передача названия города в [InformationPage]
  /// Возвращает [OutlinedButton]
  confirmationButton(BuildContext context) {
    final CityWeatherBloc cityWeatherBloc = context.read<CityWeatherBloc>();

    return OutlinedButton(
      onPressed: () {
        checkFields();
        setCityName();

        if (_isTextFormFieldFull) {
          cityWeatherBloc.city = cityName;
          cityWeatherBloc.add(CityWeatherLoadEvent());
          Navigator.pushReplacementNamed(
            context,
            informationPage,
            arguments: cityName,
          );
        }
      },
      child: const Text('Найти'),
    );
  }

  /// Проверяет заполненна ли форма [textFormField]
  checkFields() {
    _checkboxFormKey.currentState!.validate();
  }

  /// Заполнитель для validator в [TextFormField]
  /// Если заполненна, то [_isTextFormFieldFull = true], иначе возвращает строку для оттображения в ошибке
  emptyValidator(String? value) {
    if (value!.isEmpty) {
      setState(() {
        _isTextFormFieldFull = false;
      });

      return 'Введите название города';
    } else {
      setState(() {
        _isTextFormFieldFull = true;
      });
      return null;
    }
  }
}
