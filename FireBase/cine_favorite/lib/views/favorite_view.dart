import 'package:cine_favorite/controllers/movie_firestore_controller.dart';
import 'package:cine_favorite/models/movie.dart'; // Importe o modelo Movie
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cine_favorite/services/tmdb_service.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  final PageController _pageController = PageController(initialPage: 0);
  final TextEditingController _searchController = TextEditingController();
  final MovieFirestoreController _controller = MovieFirestoreController();

  Future<List<Map<String, dynamic>>>? _searchResults;

  @override
  void initState() {
    super.initState();
    _searchResults = TmdbService.searchMovie('');
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() {
      _searchResults = TmdbService.searchMovie(query);
    });
  }

  void _toggleFavorite(Map<String, dynamic> movie) async {
    final user = _controller.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Faça login para favoritar filmes.")),
      );
      return;
    }

    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorite_movies')
        .doc(movie['id'].toString())
        .get();

    if (docSnapshot.exists) {
      _controller.deleteFavoriteMovie(movie['id']);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${movie['title']} removido dos favoritos.")),
      );
    } else {
      _controller.addFavoriteMovie(movie);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${movie['title']} adicionado aos favoritos!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC7B1E4),
      body: PageView(
        controller: _pageController,
        children: [
          _buildSearchScreen(),
          _buildFavoritesScreen(),
        ],
      ),
    );
  }

  Widget _buildSearchScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFC7B1E4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFC7B1E4),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.star,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            _pageController.animateToPage(1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearch,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: 'Buscar Filmes',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _searchResults,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Erro: ${snapshot.error}", style: const TextStyle(color: Colors.white)));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final movie = snapshot.data![index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser?.uid)
                                .collection('favorite_movies') // Corrigido
                                .doc(movie['id'].toString())
                                .snapshots(),
                            builder: (context, favSnapshot) {
                              final isFavorite = favSnapshot.hasData && favSnapshot.data!.exists;
                              return _buildMovieCard(
                                movie: movie,
                                isFavorite: isFavorite,
                                onTap: () => _toggleFavorite(movie),
                              );
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text("Pesquise por um filme!", style: TextStyle(color: Colors.white)));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesScreen() {
    final user = _controller.currentUser;

    if (user == null) {
      return const Center(child: Text("Faça login para ver seus favoritos.", style: TextStyle(color: Colors.white)));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFC7B1E4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFC7B1E4),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            _pageController.animateToPage(0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Meus Interesses",
              style: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Expanded(
              // Usando FutureBuilder para o Stream
              child: FutureBuilder<Stream<List<Movie>>>(
                future: _controller.getFavoriteMovies(),
                builder: (context, streamSnapshot) {
                  if (streamSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Colors.white));
                  }
                  if (streamSnapshot.hasError || !streamSnapshot.hasData) {
                    return const Center(child: Text("Erro ao carregar filmes.", style: TextStyle(color: Colors.white)));
                  }

                  return StreamBuilder<List<Movie>>(
                    stream: streamSnapshot.data,
                    builder: (context, movieSnapshot) {
                      if (movieSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: Colors.white));
                      }
                      if (!movieSnapshot.hasData || movieSnapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            "Você ainda não tem filmes favoritos.",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      return GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.2,
                        children: movieSnapshot.data!.map((movie) {
                          final movieData = movie.toMap();
                          return _buildFavoriteMovieCard(movie: movieData, onTap: () => _toggleFavorite(movieData));
                        }).toList(),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieCard({
    required Map<String, dynamic> movie,
    required bool isFavorite,
    required VoidCallback onTap,
  }) {
    final title = movie['title'] ?? 'N/A';
    final year = (movie['release_date'] as String?)?.split('-')[0] ?? 'N/A';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Filme: $title",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  color: isFavorite ? const Color.fromARGB(255, 135, 135, 226) : Colors.black,
                ),
                onPressed: onTap,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Ano de lançamento: $year",
            style: const TextStyle(color: Colors.black),
          )
        ],
      ),
    );
  }

  Widget _buildFavoriteMovieCard({required Map<String, dynamic> movie, required VoidCallback onTap}) {
    final title = movie['title'] ?? 'N/A';
    final year = (movie['release_date'] as String?)?.split('-')[0] ?? 'N/A';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.star, color: Color(0xFF8383D7)),
              onPressed: onTap, // Ação de remover ao clicar na estrela
            ),
          ),
          Text(
            "Filme: $title",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 4),
          Text(
            "Lançamento: $year",
            style: const TextStyle(fontSize: 12, color: Colors.black),
          ),
          if (movie['director'] != null)
            Text(
              "Diretor: ${movie['director']}",
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
          const SizedBox(height: 4),
          if (movie['genres'] != null)
            Text(
              "Gênero: ${movie['genres'].join(', ')}",
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
        ],
      ),
    );
  }
}