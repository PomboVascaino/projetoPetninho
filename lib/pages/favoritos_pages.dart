import 'package:flutter/material.dart';
import '../components/favoritos_pet_card.dart'; // Card dos pets favoritos
import '../components/header.dart' hide HomePage; // Header (AppHeader)
import '../components/bottom_menu.dart'; // Footer (BottomMenu)
import 'home_page.dart'; // Importa a HomePage para navegação

// Drawer lateral (menu)
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: Center(
        child: Text('Menu Lateral'),
      ),
    );
  }
}

// Página de Favoritos
class FavoritosPage extends StatefulWidget {
  const FavoritosPage({Key? key}) : super(key: key);

  @override
  State<FavoritosPage> createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Índice do menu inferior (3 representa "Favoritos")
  int _selectedIndex = 3;

  // Lista de favoritos
  List<Map<String, dynamic>> favoritos = [
    {
      'nome': 'Crystal',
      'cidade': 'Cachoeirinha (SP)',
      'idade': '1 ano',
      'imagem': 'https://images.dog.ceo/breeds/hound-afghan/n02088094_1003.jpg',
      'sexo': 'F',
    },
    {
      'nome': 'Thor',
      'cidade': 'Porto Alegre (RS)',
      'idade': '2 anos',
      'imagem': 'https://images.dog.ceo/breeds/husky/n02110185_1469.jpg',
      'sexo': 'M',
    },
    {
      'nome': 'Maya',
      'cidade': 'Curitiba (PR)',
      'idade': '3 anos',
      'imagem': 'https://images.dog.ceo/breeds/beagle/n02088364_11136.jpg',
      'sexo': 'F',
    },
  ];

  // Função para remover um favorito
  void _removerFavorito(int index) {
    final removedItem = favoritos[index];
    favoritos.removeAt(index);

    _listKey.currentState?.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: FavoritePetCard(
          nome: removedItem['nome'],
          cidade: removedItem['cidade'],
          idade: removedItem['idade'],
          imagem: removedItem['imagem'],
          sexo: removedItem['sexo'],
        ),
      ),
      duration: const Duration(milliseconds: 400),
    );

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFFB3E0DB),
        content: Text('${removedItem['nome']} removido dos favoritos'),
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: Colors.red,
          onPressed: () {
            setState(() {
              favoritos.insert(index, removedItem);
              _listKey.currentState?.insertItem(index);
            });
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // 🔹 Quando um item do menu inferior for tocado
  void _onItemTapped(int index) {
    if (index == 0) {
      // ✅ Se o usuário tocar em "Home", volta para a HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      // Apenas atualiza o índice se for outro botão
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const corPrincipal = Color(0xFFB3E0DB);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],

      // HEADER (AppHeader)
      appBar: AppHeader(
        title: "Meus Favoritos",
        scaffoldKey: _scaffoldKey,
      ),

      // MENU LATERAL
      drawer: const AppDrawer(),

      // CORPO PRINCIPAL
      body: favoritos.isEmpty
          ? const Center(
              child: Text(
                "Nenhum favorito no momento 😢",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            )
          : AnimatedList(
              key: _listKey,
              initialItemCount: favoritos.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index, animation) {
                final pet = favoritos[index];
                return SizeTransition(
                  sizeFactor: animation,
                  child: Dismissible(
                    key: ValueKey(pet['nome'] + index.toString()),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => _removerFavorito(index),
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
                    child: FavoritePetCard(
                      nome: pet['nome'],
                      cidade: pet['cidade'],
                      idade: pet['idade'],
                      imagem: pet['imagem'],
                      sexo: pet['sexo'],
                      onFavoritoTap: () => _removerFavorito(index),
                    ),
                  ),
                );
              },
            ),

      // FOOTER (BottomMenu)
      bottomNavigationBar: BottomMenu(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        forceAllOff: false,
      ),
    );
  }
}
