import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(MaterialApp(home: AcelerometroScreen(),));
}

class AcelerometroScreen extends StatefulWidget {
  const AcelerometroScreen({super.key});

  @override
  State<AcelerometroScreen> createState() => _AcelerometroScreenState();
}

class _AcelerometroScreenState extends State<AcelerometroScreen> {
  //atributos
  List<double>? _acelerometroValues; //vai aramzenar os valores dos 3 eixos
  StreamSubscription<AccelerometerEvent>? _acelerometroSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //subscrição para cada leitura de um novo evento
    _acelerometroSubscription = accelerometerEventStream().listen((AccelerometerEvent e){
      setState(() {
        _acelerometroValues = <double>[e.x, e.y, e.z];
      });
    });
  }


  //build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Acelerômetro"),),
      //map dos Valores do Vetor

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Valores do Acelerêmetro"),
            SizedBox(height: 20,),
            Text("Eixo X: ${_acelerometroValues?[0].toStringAsFixed(1)?? "0"}"),
            Text("Eixo Y: ${_acelerometroValues?[1].toStringAsFixed(1)?? "0"}"),
            Text("Eixo Z: ${_acelerometroValues?[2].toStringAsFixed(1)?? "0"}"),
          ],
        ),
      ),
    );
  }
}