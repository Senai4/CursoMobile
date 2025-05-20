//criar a classe model para Notas

class Nota {
  //atributos
  final int? id; //permite criar objeto com id nulo
  final String titulo;
  final String conteudo;

  //construtor
  Nota({
    this.id,
    required this.titulo,
    required this.conteudo,
  }); //construtor como os atributos

  //métodos
  //converter dados para o banco de dados
  //Método MAP => converte em objeto da classe Nota para um MAP (Para inserir no Banco de Dados)
  Map<String, dynamic> toMap() {
    return {"id": id, "titulo": titulo, "conteudo": conteudo};
  }

  // factory -> converte dados do BD para um Objeto
  factory Nota.fromMap(Map<String, dynamic> map) {
    return Nota(
      id: map["id"] as int, //cast
      titulo: map["titulo"] as String,
      conteudo: map["conteudo"] as String,
    );
  }

  //toString
  @override
  String toString() {
    // TODO: implement toString
    return "Nota{id: $id, Título: $titulo, Conteúdo: $conteudo}";
  }
}
