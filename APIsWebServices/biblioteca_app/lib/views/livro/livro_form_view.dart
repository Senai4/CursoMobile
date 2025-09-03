import 'package:biblioteca_app/controllers/livro.controller.dart';
import 'package:biblioteca_app/models/livro_model.dart';
import 'package:flutter/material.dart';

class LivroFormView extends StatefulWidget {
  final LivroModel? livro; // se vier, é edição

  const LivroFormView({super.key, this.livro});

  @override
  State<LivroFormView> createState() => _LivroFormViewState();
}

class _LivroFormViewState extends State<LivroFormView> {
  final _formKey = GlobalKey<FormState>();
  final _controller = LivroController();

  final _tituloController = TextEditingController();
  final _autorController = TextEditingController();
  final _anoController = TextEditingController();
  bool _disponivel = true;

  @override
  void initState() {
    super.initState();
    if (widget.livro != null) {
      _tituloController.text = widget.livro!.titulo;
      _autorController.text = widget.livro!.autor;
      _anoController.text = widget.livro!.anoPublicacao.toString();
      _disponivel = widget.livro!.disponivel;
    }
  }

  void _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final livro = LivroModel(
      id: widget.livro!.id,
      titulo: _tituloController.text,
      autor: _autorController.text,
      disponivel: _disponivel,
    );

    try {
      if (widget.livro == null) {
        await _controller.create(livro);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Livro criado com sucesso!")),
        );
      } else {
        await _controller.update(livro);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Livro atualizado com sucesso!")),
        );
      }
      Navigator.pop(context, true); // retorna true para recarregar a lista
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao salvar livro: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.livro == null ? "Cadastrar Livro" : "Editar Livro"),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade600,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Título
              TextFormField(
                controller: _tituloController,
                decoration: InputDecoration(
                  labelText: "Título",
                  prefixIcon: const Icon(Icons.menu_book),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Informe o título" : null,
              ),
              const SizedBox(height: 16),

              // Autor
              TextFormField(
                controller: _autorController,
                decoration: InputDecoration(
                  labelText: "Autor",
                  prefixIcon: const Icon(Icons.person),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Informe o autor" : null,
              ),
              const SizedBox(height: 16),

              // Ano de publicação
              TextFormField(
                controller: _anoController,
                decoration: InputDecoration(
                  labelText: "Ano de Publicação",
                  prefixIcon: const Icon(Icons.date_range),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Informe o ano";
                  final ano = int.tryParse(value);
                  if (ano == null || ano <= 0) return "Ano inválido";
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Disponível
              SwitchListTile(
                title: const Text("Disponível"),
                value: _disponivel,
                activeColor: Colors.indigo.shade600,
                onChanged: (value) => setState(() => _disponivel = value),
              ),
              const SizedBox(height: 24),

              // Botões
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _salvar,
                      icon: const Icon(Icons.save),
                      label: const Text("Salvar"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo.shade600,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.cancel),
                      label: const Text("Cancelar"),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red.shade400),
                        foregroundColor: Colors.red.shade400,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
