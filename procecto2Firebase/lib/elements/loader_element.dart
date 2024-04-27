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
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
              color ?? Colors.blue), // Color del indicador de progreso
          strokeWidth: size ?? 4.0, // Grosor del indicador de progreso
        ),
        if (message != null) // Si se proporciona un mensaje, mostrarlo
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              message,
              style: TextStyle(
                color: Colors.black, // Color del texto del mensaje
                fontSize: 16.0, // Tamaño del texto del mensaje
              ),
            ),
          ),
      ],
    ),
  );
}
