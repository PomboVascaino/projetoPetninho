import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/bottom_menu.dart';
import '../components/pet_catalog.dart';
import '../components/categories.dart';
import '../components/location_widget.dart';

class TestePage extends StatefulWidget {
  const TestePage({super.key});

  @override
  State<TestePage> createState() => _TestePageState();
}

class _TestePageState extends State<TestePage> {
  int _selectedIndex = 0; // bottom nav
  int _selectedCategory = 0; // categoria selecionada
  String _locationText = "Vila Romana - São Paulo";

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // lógica de navegação se quiser
    });
  }

  Future<void> _editLocation() async {
    final controller = TextEditingController(text: _locationText);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar localização'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Digite a nova localização'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: "Adoção de Pets"),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // categorias
            CategoriesBar(
              initialIndex: _selectedCategory,
              onChanged: (i) {
                setState(() {
                  _selectedCategory = i;
                  // se quiser, passe esse índice ao PetCatalog para filtrar
                });
              },
            ),

            const SizedBox(height: 12),

            // localização (agora acima dos cards)
            LocationWidget(
              locationText: _locationText,
              onTap: _editLocation, // opcional, abre diálogo de edição
            ),

            const SizedBox(height: 12),

            // grid de pets
            Expanded(
              child: PetCatalog(), // adapte PetCatalog para receber filtro se quiser
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomMenu(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
