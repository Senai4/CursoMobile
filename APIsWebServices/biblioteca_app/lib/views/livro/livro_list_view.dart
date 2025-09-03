import 'package:biblioteca_app/controllers/livro.controller.dart';
import 'package:biblioteca_app/models/livro_model.dart';
import 'package:biblioteca_app/views/livro/livro_form_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class LivroListView extends StatefulWidget {
  const LivroListView({super.key});

  @override
  State<LivroListView> createState() => _LivroListViewState();
}

class _LivroListViewState extends State<LivroListView> {
  final _controller = LivroController();
  List<LivroModel> _livros = [];
  List<LivroModel> _livrosFiltrados = [];
  bool _carregando = true;

  final _buscaField = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() => _carregando = true);
    try {
      _livros = await _controller.fetchAll();
      _livrosFiltrados = _livros;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao carregar livros: $e")),
      );
    }
    setState(() => _carregando = false);
  }

  void _filtrar() {
    final busca = _buscaField.text.toLowerCase();
    setState(() {
      _livrosFiltrados = _livros.where((livro) {
        return livro.titulo.toLowerCase().contains(busca) ||
            livro.autor.toLowerCase().contains(busca);
      }).toList();
    });
  }

  void _abrirForm({LivroModel? livro}) async {
    final recarregar = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LivroFormView(livro: livro),
      ),
    );
    if (recarregar == true) _carregarDados();
  }

  void _deletar(LivroModel livro) async {
    if (livro.id == null) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirmar exclusão"),
        content: Text("Deseja realmente excluir o livro '${livro.titulo}'?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text("Cancelar")),
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Excluir")),
        ],
      ),
    );

    if (confirmar == true) {
      try {
        await _controller.delete(livro.id!);
        _carregarDados();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Livro '${livro.titulo}' excluído.")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao excluir livro.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  // Campo de busca
                  TextField(
                    controller: _buscaField,
                    decoration: InputDecoration(
                      hintText: "Pesquisar por título ou autor",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) => _filtrar(),
                  ),
                  const SizedBox(height: 12),

                  // Lista de livros
                  Expanded(
                    child: _livrosFiltrados.isEmpty
                        ? const Center(
                            child: Text(
                              "Nenhum livro encontrado",
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _livrosFiltrados.length,
                            itemBuilder: (context, index) {
                              final livro = _livrosFiltrados[index];
                              return Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                elevation: 2,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 4),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.indigo.shade100,
                                    child: Icon(Icons.menu_book,
                                        color: Colors.indigo.shade700),
                                  ),
                                  title: Text(livro.titulo,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Text(livro.autor),
                                  trailing: Wrap(
                                    spacing: 8,
                                    children: [
                                      IconButton(
                                        onPressed: () => _abrirForm(livro: livro),
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                      ),
                                      IconButton(
                                        onPressed: () => _deletar(livro),
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirForm(),
        backgroundColor: Colors.indigo.shade600,
        child: const Icon(Icons.add),
      ),
    );
  }
}
