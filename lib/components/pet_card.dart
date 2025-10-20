// lib/components/pet_card.dart

import 'package:flutter/material.dart';
import 'package:teste_app/Models/pets_model.dart';
import 'package:teste_app/services/favorites_service.dart';

class PetCard extends StatelessWidget {
  final Pet pet;
  final VoidCallback onFavoriteToggle;

  const PetCard({Key? key, required this.pet, required this.onFavoriteToggle})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    const cardRadius = 16.0;

    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(cardRadius),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(cardRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem com canto arredondado
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(cardRadius),
              ),
              child: Image.network(
                pet.imagens.first, // Pega a primeira imagem da lista
                height: 130,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nome, local e idade
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              pet.nome,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              pet.sexo == 'm' ? Icons.male : Icons.female,
                              size: 16,
                              color: pet.sexo == 'm'
                                  ? Colors.blueAccent
                                  : Colors.pinkAccent,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "(${pet.bairro}, ${pet.cidade})",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${pet.idade} ano(s)',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ✅ ÍCONE DE CORAÇÃO REATIVO ✅
                  // Usamos o ValueListenableBuilder para que o ícone se atualize
                  // sozinho sempre que a lista de favoritos mudar.
                  ValueListenableBuilder(
                    valueListenable: FavoritesService.favorites,
                    builder: (context, favoritePets, _) {
                      final isFavorite = FavoritesService.isFavorite(pet);

                      return IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite
                              ? Colors.redAccent
                              : Colors.grey[700],
                        ),
                        iconSize: 20,
                        onPressed: onFavoriteToggle,
                      );
                    },
                  ),
                ],
              ),
            ),

            // Tags (chips)
            Flexible(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: pet.tags.map((t) => _smallTag(t)).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFb3e0db),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, color: Colors.black87),
      ),
    );
  }
}
