
import 'package:biblioteca_app/models/livro_model.dart';
import 'package:biblioteca_app/services/api_service.dart';

class LivroController {

  // Métodos para Livros

  // Get Livros
  Future<List<LivroModel>> fetchAll() async {
    final list = await ApiService.getList("livros");
    return list.map<LivroModel>((e) =>LivroModel.fromJson(e)).toList();
  }

  // Get Livro
  Future<LivroModel> fetchOneLivro(String id) async {
    final livro = await ApiService.getOne("livros", id);
    return LivroModel.fromJson(livro);
  }

  // Post Livro
  Future<LivroModel> createLivro(LivroModel l) async {
    final created = await ApiService.post("livros", l.toJson());
    return LivroModel.fromJson(created);
  }

  // Put Livro
  Future<LivroModel> updateLivro(LivroModel l) async {
    final updated = await ApiService.put("livros", l.toJson(), l.id);
    return LivroModel.fromJson(updated);
  }

  // Delete Livro
  Future<void> deleteLivro(String id) async {
    await ApiService.delete("livros", id);
  }

  Future<void> create(LivroModel livro) async {}

  Future<void> update(LivroModel livro) async {}

  Future<void> delete(String s) async {}
}