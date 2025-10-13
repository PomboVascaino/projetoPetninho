import 'package:flutter/material.dart';
import 'package:teste_app/pages/pet_perfil_page.dart';
import 'package:teste_app/components/pet_card.dart';

class PetCatalog extends StatelessWidget {
  const PetCatalog({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> pets = [
      {
        "name": "Theo",
        "gender": "m",
        "place": "Barra Funda - São Paulo",
        "age": "8 meses",
        "tags": ["Gosta de brincar", "Dócil", "Agitado"],
        "img": "https://i.imgur.com/IyLen7R.png",
      },
      {
        "name": "Crystal",
        "gender": "f",
        "place": "Cachoeirinha - São Paulo",
        "age": "1 ano",
        "tags": ["Gosta de passear", "Dócil", "Calma"],
        "img": "https://i.imgur.com/ZbttlFX.png",
      },
    ];

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
        final p = pets[index];

        final petCard = ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 280),
          child: PetCard(
            name: p['name'] as String,
            gender: p['gender'] as String,
            place: p['place'] as String,
            age: p['age'] as String,
            tags: List<String>.from(p['tags'] as List<dynamic>),
            imageUrl: p['img'] as String,
          ),
        );

        // Se for a Crystal, abre a tela ao clicar
        if (p['name'] == "Crystal") {
          return InkWell(
            onTap: () {
              // 💡 CORREÇÃO: Remove a propriedade 'onNavigateBack' da chamada,
              // pois ela foi removida do construtor de PetPerfilPage.
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PetPerfilPage()),
              );
            },
            child: petCard,
          );
        }

        // Outros pets continuam normais
        return petCard;
      },
    );
  }
}
