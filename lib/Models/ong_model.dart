// lib/models/ong_model.dart

import 'package:flutter/material.dart'; // Importe o material para usar a classe Color
import 'pets_model.dart';

class Ong {
  final String id;
  final String name;
  final String logoUrl;
  final String headerImageUrl; // <-- CAMPO ADICIONADO
  final Color color; // <-- CAMPO ADICIONADO
  final List<Pet> pets;

  Ong({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.headerImageUrl, // <-- ADICIONADO AO CONSTRUTOR
    required this.color, // <-- ADICIONADO AO CONSTRUTOR
    this.pets = const [],
  });
}
