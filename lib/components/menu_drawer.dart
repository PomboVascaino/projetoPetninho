import 'package:flutter/material.dart';
import 'package:teste_app/pages/contatos.dart';
import 'package:teste_app/pages/perguntas_page.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

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
            icon: Icons.pets,
            text: 'Pets',
            onTap: () {
              Navigator.pop(context);
              // Exemplo: Navigator.push(... para PetsPage) caso exista
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

          const SizedBox(height: 20),
          _buildSectionTitle('Ajuda'),

          // Botão "Entre em contato" (já feito)
          _buildMenuItem(
            icon: Icons.call_outlined,
            text: 'Entre em contato',
            onTap: () {
              // 1. Fecha o menu lateral
              Navigator.pop(context);

              // 2. Navega para a Página de Contato
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PaginaContato()),
              );
            },
          ),

          // 2. ✅ MUDANÇA AQUI
          _buildMenuItem(
            icon: Icons.quiz_outlined,
            text: 'Perguntas Frequentes',
            onTap: () {
              // 1. Fecha o menu lateral
              Navigator.pop(context);

              // 2. Navega para a Página de Perguntas
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
