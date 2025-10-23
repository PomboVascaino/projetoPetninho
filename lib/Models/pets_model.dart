// lib/models/pets_model.dart

class Pet {
  final String nome;
  final List<String> imagens;
  final String sexo;
  final String raca;
  final String idade; // Mantido como String
  final List<String> tags;
  final String descricao;
  final String bairro;
  final String cidade;
  final String telefone;
  final String? ong;
  final bool encontrado;
  bool isFavorite;

  Pet({
    required this.nome,
    this.imagens = const [],
    required this.sexo,
    required this.raca,
    required this.idade, // Espera uma String
    this.tags = const [],
    this.descricao = '',
    required this.bairro,
    required this.cidade,
    this.telefone = '',
    this.ong,
    this.encontrado = false,
    this.isFavorite = false,
  });

  String get imagemPrincipal {
    if (imagens.isNotEmpty && imagens.first.isNotEmpty) {
      return imagens.first;
    }
    return 'https://i.imgur.com/8f9f8f9.png'; // Placeholder
  }

  // --- CORREÇÃO AQUI ---
  // A idade já é uma string formatada, então apenas retornamos ela.
  String get idadeFormatada => idade;

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      nome: json['nome'] ?? '?',
      imagens: List<String>.from(json['imagens'] ?? []),
      sexo: json['sexo'] ?? 'n/a',
      raca: json['raca'] ?? 'SRD',
      idade: json['idade'] ?? 'Não informada', // Corrigido para String
      tags: List<String>.from(json['tags'] ?? []),
      descricao: json['descricao'] ?? '',
      bairro: json['bairro'] ?? '?',
      cidade: json['cidade'] ?? '?',
      telefone: json['telefone'] ?? '',
      ong: json['ong'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'imagens': imagens,
      'sexo': sexo,
      'raca': raca,
      'idade': idade,
      'tags': tags,
      'descricao': descricao,
      'bairro': bairro,
      'cidade': cidade,
      'telefone': telefone,
      'ong': ong,
    };
  }
}
