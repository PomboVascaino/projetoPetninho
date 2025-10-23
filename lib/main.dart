import 'package:flutter/material.dart';
import 'package:teste_app/pages/contatos.dart';
import 'package:teste_app/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'package:teste_app/pages/favoritos_pages.dart';
import 'package:teste_app/pages/perguntas_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const PaginaPerguntas(), // chama a tela de perfil do pet
    );
  }
}
