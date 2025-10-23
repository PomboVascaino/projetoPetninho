// lib/utils/accessibility_manager.dart

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

// Esta classe gerencia todos os estados de acessibilidade da aplicação (TTS e Libras).
class AccessibilityManager extends ChangeNotifier {
  final FlutterTts _flutterTts = FlutterTts();

  // 🎙️ Estado de Áudio (TTS)
  bool _isAudioActive = true; 
  // 🤟 Estado de Libras (Robô)
  bool _isLibrasActive = false; 
  String _robotText = "";
  
  // Posição do robô (o GlobalLibrasWrapper usará isso)
  double _robotTop = 220.0; 
  double _robotLeft = 10.0;

  // GETTERS (para que outras classes possam LER os estados)
  bool get isAudioActive => _isAudioActive;
  bool get isLibrasActive => _isLibrasActive;
  String get robotText => _robotText;
  double get robotTop => _robotTop;
  double get robotLeft => _robotLeft;

  AccessibilityManager() {
    _initializeTts();
  }
  
  void _initializeTts() {
    _flutterTts.setLanguage("pt-BR");
    _flutterTts.setPitch(1.0);
    _flutterTts.setSpeechRate(0.5);
  }

  // Ações de TTS (Usada pelo Home/Favoritos/etc para falar)
  Future<void> speak(String text) async {
    if (!_isAudioActive) return;
    await _flutterTts.stop();
    await _flutterTts.speak(text);
  }

  // Ações do Modo Áudio (Chamada pelo botão FAB na HomePage)
  void toggleAudioMode(BuildContext context) {
    _isAudioActive = !_isAudioActive;
    
    final message = _isAudioActive 
        ? 'Modo de Áudio Ativado. O aplicativo falará a navegação.' 
        : 'Modo de Áudio Desativado.';
    
    // Este modo DEVE falar
    if (_isAudioActive) {
        speak(message);
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(milliseconds: 1500)),
    );
    notifyListeners();
  }
  
  // Ações do Modo Libras (Chamada pelo botão FAB na HomePage)
  void toggleLibrasMode(BuildContext context) {
    _isLibrasActive = !_isLibrasActive;
    _robotText = ""; // Limpa o texto ao desativar/ativar
    
    final message = _isLibrasActive 
        ? 'Modo Libras Ativado! Pressione e Segure em um texto para traduzir.' 
        : 'Modo Libras Desativado.';
    
    // 🛑 CORREÇÃO APLICADA: Remoção completa da chamada `speak()`.
    // A ativação/desativação do Robô de Libras é agora completamente silenciosa.
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(milliseconds: 1500)),
    );
    notifyListeners();
  }

  // Altera o texto de tradução (Chamada pelo LongPress nos cards de pets)
  void updateRobotText(String text) {
    if (_isLibrasActive && _robotText != text) {
      _robotText = text;
      notifyListeners();
    }
  }

  // Fecha o robô (Chamada pelo X do robô e na navegação de páginas)
  void closeRobot() {
    _isLibrasActive = false;
    _robotText = "";
    notifyListeners();
  }

  // Atualiza a posição do robô quando arrastado (Chamada pelo GlobalLibrasWrapper)
  void updateRobotPosition(DragUpdateDetails details, double screenWidth, double screenHeight) {
    final newLeft = _robotLeft + details.delta.dx;
    final newTop = _robotTop + details.delta.dy;

    // 250 é a largura aproximada, 150 é a altura aproximada
    _robotLeft = newLeft.clamp(0.0, screenWidth - 250); 
    _robotTop = newTop.clamp(0.0, screenHeight - 150); 
    notifyListeners();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }
}