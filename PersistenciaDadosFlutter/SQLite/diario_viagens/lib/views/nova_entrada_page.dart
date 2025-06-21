import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/entrada_diaria.dart';
import '../controllers/entrada_controller.dart';

class NovaEntradaPage extends StatefulWidget {
  final int viagemId;
  NovaEntradaPage({required this.viagemId});

  @override
  State<NovaEntradaPage> createState() => _NovaEntradaPageState();
}

class _NovaEntradaPageState extends State<NovaEntradaPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = EntradaController();
  final _data = TextEditingController();
  final _texto = TextEditingController();
  File? _imagem;

  Future<void> _escolherImagem() async {
    final picker = ImagePicker();
    final imagem = await picker.pickImage(source: ImageSource.gallery);
    if (imagem != null) {
      setState(() {
        _imagem = File(imagem.path);
      });
    }
  }

  Future<void> _salvar() async {
    if (_formKey.currentState!.validate() && _imagem != null) {
      final entrada = EntradaDiaria(
        viagemId: widget.viagemId,
        data: _data.text,
        texto: _texto.text,
        fotoPath: _imagem!.path,
      );
      await _controller.adicionarEntrada(entrada);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos e selecione uma imagem')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nova Entrada')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _data,
                decoration: InputDecoration(labelText: 'Data'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _texto,
                decoration: InputDecoration(labelText: 'Texto do Diário'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              SizedBox(height: 10),
              _imagem == null
                  ? Text('Nenhuma imagem selecionada.')
                  : Image.file(_imagem!, height: 150),
              ElevatedButton(
                onPressed: _escolherImagem,
                child: Text('Escolher Imagem'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvar,
                child: Text('Salvar Entrada'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
