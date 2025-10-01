//classe de modelagem de dados para Movie

//classe serve para adicionar filme a lista de favoritos do FireStore
class Movie {
  // ATRIBUTOS ATUALIZADOS
  final int id; //Id do tmdb
  final String title; //titulo do filme
  final String posterPath; //Caminho para a imagem do Poster
  final String? releaseDate; // Adicionado: Data de lançamento
  double rating; //nota que o usuário dará ao filme

  // Construtor Atualizado
  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    this.releaseDate, 
    this.rating = 0,
  });

  // toMap OBJ => JSON (Atualizado para incluir releaseDate)
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "posterPath": posterPath,
      "releaseDate": releaseDate, 
      "rating": rating
    };
  }

  // fromMap => factory Json => OBJ (Atualizado para extrair releaseDate)
  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map["id"],
      title: map["title"],
      posterPath: map["posterPath"],
      releaseDate: map["releaseDate"], 
      rating: (map["rating"] as num?)?.toDouble() ?? 0,
    );
  }
}