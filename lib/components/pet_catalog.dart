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
    idade: "1 ano", // <-- CORRIGIDO para String
    tags: ["Gosta de brincar", "Dócil", "Agitado"],
    descricao: "Um cão amigável e cheio de energia.",
    bairro: "Barra Funda",
    cidade: "São Paulo",
    telefone: "(11)1234-5235",
    ong: "Em prol do Amor",
  ),
  Pet(
    nome: "Crystal",
    imagens: ['https://i.imgur.com/ZbttlFX.png'],
    sexo: "f",
    raca: "Shitzu",
    idade: "2 anos", // <-- CORRIGIDO para String
    tags: ["Gosta de passear", "Dócil", "Calma"],
    descricao: "A crystal é uma cachorra da raça Shitzu",
    bairro: "Cachoeirinha",
    cidade: "São Paulo",
    telefone: "(11) 9432-0432",
    ong: "Porta da Rua",
  ),
  Pet(
    nome: "Thor",
    imagens: ['https://images.dog.ceo/breeds/husky/n02110185_1469.jpg'],
    sexo: "m",
    raca: "Husky",
    idade: "5 anos", // <-- CORRIGIDO para String
    tags: ["Vacinas em dia", "Agitado", "Bravo"],
    descricao: "O Thor é um husky bem agitado",
    bairro: "Santana",
    cidade: "São Paulo",
    telefone: "(11) 9432-0432",
  ),
  Pet(
    nome: "Maya",
    imagens: ['https://images.dog.ceo/breeds/akita/Akita_inu_blanc.jpg'],
    sexo: "f",
    raca: "Vira-lata",
    idade: "3 anos", // <-- CORRIGIDO para String
    tags: ["Vacinas Faltando", "Agitado", "Feliz", "Castrado", "Acima do Peso"],
    descricao:
        "A Maya é uma cachorra que gosta muito de passear e brincar com outros cachorros",
    bairro: "Lapa",
    cidade: "São Paulo",
    telefone: "(11) 9432-0432",
  ),
];

class PetCatalog extends StatefulWidget {
  final List<Pet> pets;
  // Construtor atualizado para receber a lista
  const PetCatalog({super.key, required this.pets});

  @override
  State<PetCatalog> createState() => _PetCatalogState();
}

class _PetCatalogState extends State<PetCatalog> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: widget.pets.length, // Usa a lista recebida do pai (HomePage)
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.60,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final pet = widget.pets[index];

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
