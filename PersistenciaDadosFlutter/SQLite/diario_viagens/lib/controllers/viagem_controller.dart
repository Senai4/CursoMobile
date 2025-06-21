import '../models/viagem.dart';
import '../services/db_service.dart';

class ViagemController {
  final DBService _db = DBService();

  Future<int> adicionarViagem(Viagem viagem) async {
    return await _db.inserirViagem(viagem);
  }

  Future<List<Viagem>> obterTodasViagens() async {
    return await _db.listarViagens();
  }
}
