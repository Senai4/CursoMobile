import '../models/entrada_diaria.dart';
import '../services/db_service.dart';

class EntradaController {
  final DBService _db = DBService();

  Future<int> adicionarEntrada(EntradaDiaria entrada) async {
    return await _db.inserirEntrada(entrada);
  }

  Future<List<EntradaDiaria>> obterEntradasPorViagem(int viagemId) async {
    return await _db.listarEntradas(viagemId);
  }
}
