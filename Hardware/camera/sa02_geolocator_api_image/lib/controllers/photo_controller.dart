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

// --- CONFIGURAÇÃO ---
// ESTA É A SUA CHAVE DA API OPENWEATHERMAP
const String OPENWEATHER_API_KEY = "e36145c90b2091efaa7be9b454640d87";

/// Gere a lógica de negócio da aplicação.
class PhotoController {
  // Notificadores para a UI reagir a mudanças de estado
  final ValueNotifier<List<Photo>> photos = ValueNotifier<List<Photo>>([]);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<String?> errorMessage = ValueNotifier<String?>(null);

  final ImagePicker _picker = ImagePicker();

  PhotoController() {
    // Carrega as fotos guardadas assim que o controlador é criado
    loadPhotos();
  }

  /// Tira uma nova foto, obtém os metadados (localização, etc.) e guarda-a.
  Future<void> takePhoto() async {
    try {
      isLoading.value = true;
      errorMessage.value = null; // Limpa erros anteriores

      // 1. Captura a imagem com a câmara
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
      if (pickedFile == null) {
        isLoading.value = false;
        return; // O utilizador cancelou
      }

      // 2. Obtém a localização atual
      final Position position = await _determinePosition();

      // 3. Converte as coordenadas em endereço usando a API OpenWeatherMap
      final String address = await _getAddressFromCoords(position.latitude, position.longitude);

      // 4. Guarda a imagem de forma permanente no dispositivo
      final String imagePath = await _saveImagePermanently(pickedFile.path);

      // 5. Cria o objeto Photo com todos os dados
      final newPhoto = Photo(
        id: const Uuid().v4(),
        imagePath: imagePath,
        dateTime: DateTime.now(),
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
      );

      // 6. Atualiza a lista de fotos e guarda-a
      final currentPhotos = List<Photo>.from(photos.value)..add(newPhoto);
      photos.value = currentPhotos;
      await _savePhotosToPrefs();

    } catch (e) {
      errorMessage.value = "Erro: ${e.toString().replaceAll('Exception: ', '')}";
      debugPrint("Erro detalhado ao tirar foto: $e");
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Guarda a imagem do cache temporário para o diretório de documentos da app.
  Future<String> _saveImagePermanently(String tempPath) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = '${const Uuid().v4()}.jpg';
    final permanentFile = await File(tempPath).copy('${directory.path}/$fileName');
    return permanentFile.path;
  }

  /// Guarda a lista de metadados das fotos no SharedPreferences.
  Future<void> _savePhotosToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> photosJson = photos.value.map((p) => jsonEncode(p.toMap())).toList();
    await prefs.setStringList('photo_gallery', photosJson);
  }

  /// Carrega a lista de metadados das fotos do SharedPreferences.
  Future<void> loadPhotos() async {
    final prefs = await SharedPreferences.getInstance();
    final photosJson = prefs.getStringList('photo_gallery');
    if (photosJson != null) {
      photos.value = photosJson.map((json) => Photo.fromMap(jsonDecode(json))).toList();
    }
  }

  // --- FUNÇÃO MODIFICADA ---
  /// Obtém um endereço legível a partir de coordenadas usando a API OpenWeatherMap.
  Future<String> _getAddressFromCoords(double lat, double lon) async {
    if (OPENWEATHER_API_KEY.isEmpty) {
      throw Exception("A chave de API do OpenWeatherMap não foi configurada.");
    }
    // URL da API OpenWeatherMap para geocodificação reversa
    final url = Uri.parse('http://api.openweathermap.org/geo/1.0/reverse?lat=$lat&lon=$lon&limit=1&appid=$OPENWEATHER_API_KEY');
    
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data != null && data.isNotEmpty) {
        // Constrói o endereço a partir das partes da resposta
        final location = data[0];
        final name = location['name'] ?? '';
        final state = location['state'] ?? '';
        final country = location['country'] ?? '';
        return '$name, $state, $country';
      } else {
        throw Exception("Endereço não encontrado pela API.");
      }
    } else {
      throw Exception("Erro de rede (Código: ${response.statusCode})");
    }
  }

  /// Gere as permissões e obtém a posição atual do GPS.
  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Os serviços de localização estão desativados.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('A permissão de localização foi negada.');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      throw Exception('A permissão de localização foi negada permanentemente.');
    } 

    return await Geolocator.getCurrentPosition();
  }
}

