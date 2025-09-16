import 'package:flutter/material.dart';

// =======================================================
// Header do app
// =======================================================
class HomePage extends StatelessWidget {
  HomePage({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      appBar: AppHeader(
        title: "Petninho",
        scaffoldKey: _scaffoldKey, // passa a chave aqui
      ),
      body: const Center(child: Text("Conteúdo da página")),
    );
  }
}

// -------------------
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey; // chave obrigatória agora

  const AppHeader({super.key, required this.title, required this.scaffoldKey});

  static const double _preferredHeight = 125.0;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: _preferredHeight,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, size: 28, color: Colors.black),
        onPressed: () {
          scaffoldKey.currentState?.openDrawer(); // abre o drawer da página
        },
      ),
      title: Image.network(
        'https://i.imgur.com/AYEweBY.png',
        height: 125,
        fit: BoxFit.contain,
      ),
      centerTitle: true,
      actions: [
        _roundIconButton(Icons.search),
        const SizedBox(width: 8),
        _roundIconButton(Icons.notifications_none),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _roundIconButton(IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFFb3e0db),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 20, color: Colors.black87),
        onPressed: () {},
        splashRadius: 20,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(_preferredHeight);
}

// =======================================================
// Drawer do app
// =======================================================
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Drawer(child: MenuScreen());
  }
}

// =======================================================
// Conteúdo do menu (antigo MenuScreen)
// =======================================================
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuOptions = [
      {'title': 'Pets', 'icon': Icons.pets, 'onTap': () => debugPrint('Pets')},
      {
        'title': 'Bidu Assistente',
        'icon': Icons.support_agent,
        'onTap': () => debugPrint('Bidu Assistente'),
      },
      {
        'title': 'Ongs',
        'icon': Icons.home_work_outlined,
        'onTap': () => debugPrint('Ongs'),
      },
      {
        'title': 'Perdi um pet',
        'icon': Icons.search_off,
        'onTap': () => debugPrint('Perdi um pet'),
      },
      {
        'title': 'Encontrei um pet',
        'icon': Icons.search,
        'onTap': () => debugPrint('Encontrei um pet'),
      },
      {
        'title': 'Namoro Pet',
        'icon': Icons.favorite_outline,
        'onTap': () => debugPrint('Namoro Pet'),
      },
      {
        'title': 'Dicas e cuidados',
        'icon': Icons.tips_and_updates_outlined,
        'onTap': () => debugPrint('Dicas e cuidados'),
      },
    ];

    final List<Map<String, dynamic>> helpOptions = [
      {
        'title': 'Entre em contato',
        'icon': Icons.phone,
        'onTap': () => debugPrint('Entre em contato'),
      },
      {
        'title': 'Perguntas Frequentes',
        'icon': Icons.help_outline,
        'onTap': () => debugPrint('Perguntas Frequentes'),
      },
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Opções',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...menuOptions.map((item) => MenuTile(item: item)).toList(),
            const SizedBox(height: 16),
            const Text(
              'Ajuda',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...helpOptions.map((item) => MenuTile(item: item)).toList(),
          ],
        ),
      ),
    );
  }
}

// =======================================================
// Item do menu (tile)
// =======================================================
class MenuTile extends StatelessWidget {
  final Map<String, dynamic> item;
  const MenuTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(item['icon'], color: Colors.black87),
      title: Text(item['title'], style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.chevron_right),
      onTap: item['onTap'],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
    );
  }
}

// =======================================================
// Página inicial (exemplo de uso)
// =======================================================
