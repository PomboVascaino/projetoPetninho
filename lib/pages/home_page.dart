// lib/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:teste_app/Models/pets_model.dart';
import 'package:teste_app/pages/favoritos_pages.dart';
import 'package:teste_app/pages/registro_pet_page.dart' hide MenuDrawer;
import '../components/header.dart';
import '../components/bottom_menu.dart';
import '../components/pet_catalog.dart';
import '../components/categories.dart';
import '../components/location_widget.dart';
import '../components/menu_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // A lista de pets agora é a fonte única da verdade.
  final List<Pet> _pets = allPets; // Usando a lista global do pet_catalog.dart

  static const int _kMenuSize = 5;
  int _selectedIndex = 0;
  int _selectedCategory = 0;
  String _locationText = "Vila Romana - São Paulo";

  void _onItemTapped(int index) {
    if (index == 3) { // Índice de Favoritos
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FavoritosPage(allPets: _pets),
        ),
      // --- ESTA É A CORREÇÃO PRINCIPAL ---
      // Ao voltar da FavoritosPage, o .then() será executado.
      // O setState() força a HomePage a se reconstruir, lendo
      // novamente o estado de favorito de cada pet.
      ).then((_) => setState(() {})); 
    } else if (index >= 0 && index < _kMenuSize) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _adicionarPet(Pet pet) {
    setState(() {
      _pets.add(pet);
    });
  }

  void _navegarParaRegistro() {
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.pop(context);
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegistroPetPage(
          onPetRegistered: _adicionarPet,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  Future<void> _editLocation() async {
    // ... (seu código de editar localização continua igual)
    final controller = TextEditingController(text: _locationText);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar localização'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
    if (result != null && result.trim().isNotEmpty) {
      setState(() {
        _locationText = result.trim();
      });
    }
  }

  Widget _buildBody(int index) {
    if (index == 0) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CategoriesBar(
              initialIndex: _selectedCategory,
              onChanged: (i) => setState(() => _selectedCategory = i),
            ),
            const SizedBox(height: 12),
            LocationWidget(locationText: _locationText, onTap: _editLocation),
            const SizedBox(height: 12),
            Expanded(
              child: PetCatalog(
                pets: _pets,
                // Passa a função que força a reconstrução para o PetCatalog
                onNavigate: () => setState(() {}),
              ),
            ),
          ],
        ),
      );
    }

    final menuItems = ["Loja", "Chat", "Favoritos", "Perfil"];
    final title = menuItems[index - 1];

    return Center(
      child: Text(
        'Esta é a tela de $title',
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppHeader(title: "Adoção de Pets", scaffoldKey: _scaffoldKey),
      drawer: MenuDrawer(
        onNavigateToRegister: _navegarParaRegistro,
        currentRoute: '/',
      ),
      body: _buildBody(_selectedIndex),
      bottomNavigationBar: BottomMenu(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        forceAllOff: false,
      ),
    );
  }
}