import 'package:exemplo_sqlite/models/nota_models.dart';
import 'package:exemplo_sqlite/services/nota_db_helper.dart';

class NotaController {
  NotaDbHelper _dbHelper = NotaDbHelper();

  //Criar os controllers
  Future<int> createNota(Nota nota) async {
    return _dbHelper.insertNota(nota);
  }

  Future<List<Nota>> readNotas() async {
    return _dbHelper.getNotas();
  }

  Future<int> updateNota(Nota nota) async {
    return _dbHelper.updateNota(nota);
  }

  Future<int> deleteNota(int id) async {
    return _dbHelper.deleteNota(id);
  }
}
