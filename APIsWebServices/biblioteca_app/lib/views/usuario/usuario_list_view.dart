import 'package:biblioteca_app/controllers/usuario.controller.dart';
import 'package:biblioteca_app/models/usuario_model.dart';
import 'package:flutter/material.dart';

class UsuarioListView extends StatefulWidget {
  const UsuarioListView({super.key});

  @override
  State<UsuarioListView> createState() => _UsuarioListViewState();
}

class _UsuarioListViewState extends State<UsuarioListView> {
  //atributos
  final _controller = UsuarioController();
  List<UsuarioModel> _usuarios = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  _carregarDados() async{
    setState(() {
      _carregando = true;
    });
    try {
      _usuarios = await _controller.fetchAll();
    } catch (e) {
      //Tratar Erro
    }
    setState(() {
      _carregando = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _carregando ? Center(child: CircularProgressIndicator(),)
      : Expanded(child: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: _usuarios.length,
        itemBuilder: (context,index){
          final usuario = _usuarios[index];
          return Card(
            child: ListTile(
              title: Text(usuario.nome),
              subtitle: Text(usuario.email),
              //trailing -> icone para deletar o usuário
            ),
          );
        }))
    );
  }
}