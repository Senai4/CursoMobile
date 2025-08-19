import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:json_web_service_clima/controllers/clima_controller.dart';
import 'package:json_web_service_clima/models/clima_model.dart';

//clase que chama a mudança de estado
class ClimaView  extends StatefulWidget{
  const ClimaView({super.key});//cosntrutor da super classe

  //método obrigatório para chamar as mudanças
  @override
  State<StatefulWidget> createState() {
    return _ClimaViewState();
  }
}

//classe resposável por contruir a tela com as mudanças de estado
class _ClimaViewState extends State<ClimaView>{
  //atributos
  final TextEditingController _cidadeController = TextEditingController();
  final ClimaController _controllerClima = ClimaController();
  ClimaModel? _clima;
  String? _erro;

  //método
  void _buscar() async{
    final cidade = _cidadeController.text.trim();
    try {
      final result = await _controllerClima.buscarClima(cidade);
      setState(() {
        if(result != null){
          _clima = result;
          _erro = null;
        }else {
          _clima = null;
          _erro = "Cidade não Encontrada";
        }
      });
    } catch (e) {
      print("Erro ao buscar cidade $e");
    }
  }

  //build Tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Clima em Tempo Real"),),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _cidadeController,
              decoration: InputDecoration(labelText: "Digite uma Cidade"),
            ),
            ElevatedButton(
              onPressed: _buscar,
               child: Text("Buscar Clima")),
            Divider(),
            if(_clima != null) ...[
              Text("Cidade: ${_clima!.cidade}"),
              Text("Temperatura: ${_clima!.temperatura} °C"),
              Text("Descrição: ${_clima!.descricao}")
            ] else if(_erro != null) ...[
              Text(_erro!)
            ] else ...[
              Text("Pesquise uma cidade para Começar")
            ]
          ],
        ),)
    );
  }
}