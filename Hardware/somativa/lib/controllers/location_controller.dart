// lib/controllers/location_controller.dart
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LocationController {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      throw Exception('Serviço de localização desativado');
    }

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Permissão de localização negada');
    }

    return await Geolocator.getCurrentPosition();
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    final Distance distance = Distance();
    return distance(LatLng(lat1, lon1), LatLng(lat2, lon2));
  }

  Future<void> salvarPonto(LatLng ponto) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> pontos = prefs.getStringList('pontos') ?? [];
    pontos.add('${ponto.latitude},${ponto.longitude}');
    await prefs.setStringList('pontos', pontos);
  }

  Future<List<LatLng>> getPontos() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> pontos = prefs.getStringList('pontos') ?? [];
    return pontos
        .map((e) {
          final partes = e.split(',');
          return LatLng(double.parse(partes[0]), double.parse(partes[1]));
        })
        .toList();
  }
}
