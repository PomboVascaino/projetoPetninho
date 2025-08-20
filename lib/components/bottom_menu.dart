// lib/components/bottom_menu.dart
import 'package:flutter/material.dart';

class BottomMenu extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color? selectedColor;
  final Color? unselectedColor;

  /// Componente BottomMenu com estilização padrão do app.
  /// - currentIndex: índice selecionado
  /// - onTap: callback quando o usuário tocar em um item
  /// - selectedColor / unselectedColor: opcionais para sobrescrever cores
  const BottomMenu({  
    Key? key,
    required this.currentIndex,
    required this.onTap,
    this.selectedColor,
    this.unselectedColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accent = selectedColor ?? const Color(0xFF3FBFAD);
    final unselected = unselectedColor ?? const Color.fromARGB(255, 158, 158, 158);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: accent,
      unselectedItemColor: unselected,
      showUnselectedLabels: true,
      elevation: 8,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Início"),
        BottomNavigationBarItem(icon: Icon(Icons.storefront_outlined), label: "Loja"),
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: "Chat"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "Favoritos"),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Perfil"),
      ],
    );
  }
}
