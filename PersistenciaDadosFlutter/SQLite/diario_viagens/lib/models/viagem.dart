class Viagem {
  int? id;
  String titulo;
  String destino;
  String dataInicio;
  String dataFim;
  String descricao;

  Viagem({
    this.id,
    required this.titulo,
    required this.destino,
    required this.dataInicio,
    required this.dataFim,
    required this.descricao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'destino': destino,
      'data_inicio': dataInicio,
      'data_fim': dataFim,
      'descricao': descricao,
    };
  }

  factory Viagem.fromMap(Map<String, dynamic> map) {
    return Viagem(
      id: map['id'],
      titulo: map['titulo'],
      destino: map['destino'],
      dataInicio: map['data_inicio'],
      dataFim: map['data_fim'],
      descricao: map['descricao'],
    );
  }
}
