import 'package:flutter/material.dart';
import 'package:teste_app/Models/pets_model.dart';
import 'package:teste_app/pages/pet_perfil_page.dart'; 
import '../services/favorites_service.dart';
import '../components/header.dart' hide HomePage;
import '../components/bottom_menu.dart';
import 'home_page.dart';
import '../components/favorite_list_item.dart';
import '../components/menu_drawer.dart';
import 'package:teste_app/pages/home_page.dart';
import 'package:teste_app/pages/favoritos_pages.dart';

class FavoritosPage extends StatefulWidget {
  // 1. Adicionado para receber a lista de todos os pets
  final List<Pet> allPets;

  // 2. Construtor atualizado para exigir a lista
  const FavoritosPage({super.key, required this.allPets});

  @override
  State<FavoritosPage> createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // 3. Filtra a lista para pegar apenas os pets favoritados
    final List<Pet> favoritePets = widget.allPets
        .where((pet) => FavoritesService.isFavorite(pet))
        .toList();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppHeader(title: "Meus Favoritos", scaffoldKey: _scaffoldKey),
      drawer: const MenuDrawer(),
      backgroundColor: Colors.white,
      body: favoritePets.isEmpty
          ? const Center(
              child: Text(
                'Você ainda não favoritou nenhum pet. 😕',
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: favoritePets.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.60,
              ),
              itemBuilder: (context, index) {
                final pet = favoritePets[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PetPerfilPage(pet: pet),
                      ),
                    ).then((_) => setState(() {})); // Atualiza a tela ao voltar
                  },
                  child: PetCard(
                    pet: pet,
                    onFavoriteToggle: () {
                      // Ao desfavoritar, a tela é reconstruída e o pet some da lista
                      setState(() {
                        FavoritesService.toggleFavorite(pet);
                      });
                    },
                  ),
                );
              },
            ),
    );
  }
}
