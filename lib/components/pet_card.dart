// lib/components/pet_card.dart

import 'package:cached_network_image/cached_network_image.dart'; // <<< ADICIONE ou GARANTA que existe
import 'package:flutter/material.dart';
import 'package:teste_app/Models/pets_model.dart';
import 'package:teste_app/services/favorites_service.dart';

class PetCard extends StatelessWidget {
  final Pet pet;
  final VoidCallback onFavoriteToggle;

  // --- CONSTRUTOR CORRIGIDO ---
  // Removemos os parâmetros antigos que não são mais necessários
  const PetCard({Key? key, required this.pet, required this.onFavoriteToggle})
    : super(key: key);
  // --- FIM DO CONSTRUTOR CORRIGIDO ---

  @override
  Widget build(BuildContext context) {
    const cardRadius = 16.0;
    // --- ACESSO SEGURO À IMAGEM ---
    // Pega a primeira imagem SOMENTE se a lista não estiver vazia
    final String? firstImage = pet.imagens.isNotEmpty
        ? pet.imagens.first
        : null;
    // --- FIM DO ACESSO SEGURO ---

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
            // --- USO SEGURO DA IMAGEM COM CACHE ---
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(cardRadius),
              ),
              // Verifica se firstImage não é nulo antes de usar
              child:
                  (firstImage != null &&
                      firstImage
                          .isNotEmpty) // Adiciona checagem de string vazia
                  ? CachedNetworkImage(
                      // Usa CachedNetworkImage
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
                      // Widget de fallback se não houver imagem
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

            // --- FIM DO USO SEGURO DA IMAGEM ---
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
                            Flexible(
                              // Adicionado Flexible para evitar overflow
                              child: Text(
                                pet.nome,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow:
                                    TextOverflow.ellipsis, // Corta nome longo
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
                          '${pet.idade} ${pet.idade == 1 ? "ano" : "anos"}', // Formatação
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Ícone de coração reativo
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

            // Tags (chips)
            Flexible(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 4,
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
