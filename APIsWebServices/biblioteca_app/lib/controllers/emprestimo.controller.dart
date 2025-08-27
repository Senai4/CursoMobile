import 'package:biblioteca_app/models/emprestimo_model.dart';
import 'package:biblioteca_app/services/api_service.dart';

class EmprestimoController {
  // Buscar todos os empréstimos
  Future<List<EmprestimoModel>> fetchAll() async {
    final list = await ApiService.getList("emprestismo");
    return list.map<EmprestimoModel>((e) => EmprestimoModel.fromJson(e)).toList();
  }

  // GET
  Future<EmprestimoModel> fetchOne(String id) async {
    final emprestimo = await ApiService.getOne("emprestismo", id);
    return EmprestimoModel.fromJson(emprestimo);
  }

  // POST
  Future<EmprestimoModel> create(EmprestimoModel e) async {
    final created = await ApiService.post("emprestismo", e.toJson());
    return EmprestimoModel.fromJson(created);
  }

  //PUT
  Future<EmprestimoModel> update(EmprestimoModel e) async {
    final updated = await ApiService.put("emprestismo", e.toJson(), e.id);
    return EmprestimoModel.fromJson(updated);
  }

  // Deletar um empréstimo
  Future<void> delete(String id) async {
    await ApiService.delete("emprestismo", id);
  }
}