import 'package:flutter/material.dart';
// Note: Assumindo que AppHeader e BottomMenu são componentes existentes
// Se não existirem, você deve criá-los ou usar widgets placeholder
import '../components/header.dart';
import '../components/bottom_menu.dart';

// Assumindo que AppDrawer é um componente existente
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    return const Drawer(child: Center(child: Text('Menu Lateral')));
  }
}

class PetPerfilPage extends StatefulWidget {
  // 💡 REMOVIDO: onNavigateBack não é mais necessário, pois usaremos Navigator.pop
  // final VoidCallback onNavigateBack;

  const PetPerfilPage({
    super.key,
    // required this.onNavigateBack, // Removido
  });

  @override
  State<PetPerfilPage> createState() => _PetPerfilPageState();
}

class _PetPerfilPageState extends State<PetPerfilPage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> petImages = [
    'https://i.imgur.com/ZbttlFX.png',
    'https://i.imgur.com/aEw9v3C.jpeg',
    'https://i.imgur.com/lSEI2aP.jpeg',
  ];

  final List<String> petTags = [
    'Gosta de passear',
    'Dócil',
    'Calma',
    'Castrada',
    'Vacinas em dia',
    'Adora crianças',
  ];

  Widget _buildTag(String text) {
    const Color tagColor = Color(0xFFb3e0db);

    return Container(
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
    );
  }

  void _abrirModalImagem(String imageUrl) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.85),
      useSafeArea: true,
      builder: (BuildContext context) {
        return Center(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,

      // O AppHeader é mantido
      appBar: AppHeader(title: "Detalhes do Pet", scaffoldKey: _scaffoldKey),

      // DRAWER ADICIONADO AQUI
      drawer: const AppDrawer(),

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
                        itemCount: petImages.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final imageUrl = petImages[index];
                          return GestureDetector(
                            onTap: () => _abrirModalImagem(imageUrl),
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
                                          : AssetImage(imageUrl)
                                                as ImageProvider,
                                      fit: BoxFit.cover,
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
                    children: List.generate(petImages.length, (index) {
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
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Text(
                              'Crystal',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(Icons.female, color: Colors.pink, size: 22),
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
                          child: const Text(
                            'Crystal é uma cadela da raça Shitzu, muito amigável e dócil. '
                            'Ela adora brincar e se dá bem com crianças e outros animais.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(16),
                                backgroundColor: const Color(0xFFB6B2E1),
                                elevation: 0,
                              ),
                              child: const Icon(
                                Icons.phone,
                                color: Colors.white,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(16),
                                backgroundColor: const Color(0xFFB6B2E1),
                                elevation: 0,
                              ),
                              child: const Icon(
                                Icons.chat,
                                color: Colors.white,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {},
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
                  const Positioned(
                    top: 18,
                    right: 12,
                    child: Icon(Icons.favorite_border, color: Colors.grey),
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
                    const Text(
                      'Características',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: petTags.map((tag) => _buildTag(tag)).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 100),

            // 💡 REMOVIDO: Este botão não é mais necessário, pois a navegação de volta
            // será tratada pelo BottomMenu ou pelo botão de voltar nativo.
            // ElevatedButton(
            //   onPressed: widget.onNavigateBack,
            //   ...
            // ),
            // const SizedBox(height: 24),
          ],
        ),
      ),

      // 💡 NOVO: BottomMenu forçado a ficar inativo (todos os botões apagados)
      bottomNavigationBar: BottomMenu(
        // Índice 0 é o 'Início'. O menu inteiro deve estar apagado, mas este item
        // em particular pode ser um "voltar para Home" de forma implícita.
        currentIndex: 0,
        onTap: (index) {
          // Se o usuário clicar em qualquer item, simplesmente retorna à página anterior (Home).
          // Em um app real, você checaria se index == 0.
          Navigator.pop(context);
        },
        // Força todos os ícones a ficarem apagados/inativos visualmente.
        forceAllOff: true,
      ),
    );
  }
}
