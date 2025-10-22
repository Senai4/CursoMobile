import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import '../models/registro_model.dart';

class RegistroController {
  final _firestore = FirebaseFirestore.instance;

  Future<Position> pegarLocalizacao() async {
    bool ativo = await Geolocator.isLocationServiceEnabled();
    if (!ativo) throw Exception('Serviço de localização desligado');

    LocationPermission perm = await Geolocator.requestPermission();
    if (perm == LocationPermission.denied) {
      throw Exception('Permissão negada');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> registrarPonto({
    required double latitude,
    required double longitude,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Usuário não logado');

    final registro = RegistroPonto(
      usuario: user.uid,
      latitude: latitude,
      longitude: longitude,
      dataHora: DateTime.now(),
    );

    // Salva o registro dentro de uma subcoleção do usuário para isolar os pontos
    await _firestore
        .collection('usuarios')
        .doc(user.uid)
        .collection('registros')
        .add(registro.toMap());
  }
}
