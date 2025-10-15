// lib/services/favorites_service.dart

import '../Models/pets_model.dart';

class FavoritesService {
  // Lista privada e estática para ser a ÚNICA fonte de verdade
  static final List<Pet> _favorites = [];

  // Método público para obter a lista de favoritos
  static List<Pet> get favorites => _favorites;

  // Adiciona um pet aos favoritos se ele não estiver na lista
  static void add(Pet pet) {
    if (!isFavorite(pet)) {
      _favorites.add(pet);
    }
  }

  // Remove um pet dos favoritos
  static void remove(Pet pet) {
    _favorites.removeWhere((p) => p.nome == pet.nome);
  }

  // Verifica se um pet já é favorito (usando o nome como identificador único)
  static bool isFavorite(Pet pet) {
    return _favorites.any((p) => p.nome == pet.nome);
  }
}
