class Pet {
  late String nome;
  late List<String> imagens;
  late String sexo;
  late String raca;
  late int idade;
  late List<String> tags;
  late String descricao;
  late String bairro;
  late String cidade;
  late String telefone;

  Pet({
    required this.nome,
    required this.imagens,
    required this.sexo,
    required this.raca,
    required this.idade,
    required this.tags,
    required this.descricao,
    required this.bairro,
    required this.cidade,
    required this.telefone,
  });

  Pet.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    imagens = json['imagem'].cast<String>();
    sexo = json['sexo'];
    raca = json['raca'];
    idade = json['idade'];
    tags = json['tags'].cast<String>();
    descricao = json['descricao'];
    bairro = json['bairro'];
    cidade = json['cidade'];
    telefone = json['telefone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nome'] = nome;
    data['imagem'] = imagens;
    data['sexo'] = sexo;
    data['raca'] = raca;
    data['idade'] = idade;
    data['tags'] = tags;
    data['descricao'] = descricao;
    data['bairro'] = bairro;
    data['cidade'] = cidade;
    data['telefone'] = telefone;
    return data;
  }
}
