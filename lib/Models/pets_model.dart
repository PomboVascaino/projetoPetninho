// lib/models/pets_model.dart

class Pet {
  final String nome;
  final List<String> imagens;
  final String sexo;
  final String raca;
  final int idade;
  final List<String> tags;
  final String descricao;
  final String bairro;
  final String cidade;
  final String telefone;
  final String? ong; // Campo da ONG
  bool isFavorite;

  Pet({
    required this.nome,
    this.imagens = const [],
    required this.sexo,
    required this.raca,
    required this.idade,
    this.tags = const [],
    this.descricao = '',
    required this.bairro,
    required this.cidade,
    this.telefone = '',
    this.ong, // <-- Implementado no construtor
    this.isFavorite = false,
  });

  // Métodos de ajuda para formatação, mantidos para consistência
  String get imagemPrincipal {
    if (imagens.isNotEmpty && imagens.first.isNotEmpty) {
      return imagens.first;
    }
    return 'https://i.imgur.com/8f9f8f9.png'; // Placeholder
  }

  String get idadeFormatada {
    if (idade < 1) return "Menos de 1 ano";
    if (idade == 1) return "1 ano";
    return "$idade anos";
  }

  // Métodos fromJson e toJson atualizados
  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      nome: json['nome'] ?? '?',
      imagens: List<String>.from(json['imagens'] ?? []),
      sexo: json['sexo'] ?? 'n/a',
      raca: json['raca'] ?? 'SRD',
      idade: json['idade'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
      descricao: json['descricao'] ?? '',
      bairro: json['bairro'] ?? '?',
      cidade: json['cidade'] ?? '?',
      telefone: json['telefone'] ?? '',
      ong: json['ong'], // <-- Implementado no fromJson
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
      'ong': ong, // <-- Implementado no toJson
    };
  }
}
