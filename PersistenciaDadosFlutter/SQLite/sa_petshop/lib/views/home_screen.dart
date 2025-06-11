//tela inicial que vai listar os Pets do cadastro,

import 'package:flutter/material.dart';
import 'package:sa_petshop/controllers/pet_controller.dart';
import 'package:sa_petshop/models/pet_model.dart';
import 'package:sa_petshop/views/cadastro_pet_screen.dart';
import 'package:sa_petshop/views/detalhe_pet_screen.dart';

class HomeScreen extends StatefulWidget {
  // recebe as  notificações de mudança e chama o build da tela
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  // buildar a tela

  //atributos
  final _controllerPet = PetController();
  List<Pet> _pets = [];
  bool _isLoading = true; // controlar o State

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _carregarDados();
  }

  void _carregarDados() async {
    setState(() {
      _isLoading = true;
    });
    _pets = [];
    try {
      _pets = await _controllerPet.readPet(); // buscando os pets do BD
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Exception: $e")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  //build da Tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Meus Pets - Clientes")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: _pets.length, //tamanho da lista
                itemBuilder: (context, index) {
                  final pet =
                      _pets[index]; //criando um obj da classe pet a partir de um elemento do vetor
                  return ListTile(
                    //item da ListView
                    title: Text("${pet.nome} - ${pet.raca}"),
                    subtitle: Text("${pet.nomeDono} - ${pet.telefone}"),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalhePetScreen(petId: pet.id!),
                      ),
                    ), //página de detalhe do PET
                    onLongPress: () => _deletarPet(pet.id!), // deletar o Pet
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CadastroPetScreen()),
        ),
        tooltip: "Adicionar Novo Pet",
        child: Icon(Icons.add),
      ),
    );
  }

  _deletarPet(int id) async {
    try {
      _controllerPet.deletePet(id);
      _carregarDados();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Pet Deletado com Sucesso!")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Exception: $e"))
      );
    }
  }
}
