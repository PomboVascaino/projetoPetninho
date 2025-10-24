// lib/pages/pet_perfil_page.dart

import 'package:flutter/material.dart';
import 'package:teste_app/Models/pets_model.dart';
import 'package:teste_app/components/menu_drawer.dart';
import 'package:teste_app/components/pet_catalog.dart';
import 'package:teste_app/pages/favoritos_pages.dart';
// <-- IMPORTAÇÃO NECESSÁRIA
import '../components/header.dart';
import '../components/bottom_menu.dart';
import '../services/favorites_service.dart';
import '../components/partial_search_modal.dart' hide allPets; 

class PetPerfilPage extends StatefulWidget {
  final Pet pet;

  const PetPerfilPage({super.key, required this.pet});

  @override
  State<PetPerfilPage> createState() => _PetPerfilPageState();
}

class _PetPerfilPageState extends State<PetPerfilPage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _buildTag(String text) {
    const Color tagColor = Color(0xFFb3e0db);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      decoration: BoxDecoration(
        color: tagColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFb3e0db), width: 1),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _abrirModalImagem(String imageUrl) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.85),
      useSafeArea: true,
      builder: (BuildContext context) {
        return Center(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: Hero(
                  tag: imageUrl,
                  child: InteractiveViewer(
                    maxScale: 4.0,
                    child: Image.network(imageUrl, fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppHeader(title: "Detalhes do Pet", scaffoldKey: _scaffoldKey),
      drawer:  MenuDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 300,
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: widget.pet.imagens.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final imageUrl = widget.pet.imagens[index];
                          return GestureDetector(
                            onTap: () => _abrirModalImagem(imageUrl),
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 400),
                              opacity: _currentPage == index ? 1.0 : 0.6,
                              child: Hero(
                                tag: imageUrl,
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(imageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(widget.pet.imagens.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == index ? 22 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? const Color(0xFFB6B2E1)
                              : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.pet.nome,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              widget.pet.sexo == 'm'
                                  ? Icons.male
                                  : Icons.female,
                              color: widget.pet.sexo == 'm'
                                  ? Colors.blueAccent
                                  : Colors.pinkAccent,
                              size: 22,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: const [
                            Text(
                              'Anunciado há 1 dia',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Spacer(),
                            Icon(
                              Icons.location_on,
                              color: Colors.grey,
                              size: 16,
                            ),
                            Text(
                              '3.0 km',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            widget.pet.descricao,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(16),
                                backgroundColor: const Color(0xFFB6B2E1),
                                elevation: 0,
                              ),
                              child: const Icon(
                                Icons.phone,
                                color: Colors.white,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(16),
                                backgroundColor: const Color(0xFFB6B2E1),
                                elevation: 0,
                              ),
                              child: const Icon(
                                Icons.chat,
                                color: Colors.white,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.pets, color: Colors.white),
                              label: const Text(
                                'Quero adotar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFB6B2E1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 18,
                    right: 12,
                    child: ValueListenableBuilder<List<Pet>>(
                      valueListenable: FavoritesService.favorites,
                      builder: (context, favorites, _) {
                        final isFavorite = FavoritesService.isFavorite(
                          widget.pet,
                        );
                        return IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            // setState é necessário aqui para reconstruir este widget específico
                            setState(() {
                              FavoritesService.toggleFavorite(widget.pet);
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Características',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: widget.pet.tags
                          .map((tag) => _buildTag(tag))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: BottomMenu(
        currentIndex: -1,
        onTap: (index) {
          switch (index) {
            case 0: // Início
              Navigator.pop(context);
              break;
            case 3: // Favoritos
              // --- CORREÇÃO APLICADA AQUI ---
              // Usamos a lista `allPets` importada do pet_catalog.dart
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritosPage(allPets: allPets),
                ),
              );
              break;
          }
        },
        forceAllOff: false,
      ),
    );
  }
}
