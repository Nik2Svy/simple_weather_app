import 'package:flutter/material.dart';
import 'package:test_app_weather/utils/constants.dart';

/// Экран ошибки, появляющийся при ошибке загрузки данных
/// Принимает context
/// Выполняет вызов [snakBar] и возваращает текст ошибки
mySnackBar(BuildContext context, String? exception) {
  Size size = MediaQuery.of(context).size;
  final snakBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.only(bottom: size.height / 2),
    content: Text('$exception'),
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () {},
    ),
  );

  // Позволяет вызвать [snakBar] сразу после завершения сборки
  WidgetsBinding.instance.addPostFrameCallback(
      (_) => ScaffoldMessenger.of(context).showSnackBar(snakBar));

  return const Center(
    child: Text('Ошибка получения данных'),
  );
}

/// Экран ошибки, появляющийся при ошибке загрузки данных
/// Принимает context
/// Выполняет вызов [showDialog] и возваращает текст ошибки
showAlertDialog(BuildContext context, String? exception) {
  Future.delayed(Duration.zero, (() {
    showDialog(
      context: context,
      barrierColor: kAccentColor.withOpacity(0.3),
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          content: Text('$exception'),
        );
      },
    );
  }));

  return const Center(
    child: Text('Ошибка получения данных'),
  );
}
