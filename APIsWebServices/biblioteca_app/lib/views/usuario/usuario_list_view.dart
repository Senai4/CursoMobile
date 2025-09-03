import 'package:biblioteca_app/controllers/usuario.controller.dart';
import 'package:biblioteca_app/models/usuario_model.dart';
import 'package:biblioteca_app/views/usuario/usuario_form_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

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
  //atributos para fazer a busca
  final _buscaField = TextEditingController();
  List<UsuarioModel> _usuariosFiltrados = [];
  

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
      _usuarios = await _controller.fetchAll(); //busco no banco
      _usuariosFiltrados = _usuarios; // copio
    } catch (e) {
      //Tratar Erro      
    }
    setState(() {
      _carregando = false;
    });
  }

  //deletar usuário
  void _delete(UsuarioModel usuario) async{
    if(usuario.id == null) return;
    final confirmar = await showDialog<bool>(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text("Confirmar Exclusão"),
        content: Text("Deseja Realmente Excluir o Usuário ${usuario.nome}"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context,false), child: Text("Cancelar")),
          TextButton(onPressed: () => Navigator.pop(context,true), child: Text("Confirmar")),
        ],
      ));
    if(confirmar == true){
      try {
        await _controller.delete(usuario.id!);
        _carregarDados();
        //mensagem de exclusão
      } catch (e) {
        //mensagem de erro
      }
    }
  }


  //navegar para uma nova tela (formulario)
  void _abrirForm({UsuarioModel? usuario}) async{
    //usuário entra no parâmetro, não é obrigatório
    await Navigator.push(context, 
    MaterialPageRoute(builder: (context)=> UsuarioFormView(usuario:usuario)));
  }

  void _filtrar() {
    //filtar uma lista já carregada do BD
    final busca = _buscaField.text.toLowerCase();
    setState(() {
      _usuariosFiltrados = _usuarios.where(
        (user) => user.nome.toLowerCase().contains(busca) //filtra pelo nome do usuário
          || user.email.toLowerCase().contains(busca) //filtra pelo email do usuário
      ).toList();
    });

  }

  //build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _carregando
      ? Center(child: CircularProgressIndicator(),)
      : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _buscaField,
              decoration: InputDecoration(labelText: "Pesquisar Usuário"),
              onChanged: (value) => _filtrar(),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _usuariosFiltrados.length,
                itemBuilder: (context,index){
                  final usuario = _usuariosFiltrados[index];
                  return Card(
                    child: ListTile(
                      leading: IconButton(
                        onPressed: () => _abrirForm(usuario: usuario), //levar as informações do usuário para tela de formulário
                        icon: Icon(Icons.edit)),
                      title: Text(usuario.nome),
                      subtitle: Text(usuario.email),
                      trailing: IconButton(
                        onPressed: ()=> _delete(usuario), 
                        icon: Icon(Icons.delete, color: Colors.red,)),
                    ),
                  );
                })),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirForm(),
        child: Icon(Icons.add),),
    );
  }
}