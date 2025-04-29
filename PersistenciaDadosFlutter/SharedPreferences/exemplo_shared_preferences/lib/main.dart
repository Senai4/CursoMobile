import 'package:flutter/material.dart';

import 'tela_inicial.dart';

void main(){
  runApp(MaterialApp(
    home: TelaInicial(),
    theme: ThemeData(brightness: Brightness.light),
    darkTheme: ThemeData(brightness: Brightness.dark),
  ));
}