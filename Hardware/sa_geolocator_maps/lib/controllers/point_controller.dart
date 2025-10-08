//classe para fazer os controller de marcação de pontos de localização

import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:sa_geolocator_maps/models/point_location.dart';

class PointController {
  final DateFormat _formatar = DateFormat("dd/MM/yyyy - HH:mm:ss");

  // método
  // método para pegar a localização dos dispositivo
  Future<PointLocation> pegarPontoLocalizacao() async{
    //verificar se as permissões estão liberadas
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      throw Exception("Sem acesso ao GPS");
    }
    //solicitar a permissão do GPS
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
        throw Exception("Permissão GPS Negada");
      }
    }
    //se as permissões estiverem liberadas
    Position position = await Geolocator.getCurrentPosition();
    String dataHora = _formatar.format(DateTime.now());//formata data e hora em padrão pre definido

    // criar um obj do Model
    PointLocation posicaoAtual = PointLocation(
      latitude: position.latitude, 
      longitude: position.longitude, 
      dataHora: dataHora);

    return posicaoAtual;
  }
}