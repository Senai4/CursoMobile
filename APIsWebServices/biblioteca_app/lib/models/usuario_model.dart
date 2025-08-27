//classe de modelagem do usuário (atributos = base de dados)
class UsuarioModel {
  //atributos
  final String? id; //pode ser nulo inicialmente
  final String nome;
  final String email;

  //construtor
  UsuarioModel({
    this.id, required this.nome, required this.email
  });

  //FromJson Map => OBJ
  factory UsuarioModel.fromJson(Map<String,dynamic> json) => 
  UsuarioModel(
    id: json["id"].toString(),
    nome: json["nome"].toString(),
    email: json["email"].toString()
  );

  //toJson OBJ => MAP
  Map<String,dynamic> toJson() => {
    "id":id,
    "nome":nome,
    "email":email
  };
}