// lib/components/partial_search_modal.dart (ou o nome que você deu ao arquivo)

import 'package:flutter/material.dart';
import 'package:teste_app/Models/pets_model.dart';
import 'package:teste_app/pages/pet_perfil_page.dart';
import 'package:teste_app/components/pet_card.dart';
import '../services/favorites_service.dart';

// Lista de dados para a pesquisa.
final List<Pet> allPets = [
  Pet(
    nome: "Theo",
    imagens: ['https://i.imgur.com/IyLen7R.png'],
    sexo: "m",
    raca: "Golden",
    idade: "1 ano", // <-- CORRIGIDO: A idade agora é uma String
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
    idade: "2 anos", // <-- CORRIGIDO: A idade agora é uma String
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
    idade: "5 anos", // <-- CORRIGIDO: A idade agora é uma String
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
    idade: "3 anos", // <-- CORRIGIDO: A idade agora é uma String
    tags: ["Vacinas Faltando", "Agitado", "Feliz", "Castrado", "Acima do Peso"],
    descricao:
        "A Maya é uma cachorra que gosta muito de passear e brincar com outros cachorros",
    bairro: "Lapa",
    cidade: "São Paulo",
    telefone: "(11) 9432-0432",
  ),
  // ... adicione todos os seus pets aqui
];

class PetSearchDelegate extends SearchDelegate<String> {
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return theme.copyWith(
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
      textTheme: theme.textTheme.copyWith(
        titleLarge: const TextStyle(
          color: Colors.black87,
          fontSize: 16,
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.black,
      ),
    );
  }

  @override
  String get searchFieldLabel => 'Pesquisar nome, raça, tags...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  // Widget para construir a grade de resultados
  Widget _buildResultsGrid(BuildContext context, List<Pet> results) {
    if (query.isEmpty) {
      return const Center(child: Text("Digite algo para pesquisar."));
    }
    if (results.isEmpty) {
      return const Center(child: Text("Nenhum pet encontrado."));
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: results.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.60,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final pet = results[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PetPerfilPage(pet: pet)),
            );
          },
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 280),
            // CORREÇÃO: Passando o objeto 'pet' diretamente,
            // pois seu PetCard espera o objeto completo.
            child: PetCard(
              pet: pet,
              onFavoriteToggle: () {
                // Para a atualização de estado funcionar, a pesquisa precisa
                // ser um StatefulWidget. Como SearchDelegate gerencia o estado,
                // a forma mais simples é forçar a reconstrução da UI.
                showSuggestions(context); 
                FavoritesService.toggleFavorite(pet);
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final lowerCaseQuery = query.toLowerCase();

    final results = allPets.where((pet) {
      final matchesName = pet.nome.toLowerCase().contains(lowerCaseQuery);
      final matchesRace = pet.raca.toLowerCase().contains(lowerCaseQuery);
      final matchesTags =
          pet.tags.any((tag) => tag.toLowerCase().contains(lowerCaseQuery));

      return matchesName || matchesRace || matchesTags;
    }).toList();

    return _buildResultsGrid(context, results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Reutiliza a mesma lógica de `buildResults` para mostrar resultados enquanto o usuário digita.
    return buildResults(context);
  }
}