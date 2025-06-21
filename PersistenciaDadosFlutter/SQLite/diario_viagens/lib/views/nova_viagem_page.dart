import 'package:flutter/material.dart';
import '../controllers/viagem_controller.dart';
import '../models/viagem.dart';

class NovaViagemPage extends StatefulWidget {
  @override
  State<NovaViagemPage> createState() => _NovaViagemPageState();
}

class _NovaViagemPageState extends State<NovaViagemPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = ViagemController();

  final _titulo = TextEditingController();
  final _destino = TextEditingController();
  final _dataInicio = TextEditingController();
  final _dataFim = TextEditingController();
  final _descricao = TextEditingController();

  @override
  void dispose() {
    _titulo.dispose();
    _destino.dispose();
    _dataInicio.dispose();
    _dataFim.dispose();
    _descricao.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (_formKey.currentState!.validate()) {
      final viagem = Viagem(
        titulo: _titulo.text,
        destino: _destino.text,
        dataInicio: _dataInicio.text,
        dataFim: _dataFim.text,
        descricao: _descricao.text,
      );
      await _controller.adicionarViagem(viagem);
      Navigator.pop(context);
    }
  }

  Widget _campo(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nova Viagem')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _campo('Título', _titulo),
              _campo('Destino', _destino),
              _campo('Data de Início', _dataInicio),
              _campo('Data de Fim', _dataFim),
              _campo('Descrição', _descricao),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvar,
                child: Text('Salvar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
