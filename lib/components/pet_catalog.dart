// lib/components/pet_catalog.dart

import 'package:flutter/material.dart';
import 'package:teste_app/Models/pets_model.dart';
import 'package:teste_app/pages/pet_perfil_page.dart';
import 'package:teste_app/components/pet_card.dart';
import '../services/favorites_service.dart';

// Lista Global de Pets - A nossa "fonte de dados" central.
final List<Pet> allPets = [
  Pet(
    nome: "Theo",
    imagens: ['https://i.imgur.com/IyLen7R.png'],
    sexo: "m",
    raca: "Golden",
    idade: 1,
    tags: ["Gosta de brincar", "Dócil", "Agitado"],
    descricao: "Um cão amigável e cheio de energia.",
    bairro: "Barra Funda",
    cidade: "São Paulo",
    telefone: "(11)1234-5235",
    ong: "Em prol do Amor", // <-- VINCULADO À ONG
  ),
  Pet(
    nome: "Crystal",
    imagens: ['https://i.imgur.com/ZbttlFX.png'],
    sexo: "f",
    raca: "Shitzu",
    idade: 2,
    tags: ["Gosta de passear", "Dócil", "Calma"],
    descricao: "A crystal é uma cachorra da raça Shitzu",
    bairro: "Cachoeirinha",
    cidade: "São Paulo",
    telefone: "(11) 9432-0432",
    ong: "Porta da Rua", // <-- VINCULADO À ONG
  ),
  Pet(
    nome: "Thor",
    imagens: ['https://images.dog.ceo/breeds/husky/n02110185_1469.jpg'],
    sexo: "m",
    raca: "Husky",
    idade: 5,
    tags: ["Vacinas em dia", "Agitado", "Bravo"],
    descricao: "O Thor é um husky bem agitado",
    bairro: "Santana",
    cidade: "São Paulo",
    telefone: "(11) 9432-0432",
    // Sem ONG, aparecerá apenas na home
  ),
  Pet(
    nome: "Maya",
    imagens: ['https://images.dog.ceo/breeds/akita/Akita_inu_blanc.jpg'],
    sexo: "f",
    raca: "Vira-lata",
    idade: 3,
    tags: ["Vacinas Faltando", "Agitado", "Feliz", "Castrado", "Acima do Peso"],
    descricao:
        "A Maya é uma cachorra que gosta muito de passear e brincar com outros cachorros",
    bairro: "Lapa",
    cidade: "São Paulo",
    telefone: "(11) 9432-0432",
    // Sem ONG, aparecerá apenas na home
  ),
];

class PetCatalog extends StatefulWidget {
  const PetCatalog({super.key});

  @override
  State<PetCatalog> createState() => _PetCatalogState();
}

class _PetCatalogState extends State<PetCatalog> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: allPets.length, // Usa a lista central de pets
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.60,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final pet = allPets[index];

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PetPerfilPage(pet: pet)),
            );
          },
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 280),
            child: PetCard(
              pet: pet,
              onFavoriteToggle: () {
                setState(() {
                  FavoritesService.toggleFavorite(pet);
                });
              },
            ),
          ),
        );
      },
    );
  }
}
