// lib/components/menu_drawer.dart

import 'package:flutter/material.dart';
import 'package:teste_app/pages/contatos.dart';
import 'package:teste_app/pages/ongs_page.dart';
import 'package:teste_app/pages/perguntas_page.dart';
import 'package:teste_app/utils/app_routes.dart';
import '../pages/chat_page.dart';
import '../pages/home_page.dart';

class MenuDrawer extends StatelessWidget {
  final String? currentRoute;
  final VoidCallback? onNavigateToRegister;

  // ✨ A CORREÇÃO PRINCIPAL ESTÁ AQUI: REMOVIDO O 'const' ✨
  MenuDrawer({super.key, this.currentRoute, this.onNavigateToRegister});

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
            icon: Icons.add_circle_outline,
            text: 'Registro Pet',
            onTap: onNavigateToRegister ?? () {},
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.pets,
            text: 'Pets',
            route: AppRoutes.home,
            onTap: () {
              if (currentRoute != AppRoutes.home) {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              } else {
                Navigator.pop(context);
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
            route: AppRoutes.ongs,
            onTap: () {
              if (currentRoute != AppRoutes.ongs) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OngsPage()),
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.sentiment_very_dissatisfied_outlined,
            text: 'Perdi um pet',
            onTap: () => Navigator.pop(context),
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.search,
            text: 'Encontrei um pet',
            onTap: () => Navigator.pop(context),
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.favorite_border,
            text: 'Namoro Pet',
            onTap: () => Navigator.pop(context),
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.health_and_safety_outlined,
            text: 'Dicas e cuidados',
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(height: 20),
          _buildSectionTitle('Ajuda'),
          _buildMenuItem(
            context: context,
            icon: Icons.call_outlined,
            text: 'Entre em contato',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PaginaContato()),
              );
            },
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.quiz_outlined,
            text: 'Perguntas Frequentes',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaginaPerguntas(),
                ),
              );
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

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    String? route,
  }) {
    final bool isSelected = (currentRoute != null && currentRoute == route);
    const Color themeColor = Color(0xFFb3e0db);
    const Color textColor = Colors.black87;
    const Color selectedTextColor = Colors.black87;
    const Color iconColor = Colors.black54;

    return Container(
      decoration: BoxDecoration(
        color: isSelected ? themeColor : Colors.transparent,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      margin: const EdgeInsets.only(right: 16),
      child: ListTile(
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: isSelected ? Colors.white : Colors.grey[100],
          child: Icon(
            icon,
            color: isSelected ? themeColor : iconColor,
            size: 22,
          ),
        ),
        title: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? selectedTextColor : textColor,
            decoration: TextDecoration.none,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}