// lib/components/pet_card.dart

import 'package:flutter/material.dart';
import '../Models/pets_model.dart';
import '../services/favorites_service.dart';

// 1. Convertido para StatefulWidget para gerenciar o estado do coração
class PetCard extends StatefulWidget {
  // 2. Agora recebe o objeto Pet completo e uma função de callback
  final Pet pet;
  final VoidCallback onFavoriteToggle;

  const PetCard({
    Key? key,
    required this.pet,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  State<PetCard> createState() => _PetCardState();
}

class _PetCardState extends State<PetCard> {
  bool _isFavorite = false;

  // 3. Verifica o estado inicial do favorito quando o widget é construído
  @override
  void initState() {
    super.initState();
    _isFavorite = FavoritesService.isFavorite(widget.pet);
  }

  @override
  Widget build(BuildContext context) {
    final cardRadius = 16.0;
    // Extraindo dados do widget.pet para facilitar a leitura
    final pet = widget.pet;

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
              child: Image.network(
                pet.imagens.first,
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              pet.nome,
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              pet.sexo == 'm' ? Icons.male : Icons.female,
                              size: 16,
                              color: pet.sexo == 'm'
                                  ? Colors.blueAccent
                                  : Colors.pinkAccent,
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          "(${pet.bairro})",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "${pet.idade} ano(s)",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 4. Ícone agora é um botão que controla o estado
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : Colors.grey[700],
                      size: 22,
                    ),
                    onPressed: () {
                      // 5. Atualiza o estado visual e chama a função de controle
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });
                      widget.onFavoriteToggle();
                    },
                  ),
                ],
              ),
            ),
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
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Color(0xFFb3e0db),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: TextStyle(fontSize: 11, color: Colors.black87)),
    );
  }
}