import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../models/photo_model.dart';

/// Exibe os detalhes de uma única foto selecionada.
class PhotoDetailScreen extends StatelessWidget {
  final Photo photo;

  const PhotoDetailScreen({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    // Formata a data e a hora para um formato mais legível
    final formattedDate = DateFormat('dd/MM/yyyy', 'pt_BR').format(photo.dateTime);
    final formattedTime = DateFormat('HH:mm').format(photo.dateTime);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes da Foto"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animação da imagem ao abrir 
            Hero(
              tag: photo.id,
              child: Image.file(
                File(photo.imagePath),
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 250,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: Colors.grey,
                        size: 50,
                      ),
                    ),
                  );
                },
              ),
            ),
            // informações da foto
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(Icons.calendar_today, "Data", formattedDate),
                  const SizedBox(height: 8),
                  _buildDetailRow(Icons.access_time, "Hora", formattedTime),
                  const SizedBox(height: 16),
                  _buildDetailRow(Icons.location_on, "Localização", photo.address, isAddress: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget auxiliar para criar uma linha de informação (ícone, rótulo, valor).
  Widget _buildDetailRow(IconData icon, String label, String value, {bool isAddress = false}) {
    return Row(
      crossAxisAlignment: isAddress ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.teal, size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

