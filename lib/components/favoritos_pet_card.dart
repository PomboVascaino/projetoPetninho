import 'package:flutter/material.dart';

/// Widget de cartão reutilizável para exibir informações de um pet favorito.
/// Pode ser usado em diversas telas (ex: lista de favoritos, adoção, busca, etc.).
class FavoritePetCard extends StatefulWidget {
  // Dados básicos do pet
  final String nome; // Nome do pet
  final String cidade; // Cidade onde o pet está
  final String idade; // Idade do pet
  final String imagem; // URL da imagem do pet
  final String sexo; // Sexo do pet (M ou F)

  // Funções de callback para interações
  final VoidCallback?
  onFavoritoTap; // Função chamada ao tocar no botão de favorito
  final VoidCallback? onTap; // Função chamada ao tocar no card inteiro

  // Opções de personalização
  final bool initiallyFavorite; // Define se o pet já começa como favorito
  final bool showFavoriteButton; // Define se o botão de favorito será mostrado
  final double imageWidth; // Largura da imagem
  final double imageHeight; // Altura da imagem
  final double borderRadius; // Arredondamento dos cantos
  final double elevation; // Elevação (sombra) do card

  /// Construtor com parâmetros nomeados e valores padrão para personalização
  const FavoritePetCard({
    Key? key,
    required this.nome,
    required this.cidade,
    required this.idade,
    required this.imagem,
    required this.sexo,
    this.onFavoritoTap,
    this.onTap,
    this.initiallyFavorite = true,
    this.showFavoriteButton = true,
    this.imageWidth = 110,
    this.imageHeight = 110,
    this.borderRadius = 16,
    this.elevation = 4,
  }) : super(key: key);

  @override
  State<FavoritePetCard> createState() => _FavoritePetCardState();
}

/// Estado do widget FavoritePetCard.
/// Responsável por controlar a animação e o estado do botão de favorito.
class _FavoritePetCardState extends State<FavoritePetCard>
    with SingleTickerProviderStateMixin {
  // Controle se o pet está favoritado ou não
  late bool _isFavorite;

  // Controladores de animação para o botão de coração
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;

  // Cor de destaque usada no fundo do card
  static const Color _accentColor = Color(0xFFB3E0DB);

  @override
  void initState() {
    super.initState();

    // Define se o pet começa favoritado ou não
    _isFavorite = widget.initiallyFavorite;

    // Cria o controlador da animação com duração de 180ms
    _controller = AnimationController(
      vsync: this, // Necessário para controlar o ciclo de animação
      duration: const Duration(milliseconds: 180),
    );

    // Define uma animação de "pulsar" (escala de 1.0 para 1.25)
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 1.25,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    // Libera o controlador da animação quando o widget for destruído
    _controller.dispose();
    super.dispose();
  }

  /// Função chamada ao clicar no botão de favorito (ícone de coração)
  void _handleFavoriteTap() {
    // Inverte o estado atual (favorito ↔ não favorito)
    setState(() => _isFavorite = !_isFavorite);

    // Executa a animação: aumenta e volta
    _controller.forward().then((_) => _controller.reverse());

    // Chama o callback externo se existir
    widget.onFavoritoTap?.call();
  }

  /// Constrói a imagem do pet com tratamento para carregamento e erros.
  Widget _buildImage() {
    return ClipRRect(
      // Arredonda apenas os cantos do lado esquerdo
      borderRadius: BorderRadius.horizontal(
        left: Radius.circular(widget.borderRadius),
      ),
      child: SizedBox(
        width: widget.imageWidth,
        height: widget.imageHeight,
        child: Image.network(
          widget.imagem, // Carrega a imagem via URL
          fit: BoxFit.cover, // Cobre todo o espaço do contêiner
          // Enquanto carrega, mostra um indicador de progresso
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null)
              return child; // Quando terminar, mostra a imagem
            return Container(
              color: Colors.grey[300],
              child: const Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          },

          // Caso haja erro ao carregar a imagem, mostra um ícone substituto
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[300],
            child: const Center(
              child: Icon(Icons.pets, size: 36, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define ícone e cor conforme o sexo do pet
    final sexIcon = widget.sexo.toUpperCase() == 'F'
        ? Icons.female
        : Icons.male;
    final sexColor = widget.sexo.toUpperCase() == 'F'
        ? Colors.pinkAccent
        : Colors.blueAccent;

    return Semantics(
      // Acessibilidade: descrição lida por leitores de tela
      label:
          'Cartão do pet ${widget.nome}, ${widget.idade}, localizado em ${widget.cidade}',
      button: true, // Indica que o componente é interativo
      child: GestureDetector(
        // Permite que o card inteiro seja clicável
        onTap: widget.onTap,
        child: Card(
          margin: const EdgeInsets.symmetric(
            vertical: 8,
          ), // Espaçamento vertical entre cards
          elevation: widget.elevation, // Sombra do card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: Container(
            decoration: BoxDecoration(
              // Gradiente de fundo sutil (branco → verde-claro)
              gradient: LinearGradient(
                colors: [Colors.white, _accentColor.withOpacity(0.45)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            child: Row(
              children: [
                // Imagem do pet no lado esquerdo
                _buildImage(),

                // Parte direita com informações do pet
                Expanded(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ), // Espaçamento interno
                    // Título (nome + ícone de gênero)
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.nome,
                            overflow:
                                TextOverflow.ellipsis, // Corta nomes longos
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          sexIcon,
                          color: sexColor,
                          size: 18,
                        ), // Ícone de gênero
                      ],
                    ),

                    // Subtítulo (cidade e idade)
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          widget.cidade,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.idade,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    // Ícone de coração (botão de favorito)
                    trailing: widget.showFavoriteButton
                        ? ScaleTransition(
                            // Aplica a animação de zoom no ícone
                            scale: _scaleAnim,
                            child: IconButton(
                              tooltip: _isFavorite
                                  ? 'Remover dos favoritos'
                                  : 'Adicionar aos favoritos', // Texto do tooltip
                              icon: Icon(
                                _isFavorite
                                    ? Icons.favorite
                                    : Icons
                                          .favorite_border, // Ícone cheio ou vazio
                                color: Colors.red,
                                size: 26,
                              ),
                              onPressed:
                                  _handleFavoriteTap, // Chama a função de alternar favorito
                            ),
                          )
                        : null, // Se showFavoriteButton = false, não mostra o botão
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
