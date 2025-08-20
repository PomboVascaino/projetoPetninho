// lib/main.dart
import 'package:flutter/material.dart';
import 'package:teste_app/pages/home_page.dart';

void main() {
  runApp(const PetninhoApp()); // inicia o MaterialApp que envolve a TestePage
}

class PetninhoApp extends StatelessWidget {
  const PetninhoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Petninho',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFBFEFE6),
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}
