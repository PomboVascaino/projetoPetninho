// lib/services/favorites_service.dart

import '../Models/pets_model.dart';
import 'dart:async'; // Necessário para usar Streams se fosse mais complexo. Mantemos a static

class FavoritesService {
  // Lista privada e estática
  static final List<Pet> _favorites = [];

  static List<Pet> get favorites => _favorites;

  static void add(Pet pet) {
    if (!isFavorite(pet)) {
      _favorites.add(pet);
    }
  }

  static void remove(Pet pet) {
    _favorites.removeWhere((p) => p.nome == pet.nome);
  }

  static bool isFavorite(Pet pet) {
    return _favorites.any((p) => p.nome == pet.nome);
  }

  // <--- MÉTODO ADICIONADO PARA CORRIGIR O ERRO DE CHAMADA --->
  static void toggleFavorite(Pet pet) {
    if (isFavorite(pet)) {
      remove(pet);
    } else {
      add(pet);
    }
  }
}