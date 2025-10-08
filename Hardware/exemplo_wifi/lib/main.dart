
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    home: ConnectionStatusScreen(),
  ));
}

class ConnectionStatusScreen extends StatefulWidget {
  const ConnectionStatusScreen({super.key});

  @override
  State<ConnectionStatusScreen> createState() => _ConnectionStatusScreenState();
}

class _ConnectionStatusScreenState extends State<ConnectionStatusScreen> {
  //atributos
  String mensagem = ""; //informa o Status da Conexão
  //armazenar as conexões do dispositivo
  //( a cada mudança de status a lista é modificada)
  late StreamSubscription<List<ConnectivityResult>> _conexao;

  // métodos
  // método para checagem inicial da conexão
  void _checkInitialConnection() async{
    ConnectivityResult result = (await Connectivity().checkConnectivity()) as ConnectivityResult;
    //criar um novo método
    _updateStatusConnection(result);
  }
  //método para atualizar o Status da Conexão
  void _updateStatusConnection(ConnectivityResult result) async{
    setState(() {
      switch (result) {
        case ConnectivityResult.wifi:
          mensagem = "Conectado no WIFI";          
          break;
        case ConnectivityResult.mobile:
          mensagem = "Conectado via Dados Móveis";
          break;
        case ConnectivityResult.none:
          mensagem = "Sem Conexão com a Internet";
          break; 
        default: 
          mensagem = "Procurando Conexão";
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 1. faz a verificação inical da conexão ao abrir o aplicativo
    _checkInitialConnection();
    // 2. Começo a aramazenar as mudança de status no meu STREAM
    _conexao = Connectivity().onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
        _updateStatusConnection(result);
      }
    );
  }

  
  //BUILD
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Status da Conexão"),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              //mudar de acordo com a conexão
              mensagem.contains("WIFI") ? Icons.wifi :
              mensagem.contains("Dados") ? Icons.network_cell : 
              Icons.wifi_off,
              size: 80,
              color: mensagem.contains("Sem Conexão") ? Colors.red : Colors.blue,
            ),
            SizedBox(height: 10,),
            Text("Status: $mensagem")
          ],
        ),
      ),
    );
  }
}