// lib/components/favorite_list_item.dart

import 'package:flutter/material.dart';
import 'package:teste_app/Models/pets_model.dart';

class FavoriteListItem extends StatelessWidget {
  final Pet pet;
  final VoidCallback onFavoriteTap;
  final VoidCallback
  onTap; // 1. Adicionamos um novo callback para o toque no card.

  const FavoriteListItem({
    Key? key,
    required this.pet,
    required this.onFavoriteTap,
    required this.onTap, // E o tornamos obrigatório no construtor.
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 2. Envolvemos o Card com um InkWell para torná-lo clicável.
    return InkWell(
      onTap: onTap, // A ação de toque executa o callback que recebemos.
      borderRadius: BorderRadius.circular(
        16,
      ), // Para o efeito de clique ficar arredondado
      child: Card(
        color: Colors.white,
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Imagem à esquerda
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  pet.imagens.first,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),

              // Coluna com as informações do pet
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          pet.nome,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          pet.sexo == 'm' ? Icons.male : Icons.female,
                          size: 18,
                          color: pet.sexo == 'm'
                              ? Colors.blueAccent
                              : Colors.pinkAccent,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${pet.bairro}, ${pet.cidade}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${pet.idade} ano(s)',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),

              // Ícone de coração à direita
              IconButton(
                icon: const Icon(Icons.favorite, color: Colors.red, size: 28),
                onPressed: onFavoriteTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
