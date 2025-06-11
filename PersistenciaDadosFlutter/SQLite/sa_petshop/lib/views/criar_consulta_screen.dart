//tela para criar a consulta

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sa_petshop/controllers/consulta_controller.dart';
import 'package:sa_petshop/models/consulta_model.dart';
import 'package:sa_petshop/views/detalhe_pet_screen.dart';

class CriarConsultaScreen extends StatefulWidget{ // chama as mudanças de estado
  final int petId; //recebe o Id do PEt

  CriarConsultaScreen({super.key,required this.petId});

  @override
  State<StatefulWidget> createState() {
    return _CriarConsultaScreenState();
  }
}

class _CriarConsultaScreenState extends State<CriarConsultaScreen>{ //buildar as mudanças de estado 
  //atributos -> formulário

  final _formKey = GlobalKey<FormState>(); //armazenar os dados do Formulário
  final _consultaController = ConsultaController();

  late String _tipoServico;
  late String _observacao;
  //informações de Data e Hora
  DateTime _dataSelecionada = DateTime.now(); //seleciona a data atual inicialmente
  TimeOfDay _horaSelecionada = TimeOfDay.now();//Selecioan a Hora atual inicialmente

  //buildar a Tela
  @override
  Widget build(BuildContext context) {  
    //formatação da Data
    final DateFormat dataFormatada = DateFormat("dd/MM/yyyy");
    final DateFormat horaFormatada = DateFormat("HH:mm");
    return Scaffold(
      appBar: AppBar(title: Text("Novo Agendamento"),),
       body: Padding(padding: EdgeInsets.all(16), child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: "Tipo de Serviço"),
              validator: (value) => value!.isEmpty ? "Campo deve ser Preenchido":null,
              onSaved: (newValue) => _tipoServico=newValue!,
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Expanded(child: Text("Data: ${dataFormatada.format(_dataSelecionada)}")),
                //função para abrir o quadro de data
                TextButton(onPressed: ()=> _selecionarData(context), child: Text("Selecionar Data"))
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Expanded(child: Text("Hora: ${horaFormatada.format(
                  DateTime(0,0,_horaSelecionada.hour,_horaSelecionada.minute))}")),
                //função para abrir o quadro de data
                TextButton(onPressed: ()=> _selecionarHora(context), child: Text("Selecionar Hora"))
              ],
            ),
            SizedBox(height: 10,),
            TextFormField(
              decoration: InputDecoration(labelText: "Observação"),
              maxLines: 3,
              onSaved: (newValue) => _observacao=newValue!,
            ),
            ElevatedButton(onPressed: _salvarConsulta, child: Text("Agendar Atendimento"))
          ],
        ))),
    );
  }
  
  void _selecionarData(BuildContext context) async{
    final DateTime? pegarData = await showDatePicker(//abre uma jánela para pegar a data 
      context: context, 
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), 
      lastDate: DateTime(2030));
    if( pegarData != null && pegarData != _dataSelecionada){
      _dataSelecionada = pegarData;
    }
  }
  
  void _selecionarHora(BuildContext context) async {
    final TimeOfDay? pegarHora = await showTimePicker(
      context: context,
       initialTime: TimeOfDay.now());
    if(pegarHora != null){
      _horaSelecionada = pegarHora;
    }
  }

  void _salvarConsulta() async {
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();//salva os valores do formulário

      //Correção da Data
      final DateTime dataFinal = DateTime(
         _dataSelecionada.year,
        _dataSelecionada.month,
        _dataSelecionada.day,
        _horaSelecionada.hour,
        _horaSelecionada.minute
      );

  //criar a consulta
      final newConsulta = Consulta(
        petId: widget.petId, 
        dataHora: dataFinal, 
        tipoServico: _tipoServico, 
        observacao: _observacao.isEmpty ? "." : _observacao);

     
      try {
        await _consultaController.createConsulta(newConsulta); //conecto com o banco e jogo as informações
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Agendamento Feito com Sucesso"))
        );
        Navigator.push(context, MaterialPageRoute(builder: (context)=>DetalhePetScreen(petId: widget.petId)));
      } catch (e) {
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Exception: $e"))
        );
      }
    }
  }
}