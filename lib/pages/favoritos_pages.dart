// lib/pages/favoritos_page.dart

import 'package:flutter/material.dart';
import 'package:teste_app/Models/pets_model.dart';
import 'package:teste_app/pages/pet_perfil_page.dart'; // ✅ 1. Importe a página de perfil do pet.
import '../services/favorites_service.dart';
import '../components/header.dart' hide HomePage;
import '../components/bottom_menu.dart';
import 'home_page.dart';
import '../components/favorite_list_item.dart';
import '../components/menu_drawer.dart';

class FavoritosPage extends StatelessWidget {
  const FavoritosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    const int _selectedIndex = 3; // Índice de "Favoritos" no menu

    void _onItemTapped(int index) {
      if (index == 0) {
        // Se tocar em "Início", volta para a HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
      // Outros itens do menu podem ser tratados aqui se necessário.
    }

    void _removerFavorito(Pet pet, BuildContext context) {
      // Usamos o método unificado toggleFavorite
      FavoritesService.toggleFavorite(pet);

      // Mostra uma confirmação na tela
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFB3E0DB),
          content: Text('${pet.nome} removido dos favoritos'),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppHeader(title: "Meus Favoritos", scaffoldKey: _scaffoldKey),
      drawer: const MenuDrawer(),
      // 2. Usamos o ValueListenableBuilder para ouvir as mudanças no FavoritesService
      body: ValueListenableBuilder<List<Pet>>(
        valueListenable: FavoritesService.favorites,
        builder: (context, favoritos, _) {
          // Se a lista de favoritos estiver vazia, mostramos a mensagem.
          if (favoritos.isEmpty) {
            return const Center(
              child: Text(
                "Nenhum favorito no momento 😢",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            );
          }

          // Se houver favoritos, construímos a lista.
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: favoritos.length,
            itemBuilder: (context, index) {
              final pet = favoritos[index];

              return Dismissible(
                key: ValueKey(pet.nome), // Chave única para o item
                direction: DismissDirection.endToStart,
                onDismissed: (_) => _removerFavorito(pet, context),
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.delete, color: Colors.red, size: 28),
                ),
                child: FavoriteListItem(
                  pet: pet,
                  onFavoriteTap: () => _removerFavorito(pet, context),
                  onTap: () {
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
