import 'package:flutter/material.dart';

// =======================================================
// Header do app
// =======================================================

// A classe HomePage abaixo é apenas um exemplo de uso.
class HomePage extends StatelessWidget {
  // 🚨 CORREÇÃO 1: Removido o 'const' da inicialização da GlobalKey,
  // que causava erro de sintaxe 'final GlobalKey = const GlobalKey()'.
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
  final GlobalKey<ScaffoldState> scaffoldKey;

  const AppHeader({super.key, required this.title, required this.scaffoldKey});

  static const double _preferredHeight = 125.0;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: _preferredHeight,
      // Fundo sempre branco (importante!)
      backgroundColor: Colors.white,
      elevation: 0,

      // ✅ Solução para o header transparente ao rolar
      scrolledUnderElevation: 0,

      leading: IconButton(
        icon: const Icon(Icons.menu, size: 28, color: Colors.black),
        onPressed: () {
          // Abre o drawer associado ao ScaffoldKey
          scaffoldKey.currentState?.openDrawer();
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
        color: const Color(0xFFb3e0db),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: IconButton(
        // 🚨 CORREÇÃO 2: Removido o 'const' daqui.
        // A variável 'icon' não é constante, então o Widget não pode ser 'const'.
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
