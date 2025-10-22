import 'package:cloud_firestore/cloud_firestore.dart';

class RegistroPonto {
  final String usuario;
  final double latitude;
  final double longitude;
  final DateTime dataHora;

  RegistroPonto({
    required this.usuario,
    required this.latitude,
    required this.longitude,
    required this.dataHora,
  });

  Map<String, dynamic> toMap() {
    return {
      'usuario': usuario,
      'latitude': latitude,
      'longitude': longitude,
      // Salvar como Timestamp para compatibilidade com consultas/ordenacao no Firestore
      'dataHora': Timestamp.fromDate(dataHora),
    };
  }
}
