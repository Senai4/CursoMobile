import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../controllers/BP_controller.dart'; // Certifique-se de que o nome do Controller está correto
import 'historico_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = RegistroController(); // Assumo que RegistroController é seu BP_controller
  final Distance distance = Distance();
  final MapController mapController = MapController();

  // Coordenadas da sua empresa 
  final LatLng empresaLocal = LatLng(-22.5703659, -47.4471221);

  LatLng? posicaoAtual;
  String status = 'Pressione o botão para marcar ponto';
  bool dentroDaArea = false;
  // NOVO: Variável para controlar o estado de processamento
  bool _isProcessing = false; 

  // Função para pegar a localização atual do usuário
  Future<void> _pegarLocalizacao() async {
    if (_isProcessing) return; // Ignora se já estiver processando

    setState(() {
      _isProcessing = true;
      status = 'Buscando localização...';
    });

    try {
      final pos = await controller.pegarLocalizacao();
      final atual = LatLng(pos.latitude, pos.longitude);

      final metros = distance.as(LengthUnit.Meter, empresaLocal, atual);

      setState(() {
        posicaoAtual = atual;
        dentroDaArea = metros >= 1000;
        status = 'Distância até a empresa: ${metros.toStringAsFixed(1)} m';
      });

      mapController.move(atual, 17);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao obter localização: $e')),
      );
    } finally {
      // Garante que o estado seja redefinido
      setState(() {
        _isProcessing = false;
      });
    }
  }

  // Função para registrar ponto
  Future<void> _registrarPonto() async {
    if (_isProcessing) return; // Ignora se já estiver processando
    
    setState(() {
      _isProcessing = true; // Inicia o processamento
      status = 'Registrando ponto...';
    });

    try {
      Position pos;
      if (posicaoAtual != null) {
        // Se a localização já foi verificada, usa a última
        pos = Position(
          latitude: posicaoAtual!.latitude,
          longitude: posicaoAtual!.longitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0, 
          altitudeAccuracy: 0, 
          headingAccuracy: 0,
        );
      } else {
        // Se não foi verificada, pega agora (operação demorada)
        pos = await controller.pegarLocalizacao();
      }

      final metros = distance.as(LengthUnit.Meter, empresaLocal, LatLng(pos.latitude, pos.longitude));
      final dentro = metros >= 1000;

      setState(() {
        posicaoAtual = LatLng(pos.latitude, pos.longitude);
        dentroDaArea = dentro;
        status = 'Distância até a empresa: ${metros.toStringAsFixed(1)} m';
      });

      if (dentro) {
        await controller.registrarPonto( 
          latitude: pos.latitude,
          longitude: pos.longitude,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ponto registrado!\nLat: ${pos.latitude}, Lng: ${pos.longitude}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Você está fora da área de 100 metros!')),
        );
      }

      mapController.move(posicaoAtual!, 17);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao registrar ponto: $e')),
      );
    } finally {
      // Garante que o estado seja redefinido
      setState(() {
        _isProcessing = false;
      });
    }
  }

  // NOVO MÉTODO: Cria o conteúdo do botão, incluindo o spinner
  Widget _buildButtonChild(String label, IconData icon) {
      if (_isProcessing) {
        return const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
        );
      }
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(label),
        ],
      );
    }
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caterpillar Piracicaba'),
        actions: [
          IconButton(
            icon: const Icon(Icons.access_time),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoricoPage()),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: empresaLocal,
                initialZoom: 16,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://a.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: empresaLocal,
                      width: 60,
                      height: 60,
                      child: const Icon(Icons.business, color: Color.fromARGB(255, 64, 15, 179), size: 35),
                    ),
                    if (posicaoAtual != null)
                      Marker(
                        point: posicaoAtual!,
                        width: 60,
                        height: 60,
                        child: Icon(
                          Icons.person_pin_circle,
                          color: dentroDaArea
                              ? const Color.fromARGB(285, 255, 160, 247)
                              : const Color.fromARGB(255, 128, 128, 128),
                          size: 35,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(status, textAlign: TextAlign.center),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // BOTÃO 'Ver Localização' - Desabilitado durante o processamento
              ElevatedButton(
                onPressed: _isProcessing ? null : _pegarLocalizacao,
                child: _buildButtonChild('Ver Localização', Icons.my_location),
              ),
              // BOTÃO 'Registrar Ponto' - Desabilitado durante o processamento
              ElevatedButton(
                onPressed: _isProcessing ? null : _registrarPonto,
                child: _buildButtonChild('Registrar Ponto', Icons.fingerprint),
              ),
            ],
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}