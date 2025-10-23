import 'package:flutter/material.dart';
// Certifique-se de importar o modelo Pet e a lista de pets, se necessário
import 'package:teste_app/Models/pets_model.dart'; 
import 'package:teste_app/pages/pet_perfil_page.dart'; // Para navegar para o perfil
import 'package:teste_app/components/pet_card.dart'; // Para exibir o PetCard
// Você pode precisar do FavoritesService se o PetCard usar.
// import '../services/favorites_service.dart'; 

// A lista de dados duplicada do seu PetCatalog.
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


class PetSearchDelegate extends SearchDelegate<String> {
  
  // MÉTODO appBarTheme - MANTIDO INTACTO
@override
ThemeData appBarTheme(BuildContext context) {
  final ThemeData theme = Theme.of(context);

  // Retorna um novo ThemeData modificado
  return theme.copyWith(
    // CRUCIAL: Força o fundo da tela de pesquisa a ser branco (Scaffold)
    scaffoldBackgroundColor: Colors.white,

    // 1. Customização do AppBar (Header da Pesquisa)
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black), // Ícones pretos
    ),
    
    // 2. Customização do Campo de Input
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(
        color: Colors.grey, 
        fontSize: 16,
      ),
      border: InputBorder.none, 
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
    ),

    // 3. Customização do Texto Digitado e Cursor
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

  // 1. Configura o texto de dica da barra - MANTIDO INTACTO
  @override
  String get searchFieldLabel => 'Pesquisar nome, raça, tags...';
  
  // 2. Ações à direita da barra (ex: botão de limpar) - MANTIDO INTACTO
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          // Limpa o texto da pesquisa
          query = ''; 
          // Reconstroi a tela com o texto limpo
          showSuggestions(context); 
        },
      )
    ];
  }

  // 3. Ações à esquerda da barra (ex: botão de voltar) - MANTIDO INTACTO
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        // Fecha a pesquisa
        close(context, ''); 
      },
    );
  }

  // 4. Constrói os resultados da pesquisa - MANTIDO INTACTO
  @override
  Widget buildResults(BuildContext context) {
    // Transforma o texto da pesquisa em letras minúsculas para comparação
    final lowerCaseQuery = query.toLowerCase();

    // Filtra a lista de pets
    final results = allPets.where((pet) {
      // Verifica o nome, raça e tags (ajuste conforme o que você deseja pesquisar)
      final matchesName = pet.nome.toLowerCase().contains(lowerCaseQuery);
      final matchesRace = pet.raca.toLowerCase().contains(lowerCaseQuery);
      final matchesTags = pet.tags.any((tag) => tag.toLowerCase().contains(lowerCaseQuery));
      
      return matchesName || matchesRace || matchesTags;
    }).toList();

    // Exibe os resultados em uma lista ou GridView
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
            // Navega para a página de perfil
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PetPerfilPage(pet: pet)),
            );
          },
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 280),
            // Reutiliza seu PetCard para mostrar o resultado
            child: PetCard(
              pet: pet,
              // Adapte o PetCard para a tela de pesquisa, se precisar de lógica de favoritos
              onFavoriteToggle: () { /* Lógica de favoritos */ }, 
            ),
          ),
        );
      },
    );
  }

  // 5. Constrói as sugestões (opcional, mas bom para histórico ou dicas)
  @override
  Widget buildSuggestions(BuildContext context) {
    // Exibe os resultados conforme o usuário digita (o mesmo que buildResults)
    // Ou exibe uma lista de pesquisas recentes/sugestões populares.
    
    // Por simplicidade, vamos usar o mesmo filtro (apenas Nome e Raça para sugestão):
    final lowerCaseQuery = query.toLowerCase();

    final suggestions = allPets.where((pet) {
      final matchesName = pet.nome.toLowerCase().contains(lowerCaseQuery);
      final matchesRace = pet.raca.toLowerCase().contains(lowerCaseQuery);
      return matchesName || matchesRace;
    }).toList();

    return Theme(
      // Mantém a customização de splash/highlight discreta
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final pet = suggestions[index];
          return ListTile(
            // **********************************************
            // >>> FOTO QUADRADA <<<
            // **********************************************
            leading: ClipRRect(
              // Define o raio dos cantos (8.0 é um bom padrão)
              borderRadius: BorderRadius.circular(8.0),
              child: Image(
                // Tenta carregar a primeira imagem do pet
                image: NetworkImage(pet.imagens.isNotEmpty ? pet.imagens.first : ''),
                width: 40,  // Tamanho da largura
                height: 40, // Tamanho da altura (para ser um quadrado)
                fit: BoxFit.cover, // Garante que a imagem preencha o espaço sem distorção
                errorBuilder: (context, error, stackTrace) {
                  // Fallback para quando a imagem não carrega
                  return Container(
                    width: 40,
                    height: 40,
                    color: Colors.grey[200],
                    child: const Icon(Icons.pets, color: Colors.grey),
                  );
                },
              ),
            ),
            
            title: Text('${pet.nome} - ${pet.raca}'),
            onTap: () {
              // *******************************************************************
              // >>> ALTERAÇÃO SOLICITADA: NAVEGAÇÃO DIRETA PARA O PERFIL DO PET <<<
              // *******************************************************************
              
              // 1. Fecha a pesquisa
              // close(context, null) é melhor do que close(context, pet.nome) quando você não precisa retornar um valor.
              close(context, ''); 
              
              // 2. Navega diretamente para a página do perfil do pet
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PetPerfilPage(pet: pet)),
              );
            },
          );
        },
      ),
    );
  }
} 