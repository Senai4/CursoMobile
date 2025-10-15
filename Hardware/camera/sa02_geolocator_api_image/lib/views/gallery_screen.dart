import 'package:flutter/material.dart';
import 'dart:io';
import '../controllers/photo_controller.dart';
import '../models/photo_model.dart';
import 'photo_detail_screen.dart';

/// Tela principal que exibe a galeria de fotos em formato de grelha.
class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final PhotoController _controller = PhotoController();

  @override
  void initState() {
    super.initState();
    // Ouve as mensagens de erro do controlador para mostrar um aviso
    _controller.errorMessage.addListener(() {
      final message = _controller.errorMessage.value;
      if (message != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("A Minha Galeria"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Grelha de fotos
          ValueListenableBuilder<List<Photo>>(
            valueListenable: _controller.photos,
            builder: (context, photoList, child) {
              if (photoList.isEmpty) {
                return const Center(
                  child: Text(
                    "Nenhuma foto na galeria.\nTire a sua primeira foto!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }
              final reversedList = photoList.reversed.toList(); // Mostra as mais recentes primeiro
              return GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: reversedList.length,
                itemBuilder: (context, index) {
                  final photo = reversedList[index];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhotoDetailScreen(photo: photo),
                      ),
                    ),
                    child: Hero(
                      tag: photo.id,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.file(
                          File(photo.imagePath),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, color: Colors.grey, size: 40),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          // Ecrã de carregamento (loading)
          ValueListenableBuilder<bool>(
            valueListenable: _controller.isLoading,
            builder: (context, isLoading, child) {
              if (!isLoading) return const SizedBox.shrink(); // Não mostra nada se não estiver a carregar
              return Container(
                color: Colors.black.withOpacity(0.6),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 16),
                      Text("A processar foto...",
                          style: TextStyle(color: Colors.white, fontSize: 16, decoration: TextDecoration.none)),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _controller.takePhoto,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

