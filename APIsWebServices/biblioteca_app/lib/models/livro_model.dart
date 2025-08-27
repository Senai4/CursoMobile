class LivroModel {
  final String id;
  final String titulo;
  final String autor;
  final bool disponivel;

  LivroModel({
    required this.id,
    required this.titulo,
    required this.autor,
    required this.disponivel,
  });

  factory LivroModel.fromJson(Map<String,dynamic> json) =>
  LivroModel(
    id: json["id"].toString(),
    titulo: ["titulo"].toString(),
    autor: ["autor"].toString(),
    disponivel: json["disponivel"] == true ? true : false
  );

  Map<String,dynamic> toJson() => {
    "id":id,
    "titulo":titulo,
    "autor":autor,
    "disponivel":disponivel
  };
}