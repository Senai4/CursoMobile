import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/photo_model.dart';

// Chave de API para o serviço OpenWeatherMap.
const String OPENWEATHER_API_KEY = "e36145c90b2091efaa7be9b454640d87";

/// Gerencia a lógica de negócio, o estado e a persistência de dados da aplicação.
class PhotoController {
  // Notificadores de estado para que a UI possa reagir a mudanças.
  final ValueNotifier<List<Photo>> photos = ValueNotifier<List<Photo>>([]);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<String?> errorMessage = ValueNotifier<String?>(null);

  // Instância do controlador para acesso à câmera e galeria.
  final ImagePicker _picker = ImagePicker();

  PhotoController() {
    // Carrega as fotos salvas do dispositivo na inicialização do controlador.
    loadPhotos();
  }

  /// Inicia o processo completo de captura e salvamento de uma nova foto.
  Future<void> takePhoto() async {
    try {
      // Ativa o indicador de progresso e limpa erros anteriores.
      isLoading.value = true;
      errorMessage.value = null;

      // 1. Abre a câmera para o usuário capturar uma imagem.
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
      if (pickedFile == null) {
        isLoading.value = false;
        return; // O usuário cancelou a captura.
      }

      // 2. Obtém as coordenadas geográficas atuais do dispositivo.
      final Position position = await _determinePosition();

      // 3. Converte as coordenadas em um endereço legível via API.
      final String address = await _getAddressFromCoords(position.latitude, position.longitude);

      // 4. Salva o arquivo de imagem permanentemente no armazenamento do dispositivo.
      final String imagePath = await _saveImagePermanently(pickedFile.path);

      // 5. Agrupa todas as informações em um novo objeto Photo.
      final newPhoto = Photo(
        id: const Uuid().v4(),
        imagePath: imagePath,
        dateTime: DateTime.now(),
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
      );

      // 6. Adiciona a nova foto à lista de estado e persiste os dados.
      final currentPhotos = List<Photo>.from(photos.value)..add(newPhoto);
      photos.value = currentPhotos;
      await _savePhotosToPrefs();

    } catch (e) {
      // Captura e trata qualquer exceção durante o processo.
      errorMessage.value = "Erro: ${e.toString().replaceAll('Exception: ', '')}";
      debugPrint("Erro detalhado ao tirar foto: $e");
    } finally {
      // Garante que o indicador de progresso seja desativado ao final do processo.
      isLoading.value = false;
    }
  }
  
  /// Salva um arquivo de imagem de um caminho temporário para o diretório de documentos da aplicação.
  Future<String> _saveImagePermanently(String tempPath) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = '${const Uuid().v4()}.jpg';
    final permanentFile = await File(tempPath).copy('${directory.path}/$fileName');
    return permanentFile.path;
  }

  /// Persiste a lista de fotos (em formato JSON) no SharedPreferences.
  Future<void> _savePhotosToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> photosJson = photos.value.map((p) => jsonEncode(p.toMap())).toList();
    await prefs.setStringList('photo_gallery', photosJson);
  }

  /// Carrega a lista de fotos do SharedPreferences ao iniciar a aplicação.
  Future<void> loadPhotos() async {
    final prefs = await SharedPreferences.getInstance();
    final photosJson = prefs.getStringList('photo_gallery');
    if (photosJson != null) {
      photos.value = photosJson.map((json) => Photo.fromMap(jsonDecode(json))).toList();
    }
  }

  /// Obtém um endereço legível a partir de coordenadas geográficas usando a API OpenWeatherMap.
  Future<String> _getAddressFromCoords(double lat, double lon) async {
    if (OPENWEATHER_API_KEY.isEmpty) {
      throw Exception("A chave da API do OpenWeatherMap não foi configurada.");
    }
    // Monta a URL para a API de geocodificação reversa.
    final url = Uri.parse('http://api.openweathermap.org/geo/1.0/reverse?lat=$lat&lon=$lon&limit=1&appid=$OPENWEATHER_API_KEY');
    
    // Executa a requisição HTTP GET.
    final response = await http.get(url);

    // Verifica se a requisição foi bem-sucedida.
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data != null && data.isNotEmpty) {
        // Extrai os dados da resposta para construir o endereço.
        final location = data[0];
        final name = location['name'] ?? 'Local';
        final state = location['state'] ?? 'Estado Desconhecido';
        final country = location['country'] ?? 'País Desconhecido';
        return '$name, $state, $country';
      } else {
        throw Exception("Endereço não encontrado pela API.");
      }
    } else {
      // Lança uma exceção em caso de falha na requisição.
      throw Exception("Erro de rede (Código: ${response.statusCode})");
    }
  }

  /// Gerencia as permissões de localização e obtém a posição atual do dispositivo.
  Future<Position> _determinePosition() async {
    // Verifica se o serviço de localização está habilitado no dispositivo.
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Os serviços de localização estão desativados.');
    }

    // Verifica o status da permissão de localização para a aplicação.
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Se a permissão for negada, solicita ao usuário.
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('A permissão de localização foi negada.');
      }
    }
    
    // Verifica se a permissão foi negada permanentemente pelo usuário.
    if (permission == LocationPermission.deniedForever) {
      throw Exception('A permissão de localização foi negada permanentemente.');
    } 

    // Retorna a posição atual se as permissões foram concedidas.
    return await Geolocator.getCurrentPosition();
  }
}

