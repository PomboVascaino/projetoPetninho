import 'package:flutter/material.dart';
import 'package:teste_app/components/partial_search_modal.dart.dart';
import 'package:teste_app/pages/favoritos_pages.dart';
import '../components/header.dart';
import '../components/bottom_menu.dart';
import '../components/pet_catalog.dart';
import '../components/categories.dart';
import '../components/location_widget.dart';
import '../components/menu_drawer.dart';
// 1. IMPORT NECESSÁRIO: Certifique-se de que o caminho está correto!
import '../components/partial_search_modal.dart.dart'; 

// =========================
// HomePage
// =========================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Número de itens fixos no menu inferior (0 a 4)
  static const int _kMenuSize = 5;

  int _selectedIndex = 0; // O índice 0 é a Home/Início
  int _selectedCategory = 0;
  String _locationText = "Vila Romana - São Paulo";

  // Função para alterar o índice do menu inferior
  void _onItemTapped(int index) {
    if (index >= 0 && index < _kMenuSize) {
      if (index == 3) {
        // ✅ Se o usuário clicar em "Favoritos" (índice 3), abre FavoritosPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const FavoritosPage()),
        );
      } else {
        // Atualiza o índice para os outros botões
        setState(() {
          _selectedIndex = index;
        });
      }
    }
  }

  Future<void> _editLocation() async {
    final controller = TextEditingController(text: _locationText);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar localização'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Digite a nova localização',
          ),
        ),
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
              onChanged: (i) {
                setState(() {
                  _selectedCategory = i;
                });
              },
            ),
            const SizedBox(height: 12),
            LocationWidget(locationText: _locationText, onTap: _editLocation),
            const SizedBox(height: 12),
            Expanded(child: PetCatalog()),
          ],
        ),
      );
    }

    if (index > 0 && index < _kMenuSize) {
      final menuItems = ["Loja", "Chat", "Favoritos", "Perfil"];
      final title = menuItems[index - 1];

      return Center(
        child: Text(
          'Esta é a tela de $title',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      );
    }

    return const Center(
      child: Text('Página não encontrada', style: TextStyle(fontSize: 24)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      // 2. ADIÇÃO NECESSÁRIA: Passando a ação para o botão de pesquisa no Header
      appBar: AppHeader(
        title: "Adoção de Pets",
        scaffoldKey: _scaffoldKey,
        onSearchPressed: () {
          // Ação ao clicar no botão de pesquisa redondo
          showSearch(
            context: context,
            // A classe PetSearchDelegate deve estar definida e acessível.
            delegate: PetSearchDelegate(), 
          );
        },
      ),
      drawer: const MenuDrawer(),
      body: _buildBody(_selectedIndex),
      bottomNavigationBar: BottomMenu(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        forceAllOff: false,
      ),
    );
  }
}