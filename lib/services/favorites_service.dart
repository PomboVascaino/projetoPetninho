// lib/services/favorites_service.dart
import 'package:flutter/material.dart';
import '../Models/pets_model.dart'; // Certifique-se de que o caminho para o seu modelo está correto

class FavoritesService {
  // 1. Criamos um ValueNotifier privado que irá conter la lista de pets.
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

    // Usamos a propriedade 'isFavorite' do próprio pet para decidir a ação
    if (pet.isFavorite) {
      // Se o pet já está favoritado, removemos ele.
      // Usamos 'removeWhere' para garantir que o pet correto seja removido.
      // É recomendado comparar por um ID único se você tiver um. Por enquanto, o nome funciona.
      list.removeWhere((p) => p.nome == pet.nome);
      pet.isFavorite = false; // Atualiza o estado do pet
    } else {
      // Se não está, adicionamos.
      list.add(pet);
      pet.isFavorite = true; // Atualiza o estado do pet
    }

    // 4. Notificamos todos os "ouvintes" (os ValueListenableBuilder) de que a lista mudou.
    //    Criamos uma nova lista com List.from() para garantir que a notificação funcione.
    _favorites.value = List.from(list);
  }

  // 5. Método que verifica se um pet já está na lista.
  static bool isFavorite(Pet pet) {
    // Agora, simplesmente verificamos a propriedade do próprio pet.
    return pet.isFavorite;
  }

  // <--- MÉTODO DUPLICADO E INCORRETO FOI REMOVIDO DAQUI --->
}