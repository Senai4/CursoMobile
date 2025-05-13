import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tela01 extends StatefulWidget {
  @override
  _Tela01State createState() => _Tela01State();
}

class _Tela01State extends State<Tela01> {
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _idadeController = TextEditingController();

  String _nome = "";
  String _idade = "";
  String _corFavorita = "Azul"; // Cor aplicada (salva)
  String _corSelecionada = "Azul"; // Cor selecionada no dropdown

  final List<String> _cores = ["Azul", "Verde", "Vermelho", "Amarelo"];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nome = prefs.getString("nome") ?? "";
      _idade = prefs.getString("idade") ?? "";
      _corFavorita = prefs.getString("cor") ?? "Azul";
      _corSelecionada = _corFavorita;

      _nomeController.text = _nome;
      _idadeController.text = _idade;
    });
  }

  Future<void> _salvarDados() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("nome", _nomeController.text);
    await prefs.setString("idade", _idadeController.text);
    await prefs.setString("cor", _corSelecionada);

    setState(() {
      _nome = _nomeController.text;
      _idade = _idadeController.text;
      _corFavorita = _corSelecionada; // Agora aplica a cor escolhida
    });
  }

  Color _corDeFundo() {
    switch (_corFavorita) {
      case 'Vermelho':
        return Colors.red.shade200;
      case 'Verde':
        return Colors.green.shade200;
      case 'Amarelo':
        return Colors.yellow.shade200;
      case 'Azul':
      default:
        return Colors.blue.shade200;
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _corDeFundo(),
      appBar: AppBar(title: Text('Meu Perfil Persistente')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _idadeController,
              decoration: InputDecoration(labelText: 'Idade'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: _corSelecionada,
              onChanged: (novaCor) {
                setState(() {
                  _corSelecionada = novaCor!;
                });
              },
              items: _cores.map((cor) {
                return DropdownMenuItem(
                  value: cor,
                  child: Text(cor),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvarDados,
              child: Text('Salvar Dados'),
            ),
            SizedBox(height: 30),
            Text(
              'Dados Salvos:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Nome: $_nome'),
            Text('Idade: $_idade'),
            Text('Cor favorita: $_corFavorita'),
          ],
        ),
      ),
    );
  }
}
