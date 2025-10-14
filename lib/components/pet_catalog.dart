import 'package:flutter/material.dart';
import 'package:teste_app/Models/pets_model.dart';
import 'package:teste_app/pages/pet_perfil_page.dart';
import 'package:teste_app/components/pet_card.dart';

class PetCatalog extends StatelessWidget {
  PetCatalog({super.key});

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
      descricao: "AAAAAAA",
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
      descricao: "A crystal é uma cachorra da raça Shitzua",
      bairro: "Cachoeirinha",
      cidade: "São Paulo",
      telefone: "(11 9432-0432)",
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

        final petCard = ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 280),
          child: PetCard(
            name: pet.nome,
            gender: pet.sexo,
            place: pet.bairro,
            age: pet.idade.toString(),
            tags: List<String>.from(pet.tags),
            imageUrl: pet.imagens[0],
          ),
        );

        // Se for a Crystal, abre a tela ao clicar

        return InkWell(
          onTap: () {
            // 💡 CORREÇÃO: Remove a propriedade 'onNavigateBack' da chamada,
            // pois ela foi removida do construtor de PetPerfilPage.
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PetPerfilPage(pet: pet)),
            );
          },
          child: petCard,
        );

        // Outros pets continuam normais
      },
    );
  }
}
