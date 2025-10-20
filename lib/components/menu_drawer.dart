// lib/components/menu_drawer.dart

import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        // Remove o padding padrão do ListView
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Um cabeçalho simples, pode ser customizado depois
          const SizedBox(height: 60),

          // Seção "Opções"
          _buildSectionTitle('Opções'),
          _buildMenuItem(
            icon: Icons.pets,
            text: 'Pets',
            onTap: () {
              // TODO: Implementar navegação para a página de Pets
              Navigator.pop(context); // Fecha o drawer
            },
          ),
          _buildMenuItem(
            icon: Icons.smart_toy_outlined,
            text: 'Bidu Assistente',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          _buildMenuItem(
            icon: Icons.volunteer_activism_outlined,
            text: 'Ongs',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          _buildMenuItem(
            icon: Icons.sentiment_very_dissatisfied_outlined,
            text: 'Perdi um pet',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          _buildMenuItem(
            icon: Icons.search,
            text: 'Encontrei um pet',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          _buildMenuItem(
            icon: Icons.favorite_border,
            text: 'Namoro Pet',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          _buildMenuItem(
            icon: Icons.health_and_safety_outlined,
            text: 'Dicas e cuidados',
            onTap: () {
              Navigator.pop(context);
            },
          ),

          const SizedBox(height: 20), // Espaçamento entre as seções
          // Seção "Ajuda"
          _buildSectionTitle('Ajuda'),
          _buildMenuItem(
            icon: Icons.call_outlined,
            text: 'Entre em contato',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          _buildMenuItem(
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

  // Widget auxiliar para criar os títulos das seções
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

  // Widget auxiliar para criar cada item do menu, evitando repetição de código
  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.grey[100],
        child: Icon(icon, color: Colors.black54, size: 22),
      ),
      title: Text(text, style: const TextStyle(fontSize: 15)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
