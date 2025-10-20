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



// Importe o PetSearchDelegate se você já o criou.
// import 'seu_caminho/pet_search_delegate.dart'; 
// (Vou assumir que a lógica de showSearch será passada do HomePage)


// -------------------
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;
  // NOVO: Adiciona a função de callback para o botão de pesquisa
  final VoidCallback? onSearchPressed; 

  const AppHeader({
    super.key, 
    required this.title, 
    required this.scaffoldKey,
    // NOVO: Recebe a função de pesquisa
    this.onSearchPressed, 
  });

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
        // 1. PASSA o callback 'onSearchPressed' para o botão de pesquisa
        _roundIconButton(Icons.search, onPressed: onSearchPressed), 
        const SizedBox(width: 8),
        // O botão de notificação permanece inalterado
        _roundIconButton(Icons.notifications_none),
        const SizedBox(width: 8),
      ],
    );
  } 

  // 2. MODIFICA o _roundIconButton para aceitar um onPressed
  Widget _roundIconButton(IconData icon, {VoidCallback? onPressed}) {
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
        icon: Icon(icon, size: 20, color: Colors.black87),
        // 3. USA a função onPressed. Se for nula, usa a função vazia.
        onPressed: onPressed ?? () {}, 
        splashRadius: 20,
      ),
    );
  }

  // A linha corrigida para preferredSize
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
