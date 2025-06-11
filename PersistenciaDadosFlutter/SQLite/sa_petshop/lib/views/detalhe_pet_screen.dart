//tela de Detalhe do Pet

import 'package:flutter/material.dart';
import 'package:sa_petshop/controllers/consulta_controller.dart';
import 'package:sa_petshop/controllers/pet_controller.dart';
import 'package:sa_petshop/models/consulta_model.dart';
import 'package:sa_petshop/models/pet_model.dart';
import 'package:sa_petshop/views/criar_consulta_screen.dart';

class DetalhePetScreen extends StatefulWidget{
  //atributos
  final int petId; //receber o Id do Pet

  //construtor pega o Id do Pet
  DetalhePetScreen({super.key,required this.petId});

  @override
  State<StatefulWidget> createState() {
    return _DetalhePetScreenState();
  } 
}

class _DetalhePetScreenState extends State<DetalhePetScreen> {
  //atributos
  final _controllerPet = PetController();
  final _controllerConsulta = ConsultaController();

  bool _isLoading = true;

  Pet? _pet; //inicialmente pode ser nulo

  List<Consulta> _consultas = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _carregarDados();
  }

  void _carregarDados() async{
    setState(() {
      _isLoading = true;
    });
    _consultas =[];
    try {
      _pet = await _controllerPet.readPetById(widget.petId);
      _consultas = await _controllerConsulta.readConsultaByPet(widget.petId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Exception $e"))
      );  
    } finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("detalhes do Pet"),),
      body: _isLoading
        ? Center(child: CircularProgressIndicator(),)
        : _pet == null //verifica se o pet foi encontrado
          ? Center(child: Text("Erro ao Carregar o Pet. Verifique o Id"),)
          : Padding(padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Nome: ${_pet!.nome}", style: TextStyle(fontSize: 20),),
                Text("Raça: ${_pet!.raca}"),
                Text("Dono: ${_pet!.nomeDono}"),
                Text("Telefone: ${_pet!.telefone}"),
                Divider(),//linha divisão(hr)
                Text("Consultas"), //style
                //operador ternário para consultas
                _consultas.isEmpty 
                  ? Center(child: Text("Não Existe Consultas Cadastradas"),)
                  : Expanded(child: ListView.builder(
                    itemCount: _consultas.length,
                    itemBuilder: (context,index){
                      final consulta = _consultas[index]; //criando um OBJ a partir do vetor de objs
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(consulta.tipoServico),
                          subtitle: Text(consulta.dataHoraLocal),
                          trailing: IconButton(
                            onPressed: ()=>_deletarConsulta(consulta.id!), 
                            icon: Icon(Icons.delete)),//apagar a consulta
                          //onTap: (){}//implementar a navegação para detalhes da consulta
                        ),
                      );
                    }))
              ],
            ),),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          Navigator.push(context, MaterialPageRoute(
            builder: (context)=>CriarConsultaScreen(petId: widget.petId)));
        },
        child: Icon(Icons.add),)
      //cenas do próximo capítulo -> tela de criação de consultas, implementar os métodos que faltam (deletar consluta, deletar Pet, )
    );
  }

  //método para Deletar Consulta
  _deletarConsulta(int id) async{
    try {
      _controllerConsulta.deleteConsulta(id);
      _carregarDados();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Consulta Apagada com Sucesso"))
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Exception: $e"))
      );
    }
  }

}