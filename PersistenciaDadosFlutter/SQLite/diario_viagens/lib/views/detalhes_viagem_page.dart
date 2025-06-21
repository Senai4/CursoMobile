import 'dart:io';

import 'package:flutter/material.dart';
import '../models/viagem.dart';
import '../models/entrada_diaria.dart';
import '../controllers/entrada_controller.dart';
import 'nova_entrada_page.dart';

class DetalhesViagemPage extends StatefulWidget {
  final Viagem viagem;
  DetalhesViagemPage({required this.viagem});

  @override
  State<DetalhesViagemPage> createState() => _DetalhesViagemPageState();
}

class _DetalhesViagemPageState extends State<DetalhesViagemPage> {
  final EntradaController _controller = EntradaController();
  List<EntradaDiaria> _entradas = [];

  @override
  void initState() {
    super.initState();
    _carregarEntradas();
  }

  Future<void> _carregarEntradas() async {
    final entradas = await _controller.obterEntradasPorViagem(widget.viagem.id!);
    setState(() => _entradas = entradas);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.viagem.titulo)),
      body: ListView(
        children: [
          ListTile(
            title: Text('Destino'),
            subtitle: Text(widget.viagem.destino),
          ),
          ListTile(
            title: Text('Período'),
            subtitle: Text('${widget.viagem.dataInicio} até ${widget.viagem.dataFim}'),
          ),
          ListTile(
            title: Text('Descrição'),
            subtitle: Text(widget.viagem.descricao),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Entradas Diárias', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ..._entradas.map((entrada) => ListTile(
            title: Text(entrada.data),
            subtitle: Text(entrada.texto),
            leading: Image.file(
              File(entrada.fotoPath),
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NovaEntradaPage(viagemId: widget.viagem.id!),
            ),
          );
          _carregarEntradas();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
