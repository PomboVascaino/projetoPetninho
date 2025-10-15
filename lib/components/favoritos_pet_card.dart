import 'package:flutter/material.dart';

// Widget que representa um cartão de pet favorito (com nome, idade, cidade, imagem, sexo, etc.)
class FavoritePetCard extends StatefulWidget {
  final String nome;
  final String cidade;
  final String idade;
  final String imagem;
  final String sexo;

  final VoidCallback? onFavoritoTap;
  final VoidCallback? onTap;

  final bool initiallyFavorite;
  final bool showFavoriteButton;
  final double imageWidth;
  final double imageHeight;
  final double borderRadius;
  final double elevation;

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
    this.borderRadius = 18,
    this.elevation = 3,
  }) : super(key: key);

  @override
  State<FavoritePetCard> createState() => _FavoritePetCardState();
}

class _FavoritePetCardState extends State<FavoritePetCard>
    with SingleTickerProviderStateMixin {
  late bool _isFavorite;
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.initiallyFavorite;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.98,
      upperBound: 1.0,
    );

    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleFavoriteTap() {
    setState(() => _isFavorite = !_isFavorite);
    widget.onFavoritoTap?.call();
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.horizontal(
        left: Radius.circular(widget.borderRadius),
      ),
      child: SizedBox(
        width: widget.imageWidth,
        height: widget.imageHeight,
        child: Image.network(
          widget.imagem,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return Container(
              color: Colors.grey[200],
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
          errorBuilder: (_, __, ___) => Container(
            color: Colors.grey[300],
            child: const Icon(Icons.pets, size: 40, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sexIcon = widget.sexo.toUpperCase() == 'F'
        ? Icons.female
        : Icons.male;
    final sexColor = widget.sexo.toUpperCase() == 'F'
        ? Colors.pinkAccent
        : Colors.blueAccent;

    final theme = Theme.of(context);

    return ScaleTransition(
      scale: _scaleAnim,
      child: GestureDetector(
        onTapDown: (_) => _controller.reverse(),
        onTapUp: (_) {
          _controller.forward();
          widget.onTap?.call();
        },
        onTapCancel: () => _controller.forward(),
        child: Card(
          elevation: widget.elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // fundo branco
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            child: Row(
              children: [
                _buildImage(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                widget.nome,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87, // texto escuro
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(sexIcon, color: sexColor, size: 19),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.cidade,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          widget.idade,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.showFavoriteButton)
                  IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.redAccent,
                      size: 26,
                    ),
                    onPressed: _handleFavoriteTap,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
