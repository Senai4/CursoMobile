import 'package:cine_favorite/controllers/movie_firestore_controller.dart';
import 'package:cine_favorite/models/movie.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cine_favorite/services/tmdb_service.dart';

// View principal que gerencia as telas de Busca e Favoritos
class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  // Controladores de navegação (PageView) e busca (TextField)
  final PageController _pageController = PageController(initialPage: 0);
  final TextEditingController _searchController = TextEditingController();
  final MovieFirestoreController _controller = MovieFirestoreController();

  // Future para armazenar os resultados da busca na API TMDB
  Future<List<Map<String, dynamic>>>? _searchResults;

  @override
  void initState() {
    super.initState();
    // Inicia a busca com uma string vazia (pode mostrar populares ou vazio)
    _searchResults = TmdbService.searchMovie('');
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Atualiza o estado da tela com novos resultados de busca
  void _onSearch(String query) {
    setState(() {
      _searchResults = TmdbService.searchMovie(query);
    });
  }

  // Lógica para adicionar/remover um filme nos favoritos do Firestore
  void _toggleFavorite(Map<String, dynamic> movie) async {
    final user = _controller.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Faça login para favoritar filmes.")),
      );
      return;
    }

    // Verifica se o filme já está na coleção de favoritos do usuário
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
    // Scaffold principal usando PageView para alternar entre as telas
    return Scaffold(
      backgroundColor: const Color(0xFFC7B1E4),
      body: PageView(
        controller: _pageController,
        children: [_buildSearchScreen(), _buildFavoritesScreen()],
      ),
    );
  }

  // --- Tela de Busca de Filmes ---
  Widget _buildSearchScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFC7B1E4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFC7B1E4),
        elevation: 0,
        // Ícone para navegar para a tela de favoritos
        leading: IconButton(
          icon: const Icon(Icons.star, color: Colors.white, size: 30),
          onPressed: () {
            _pageController.animateToPage(
              1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ),
        // Ação de logout
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white, size: 30),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/login', (route) => false);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo de texto para a busca (TextField)
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
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              // FutureBuilder para exibir os resultados da API (TmdbService)
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _searchResults,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Erro: ${snapshot.error}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    // Lista de resultados de busca, monitorando o status de favorito
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final movie = snapshot.data![index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          // StreamBuilder para verificar o status de favorito em tempo real
                          child: StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser?.uid)
                                .collection('favorite_movies')
                                .doc(movie['id'].toString())
                                .snapshots(),
                            builder: (context, favSnapshot) {
                              final isFavorite =
                                  favSnapshot.hasData && favSnapshot.data!.exists;
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
                    return const Center(
                      child: Text(
                        "Pesquise por um filme!",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Tela de Filmes Favoritos ---
  Widget _buildFavoritesScreen() {
    final user = _controller.currentUser;

    if (user == null) {
      return const Center(
        child: Text(
          "Faça login para ver seus favoritos.",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFC7B1E4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFC7B1E4),
        elevation: 0,
        // Ícone para voltar para a tela de busca
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () {
            _pageController.animateToPage(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ),
        // Ação de logout
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white, size: 30),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/login', (route) => false);
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
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              // FutureBuilder que obtém o Stream dos filmes favoritos do Firestore
              child: FutureBuilder<Stream<List<Movie>>>(
                future: _controller.getFavoriteMovies(),
                builder: (context, streamSnapshot) {
                  if (streamSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }
                  if (streamSnapshot.hasError || !streamSnapshot.hasData) {
                    return const Center(
                      child: Text(
                        "Erro ao carregar filmes.",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  // StreamBuilder para reagir a mudanças nos dados dos favoritos em tempo real
                  return StreamBuilder<List<Movie>>(
                    stream: streamSnapshot.data,
                    builder: (context, movieSnapshot) {
                      if (movieSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }
                      if (!movieSnapshot.hasData ||
                          movieSnapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            "Você ainda não tem filmes favoritos.",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      // GridView para exibir os filmes favoritos
                      return GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.65, // Ajustado para incluir a imagem
                        children: movieSnapshot.data!.map((movie) {
                          final movieData = movie.toMap();
                          return _buildFavoriteMovieCard(
                            movie: movieData,
                            onTap: () => _toggleFavorite(movieData),
                          );
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

  // --- Card de Exibição de Filme (na Busca) ---
  Widget _buildMovieCard({
    required Map<String, dynamic> movie,
    required bool isFavorite,
    required VoidCallback onTap,
  }) {
    final title = movie['title'] ?? 'N/A';
    final year = (movie['release_date'] as String?)?.split('-')[0] ?? 'N/A';
    final posterPath = movie['poster_path'];
    // URL base para imagens do TMDB (tamanho w92 ou w200 são boas opções)
    const String baseImageUrl = 'https://image.tmdb.org/t/p/w92';
    final String fullImageUrl =
        posterPath != null ? '$baseImageUrl$posterPath' : '';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Imagem do Pôster
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 60, // Largura fixa para o pôster
              height: 90, // Altura fixa para o pôster (proporção de pôster)
              child: posterPath != null
                  ? Image.network(
                      fullImageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                            child: CircularProgressIndicator(strokeWidth: 2));
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.movie, size: 40, color: Colors.grey),
                    )
                  : const Icon(Icons.movie, size: 40, color: Colors.grey), // Placeholder
            ),
          ),
          const SizedBox(width: 16),

          // 2. Conteúdo do filme
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        maxLines: 2, // Limita o título a 2 linhas
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Ícone de favorito/desfavorito
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.star : Icons.star_border,
                        color: isFavorite
                            ? const Color.fromARGB(255, 135, 135, 226)
                            : Colors.black,
                      ),
                      onPressed: onTap,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "Ano: $year",
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Card de Exibição de Filme (na Tela de Favoritos - Grid) ---
  Widget _buildFavoriteMovieCard({
    required Map<String, dynamic> movie,
    required VoidCallback onTap,
  }) {
    final title = movie['title'] ?? 'N/A';
    // No modelo Movie, o nome do campo é 'releaseDate' e 'posterPath'
    final year = (movie['releaseDate'] as String?)?.split('-')[0] ?? 'N/A';
    final posterPath = movie['posterPath']; 
    // URL base para imagens do TMDB (tamanho w200 é bom para GridView)
    const String baseImageUrl = 'https://image.tmdb.org/t/p/w200';
    final String fullImageUrl =
        posterPath != null ? '$baseImageUrl$posterPath' : '';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Imagem do Pôster
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(15)),
                  child: posterPath != null
                      ? Image.network(
                          fullImageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                                child: CircularProgressIndicator(strokeWidth: 2));
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                                  child: Icon(Icons.movie,
                                      size: 50, color: Colors.grey)),
                        )
                      : const Center(
                          child: Icon(Icons.movie, size: 50, color: Colors.grey)),
                ),
              ),

              // 2. Detalhes do Filme
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      maxLines: 1, 
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Ano: $year",
                      style:
                          const TextStyle(fontSize: 11, color: Colors.black54),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Estrela para remover/indicar favorito
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color(0xFFC7B1E4), // Fundo roxo para destacar a estrela
                shape: BoxShape.circle,
              ),
              child: GestureDetector(
                onTap: onTap, // O toque remove dos favoritos
                child: const Icon(
                  Icons.star,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}