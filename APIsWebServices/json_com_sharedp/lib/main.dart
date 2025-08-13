import 'dart:convert'; //biblioteca interna do Dart -> não precisa instalar no pubspec

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(){
  runApp(const MyApp());
}

//classe que chama a Mudança de estado
class MyApp extends StatefulWidget{ // permite mudança de estado
  //construtor
  const MyApp({super.key});

  //método de mudança de estado
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }

}

//classe que vai montar(build) a tela
class _MyAppState extends State<MyApp>{
  //atributos
  bool _temaEscuro = false; //vai controler a mudança de tema
  late TextEditingController _nomeController; // vai controlar a inserção de texto dentro do TextFormField

  //métodos
  //precisa carregar as informações logo no começo da aplicação 
  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
    _carregarPreferencias();
  }

  void _carregarPreferencias() async{
    //estabelece conexão com o SharedPrefernces(cache)
    final prefs = await SharedPreferences.getInstance();
    //buscas um texto em Formato Json com as informações do usuário
    // {"temaEscuro": true, "nome": "Nome do Usuário","idade": 25}
    String? jsonConfig = prefs.getString("config");
    if(jsonConfig != null){
      print(jsonConfig);
      Map<String,dynamic> config = json.decode(jsonConfig);
      setState(() { //chama a mudança de Tela
        _temaEscuro = config["temaEscuro"] ?? false; //operador de coalescência
        _nomeController.text = config["nome"] ?? "";
      });
    } //fim do if
  }//fim do método

  void _salvarPreferencias() async{
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> config = {
      "temaEscuro": _temaEscuro,
      "nome": _nomeController.text.trim()
    };
    String jsonConfig = json.encode(config);
    prefs.setString("config", jsonConfig);

    //snackBar
   ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Preferências Salvas!"))
    );
  }

  //precisa do build(montar a tela)
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //operador Ternário (if else encurtado)
      theme: _temaEscuro ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(title: Text("Preferências de Usuário"),),
        body: Padding(
          padding: EdgeInsets.all(16),
              child: Column(
            children: [
              SwitchListTile(
                title: Text("Tema Escuro"),
                value: _temaEscuro, 
                onChanged: (value){
                  setState(() {
                    _temaEscuro = value;
                  });
                }),
                TextField(
                  controller: _nomeController,
                  decoration: InputDecoration(labelText: "Nome do Usuário"),
                ),
                SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: _salvarPreferencias,
                   child: Text("Salvar Preferências")),
                SizedBox(height: 20,),
                Divider(),
                Text("Configurações Atuais:", style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 20,),
                Text("Tema: ${_temaEscuro ? "Escuro" : "Claro"}"),
                Text("Usuário: ${_nomeController.text}")
            ],
          ),
        ),
      ),
    );
    
  }
}
