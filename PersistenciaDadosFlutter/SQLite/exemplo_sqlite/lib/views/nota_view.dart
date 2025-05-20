//classe de visualização (dinâmica)

import 'package:exemplo_sqlite/controllers/nota_controller.dart';
import 'package:exemplo_sqlite/models/nota_models.dart';
import 'package:flutter/material.dart';

class NotaView extends StatefulWidget {
  //chama as mudanças
  @override
  State<StatefulWidget> createState() {
    return _NotaViewState();
  }
}

class _NotaViewState extends State<NotaView> {
  //build
  final NotaController _notaController =
      NotaController(); //conectar com elementos da bd

  List<Nota> _notes = [];
  bool _isLoading = true; //indicação visual do carregamento do BD

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _carregarDados();
  }

  //método para carregamentos das nota do BD
  Future<void> _carregarDados() async {
    setState(() {
      _isLoading = true;
    });
    try {
      _notes = [];
      _notes = await _notaController.readNotas();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao Carregar as Notas, $e")));
    }
    setState(() {
      _isLoading = false;
    });
  }

  //create
  Future<void> _addNotas() async {
    Nota novaNota = Nota(
      titulo: "Nota ${DateTime.now()}",
      conteudo: "Conteúdo da Nota",
    );
    try {
      _notaController.createNota(novaNota);
      _carregarDados();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao Salvar a Nota, $e")));
    }
  }

  //update
  Future<void> _updateNota(Nota nota) async {
    Nota notaAtualizada = Nota(
      id: nota.id,
      titulo: "${nota.titulo} (Editado)",
      conteudo: nota.conteudo,
    );
    //criar um alert
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Atualizar Nota"),
            content: TextField(
              controller: TextEditingController(text: nota.conteudo),
              onChanged:
                  (value) =>
                      notaAtualizada=Nota(id: nota.id, titulo: nota.titulo, conteudo: value),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _notaController.updateNota(notaAtualizada);
                  _carregarDados();
                  Navigator.of(context).pop();
                },
                child: Text("Atualizar"),
              ),
            ],
          ),
    );
  }

  //delete
  Future<void> _deleteNota(int id) async {
    try {
      await _notaController.deleteNota(id);
      _carregarDados(); // Atualiza a lista após a exclusão
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Nota Deletada")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao Deletar a Nota, $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    //buildar a tela
    return Scaffold(
      appBar: AppBar(title: Text("Minhas Notas")),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: EdgeInsets.all(16),
                child: ListView.builder(
                  itemCount: _notes.length,
                  itemBuilder: (context, index) {
                    final nota = _notes[index];
                    return ListTile(
                      title: Text(nota.titulo),
                      subtitle: Text(nota.conteudo),
                      onLongPress: () => _deleteNota(nota.id!),
                      onTap: () => _updateNota(nota),
                    );
                  },
                ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNotas,
        tooltip: "Adicionar Nota",
        child: Icon(Icons.add),
      ),
    );
  }
}
