// lib/pages/home_page.dart (CÓDIGO FINAL COM DOIS BOTÕES DE ACESSIBILIDADE: TTS E LIBRAS)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:teste_app/pages/favoritos_pages.dart';
import 'package:teste_app/pages/perfil_page.dart';
import '../components/partial_search_delegate.dart.dart' show PetSearchDelegate;
import '../utils/accessibility_manager.dart'; 

// Importações dos componentes
import '../components/header.dart';
import '../components/bottom_menu.dart';
import '../components/pet_search_delegate.dart'; 
import '../components/pet_catalog.dart';
import '../components/categories.dart';
import '../components/location_widget.dart';
import '../components/menu_drawer.dart';


// =========================
// HomePage
// =========================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  static const int _kMenuSize = 5;

  int _selectedIndex = 0;
  int _selectedCategory = 0;
  String _locationText = "Vila Romana - São Paulo";
  
  // Lista de categorias
  final List<String> _categoryNames = ["Gatos", "Cachorros", "Pássaros", "Roedores", "Peixes"];

  // Função para alterar o índice do menu inferior
  void _onItemTapped(int index) {
    final manager = context.read<AccessibilityManager>(); 
    final List<String> menuNames = ["Início", "Loja", "Chat", "Favoritos", "Perfil"];

    // 🛑 Parar a leitura TTS ao navegar
    if (manager.isAudioActive) {
      manager.speak(""); 
    }

    if (index >= 0 && index < _kMenuSize) {
      // 🤟 Fechar Robô de Libras em qualquer navegação que não seja Início
      if (index != 0 && manager.isLibrasActive) { 
        manager.closeRobot();
      }
      
      // 🗣️ Fala a ação APENAS se o modo de áudio estiver ATIVO
      if (manager.isAudioActive && index < menuNames.length) { 
        manager.speak("Você está navegando para ${menuNames[index]}");
      }
      
      if (index == 3) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const FavoritosPage()),
        );
      } else if (index == 4) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PerfilPage()),
        );
      } else {
        setState(() {
          _selectedIndex = index;
        });
      }
    }
  }

  Future<void> _editLocation() async {
    final controller = TextEditingController(text: _locationText);
    final manager = context.read<AccessibilityManager>();
    
    // A voz só é falada se o TTS estiver ativo
    if (manager.isAudioActive) {
      manager.speak("Abrindo modal para editar localização.");
    }

    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar localização'),
        content: Semantics(
          label: 'Campo de texto para digitar a nova localização',
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Digite a nova localização',
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (manager.isAudioActive) manager.speak('Localização cancelada.');
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (manager.isAudioActive) manager.speak('Localização salva com sucesso.');
              Navigator.of(ctx).pop(controller.text);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );

    if (result != null && result.trim().isNotEmpty) {
      setState(() {
        _locationText = result.trim();
      });
    }
  }

  void _handlePetCardLongPress(String petName, String petDetails) {
    final manager = Provider.of<AccessibilityManager>(context, listen: false);
    
    final fullDescription = "$petName. $petDetails. Para tradução em Libras, mantenha pressionado o texto.";
    
    // 🗣️ Fala a descrição apenas se o modo de áudio estiver ativo
    if (manager.isAudioActive) {
        manager.speak("Detalhes do pet: $petName.");
    }

    // 🤟 Traduz em Libras apenas se o modo Libras estiver ativo
    if (manager.isLibrasActive) {
      manager.updateRobotText(fullDescription);
    }
  }

  Widget _buildBody(int index, AccessibilityManager manager) {
    if (index == 0) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CategoriesBar(
              initialIndex: _selectedCategory,
              onChanged: (i) {
                setState(() {
                  _selectedCategory = i;
                });
                // 🗣️ Fala a mudança APENAS se o modo de áudio estiver ATIVO
                if (manager.isAudioActive && i >= 0 && i < _categoryNames.length) {
                  manager.speak("Categoria selecionada: ${_categoryNames[i]}");
                }
              },
            ),
            const SizedBox(height: 12),

            GestureDetector(
              onLongPress: () {
                // 🤟 Tradução em Libras
                if (manager.isLibrasActive) {
                  manager.updateRobotText("A localização atual é $_locationText. Para alterar, toque duas vezes no botão de editar.");
                }
              },
              child: Semantics(
                label: 'Localização atual: $_locationText. Pressione e segure para tradução em Libras.',
                child: LocationWidget(locationText: _locationText, onTap: _editLocation),
              ),
            ),
            
            const SizedBox(height: 12),
            Expanded(
              child: PetCatalog(
                onPetCardLongPress: _handlePetCardLongPress,
              ),
            ),
            // Espaço para o BottomMenu
            const SizedBox(height: 60), 
          ],
        ),
      );
    }
    
    if (index > 0 && index < _kMenuSize) {
      final menuItems = ["Loja", "Chat"]; 
      if (index == 1 || index == 2) {
        final title = menuItems[index - 1];
        final screenText = 'Esta é a tela de $title';

        // 🗣️ Fala a tela APENAS se o modo de áudio estiver ATIVO
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (manager.isAudioActive) {
            manager.speak(screenText);
          }
        });
        
        return Center(
          child: GestureDetector(
            onLongPress: () {
                // 🤟 Tradução em Libras
                if (manager.isLibrasActive) {
                  manager.updateRobotText(screenText);
                }
            },
            child: Semantics(
              label: screenText,
              child: Text(
                screenText,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      }
    }

    return const Center(
      child: Text('Página não encontrada', style: TextStyle(fontSize: 24)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<AccessibilityManager>();

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppHeader(
        title: "Adoção de Pets",
        scaffoldKey: _scaffoldKey,
        onSearchPressed: () {
          if (context.read<AccessibilityManager>().isAudioActive) {
            context.read<AccessibilityManager>().speak("Abrindo pesquisa de pets."); 
          }
          showSearch(
            context: context,
            delegate: PetSearchDelegate(), 
          );
        },
      ),
      drawer: const MenuDrawer(),
      body: Stack(
        children: [
          _buildBody(_selectedIndex, manager),
          
          // O BottomMenu Customizado
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 24), 
              child: BottomMenu(
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                forceAllOff: false,
              ),
            ),
          ),
        ],
      ),
      
      // CONFIGURAÇÃO DOS DOIS BOTÕES: TTS e LIBRAS (visuais/silenciosos)
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. BOTÃO DE ACESSIBILIDADE DE ÁUDIO (TTS - Fala)
          FloatingActionButton(
            heroTag: "accessibility_audio", 
            mini: true, 
            backgroundColor: manager.isAudioActive ? const Color(0xFFB6B2E1) : Colors.grey, 
            onPressed: () => manager.toggleAudioMode(context),
            tooltip: manager.isAudioActive 
                ? 'Desativar Acessibilidade de Áudio (TTS)' 
                : 'Ativar Acessibilidade de Áudio (TTS) para navegação por voz.', 
            child: const Icon(Icons.accessibility_new, color: Colors.white), 
          ),
          const SizedBox(height: 10),

          // 2. BOTÃO DE ACESSIBILIDADE EM LIBRAS (SILENCIOSO - Assistente Visual)
          FloatingActionButton(
            heroTag: "accessibility_libras", 
            mini: true, 
            backgroundColor: manager.isLibrasActive ? Colors.redAccent : const Color(0xFF3FBFAD), 
            onPressed: () => manager.toggleLibrasMode(context),
            // Tooltip focado apenas no visual de Libras
            tooltip: manager.isLibrasActive 
                ? 'Desativar Assistente Virtual de Libras' 
                : 'Ativar Assistente Virtual de Libras. Use o toque longo para traduzir textos.', 
            child: const Icon(Icons.sign_language, color: Colors.white), 
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop, 
    );
  }
}