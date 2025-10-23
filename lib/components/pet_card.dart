// lib/components/pet_card.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:teste_app/Models/pets_model.dart'; // Corrigido para 'models' minúsculo
import 'package:teste_app/services/favorites_service.dart';

class PetCard extends StatelessWidget {
  final Pet pet;
  final VoidCallback onFavoriteToggle;

  const PetCard({Key? key, required this.pet, required this.onFavoriteToggle})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayedTags = pet.tags.take(4).toList();
    const cardRadius = 16.0;

    final String? firstImage = pet.imagens.isNotEmpty
        ? pet.imagens.first
        : null;

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
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(cardRadius),
              ),
              child: (firstImage != null && firstImage.isNotEmpty)
                  ? CachedNetworkImage(
                      imageUrl: firstImage,
                      height: 130,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 130,
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2.0),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 130,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : Container(
                      height: 130,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(cardRadius),
                        ),
                      ),
                      child: const Center(
                        child: Icon(Icons.pets, color: Colors.grey, size: 40),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                pet.nome,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
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
                          maxLines: 1,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          // Use a função de formatação do seu modelo
                          pet.idadeFormatada,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ValueListenableBuilder<List<Pet>>(
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
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: onFavoriteToggle,
                      );
                    },
                  ),
                ],
              ),
            ),

            // --- CORREÇÃO APLICADA AQUI ---
            // O Wrap agora usa a lista `displayedTags` que foi limitada a 3 itens
            Flexible(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: displayedTags.map((t) => _smallTag(t)).toList(),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFb3e0db),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 10, color: Colors.black87),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
