import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sa_geolocator_maps/controllers/point_controller.dart';
import 'package:sa_geolocator_maps/models/point_location.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  //atributos
  List<PointLocation> listaPontos = [];
  final _pointController = PointController(); //obj para manipulas os controllers
  final _flutterMapController = MapController(); // obj para controllar o Map

  bool _isLoading = false;
  String? _erro;

  // metodo pra adicionar pontos no Mapa
  void _adicionarPonto() async {
    setState(() {
      _isLoading = true;
      _erro = null;
    });
    try {
      //pegar a localização
      PointLocation novaMarcacao = await _pointController.pegarPontoLocalizacao();
      listaPontos.add(novaMarcacao);
      _flutterMapController.move(
          LatLng(novaMarcacao.latitude, novaMarcacao.longitude), 11);
    } catch (e) {
      _erro = e.toString();
      //mostrar o erro
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(_erro!)));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // --- NOVO MÉTODO PARA REMOVER PONTO ---
  void _removerPonto(PointLocation pontoParaRemover) {
    setState(() {
      listaPontos.remove(pontoParaRemover);
    });
  }

  // --- NOVO MÉTODO PARA MOSTRAR DIÁLOGO DE CONFIRMAÇÃO ---
  void _mostrarDialogoConfirmacao(PointLocation ponto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar Exclusão"),
          content: const Text("Deseja realmente remover esta marcação?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
            ),
            TextButton(
              child: const Text("Remover"),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
                _removerPonto(ponto);      // Chama a função de remoção
              },
            ),
          ],
        );
      },
    );
  }


  //build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //botao para adicionar pontos no map
      // o mapa
      appBar: AppBar(
        title: const Text("Mapa de Localização"),
        actions: [
          IconButton(
              //evita de apertar o botão seguidas vezes
              onPressed: _isLoading ? null : _adicionarPonto,
              icon: _isLoading
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.add_location_alt))
        ],
      ),
      body: FlutterMap(
          mapController: _flutterMapController,
          options: const MapOptions(
              initialCenter: LatLng(-22.3353, -47.2417), initialZoom: 11),
          //camadas do mapa
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              userAgentPackageName: "com.example.sa_gelocator_maps",
            ),
            //proxima camada serão as marcações
            MarkerLayer(
                markers: listaPontos.map((ponto) {
              return Marker(
                  point: LatLng(ponto.latitude, ponto.longitude),
                  width: 50,
                  height: 50,
                  // --- MODIFICAÇÃO AQUI: ADICIONADO GestureDetector ---
                  child: GestureDetector(
                    onTap: () {
                      _mostrarDialogoConfirmacao(ponto);
                    },
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 35,
                    ),
                  ));
            }).toList())
          ]),
    );
  }
}