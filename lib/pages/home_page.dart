import 'package:flutter/material.dart';
// NOVO: Importe o modelo e a página de registro
import 'package:teste_app/Models/pets_model.dart';
import 'package:teste_app/pages/registro_pet_page.dart';
import '../components/header.dart';
import '../components/bottom_menu.dart';
import '../components/pet_catalog.dart';
import '../components/categories.dart';
import '../components/location_widget.dart';
import '../components/menu_drawer.dart'; // Certifique-se que este import está correto

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

  // NOVO: A lista de pets agora vive aqui no estado da HomePage
  final List<Pet> _pets = [
    Pet(
      nome: "Theo",
      sexo: "Macho",
      bairro: "Barra Funda",
      cidade: "São Paulo",
      idade: "8 meses",
      tags: ["Gosta de brincar", "Dócil", "Agitado"],
      imagens: ["https://i.imgur.com/IyLen7R.png"],
      raca: 'SRD',
      descricao: 'Um pet muito amigável.',
      telefone: '99999-9999',
    ),
    Pet(
      nome: "Crystal",
      sexo: "Fêmea",
      bairro: "Cachoeirinha",
      cidade: "São Paulo",
      idade: "1 ano",
      tags: ["Gosta de passear", "Dócil", "Calma"],
      imagens: ["https://i.imgur.com/ZbttlFX.png"],
      raca: 'Shitzu',
      descricao: 'Uma pet muito dócil.',
      telefone: '99999-9999',
    ),
  ];

  static const int _kMenuSize = 5;
  int _selectedIndex = 0;
  int _selectedCategory = 0;
  String _locationText = "Vila Romana - São Paulo";

  void _onItemTapped(int index) {
    if (index >= 0 && index < _kMenuSize) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // NOVO: Função para adicionar um pet à lista e reconstruir a tela
  void _adicionarPet(Pet pet) {
    setState(() {
      _pets.add(pet);
    });
  }

  // NOVO: Função para navegar para a tela de registro
  void _navegarParaRegistro() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegistroPetPage(
          onPetRegistered: _adicionarPet, // Passa a função de adicionar
        ),
      ),
    );
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
              onChanged: (i) => setState(() => _selectedCategory = i),
            ),
            const SizedBox(height: 12),
            LocationWidget(locationText: _locationText, onTap: _editLocation),
            const SizedBox(height: 12),
            Expanded(
              // ALTERADO: Passa a lista de pets para o PetCatalog
              child: PetCatalog(pets: _pets),
            ),
          ],
        ),
      );
    }

    // ... resto do seu código _buildBody
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
      // Use o AppHeader (veja exemplo abaixo) - passe a scaffoldKey para que o botão abra o drawer
      appBar: AppHeader(title: "Adoção de Pets", scaffoldKey: _scaffoldKey),
      drawer: const MenuDrawer(), // <-- aqui está o novo menu lateral integrado
      body: _buildBody(_selectedIndex),
      bottomNavigationBar: BottomMenu(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        forceAllOff: false,
      ),
    );
  }
}
