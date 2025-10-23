import 'package:flutter/material.dart';

// Componente que simula visualmente o widget VLibras flutuante e arrastável.
class LibrasOverlayRobot extends StatelessWidget {
  final String currentText;
  final VoidCallback onClose;
  final Function(DragUpdateDetails)? onDragUpdate; // Propriedade não utilizada aqui, mas exigida pelo GestureDetector na HomePage

  const LibrasOverlayRobot({
    super.key,
    required this.currentText,
    required this.onClose,
    this.onDragUpdate, 
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 240, // Largura fixa para o robô/painel
        height: 120, // Altura fixa para o robô/painel
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: const Color(0xFF3FBFAD), width: 3),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho do Robô (Área de Arraste e Botão Fechar)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    // Ícone que representa o avatar/personagem
                    Icon(Icons.person_pin, color: Colors.redAccent, size: 24),
                    SizedBox(width: 4),
                    Text(
                      "VLibras",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                // Botão Fechar
                GestureDetector(
                  onTap: onClose,
                  child: const Icon(Icons.close, color: Colors.grey, size: 18),
                ),
              ],
            ),
            const Divider(height: 8),

            // Área de Texto (Onde o texto para tradução é exibido)
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  currentText.isEmpty
                      ? "Toque e segure em um texto (por exemplo, no card do pet) para o robô iniciar a tradução em Libras!"
                      : currentText,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                  overflow: TextOverflow.clip,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
