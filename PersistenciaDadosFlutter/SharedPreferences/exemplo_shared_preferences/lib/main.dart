import 'package:flutter/material.dart';

import 'tela_inicial.dart';

void main(){
  runApp(MaterialApp(
    initialRoute: "/",
    theme: ThemeData(brightness: Brightness.light),
    darkTheme: ThemeData(brightness: Brightness.dark),
  ));
}