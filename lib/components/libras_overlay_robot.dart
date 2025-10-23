// lib/components/audio_overlay_robot.dart (NOVO ARQUIVO: Focado em TTS/Áudio)

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart'; 

// O arraste (onDragUpdate) foi removido do construtor, pois não é necessário em um AlertDialog.

class AudioOverlayRobot extends StatefulWidget {
  final String currentText; // O texto que o robô deve "ler"
  final VoidCallback onClose; // Função para fechar o pop-up

  // Removido o onDragUpdate, pois não vamos arrastar o AlertDialog
  const AudioOverlayRobot({
    super.key,
    required this.currentText,
    required this.onClose, required Null Function(dynamic _) onDragUpdate,
  });

  @override
  State<AudioOverlayRobot> createState() => _AudioOverlayRobotState();
}

class _AudioOverlayRobotState extends State<AudioOverlayRobot> {
  final FlutterTts flutterTts = FlutterTts();

  // Variável de controle do TTS para evitar que ele fale o mesmo texto repetidamente
  String _lastSpokenText = "";

  @override
  void initState() {
    super.initState();
    _initializeTts();
    // Inicia a leitura do texto atual
    _speakCurrentText(widget.currentText);
  }

  @override
  void didUpdateWidget(covariant AudioOverlayRobot oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Lê o novo texto apenas se ele for diferente do anterior
    if (oldWidget.currentText != widget.currentText) {
      _speakCurrentText(widget.currentText);
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  void _initializeTts() {
    flutterTts.setLanguage("pt-BR");
    flutterTts.setPitch(1.0);
    flutterTts.setSpeechRate(0.5);
  }

  Future<void> _speakCurrentText(String text) async {
    final String defaultMessage = 'Pressione e segure o dedo sobre um elemento ou card para ativar a leitura.';
    
    // Evita ler o texto se já foi lido ou se é a mensagem padrão de instrução
    if (text.isNotEmpty && text != defaultMessage && text != _lastSpokenText) { 
      await flutterTts.stop(); 
      await flutterTts.speak(text); 
      _lastSpokenText = text; // Atualiza o último texto falado
    }
  }
  
  // -----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // Cores focadas na acessibilidade visual (turquesa)
    const Color primaryColor = Color(0xFF3FBFAD); 
    const Color boxColor = Color(0xFFF0FDF8); 
    
    final String defaultMessage = 'Pressione e segure o dedo sobre um elemento ou card para ativar a leitura.';
    final bool isReading = widget.currentText.isNotEmpty && widget.currentText != defaultMessage;

    final displayMessage = isReading 
        ? widget.currentText // Exibe o texto completo
        : defaultMessage; // Mensagem de instrução
        
    final iconColor = isReading ? Colors.redAccent : primaryColor;

    return Container(
      // Reduz a largura para caber melhor no AlertDialog
      width: 250, 
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. HEADER (Título e Fechar)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Acessibilidade de Áudio (TTS)",
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  color: primaryColor,
                  fontSize: 14,
                ),
              ),
              GestureDetector(
                onTap: widget.onClose,
                child: const Icon(Icons.close, size: 16, color: Colors.grey),
              ),
            ],
          ),
          const Divider(height: 10, thickness: 1, color: primaryColor),
          
          // 2. CONTEÚDO PRINCIPAL (Avatar e Mensagem)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ÍCONE DO PERSONAGEM (Avatar)
              Padding(
                padding: const EdgeInsets.only(right: 12.0, top: 4),
                child: Icon(
                  // Ícone de áudio ou leitura
                  isReading ? Icons.volume_up : Icons.accessibility_new,
                  size: 35, 
                  color: iconColor,
                ),
              ),

              // Mensagem de Leitura
              Flexible( 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isReading ? 'LENDO:' : 'Modo Instrução',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      displayMessage,
                      style: const TextStyle(
                        fontSize: 13, 
                        color: Colors.black87,
                      ),
                      maxLines: isReading ? 5 : 3, 
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}