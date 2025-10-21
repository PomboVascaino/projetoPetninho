// lib/services/favorites_service.dart
import 'package:flutter/material.dart';
import '../Models/pets_model.dart'; // Certifique-se de que o caminho para o seu modelo está correto

class FavoritesService {
  // 1. Criamos um ValueNotifier privado que irá conter a lista de pets.
  //    Ele é o responsável por "avisar" a interface sobre as mudanças.
  static final ValueNotifier<List<Pet>> _favorites = ValueNotifier<List<Pet>>(
    [],
  );

  // 2. Criamos um getter público para expor o ValueNotifier de forma segura.
  //    É este "favorites" que o seu ValueListenableBuilder vai usar.
  static ValueNotifier<List<Pet>> get favorites => _favorites;

  // 3. Implementamos a lógica para adicionar e remover.
  static void toggleFavorite(Pet pet) {
    // Acessamos a lista atual através de '.value'
    final list = _favorites.value;

    if (isFavorite(pet)) {
      // Se o pet já está na lista, removemos ele.
      // Usamos 'removeWhere' para garantir que o pet correto seja removido, comparando por um ID único.
      // Se seu modelo Pet não tiver um 'id', você pode usar o 'nome' por enquanto.
      list.removeWhere((p) => p.nome == pet.nome);
    } else {
      // Se não está, adicionamos.
      list.add(pet);
    }

    // 4. Notificamos todos os "ouvintes" (os ValueListenableBuilder) de que a lista mudou.
    //    Criamos uma nova lista com List.from() para garantir que a notificação funcione.
    _favorites.value = List.from(list);
  }

  // 5. Método que verifica se um pet já está na lista.
  static bool isFavorite(Pet pet) {
    return _favorites.value.any((p) => p.nome == pet.nome);
  }
}
