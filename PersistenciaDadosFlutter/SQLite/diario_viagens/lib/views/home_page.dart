import 'package:flutter/material.dart';
import '../controllers/viagem_controller.dart';
import '../models/viagem.dart';
import 'nova_viagem_page.dart';
import 'detalhes_viagem_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ViagemController _viagemController = ViagemController();
  List<Viagem> _viagens = [];

  @override
  void initState() {
    super.initState();
    _carregarViagens();
  }

  Future<void> _carregarViagens() async {
    final viagens = await _viagemController.obterTodasViagens();
    setState(() => _viagens = viagens);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Minhas Viagens')),
      body: ListView.builder(
        itemCount: _viagens.length,
        itemBuilder: (context, index) {
          final viagem = _viagens[index];
          return ListTile(
            title: Text(viagem.titulo),
            subtitle: Text('${viagem.destino} | ${viagem.dataInicio} - ${viagem.dataFim}'),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetalhesViagemPage(viagem: viagem),
                ),
              );
              _carregarViagens();
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => NovaViagemPage()),
          );
          _carregarViagens();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
