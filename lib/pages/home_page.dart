import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/bottom_menu.dart';
import '../components/pet_catalog.dart';
import '../components/categories.dart';
import '../components/location_widget.dart';

// Simulação de componentes que não foram fornecidos:
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    return const Drawer(child: Center(child: Text('Menu Lateral')));
  }
}

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

  // Definimos o número de itens fixos no menu inferior (5, de 0 a 4)
  static const int _kMenuSize = 5;

  int _selectedIndex = 0; // O índice 0 é a Home/Início
  int _selectedCategory = 0;
  String _locationText = "Vila Romana - São Paulo";

  void _onItemTapped(int index) {
    // Só permite a mudança se o índice estiver dentro do range do menu (0 a 4)
    if (index >= 0 && index < _kMenuSize) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // 💡 REMOVIDO: A função navigateToExternalPage não é mais necessária.

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

  // Função que constrói o corpo da tela com base no índice selecionado
  Widget _buildBody(int index) {
    // Conteúdo da Home (Início) - Índice 0
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
            Expanded(
              // 💡 CORREÇÃO APLICADA: O parâmetro onPetTap foi removido daqui.
              // A navegação agora é tratada internamente pelo PetCatalog.
              child: const PetCatalog(),
            ),
          ],
        ),
      );
    }

    // Conteúdo para telas que SÃO parte do menu (índices 1 a 4)
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

    // Fallback
    return const Center(
      child: Text('Página não encontrada', style: TextStyle(fontSize: 24)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // A navegação para PetPerfilPage usa Navigator.push, que empilha uma nova rota.
    // Isso garante que o BottomMenu da HomePage desapareça naturalmente quando a página de perfil é aberta.
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppHeader(title: "Adoção de Pets", scaffoldKey: _scaffoldKey),
      drawer: const AppDrawer(),
      body: _buildBody(_selectedIndex), // O corpo da tela muda com o índice

      bottomNavigationBar: BottomMenu(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        // forceAllOff não é mais necessário aqui, pois a navegação externa usa uma nova rota.
        forceAllOff: false,
      ),
    );
  }
}
