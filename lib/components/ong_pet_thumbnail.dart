// lib/components/ong_pet_thumbnail.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:teste_app/Models/pets_model.dart'; // <<< VERIFIQUE se o caminho está correto (models vs Models)

class OngPetThumbnail extends StatelessWidget {
  final Pet pet;

  const OngPetThumbnail({Key? key, required this.pet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ajuste estes valores para corresponder ao tamanho desejado na tela OngsPage
    const double cardWidth = 110.0; // Um pouco maior que o anterior
    const double cardHeight = 110.0 * 1.25; // Proporção um pouco menos alta
    const double borderRadius = 15.0; // Raio de borda da referência

    // Acesso seguro à imagem
    final String? firstImage = pet.imagens.isNotEmpty
        ? pet.imagens.first
        : null;

    return Container(
      width: cardWidth,
      height: cardHeight,
      margin: const EdgeInsets.only(
        right: 8.0,
      ), // Espaço APENAS à direita entre cards
      child: ClipRRect(
        // ClipRRect envolve tudo para garantir bordas arredondadas
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          fit: StackFit.expand, // Faz os filhos Stack preencherem o espaço
          children: [
            // --- Imagem de Fundo ---
            if (firstImage != null && firstImage.isNotEmpty)
              CachedNetworkImage(
                imageUrl: firstImage,
                fit: BoxFit.cover, // Garante que a imagem cubra todo o espaço
                placeholder: (context, url) => Container(
                  color: Colors.grey[200], // Placeholder simples
                ),
                errorWidget: (context, url, error) => Container(
                  // Fallback de erro
                  color: Colors.grey[300],
                  child: const Icon(Icons.pets, color: Colors.grey, size: 40),
                ),
              )
            else
              Container(
                // Fallback se não houver imagem
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(Icons.pets, color: Colors.grey, size: 40),
                ),
              ),

            // --- Gradiente Inferior ---
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: cardHeight * 0.5, // Metade inferior do card
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.75), // Mais escuro na base
                      Colors.transparent, // Transparente no meio
                    ],
                    stops: const [
                      0.0,
                      0.8,
                    ], // Controla onde o gradiente termina
                  ),
                ),
              ),
            ),

            // --- Conteúdo Sobreposto (Nome, Ícones) ---
            Positioned(
              bottom: 8, // Espaçamento inferior
              left: 8, // Espaçamento esquerdo
              right: 8, // Espaçamento direito
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Nome à esquerda, coração à direita
                crossAxisAlignment: CrossAxisAlignment.end, // Alinha na base
                children: [
                  // Nome e Gênero (agrupados e flexíveis)
                  Flexible(
                    // Impede o nome de empurrar o coração para fora
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Encolhe a Row
                      children: [
                        Flexible(
                          // Permite que o nome seja cortado se for muito longo
                          child: Text(
                            pet.nome,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14, // Um pouco maior
                              shadows: [
                                Shadow(blurRadius: 1, color: Colors.black87),
                              ],
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          pet.sexo == 'm' ? Icons.male : Icons.female,
                          size: 16, // Um pouco maior
                          color: Colors.white.withOpacity(0.9), // Mais visível
                          shadows: const [
                            Shadow(blurRadius: 1, color: Colors.black87),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Ícone de Coração (apenas visual)
                  Icon(
                    Icons.favorite_border,
                    color: Colors.white.withOpacity(0.9), // Mais visível
                    size: 18, // Um pouco maior
                    shadows: const [
                      Shadow(blurRadius: 1, color: Colors.black87),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
