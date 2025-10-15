// lib/components/pet_catalog.dart

import 'package:flutter/material.dart';
import 'package:teste_app/Models/pets_model.dart';
import 'package:teste_app/pages/pet_perfil_page.dart';
import 'package:teste_app/components/pet_card.dart';
import '../services/favorites_service.dart'; // Importe o serviço

// 1. Convertido para StatefulWidget para poder atualizar a UI
class PetCatalog extends StatefulWidget {
  PetCatalog({super.key});

  @override
  State<PetCatalog> createState() => _PetCatalogState();
}

class _PetCatalogState extends State<PetCatalog> {
  final List<Pet> pets = [
    Pet(
      nome: "Theo",
      imagens: [
        'https://i.imgur.com/IyLen7R.png',
        'https://i.imgur.com/aEw9v3C.jpeg',
        'https://i.imgur.com/lSEI2aP.jpeg',
      ],
      sexo: "m",
      raca: "Golden",
      idade: 1,
      tags: ["Gosta de brincar", "Dócil", "Agitado"],
      descricao: "Um cão amigável e cheio de energia.",
      bairro: "Barra Funda",
      cidade: "São Paulo",
      telefone: "(11)1234-5235",
    ),
    Pet(
      nome: "Crystal",
      imagens: [
        'https://i.imgur.com/ZbttlFX.png',
        'https://i.imgur.com/aEw9v3C.jpeg',
        'https://i.imgur.com/lSEI2aP.jpeg',
      ],
      sexo: "f",
      raca: "Shitzu",
      idade: 2,
      tags: ["Gosta de passear", "Dócil", "Calma"],
      descricao: "A crystal é uma cachorra da raça Shitzu",
      bairro: "Cachoeirinha",
      cidade: "São Paulo",
      telefone: "(11) 9432-0432",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: pets.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.60,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final pet = pets[index];

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PetPerfilPage(pet: pet)),
            );
          },
          // 2. Passamos o objeto Pet e a função de controle para o PetCard
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 280),
            child: PetCard(
              pet: pet,
              onFavoriteToggle: () {
                // 3. Lógica para adicionar/remover do serviço
                if (FavoritesService.isFavorite(pet)) {
                  FavoritesService.remove(pet);
                } else {
                  FavoritesService.add(pet);
                }
                // 4. setState para garantir que a UI reflita a mudança (opcional, mas bom)
                setState(() {});
              },
            ),
          ),
        );
      },
    );
  }
}
