import 'package:intl/intl.dart';

class Consulta {
  //atributos -> id, petId, dataHora, tipoServico, observacao
  final int? id; //pode ser criado com valor nulo
  final int petId; //chave Estrangeira para Pet
  final DateTime dataHora;
  final String tipoServico;
  final String observacao;

  //construtor em formato rápido
  Consulta({
    this.id,
    required this.petId,
    required this.dataHora,
    required this.tipoServico,
    required this.observacao
  });

  //métodos de Conversão
  // toMap Obj -> BD
  Map<String,dynamic> toMap() =>{
    "id": id,
    "pet_id":petId,
    "data_hora":dataHora.toIso8601String(),
    "tipo_servico":tipoServico,
    "observacao":observacao
  };

  //fromMap() : BD -> obj
  factory Consulta.fromMap(Map<String,dynamic> map){
    return Consulta(
      id: map["id"] as int,
      petId: map["pet_id"] as int, 
      dataHora: DateTime.parse(map["data_hora"] as String), 
      tipoServico: map["tipo_servico"] as String, 
      observacao: map["observacao"] as String);
  }

  //método para converter dataHora em Formato Local("dd/MM/yyyy HH:mm");
  String get dataHoraLocal{
    final local = DateFormat("dd/MM/yyyy HH:mm");
    return local.format(dataHora);
  }

  @override
  String toString() {
    // TODO: implement toString
    return "Consulta:{id $id, petId: $petId, dataHora: $dataHora, serviço: $tipoServico, observacao: $observacao}";
  }
}