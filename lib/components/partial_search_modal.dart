// lib/components/partial_search_modal.dart

import 'package:flutter/material.dart';
import 'package:teste_app/Models/pets_model.dart'; 
import 'package:teste_app/pages/pet_perfil_page.dart'; 
// import de PetCard não é necessário aqui, pois só listamos sugestões

// A lista de dados (VOCÊ DEVE MANTER ESTA LISTA DE FORA DA CLASSE, 
// como está no seu código original PetSearchDelegate.dart, 
// para ser acessível, ou movê-la para um repositório centralizado).
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
  ),
  Pet(
    nome: "Thor",
    imagens: ['https://images.dog.ceo/breeds/husky/n02110185_1469.jpg'],
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
    imagens: ['https://images.dog.ceo/breeds/akita/Akita_inu_blanc.jpg'],
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
  // ... adicione todos os seus pets aqui
];

// O Novo Widget que será o conteúdo do modal
class PartialSearchModal extends StatefulWidget {
  const PartialSearchModal({super.key});

  @override
  State<PartialSearchModal> createState() => _PartialSearchModalState();
}

class _PartialSearchModalState extends State<PartialSearchModal> {
  String query = '';
  final TextEditingController _controller = TextEditingController();

  // Função para filtrar pets (reutilizando a lógica anterior)
  List<Pet> _filterPets(String currentQuery) {
    final lowerCaseQuery = currentQuery.toLowerCase();
    
    return allPets.where((pet) {
      final matchesName = pet.nome.toLowerCase().contains(lowerCaseQuery);
      final matchesRace = pet.raca.toLowerCase().contains(lowerCaseQuery);
      return matchesName || matchesRace;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final suggestions = _filterPets(query);

    return Container(
      // CRUCIAL: Define o fundo como branco para não ter problemas de transparência
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          // 1. Barra de Pesquisa Customizada (Substituindo o AppBar do Delegate)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                // Botão de Fechar (equivalente ao buildLeading)
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                // Campo de Texto de Pesquisa
                Expanded(
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Pesquisar nome, raça...',
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    style: const TextStyle(color: Colors.black87, fontSize: 16),
                    onChanged: (value) {
                      setState(() {
                        query = value;
                      });
                    },
                  ),
                ),
                // Botão de Limpar (equivalente ao buildActions)
                IconButton(
                  icon: const Icon(Icons.clear, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      query = '';
                      _controller.clear();
                    });
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Colors.grey),

          // 2. Lista de Sugestões com a Foto (equivalente ao buildSuggestions)
          Expanded(
            child: ListView.builder(
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final pet = suggestions[index];
                return ListTile(
                  // ALTERAÇÃO DA FOTO APLICADA
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(pet.imagens.isNotEmpty ? pet.imagens.first : ''),
                    radius: 20, 
                  ),
                  title: Text('${pet.nome} - ${pet.raca}'),
                  onTap: () {
                    // Navega para a página de perfil e fecha o modal
                    Navigator.of(context).pop(); // Fecha o modal de pesquisa
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PetPerfilPage(pet: pet)),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}