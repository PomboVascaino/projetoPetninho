import 'package:flutter/material.dart';
import 'package:teste_app/pages/home_page.dart';


void main() => runApp(const PetninhoApp());

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
      ),
      home: const HomePage(),
    );
  }
}
