//classe de modelagem de dados para Movie

//classe serve para adicionar filme a lista de favoritos do FireStore
class Movie {
  //atributos
  final int id; //Id fo tmdb
  final String title; //titulo do filme
  final String posterPath; //Caminho para a imagem do Poster
  double rating; //nota que o usuário dará ao filme

  //Construtor
  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    this.rating = 0
  });

  // métodos de conversão de OBJ <=> JSON

  //toMap OBJ => JSON
  Map<String,dynamic> toMap() {
    return{
      "id": id,
      "title": title,
      "posterPath":posterPath,
      "rating": rating
    };
  } 
  
  //fromMap => factory Json => OBJ
  factory Movie.fromMap(Map<String,dynamic> map){
    return Movie(
      id: map["id"], 
      title: map["title"], 
      posterPath: map["posterPath"],
      rating: (map["rating"] as num).toDouble());
  }

}