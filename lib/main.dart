// lib/main.dart (Onde você inicializa seu app)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/vlibras_widget.dart' show LibrasOverlayRobot;
import 'pages/home_page.dart';
import 'utils/accessibility_manager.dart'; // 💡 Importe o seu Provider
import 'components/libras_overlay_robot.dart'; // 💡 Importe o robô

void main() {
  // 1. Injeta o Provider no topo da árvore
  runApp(
    ChangeNotifierProvider(
      create: (context) => AccessibilityManager(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Pet App',
      // ... outras configurações de tema
      home: GlobalLibrasWrapper(), // 2. Usa o Wrapper para envolver o robô
    );
  }
}

// Classe que garante que o robô flutue sobre todas as telas.
class GlobalLibrasWrapper extends StatelessWidget {
  const GlobalLibrasWrapper({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Escuta as mudanças no manager para saber se deve mostrar/mover o robô
    final manager = Provider.of<AccessibilityManager>(context); 
    
    // O Stack permite que o robô flutue sobre o conteúdo principal
    return Stack(
      children: [
        // O conteúdo principal da sua aplicação
        const HomePage(), 
        // 💡 Aqui você pode colocar outras telas que são a raiz da sua navegação
        
        // 3. O Robô de Libras, renderizado globalmente se ativo
        if (manager.isLibrasActive) 
          Positioned(
            top: manager.robotTop,
            left: manager.robotLeft,
            child: GestureDetector(
              onPanUpdate: (details) {
                // Chama a função de mover no Manager
                manager.updateRobotPosition(
                  details, 
                  MediaQuery.of(context).size.width, 
                  MediaQuery.of(context).size.height,
                );
              },
              child: LibrasOverlayRobot(
                currentText: manager.robotText, 
                onClose: manager.closeRobot,
                // Passa o onDragUpdate para o widget interno (se ele precisar)
                onDragUpdate: (details) {
                  manager.updateRobotPosition(
                    details, 
                    MediaQuery.of(context).size.width, 
                    MediaQuery.of(context).size.height,
                  );
                }, 
              ),
            ),
          ),
      ],
    );
  }
}