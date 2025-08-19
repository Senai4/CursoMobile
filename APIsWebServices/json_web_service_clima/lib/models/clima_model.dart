// model -> modelagem de Dados -> classes dos objetos modelaveis em um banco de dados
class ClimaModel {
  final String cidade;
  final double temperatura;
  final String descricao;

  // construtor
  ClimaModel({
    required this.cidade,
    required this.temperatura,
    required this.descricao
  });

   // fromMAp -> toMap
  factory ClimaModel.fromJson(Map<String,dynamic> json){
    return ClimaModel(
      cidade: json["name"], 
      temperatura: json["main"]["temp"].toDouble(), 
      descricao: json["weather"][0]["description"]);
  }
}