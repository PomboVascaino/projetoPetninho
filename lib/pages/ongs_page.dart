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
import 'package:teste_app/components/bottom_menu.dart'; // Importação necessária

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
    final List<Map<String, dynamic>> ongsData = [
      {
        'id': '1',
        'name': 'Em prol do Amor',
        'logoUrl': 'https://i.imgur.com/U8A1B29.png',
        'headerImageUrl': 'https://i.imgur.com/8a1S6f8.jpeg',
        'color': 0xFFFBC02D,
        'pets': [
          {
            "name": "Theo 1",
            "gender": "m",
            "place": "Barra Funda - SP",
            "age": "8 meses",
            "tags": ["Brincalhão", "Dócil"],
            "img": "https://i.imgur.com/IyLen7R.png",
          },
          {
            "name": "Theo 2",
            "gender": "m",
            "place": "Barra Funda - SP",
            "age": "8 meses",
            "tags": ["Agitado", "Amoroso"],
            "img": "https://i.imgur.com/IyLen7R.png",
          },
          {
            "name": "Theo 3",
            "gender": "m",
            "place": "Barra Funda - SP",
            "age": "8 meses",
            "tags": ["Dócil", "Calmo"],
            "img": "https://i.imgur.com/IyLen7R.png",
          },
          {
            "name": "Theo 4",
            "gender": "m",
            "place": "Barra Funda - SP",
            "age": "9 meses",
            "tags": ["Energético"],
            "img": "https://i.imgur.com/IyLen7R.png",
          },
        ],
      },
      {
        'id': '2',
        'name': 'Porta da Rua',
        'logoUrl': 'https://i.imgur.com/T5Nocco.png',
        'headerImageUrl': 'https://i.imgur.com/r6d0g2e.jpeg',
        'color': 0xFF8D6E63,
        'pets': [
          {
            "name": "Crystal 1",
            "gender": "f",
            "place": "Cachoeirinha - SP",
            "age": "1 ano",
            "tags": ["Passeio", "Calma"],
            "img": "https://i.imgur.com/ZbttlFX.png",
          },
          {
            "name": "Crystal 2",
            "gender": "f",
            "place": "Cachoeirinha - SP",
            "age": "1 ano",
            "tags": ["Dócil", "Crianças"],
            "img": "https://i.imgur.com/ZbttlFX.png",
          },
          {
            "name": "Crystal 3",
            "gender": "f",
            "place": "Cachoeirinha - SP",
            "age": "1 ano",
            "tags": ["Castrada", "Vacinada"],
            "img": "https://i.imgur.com/ZbttlFX.png",
          },
        ],
      },
    ];

    _ongs = ongsData.map((ongData) {
      final List<dynamic> petsRaw = ongData['pets'] ?? [];
      final List<Pet> pets = petsRaw
          .map((petData) => _createPetFromData(petData))
          .toList();
      return Ong(
        id: ongData['id'] ?? '',
        name: ongData['name'] ?? 'ONG Desconhecida',
        logoUrl: ongData['logoUrl'] ?? '',
        headerImageUrl: ongData['headerImageUrl'] ?? '',
        color: Color(ongData['color'] ?? 0xFF9E9E9E),
        pets: pets,
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
          return _buildOngSection(ong);
        },
      ),
      // --- CÓDIGO DO BOTTOM MENU CORRIGIDO ---
      bottomNavigationBar: BottomMenu(
        currentIndex: -1, // Nenhum item está selecionado
        forceAllOff: true, // Garante que todos os ícones fiquem "apagados"
        onTap: (index) {
          // AÇÃO CORRETA: Apenas fecha a tela atual (OngsPage)
          // e volta para a tela anterior (HomePage).
          Navigator.pop(context);
        },
      ),
    );
  }

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

  Pet _createPetFromData(Map<String, dynamic> petData) {
    final List<String> imageUrls = [];
    if (petData['img'] != null &&
        petData['img'] is String &&
        (petData['img'] as String).isNotEmpty) {
      imageUrls.add(petData['img']);
    }
    return Pet(
      nome: petData['name'] ?? '?',
      imagens: imageUrls,
      sexo: petData['gender'] ?? 'n/a',
      raca: petData['raca'] ?? 'SRD',
      idade: _parseIdade(petData['age']),
      tags: List<String>.from(petData['tags'] ?? []),
      descricao: petData['descricao'] ?? '',
      bairro: _parseLocal(petData['place'])[0],
      cidade: _parseLocal(petData['place'])[1],
      telefone: petData['telefone'] ?? '',
    );
  }

  int _parseIdade(String? ageString) {
    if (ageString == null) return 0;
    final parts = ageString.split(' ');
    if (parts.length > 1 &&
        (parts[1].toLowerCase().contains('mes') ||
            parts[1].toLowerCase().contains('mês'))) {
      return 0;
    }
    return int.tryParse(parts[0]) ?? 0;
  }

  List<String> _parseLocal(String? placeString) {
    if (placeString == null) return ['?', '?'];
    final parts = placeString.split(' - ');
    if (parts.length == 2) return [parts[0].trim(), parts[1].trim()];
    return [placeString, '?'];
  }
}
