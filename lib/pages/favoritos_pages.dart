// lib/pages/favoritos_page.dart

import 'package:flutter/material.dart';
import 'package:teste_app/Models/pets_model.dart';
import 'package:teste_app/pages/pet_perfil_page.dart';
import '../services/favorites_service.dart';
import '../components/header.dart' hide HomePage;
import '../components/bottom_menu.dart';
import 'home_page.dart';
import '../components/favorite_list_item.dart'; // Agora será utilizado
import '../components/menu_drawer.dart';

class FavoritosPage extends StatefulWidget {
  final List<Pet> allPets;

  const FavoritosPage({super.key, required this.allPets});

  @override
  State<FavoritosPage> createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (Route<dynamic> route) => false,
      );
    } else if (index == 3) {
      // Já está na página de favoritos, não faz nada.
      return;
    } else {
      // Para outros itens, navega para a home que controlará a exibição
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Pet> favoritePets = widget.allPets
        .where((pet) => FavoritesService.isFavorite(pet))
        .toList();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppHeader(title: "Meus Favoritos", scaffoldKey: _scaffoldKey),
      drawer: MenuDrawer(),
      backgroundColor: Colors.white,
      body: favoritePets.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Você ainda não favoritou nenhum pet. 😕',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          // --- CORREÇÃO: Substituindo GridView por ListView ---
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: favoritePets.length,
              itemBuilder: (context, index) {
                final pet = favoritePets[index];
                
                // Usando o widget correto: FavoriteListItem
                return FavoriteListItem(
                  pet: pet,
                  // Ação ao tocar no card: ir para o perfil do pet
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PetPerfilPage(pet: pet),
                      ),
                      // Garante que a lista de favoritos seja atualizada se o usuário
                      // desfavoritar o pet na tela de perfil.
                    ).then((_) => setState(() {}));
                  },
                  // Ação ao tocar no coração: remover dos favoritos
                  onFavoriteTap: () {
                    setState(() {
                      FavoritesService.toggleFavorite(pet);
                    });
                  },
                );
              },
            ),
      bottomNavigationBar: BottomMenu(
        currentIndex: 3, // Mantém o ícone "Favoritos" selecionado
        onTap: _onItemTapped,
      ),
    );
  }
}