// lib/pages/ongs_page.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:teste_app/Models/ong_model.dart';
import 'package:teste_app/Models/pets_model.dart';
import 'package:teste_app/services/favorites_service.dart';
import 'package:teste_app/components/header.dart';
import 'package:teste_app/components/menu_drawer.dart';
import 'package:teste_app/components/pet_card.dart';
import 'package:teste_app/pages/ong_detail_page.dart';
import 'package:teste_app/utils/app_routes.dart';
import 'package:teste_app/components/bottom_menu.dart';
import 'package:teste_app/components/pet_catalog.dart'; // Importa para ter acesso à lista `allPets`

class OngsPage extends StatefulWidget {
  const OngsPage({super.key});

  @override
  State<OngsPage> createState() => _OngsPageState();
}

class _OngsPageState extends State<OngsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Ong> _ongs = [];

  @override
  void initState() {
    super.initState();
    _loadOngs();
  }

  void _loadOngs() {
    // Esta lista agora define APENAS as ONGs, sem os pets
    final List<Map<String, dynamic>> ongsMetadata = [
      {
        'id': '1',
        'name': 'Em prol do Amor',
        'logoUrl': 'https://i.imgur.com/U8A1B29.png',
        'headerImageUrl': 'https://i.imgur.com/8a1S6f8.jpeg',
        'color': 0xFFFBC02D,
      },
      {
        'id': '2',
        'name': 'Porta da Rua',
        'logoUrl': 'https://i.imgur.com/T5Nocco.png',
        'headerImageUrl': 'https://i.imgur.com/r6d0g2e.jpeg',
        'color': 0xFF8D6E63,
      },
    ];

    // Mapeia a metadata das ONGs e filtra os pets para cada uma
    _ongs = ongsMetadata.map((ongData) {
      // Filtra a lista global `allPets` para encontrar os pets desta ONG
      final List<Pet> ongPets = allPets
          .where((pet) => pet.ong == ongData['name'])
          .toList();

      return Ong(
        id: ongData['id'] ?? '',
        name: ongData['name'] ?? 'ONG Desconhecida',
        logoUrl: ongData['logoUrl'] ?? '',
        headerImageUrl: ongData['headerImageUrl'] ?? '',
        color: Color(ongData['color'] ?? 0xFF9E9E9E),
        pets: ongPets, // Atribui a lista de pets filtrada dinamicamente
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppHeader(title: "ONGs", scaffoldKey: _scaffoldKey),
      drawer: const MenuDrawer(currentRoute: AppRoutes.ongs),
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        itemCount: _ongs.length,
        itemBuilder: (context, index) {
          final ong = _ongs[index];
          // Se a ONG não tiver pets, não mostra a seção dela
          if (ong.pets.isEmpty) {
            return const SizedBox.shrink();
          }
          return _buildOngSection(ong);
        },
      ),
      bottomNavigationBar: BottomMenu(
        currentIndex: -1,
        forceAllOff: true,
        onTap: (index) {
          Navigator.pop(context);
        },
      ),
    );
  }

  // O resto do código (widgets de build, funções auxiliares) permanece o mesmo
  // pois já está preparado para receber os dados dinamicamente.

  Widget _buildOngSection(Ong ong) {
    final List<Pet> previewPets = ong.pets.take(3).toList();
    return Container(
      margin: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OngDetailPage(ong: ong),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: CachedNetworkImageProvider(
                      ong.logoUrl.isNotEmpty ? ong.logoUrl : 'INVALID_URL',
                    ),
                    onBackgroundImageError: (e, s) {},
                    child: ong.logoUrl.isEmpty
                        ? const Icon(
                            Icons.home_work_outlined,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      ong.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 290,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: previewPets.length,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemBuilder: (context, index) {
                final pet = previewPets[index];
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: PetCard(
                      pet: pet,
                      onFavoriteToggle: () =>
                          setState(() => FavoritesService.toggleFavorite(pet)),
                    ),
                  ),
                );
              },
            ),
          ),
          if (ong.pets.length > 3)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OngDetailPage(ong: ong),
                    ),
                  ),
                  child: Text(
                    "Ver mais",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
