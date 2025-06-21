class EntradaDiaria {
  int? id;
  int viagemId;
  String data;
  String texto;
  String fotoPath;

  EntradaDiaria({
    this.id,
    required this.viagemId,
    required this.data,
    required this.texto,
    required this.fotoPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'viagem_id': viagemId,
      'data': data,
      'texto': texto,
      'foto_path': fotoPath,
    };
  }

  factory EntradaDiaria.fromMap(Map<String, dynamic> map) {
    return EntradaDiaria(
      id: map['id'],
      viagemId: map['viagem_id'],
      data: map['data'],
      texto: map['texto'],
      fotoPath: map['foto_path'],
    );
  }
}
