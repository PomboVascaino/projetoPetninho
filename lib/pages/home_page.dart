import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/bottom_menu.dart';
import '../components/pet_catalog.dart';
import '../components/categories.dart';
import '../components/location_widget.dart'; // se AppDrawer estiver separado

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
  int _selectedIndex = 0;
  int _selectedCategory = 0;
  String _locationText = "Vila Romana - São Paulo";

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppHeader(title: "Adoção de Pets", scaffoldKey: _scaffoldKey),
      drawer: const AppDrawer(),
      body: Padding(
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
      ),
      bottomNavigationBar: BottomMenu(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
