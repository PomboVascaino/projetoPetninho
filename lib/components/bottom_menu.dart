import 'package:flutter/material.dart';

class BottomMenu extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color? selectedColor;
  final Color? unselectedColor;

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
    final unselected = unselectedColor ?? const Color(0xFF9E9E9E);

    final items = [
      {"icon": Icons.home_outlined, "label": "Início"},
      {"icon": Icons.storefront_outlined, "label": "Loja"},
      {"icon": Icons.chat_bubble_outline, "label": "Chat"},
      {"icon": Icons.favorite_border, "label": "Favoritos"},
      {"icon": Icons.person_outline, "label": "Perfil"},
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 24),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isSelected = currentIndex == index;
          final color = isSelected ? accent : unselected;
          return GestureDetector(
            onTap: () => onTap(index),
            behavior: HitTestBehavior.translucent,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 250),
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedScale(
                    scale: isSelected ? 1.2 : 1.0, // dá zoom quando selecionado
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    child: Icon(
                      items[index]["icon"] as IconData,
                      color: color,
                      size: isSelected ? 28 : 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    items[index]["label"] as String,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
