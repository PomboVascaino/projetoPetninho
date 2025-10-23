import 'package:flutter/material.dart';
import 'package:teste_app/components/partial_search_delegate.dart.dart';
import 'package:teste_app/pages/favoritos_pages.dart';
import '../components/header.dart';
import '../components/bottom_menu.dart';
import '../components/pet_catalog.dart';
import '../components/categories.dart';
import '../components/location_widget.dart';
import '../components/menu_drawer.dart';
// 1. IMPORT NECESSÁRIO: Certifique-se de que o caminho está correto!
import '../components/partial_search_delegate.dart.dart'; 
import '../components/libras_overlay_robot.dart'; 


class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Center(
          child: Image.asset(
            "assets/logo.png", // coloque o logo "petninho" aqui
            height: 40,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Perfil",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Dados do usuário
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person, color: Colors.black),
              ),
              title: const Text("Gustavo Zazu"),
              subtitle: const Text("guh.zazu@gmail.com"),
              onTap: () {},
            ),
            const SizedBox(height: 10),

            // Lista de opções
            _buildMenuItem(Icons.credit_card, "Meus Dados", () {}),
            _buildMenuItem(Icons.favorite, "Minhas Adoções", () {}),
            _buildMenuItem(Icons.shopping_bag, "Minhas Compras", () {}),
            _buildMenuItem(Icons.location_on, "Endereços", () {}),
            _buildMenuItem(Icons.payment, "Meus Cartões", () {}),
            _buildMenuItem(Icons.notifications, "Notificações", () {}),

            const Spacer(),

            // Botão sair
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.black26),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                ),
                child: const Text(
                  "Sair",
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        backgroundColor: const Color(0xFFD2F1EB), // verde claro do Figma
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Início"),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: "Loja"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favoritos"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),
    );
  }

  // Widget para cada item do menu
  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.black),
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
        const Divider(height: 1),
      ],
    );
  }
}
