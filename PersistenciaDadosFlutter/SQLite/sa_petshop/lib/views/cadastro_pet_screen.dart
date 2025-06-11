import 'package:flutter/material.dart';
import 'package:sa_petshop/controllers/pet_controller.dart';
import 'package:sa_petshop/models/pet_model.dart';
import 'package:sa_petshop/views/home_screen.dart';

class CadastroPetScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _CadastroPetScreenState();
}

class _CadastroPetScreenState extends State<CadastroPetScreen>{
  //atributos
  final _formKey = GlobalKey<FormState>();
  final _controllerPet = PetController();

  //atributos do obj
  late String _nome; // permite que a varialver sejá null inicialmente
  late String _raca;
  late String _nomeDono;
  late String _telefone;

  // Método para Cadastrar o Pet(salvar no BD e volta para a home)
  _salvarPet() async{
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      final newPet = Pet(
        nome: _nome, 
        raca: _raca, 
        nomeDono: _nomeDono, 
        telefone: _telefone); 
      //manda as infos para o BD
      await _controllerPet.createPet(newPet);
      //volta para a HomeScreen
      Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
    }
  }

  //build da Tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Novo Pet"),),
      body: Padding(padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: "Nome do Pet"),
              validator: (value) => value!.isEmpty ? "Campo não Preenchido" : null,
              onSaved: (newValue) => _nome = newValue!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Raça do Pet"),
              validator: (value) => value!.isEmpty ? "Campo não Preenchido" : null,
              onSaved: (newValue) => _raca = newValue!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Nome do Dono"),
              validator: (value) => value!.isEmpty ? "Campo não Preenchido" : null,
              onSaved: (newValue) => _nomeDono = newValue!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Telefone"),
              validator: (value) => value!.isEmpty ? "Campo não Preenchido" : null,
              onSaved: (newValue) => _telefone = newValue!,
            ),
            ElevatedButton(onPressed: _salvarPet, child: Text("Cadastrar"))
          ],
        )),),
    );
  }
}