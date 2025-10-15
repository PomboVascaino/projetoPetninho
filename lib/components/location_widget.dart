// lib/components/location_widget.dart
import 'package:flutter/material.dart';

class LocationWidget extends StatelessWidget {
  /// Texto exibido ao lado do ícone (ex: "Vila Romana - São Paulo")
  final String locationText;

  /// Callback opcional ao tocar no widget (por ex. abrir seleção de local)
  final VoidCallback? onTap;

  /// Se quiser esconder o título "Localização" (opcional)
  final bool showLabel;

  const LocationWidget({
    Key? key,
    required this.locationText,
    this.onTap,
    this.showLabel = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // cores idênticas ao seu código original
    final labelColor = Colors.grey[600];
    final iconColor = Colors.grey[700];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
            child: Text("Localização", style: TextStyle(color: labelColor)),
          ),

        // Linha clicável com ícone e texto
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Icon(Icons.location_on, color: iconColor, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    locationText,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                // pequeno chevron para indicar ação opcional
                if (onTap != null)
                  const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
