  import 'package:flutter/material.dart';

String getNumeroName(String palabra){

    for (int i = 0; i < palabra.length; ++i){
      if (palabra[i] == ':') return palabra.substring(0, i);
    }

    return '0';

  }

  String getNameSinNumero(String palabra){

    for (int i = palabra.length - 1; i >= 0; --i){
      if (palabra[i] == ':') return palabra.substring(i + 2, palabra.length);
    }

    return '0';

  }

  Color getAppColor(String color, int potencia){

    if (color == 'lila') return Colors.deepPurple[potencia];
    else if (color == 'rojo') return Colors.red[potencia];
    else if (color == 'marron') return Colors.brown[potencia];
    else if (color == 'verde') return Colors.green[potencia + 100];
    else if (color == 'azul') return Colors.blue[potencia];
    else if (color == 'rosa') return Colors.pink[potencia];
    else if (color == 'naranja') return Colors.orange[potencia];

  }