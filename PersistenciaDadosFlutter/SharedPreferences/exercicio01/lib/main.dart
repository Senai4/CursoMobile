import 'package:flutter/material.dart';
import 'Tela01.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false, // Desabilita a bandeira de debug
    initialRoute: "/",  // Definindo a rota inicial
    routes: {
      "/": (context) => Tela01(),  // A rota inicial vai para a Tela01
    },
  ));
}
