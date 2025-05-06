import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaInicial extends StatefulWidget {
  //Tela Dinâmica (mudança de estado)
  @override
  _TelaInicialState createState() => _TelaInicialState(); //Chama da Mudança de Estado
}

class _TelaInicialState extends State<TelaInicial> {
  //Estado da Tela Inicial
  //atributos
  TextEditingController _nomeController = TextEditingController(); //Recebe informações TextField
  String _nome = ""; // Atributo que Armazena o Nome do Usuário
  bool _darkMode = false; //Atributo que armazena o modo escuro

  //método initState ->
  @override
  void initState() {
    //método para iniciar a tela
    super.initState();
    _carregarPreferencias();
  }

  //Método para Carregar Nome do Usuário
  void _carregarPreferencias() async { // Método assincrono
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _nome = _prefs.getString("nome") ?? ""; // Pega o nome do usuário no shared
    _darkMode = _prefs.getBool("dartMode") ?? false; // Pega o modo escuro shared
    setState(() {
      // Recarregar a tela
    });
  }

  //Método para Salvar o Nome do Usuário
  void _salvarNome() async {
    // Adicionar o valvar o shared preferences
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    _nome = _nomeController.text.trim();
    if (_nome.isEmpty) {
      //Madar uma Mensagem para o usuário
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Informe um Nome Válido!")));
    } else {
      _nomeController.clear(); //limpa o TextField
      _prefs.setString("nome", _nome); // Salva o nome no SharedPreferences
      setState(() {
        //Atualizar o Nome do usuário na Tela
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Nome do Usuário Atualizado!")));
      });
    }
  }

  //método salvar Modo Escuro
  void _salvarModoEscuro() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _darkMode = !_darkMode; //inverte o valor do darkmode(atributo)
    _prefs.setBool("darkMode", _darkMode); //salvo no Shared
    setState(() {
      //atualiza a tela
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Modo Escuro ${_darkMode ? "Ativado" : "Desativado"}")));
    });
  }


  @override
  Widget build(BuildContext context) {
    // Constroi a Tela
    return AnimatedTheme(
      //muda o tema da tela
      data: _darkMode ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        //estrutura básica da tela
        appBar: AppBar(
          title: Text("Bem-vindo ${_nome == "" ? "Visitante" : _nome}"),
          actions: [
            IconButton(onPressed: _salvarModoEscuro,
             icon: Icon(_darkMode ? Icons.light_mode : Icons.dark_mode))
          ],
        ),
        body: Center(
          child: Column(
            children: [
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: "Informe seu Nome"),
              ),
              ElevatedButton(
                onPressed: _salvarNome,
                child: Text("Salvar Nome do Usuário")),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, "/tarefas"), //navegar para a tela de tarefas
                child: Text("Tarefas do $_nome"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// O que é o SharedPreferences?
// É uma biblioteca de armazenamento de dados interna do aplicativo (cache do app)
// Como ela funciona?
// Armazena dados na condição de chave-valor(key-value)
// nome -> _nome
// Tipos de dados armazenados no shared preferences:
// String, int, double, bool, List<String>
// Métodos do shared preferences
// getters and setters