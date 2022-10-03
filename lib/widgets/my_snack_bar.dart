import 'package:flutter/material.dart';

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
