// lib/components/pet_catalog.dart (CÓDIGO CORRIGIDO)

import 'package:flutter/material.dart';
import 'package:teste_app/Models/pets_model.dart';
import 'package:teste_app/pages/pet_perfil_page.dart';
import 'package:teste_app/components/pet_card.dart';
import '../services/favorites_service.dart';

// 1. CORREÇÃO: Tornar o callback final e incluí-lo no construtor
class PetCatalog extends StatefulWidget {
  final Function(String petName, String petDetails) onPetCardLongPress;

  const PetCatalog({
    super.key, 
    required this.onPetCardLongPress, // ATRIBUIÇÃO CORRETA
  });

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
    Pet(
      nome: "Thor",
      imagens: [
        'https://images.dog.ceo/breeds/husky/n02110185_1469.jpg',
        'https://i.imgur.com/aEw9v3C.jpeg',
        'https://i.imgur.com/lSEI2aP.jpeg',
      ],
      sexo: "m",
      raca: "Husky",
      idade: 5,
      tags: ["Vacinas em dia", "Agitado", "Bravo"],
      descricao: "O Thor é um husky bem agitado ",
      bairro: "Santana",
      cidade: "São Paulo",
      telefone: "(11) 9432-0432",
    ),
    Pet(
      nome: "Maya",
      imagens: [
        'https://images.dog.ceo/breeds/akita/Akita_inu_blanc.jpg',
        'https://i.imgur.com/aEw9v3C.jpeg',
        'https://i.imgur.com/lSEI2aP.jpeg',
      ],
      sexo: "f",
      raca: "Vira-lata",
      idade: 3,
      tags: ["Vacinas Faltando", "Agitado"],
      descricao:
          "A Maya é uma Husky que gosta muiito de passear e brincar com outros cachorros ",
      bairro: "Lapa",
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
          // CORREÇÃO: Adicionar a funcionalidade onLongPress
          onLongPress: () {
            // Chama o callback da HomePage e passa o texto
            widget.onPetCardLongPress(pet.nome, pet.descricao);
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