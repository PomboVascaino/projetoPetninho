import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const AppHeader({super.key, required this.title});

  // altura reduzida agora que as categorias foram removidas
  static const double _preferredHeight = 125.0;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        top: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 0.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu, size: 28),
                onPressed: () {},
              ),
              Expanded(
                child: Center(
                  child: Image.network(
                    'https://i.imgur.com/AYEweBY.png',
                    height: 125, // aumente/reduza se quiser
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Row(
                children: [
                  _roundIconButton(Icons.search),
                  const SizedBox(width: 8),
                  _roundIconButton(Icons.notifications_none),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _roundIconButton(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: IconButton(
        icon: Icon(icon, size: 20),
        onPressed: () {},
        splashRadius: 20,
        color: Colors.black87,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(_preferredHeight);
}
