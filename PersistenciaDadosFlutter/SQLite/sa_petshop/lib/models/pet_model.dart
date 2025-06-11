class Pet{
  //atributos -> id, nome, raca, nomeDono, telefoneDono
  final int? id; //pode ser nula 
  final String nome;
  final String raca;
  final String nomeDono;
  final String telefone;

  // métodos de acesso public (getter and setters) CASO ATRIBUTOS FOSSEM PRIVADOS
  // getId() {
  //   return id;  
  // }

  // setId(int id) {
   // this._id = id;
  // }

  //construtor
  Pet({
    this.id,
    required this.nome,
    required this.raca,
    required this.nomeDono,
    required this.telefone
  });

  //métodos de conversão OBJ<->BD
  // toMap : obj -> entidade BD
  Map<String,dynamic> toMap() {
    return{
      "id" : id,
      "nome" : nome,
      "raca" : raca,
      "nome_dono" : nomeDono,
      "telefone" : telefone
    };
  }

  //fromMap BD -> obj
  factory Pet.fromMap(Map<String,dynamic> map) {
    return Pet(
      id: map["id"] as int,
      nome: map["nome"] as String, 
      raca: map["raca"] as String, 
      nomeDono: map["nome_dono"] as String, 
      telefone: map["telefone"] as String);
  }
  
  @override
  String toString() {
    // TODO: implement toString
    return "Pet{id: $id, nome: $nome, raca: $raca, dono: $nomeDono, telefone: $telefone}";
  }
}