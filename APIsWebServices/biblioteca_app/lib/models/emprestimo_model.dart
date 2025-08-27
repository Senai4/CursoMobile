class EmprestimoModel {
  final String id;
  final String usuarioId;
  final String livroId;
  final String dataEmprestimo;
  final String dataDevolucao;
  final bool devolvido;

  EmprestimoModel({
    required this.id,
    required this.usuarioId,
    required this.livroId,
    required this.dataEmprestimo,
    required this.dataDevolucao,
    required this.devolvido
  });

  factory EmprestimoModel.fromJson(Map<String,dynamic> json) =>
  EmprestimoModel(
    id: json["id"].toString(),
    usuarioId: ["usuarioId"].toString(),
    livroId: ["livroId"].toString(),
    dataEmprestimo: ["dataEmprestimo"].toString(),
    dataDevolucao: ["dataDevolucao"].toString(),
    devolvido: json["devolvido"] == true ? true : false
  );

  Map<String,dynamic> toJson() => {
    "id":id,
    "usuarioId":usuarioId,
    "livroId":livroId,
    "dataEmprestimo":dataEmprestimo,
    "dataDevolucao":dataDevolucao,
    "devolvido":devolvido
  };
}