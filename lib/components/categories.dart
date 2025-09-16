import 'package:flutter/material.dart';

class CategoriesBar extends StatefulWidget {
  final List<String> categories;
  final int initialIndex;
  final ValueChanged<int>? onChanged;

  const CategoriesBar({
    super.key,
    this.categories = const ["Todos", "Cachorros", "Gatos", "Peixes", "Aves"],
    this.initialIndex = 0,
    this.onChanged,
  });

  @override
  State<CategoriesBar> createState() => _CategoriesBarState();
}

class _CategoriesBarState extends State<CategoriesBar> {
  late int _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final primary = const Color(0xFFb3e0db);

    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.only(left: 12, right: 12),
        scrollDirection: Axis.horizontal,
        itemCount: widget.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final isSelected = i == _selected;
          return ChoiceChip(
            label: Text(
              widget.categories[i],
              style: const TextStyle(fontSize: 14),
            ),
            selected: isSelected,
            showCheckmark: false, // 🔥 remove o "Vzinho"
            selectedColor: primary,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: isSelected ? primary : const Color(0xFFEAEAEA),
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            onSelected: (_) {
              setState(() => _selected = i);
              if (widget.onChanged != null) widget.onChanged!(i);
            },
          );
        },
      ),
    );
  }
}
