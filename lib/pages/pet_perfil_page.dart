// lib/pages/pet_perfil_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teste_app/Models/pets_model.dart';
import 'package:teste_app/components/menu_drawer.dart';
import '../components/header.dart';
import '../components/bottom_menu.dart';
import '../components/partial_search_delegate.dart.dart' show PetSearchDelegate;
import '../services/favorites_service.dart';
import '../components/pet_search_delegate.dart'; 
import '../components/libras_overlay_robot.dart'; 
import '../utils/accessibility_manager.dart'; 


class PetPerfilPage extends StatefulWidget {
  final Pet pet;

  const PetPerfilPage({
    super.key,
    required this.pet,
  });

  @override
  State<PetPerfilPage> createState() => _PetPerfilPageState();
}

class _PetPerfilPageState extends State<PetPerfilPage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AccessibilityManager _manager;


  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _manager = Provider.of<AccessibilityManager>(context, listen: false); 
      
      final description = "Você está na página de perfil de ${widget.pet.nome}. ${widget.pet.descricao}. Pressione e segure em qualquer texto para tradução em libras.";
      _manager.speak(description);
      
      if (_manager.isLibrasActive) {
        _manager.updateRobotText(description);
      }
    });
  }

  @override
  void dispose() {
    if (mounted) {
      _manager.speak(""); 
    }
    super.dispose();
  }


  Widget _buildTag(String text) {
    const Color tagColor = Color(0xFFb3e0db);

    return Semantics(
      label: 'Característica: $text',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        margin: const EdgeInsets.only(right: 8, bottom: 8),
        decoration: BoxDecoration(
          color: tagColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFb3e0db), width: 1),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _abrirModalImagem(String imageUrl) {
    _manager.speak("Abrindo visualização ampliada da imagem. Toque para fechar.");
    
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.85),
      useSafeArea: true,
      builder: (BuildContext context) {
        return Center(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            onLongPress: () {
               if (_manager.isLibrasActive) {
                  _manager.updateRobotText("Visualização ampliada da imagem. Toque em qualquer lugar para fechar.");
                }
            },
            child: Semantics(
              label: 'Visualização ampliada da imagem. Toque em qualquer lugar para fechar.',
              button: true,
              child: Container(
                color: Colors.transparent,
                child: Center(
                  child: Hero(
                    tag: imageUrl,
                    child: InteractiveViewer(
                      maxScale: 4.0,
                      child: Image.network(imageUrl, fit: BoxFit.contain),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final manager = Provider.of<AccessibilityManager>(context, listen: false); 

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,

      appBar: AppHeader(
        title: "Detalhes do Pet", 
        scaffoldKey: _scaffoldKey,
        onSearchPressed: () {
          manager.speak("Abrindo pesquisa de pets."); 
          showSearch(context: context, delegate: PetSearchDelegate());
        },
      ),

      drawer: const MenuDrawer(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Carrossel com modal de imagem ---
            SizedBox(
              height: 300,
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: widget.pet.imagens.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                          manager.speak("Imagem ${index + 1} de ${widget.pet.imagens.length} selecionada.");
                        },
                        itemBuilder: (context, index) {
                          final imageUrl = widget.pet.imagens[index];
                          return GestureDetector(
                            onTap: () => _abrirModalImagem(imageUrl),
                            onLongPress: () {
                              if (manager.isLibrasActive) {
                                manager.updateRobotText("Imagem ${index + 1} do pet ${widget.pet.nome}. Toque para ampliar.");
                              }
                            },
                            child: Semantics(
                              label: 'Imagem ${index + 1} de ${widget.pet.imagens.length}. Toque para ampliar.',
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 400),
                                opacity: _currentPage == index ? 1.0 : 0.6,
                                child: Hero(
                                  tag: imageUrl,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageUrl.startsWith('http')
                                            ? NetworkImage(imageUrl)
                                            : AssetImage(imageUrl) as ImageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(widget.pet.imagens.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == index ? 22 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? const Color(0xFFB6B2E1)
                              : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: _currentPage == index
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : [],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
 
            // --- Card principal com Nome, Descrição e Botões ---
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Stack(
                children: [
                  GestureDetector( 
                    onLongPress: () {
                        if (manager.isLibrasActive) {
                          final textToTranslate = "Nome: ${widget.pet.nome}. Gênero: Fêmea. Descrição: ${widget.pet.descricao}.";
                          manager.updateRobotText(textToTranslate);
                        }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.pet.nome,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Semantics(
                                label: 'Gênero: Fêmea',
                                child: const Icon(Icons.female, color: Colors.pink, size: 22),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: const [
                              Text(
                                'Anunciado há 1 dia',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Spacer(),
                              Icon(
                                Icons.location_on,
                                color: Colors.grey,
                                size: 16,
                              ),
                              Text(
                                '3.0 km',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Semantics(
                              label: 'Descrição do pet: ${widget.pet.descricao}',
                              child: Text(
                                widget.pet.descricao,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () => manager.speak("Tentando ligar para o anunciante."),
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(16),
                                  backgroundColor: const Color(0xFFB6B2E1),
                                  elevation: 0,
                                ),
                                child: Semantics(
                                  label: 'Ligar para o anunciante',
                                  button: true,
                                  child: const Icon(Icons.phone, color: Colors.white),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => manager.speak("Abrindo chat com o anunciante."),
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(16),
                                  backgroundColor: const Color(0xFFB6B2E1),
                                  elevation: 0,
                                ),
                                child: Semantics(
                                  label: 'Abrir chat com o anunciante',
                                  button: true,
                                  child: const Icon(Icons.chat, color: Colors.white),
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () => manager.speak("Abrindo formulário de adoção."),
                                icon: const Icon(Icons.pets, color: Colors.white),
                                label: const Text(
                                  'Quero adotar',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFB6B2E1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // 🚨 CORREÇÃO APLICADA AQUI: Removido o 'const' do Positioned
                  Positioned(
                    top: 18,
                    right: 12,
                    child: GestureDetector( // 💡 Adicionado GestureDetector para ação
                      onTap: () {
                        // 🗣️ Fala a ação (e aqui adicionaria a lógica real do FavoriteService)
                        manager.speak("Adicionando aos favoritos."); 
                      },
                      onLongPress: () {
                        // 🤟 Tradução em Libras
                        if (manager.isLibrasActive) {
                          manager.updateRobotText("Adicionar ou remover este pet dos favoritos.");
                        }
                      },
                      child: Semantics( // 💡 Semantics para Favorito
                        label: 'Adicionar ou remover dos favoritos',
                        button: true,
                        child: const Icon(Icons.favorite_border, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // --- Bloco: Características com Tags ---
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector( 
                      onLongPress: () {
                          if (manager.isLibrasActive) {
                            final tagsText = widget.pet.tags.join(', ');
                            manager.updateRobotText("Características do pet: $tagsText.");
                          }
                      },
                      // 🚨 CORREÇÃO APLICADA AQUI: Removido o 'const' do Semantics
                      child: Semantics(
                        label: 'Seção de Características',
                        child: const Text(
                          'Características',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: widget.pet.tags
                          .map((tag) => _buildTag(tag))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),

      bottomNavigationBar: BottomMenu(
        currentIndex: 0,
        onTap: (index) {
          manager.speak("Voltando para a página inicial."); 
          Navigator.pop(context);
        },
        forceAllOff: true,
      ),
    );
  }
}