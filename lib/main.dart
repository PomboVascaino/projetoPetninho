import 'package:flutter/material.dart';
import 'package:teste_app/pages/favoritos_pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const FavoritosPage(), // chama a tela de perfil do pet
    );
  }
}
