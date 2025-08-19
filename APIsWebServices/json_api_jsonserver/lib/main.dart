import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TarefaPage(),
  ));
}

class TarefaPage extends StatefulWidget {
  const TarefaPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TarefasPageState();
  }
}

class _TarefasPageState extends State<TarefaPage> {
  List tarefas = [];
  final TextEditingController _tarefaController = TextEditingController();
  static const String baseUrl = "http://10.109.197.38:3006/tarefas";

  @override
  void initState() {
    super.initState();
    _carregarTarefas();
  }

  // Carregar tarefas da API
  void _carregarTarefas() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        setState(() {
          List<dynamic> dados = json.decode(response.body);
          tarefas =
              dados.map((item) => Map<String, dynamic>.from(item)).toList();
        });
      }
    } catch (e) {
      print("Erro ao buscar Tarefa: $e");
    }
  }

  // Adicionar nova tarefa
  void _adicionarTarefa(String titulo) async {
    final novaTarefa = {"titulo": titulo, "concluida": false};
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(novaTarefa),
      );
      if (response.statusCode == 201) {
        _tarefaController.clear();
        _carregarTarefas();
      }
    } catch (e) {
      print("Erro ao adicionar Tarefa: $e");
    }
  }

  // Remover tarefa
  void _removerTarefa(String id) async {
    try {
      final response = await http.delete(Uri.parse("$baseUrl/$id"));
      if (response.statusCode == 200) {
        _carregarTarefas();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Tarefa Apagada com Sucesso")),
        );
      }
    } catch (e) {
      print("Erro ao deletar Tarefa: $e");
    }
  }

  // Modificar tarefa (atualizar título e concluída)
  void _atualizarTarefa(String id, String novoTitulo, bool concluida) async {
    try {
      final novosDados = {
        "titulo": novoTitulo,
        "concluida": concluida,
      };

      final response = await http.put(
        Uri.parse("$baseUrl/$id"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(novosDados),
      );

      if (response.statusCode == 200) {
        _carregarTarefas();
      } else {
        print("Erro ao atualizar: ${response.statusCode}");
      }
    } catch (e) {
      print("Erro ao atualizar Tarefa: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tarefas Via API"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _tarefaController,
              decoration: InputDecoration(
                labelText: "Nova Tarefa",
                border: OutlineInputBorder(),
              ),
              onSubmitted: _adicionarTarefa,
            ),
            SizedBox(height: 10),
            Expanded(
              child: tarefas.isEmpty
                  ? Center(child: Text("Nenhuma Tarefa Adicionada"))
                  : ListView.builder(
                      itemCount: tarefas.length,
                      itemBuilder: (context, index) {
                        final tarefa = tarefas[index];
                        return ListTile(
                          leading: Checkbox(
                            value: tarefa["concluida"],
                            onChanged: (valor) {
                              _atualizarTarefa(
                                tarefa["id"].toString(),
                                tarefa["titulo"],
                                valor ?? false,
                              );
                            },
                          ),
                          title: Text(tarefa["titulo"]),
                          subtitle: Text(
                              tarefa["concluida"] ? "Concluída" : "Pendente"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Botão de editar título
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  TextEditingController editController =
                                      TextEditingController(
                                          text: tarefa["titulo"]);

                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("Editar Tarefa"),
                                      content: TextField(
                                        controller: editController,
                                        decoration: InputDecoration(
                                            labelText: "Novo título"),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("Cancelar"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            _atualizarTarefa(
                                              tarefa["id"].toString(),
                                              editController.text,
                                              tarefa["concluida"],
                                            );
                                            Navigator.pop(context);
                                          },
                                          child: Text("Salvar"),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              // Botão de deletar
                              IconButton(
                                onPressed: () =>
                                    _removerTarefa(tarefa["id"].toString()),
                                icon: Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                        );
                      }),
            ),
          ],
        ),
      ),
    );
  }
}
