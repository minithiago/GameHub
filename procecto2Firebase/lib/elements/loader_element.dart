import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildLoadingWidget({
  Color? color,
  double? size,
  String? message,
}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CupertinoActivityIndicator(
          color: (color ?? Color.fromARGB(255, 33, 215, 243)), // Color del indicador de progreso
          radius: size ?? 10,
           // Grosor del indicador de progreso
        ),
        if (message != null) // Si se proporciona un mensaje, mostrarlo
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.black, // Color del texto del mensaje
                fontSize: 16.0, // Tamaño del texto del mensaje
              ),
            ),
          ),
      ],
    ),
  );
}
