import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaTodoList extends StatefulWidget {
  @override
  _TelaTodoListState createState() => _TelaTodoListState();
}

class _TelaTodoListState extends State<TelaTodoList> {
  //atributos
  String _nome = "";
  bool _darkMode = false;
  List<String> _tarefas = [];
  TextEditingController _tarefasController = TextEditingController();
  //Controlador para novas tarefas
  //lista_diferente_para_cada_usuario
  String _chaveLista = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _carregarPreferencias();
  }

  void _carregarPreferencias() async {
    SharedPreferences _prefs =
        await SharedPreferences.getInstance(); //estabelece conexão memoria
    _nome = _prefs.getString("nome") ?? ""; // pega as informações do nome
    _darkMode =
        _prefs.getBool("darkMode") ?? false; // pega informaç~eos do darkMode
    _chaveLista = "lista${_nome}"; // constroe a chave da lista
    _tarefas =
        _prefs.getStringList(_chaveLista) ??
        []; // pega as informações da lista referente ao usuário específico
    setState(() {});
  }

  void _salvarTarefas() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (_tarefasController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("A Tarefa Está Vazia")));
    } else {
      _tarefas.add(_tarefasController.text.trim());
      _chaveLista = "lista${_nome}";
      _prefs.setStringList(_chaveLista, _tarefas);
      setState(() {
        _tarefasController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Tarefa Adicionada Com Sucesso")),
        );
        Navigator.pop(context);//Fecha a caixa de dialogo
      });
    }
  }

  _removerTarefa(int index) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _tarefas.removeAt(index); //remove a tarefa da lista
    _chaveLista = "lista${_nome}";
    _prefs.setStringList(_chaveLista, _tarefas); //atualiza a lista na memoria
    setState(() {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Tarefa Removida Com Sucesso")));
    });
  }

  //build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista de Tarefas de ${_nome}")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: _tarefas.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_tarefas[index]),
              //remover tarefas
              trailing: IconButton(
                onPressed: () => _removerTarefa(index),
                icon: Icon(Icons.delete, color: Colors.red),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: Text("Nova Tarefa"),
                  content: TextField(
                    controller: _tarefasController,
                    decoration: InputDecoration(hintText: "Digite a Tarefa"),
                  ),
                  actions: [
                    TextButton(
                      onPressed: _salvarTarefas,
                      child: Text("Adicionar"),
                    ),
                  ],
                ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
