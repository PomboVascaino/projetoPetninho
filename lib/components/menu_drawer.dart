// lib/components/menu_drawer.dart

import 'package:flutter/material.dart';
import 'package:teste_app/utils/app_routes.dart';
import '../pages/chat_page.dart';

// lib/components/menu_drawer.dart
// (Manter todas as importações e o restante da classe MenuDrawer intactos)

// ... (seus imports e as outras partes da classe MenuDrawer)

class MenuDrawer extends StatelessWidget {
  final String? currentRoute;

  const MenuDrawer({super.key, this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const SizedBox(height: 60),

          _buildSectionTitle('Opções'),
          _buildMenuItem(
            context: context,
            icon: Icons.pets,
            text: 'Pets',
            route: AppRoutes.home,
            onTap: () {
              if (currentRoute != AppRoutes.home) {
                Navigator.pop(context); // Fecha o drawer
                // Exemplo: Navigator.pushReplacementNamed(context, AppRoutes.home);
                // ou Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
              } else {
                Navigator.pop(context); // Apenas fecha o drawer
              }
            },
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.smart_toy_outlined,
            text: 'Bidu Assistente',
            route: AppRoutes.chat,
            onTap: () {
              if (currentRoute != AppRoutes.chat) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatPage()),
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.volunteer_activism_outlined,
            text: 'Ongs',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.sentiment_very_dissatisfied_outlined,
            text: 'Perdi um pet',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.search,
            text: 'Encontrei um pet',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.favorite_border,
            text: 'Namoro Pet',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.health_and_safety_outlined,
            text: 'Dicas e cuidados',
            onTap: () {
              Navigator.pop(context);
            },
          ),

          const SizedBox(height: 20),
          _buildSectionTitle('Ajuda'),
          _buildMenuItem(
            context: context,
            icon: Icons.call_outlined,
            text: 'Entre em contato',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.quiz_outlined,
            text: 'Perguntas Frequentes',
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
    );
  }

  // ==============  MÉTODO MODIFICADO (nova versão mais moderna)  ==============
  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    String? route, // Parâmetro de rota opcional
  }) {
    final bool isSelected = (currentRoute != null && currentRoute == route);
    const Color themeColor = Color(0xFFb3e0db); // Sua cor tema
    const Color textColor = Colors.black87; // Cor padrão do texto
    const Color selectedTextColor =
        Colors.white; // Cor do texto quando selecionado
    const Color iconColor = Colors.black54; // Cor padrão do ícone
    // Cor do ícone quando selecionado

    return Container(
      // Container para o fundo do item selecionado
      decoration: BoxDecoration(
        color: isSelected
            ? themeColor
            : Colors.transparent, // Fundo com a cor do tema
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      margin: const EdgeInsets.only(
        right: 16,
      ), // Margem para dar o efeito de canto arredondado
      child: ListTile(
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: isSelected
              ? Colors.white
              : Colors.grey[100], // Fundo do círculo do ícone
          child: Icon(
            icon,
            color: isSelected ? themeColor : iconColor,
            size: 22,
          ), // Cor do ícone
        ),
        title: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? selectedTextColor : textColor, // Cor do texto
            // Remove o sublinhado
            decoration: TextDecoration.none,
          ),
        ),
        // REMOVIDO: Remove a seta
        // trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
