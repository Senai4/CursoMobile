/// Representa o modelo de dados para uma foto.
/// Contém o ID, o caminho da imagem, data, coordenadas e o endereço.
class Photo {
  final String id;
  final String imagePath;
  final DateTime dateTime;
  final double latitude;
  final double longitude;
  final String address;

  Photo({
    required this.id,
    required this.imagePath,
    required this.dateTime,
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  /// Converte o objeto Photo para um Map, facilitando a conversão para JSON.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePath': imagePath,
      'dateTime': dateTime.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }

  /// Cria um objeto Photo a partir de um Map (geralmente vindo de um JSON).
  factory Photo.fromMap(Map<String, dynamic> map) {
    return Photo(
      id: map['id'],
      imagePath: map['imagePath'],
      dateTime: DateTime.parse(map['dateTime']),
      latitude: map['latitude'],
      longitude: map['longitude'],
      address: map['address'],
    );
  }
}

