import 'dart:io';
import 'package:cine_favorite/models/movie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class MovieFirestoreController {
  //atributos
  final _auth = FirebaseAuth.instance; //controlador do Usuáro
  final _db = FirebaseFirestore.instance; //controlador do FireStore

  //Criar um User => método para pegar o usuário logado
  User? get currentUser => _auth.currentUser;

  //métodos (CRUD)
  //Pegar a Lista de Filme Favoritos
  //Stream => listener , pega a lista de favoritos sempre que form modificada
  Future<Stream<List<Movie>>> getFavoriteMovies() async {
    //lista salva no FireStore
    if (currentUser == null)
      return Stream.value(
        [],
      ); // se não tiver um usuário retrona uma lista vazia

    return await _db
        .collection("users")
        .doc(currentUser!.uid)
        .collection("favorite_movies")
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Movie.fromMap(doc.data())).toList(),
        );
    //retorna a coleção que está em json => covertida para uma lista de OBJ(Movie)
  }

  //adicionar filmes a lista de favoritos
  void addFavoriteMovie(Map<String, dynamic> movieData) async {
    //usar as bibliotecas path e path_provider para armazenar as img dos poster
    //armazenar a capa do filme no disposito
    //baixar a imagem da internet
    final imagemUrl =
        "https://image.tmdb.org/t/p/w500${movieData["poster_path"]}";
    //https://image.tmdb.org/t/p/w500/6vbxUh6LWHGhfuPI7GrimQaXNsQ.jpg
    final responseImg = await http.get(Uri.parse(imagemUrl));
    //Armazernas a imagem no celular (diretórios do app)
    final imgDir = await getApplicationDocumentsDirectory();
    final file = File("${imgDir.path}/${movieData["id"]}.jpg");
    await file.writeAsBytes(responseImg.bodyBytes);

    //criar o OBJ
    final movie = Movie(
      id: movieData["id"],
      title: movieData["title"],
      posterPath: movieData["poster_path"],
      releaseDate: movieData["release_date"], 
      // É recomendado incluir o rating inicial aqui para garantir que o campo exista.
      rating: 0.0, 
    );

    //adicionar o OBJ ao FireStore
    await _db
        .collection("users")
        .doc(currentUser!.uid)
        .collection("favorite_movies")
        .doc(movie.id.toString()) //eu determinei o ID o OBJ no banco
        .set(movie.toMap()); //
  }

  //delete (dos favoritos)
  void deleteFavoriteMovie(int movieId) async {
    if (currentUser == null) return;
    await _db
        .collection("users")
        .doc(currentUser!.uid)
        .collection("favorite_movies")
        .doc(movieId.toString())
        .delete();

    // deletar a imagem do diretório
    final imgPath = await getApplicationCacheDirectory();
    final file = File("${imgPath.path}/$movieId.jpg");
    try {
      await file.delete();
    } catch (e) {
      print("erro ao deletar img");
    }
  }

  //update
  void updateMovieRating(int movieId, double rating) async {
    if (currentUser == null) return;
    await _db
        .collection("users")
        .doc(currentUser!.uid)
        .collection("favorite_movies")
        .doc(movieId.toString())
        .update({"rating": rating});
  }
}
