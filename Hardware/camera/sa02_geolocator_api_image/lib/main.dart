import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'views/gallery_screen.dart';

void main() async {
  // Garante que o Flutter está pronto antes de executar código assíncrono.
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa a formatação de data para o idioma Português (Brasil).
  // Isto é necessário para que o `DateFormat` funcione corretamente.
  await initializeDateFormatting('pt_BR', null);
  
  runApp(const MyApp());
}

/// O widget principal que representa a raiz da aplicação.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Galeria de Fotos',
      // Remove a faixa de "Debug" no canto superior direito.
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define a cor principal da aplicação.
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Define a tela inicial da aplicação.
      home: const GalleryScreen(),
    );
  }
}

