import 'package:sa_petshop/models/consulta_model.dart';
import 'package:sa_petshop/services/db_helper.dart';

class ConsultaController {
  final _dbHelper = DbHelper();

  //métodos
  Future<int> createConsulta(Consulta consulta) async{
    return _dbHelper.insertConsulta(consulta);
  }

  Future<List<Consulta>> readConsultaByPet(int petId) async{
    return _dbHelper.getConsultaByPet(petId);
  }

  Future<int> deleteConsulta(int id) async{
    return _dbHelper.deleteConsulta(id);
  }
}