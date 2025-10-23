// lib/data/pet_repository.dart

import 'package:teste_app/Models/pets_model.dart'; 
// OBS: Ajuste o caminho acima se seu Models/pets_model.dart estiver em outro lugar.

class PetRepository {
  // Lista de pets CENTRALIZADA (fonte de dados única)
  static final List<Pet> _allPets = [
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

  // Método estático para que qualquer parte do app (PetCatalog ou SearchDelegate) 
  // possa acessar a lista
  static List<Pet> getPets() {
    return _allPets;
  }
}