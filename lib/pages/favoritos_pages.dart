// lib/pages/favoritos_page.dart

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
  const FavoritosPage({Key? key}) : super(key: key);

  @override
  State<FavoritosPage> createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 3;
  late List<Pet> _favoritos;

  @override
  void initState() {
    super.initState();
    _favoritos = FavoritesService.favorites;
  }

  void _removerFavorito(Pet pet) {
    setState(() {
      FavoritesService.remove(pet);
      _favoritos = FavoritesService.favorites;
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFFB3E0DB),
        content: Text('${pet.nome} removido dos favoritos'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppHeader(title: "Meus Favoritos", scaffoldKey: _scaffoldKey),
      drawer: const MenuDrawer(),
      body: _favoritos.isEmpty
          ? const Center(
              child: Text(
                "Nenhum favorito no momento 😢",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _favoritos.length,
              itemBuilder: (context, index) {
                final pet = _favoritos[index];

                return Dismissible(
                  key: ValueKey(pet.nome),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => _removerFavorito(pet),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 28,
                    ),
                  ),
                  child: FavoriteListItem(
                    pet: pet,
                    onFavoriteTap: () => _removerFavorito(pet),
                    // ✅ 2. Adicionamos o novo parâmetro 'onTap' ao nosso widget.
                    onTap: () {
                      // E definimos a ação de navegar para a PetPerfilPage.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PetPerfilPage(pet: pet),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomMenu(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        forceAllOff: false,
      ),
    );
  }
}
