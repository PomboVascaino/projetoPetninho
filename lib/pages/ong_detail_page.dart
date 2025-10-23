// lib/pages/ong_detail_page.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:teste_app/Models/ong_model.dart';
import 'package:teste_app/services/favorites_service.dart';
import 'package:teste_app/components/pet_card.dart';

class OngDetailPage extends StatefulWidget {
  final Ong ong;

  const OngDetailPage({super.key, required this.ong});

  @override
  State<OngDetailPage> createState() => _OngDetailPageState();
}

class _OngDetailPageState extends State<OngDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // O novo cabeçalho personalizado
          SliverAppBar(
            expandedHeight: 240.0,
            pinned: true,
            backgroundColor: widget.ong.color,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.ong.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Imagem de capa
                  CachedNetworkImage(
                    imageUrl: widget.ong.headerImageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(color: widget.ong.color.withOpacity(0.5)),
                    errorWidget: (context, url, error) => Container(
                      color: widget.ong.color.withOpacity(0.8),
                      child: const Icon(Icons.error, color: Colors.white),
                    ),
                  ),
                  // Gradiente para escurecer a imagem e facilitar a leitura do título
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.0, 0.5),
                        end: Alignment(0.0, 0.0),
                        colors: <Color>[Color(0x60000000), Color(0x00000000)],
                      ),
                    ),
                  ),
                  // Logo da ONG posicionada
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: CircleAvatar(
                        radius: 42, // Raio maior
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: CachedNetworkImageProvider(
                            widget.ong.logoUrl,
                          ),
                          backgroundColor: Colors.grey[200],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Espaçamento entre o header e a grade de pets
          const SliverToBoxAdapter(
            child: SizedBox(height: 50), // Altura para compensar a logo
          ),

          // A grade com todos os pets da ONG
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                final pet = widget.ong.pets[index];
                return PetCard(
                  pet: pet,
                  onFavoriteToggle: () {
                    setState(() {
                      FavoritesService.toggleFavorite(pet);
                    });
                  },
                );
              }, childCount: widget.ong.pets.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.60,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
