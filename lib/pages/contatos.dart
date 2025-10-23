import 'package:flutter/material.dart';

// 1. IMPORTS DOS SEUS COMPONENTES
import 'package:teste_app/components/bottom_menu.dart';
import 'package:teste_app/components/header.dart' hide HomePage;
import 'package:teste_app/components/menu_drawer.dart';

// 2. IMPORT DAS PÁGINAS DE DESTINO
// Este import busca a sua classe 'HomePage'
import 'package:teste_app/pages/home_page.dart';
import 'package:teste_app/pages/favoritos_pages.dart';

// -----------------------------------------------------------------
// CLASSE DA PÁGINA (PaginaContato)
// -----------------------------------------------------------------
class PaginaContato extends StatefulWidget {
  const PaginaContato({Key? key}) : super(key: key);

  @override
  State<PaginaContato> createState() => _PaginaContatoState();
}

class _PaginaContatoState extends State<PaginaContato> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppHeader(title: "Fale Conosco", scaffoldKey: _scaffoldKey),
      drawer: const MenuDrawer(),
      body: const ConteudoContato(),
      extendBody: true,
      bottomNavigationBar: BottomMenu(
        forceAllOff: true,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          // LÓGICA DE NAVEGAÇÃO
          switch (index) {
            case 0: // Início
              Navigator.pushReplacement(
                context,
                // ✅ ESTA É A SUA PÁGINA 'HomePage'
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
              break;
            case 3: // Favoritos
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const FavoritosPage()),
              );
              break;
          }
        },
      ),
    );
  }
}

// -----------------------------------------------------------------
// CLASSE DO CONTEÚDO (O Formulário)
// -----------------------------------------------------------------
class ConteudoContato extends StatefulWidget {
  const ConteudoContato({Key? key}) : super(key: key);

  @override
  State<ConteudoContato> createState() => _ConteudoContatoState();
}

class _ConteudoContatoState extends State<ConteudoContato> {
  // Chave do Formulário
  final _formKey = GlobalKey<FormState>();

  // Controladores
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _mensagemController = TextEditingController();

  // Estado de envio
  bool _isEnviando = false;

  // Função de envio do formulário
  Future<void> _enviarFormulario() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isEnviando = true;
      });

      // Simulação de envio
      await Future.delayed(const Duration(seconds: 2));

      // Mensagem de sucesso
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mensagem enviada com sucesso! 🐾'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Limpa os campos
      _nomeController.clear();
      _emailController.clear();
      _mensagemController.clear();

      setState(() {
        _isEnviando = false;
      });
    } else {
      // Mensagem de erro na validação
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos corretamente.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Limpa os controladores
  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _mensagemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 120),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título (Cor independente)
            const Text(
              'Entre em contato com nossa matilha!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000000),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Adoraríamos ouvir você! Se você tem dúvidas, sugestões ou quer ser um parceiro do Petninho, use o formulário abaixo.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),

            // Formulário
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextFormField(
                    controller: _nomeController,
                    label: 'Seu Nome',
                    hint: 'Digite seu nome completo',
                    icon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite seu nome';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextFormField(
                    controller: _emailController,
                    label: 'Seu E-mail',
                    hint: 'exemplo@petninho.com.br',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite seu e-mail';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Por favor, digite um e-mail válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextFormField(
                    controller: _mensagemController,
                    label: 'Mensagem',
                    hint: 'Digite sua dúvida ou sugestão aqui...',
                    icon: Icons.chat_bubble_outline,
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite sua mensagem';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Botão de Envio (Cor independente)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB3E0DB),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onPressed: _isEnviando ? null : _enviarFormulario,
                      child: _isEnviando
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : const Text(
                              'Enviar Mensagem',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método auxiliar para construir o campo de texto
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.8),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Color(0xFFB3E0DB), width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.red.shade700, width: 2.0),
        ),
      ),
    );
  }
}
