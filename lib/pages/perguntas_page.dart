import 'package:flutter/material.dart';

// 1. IMPORTS DOS SEUS COMPONENTES
import 'package:teste_app/components/bottom_menu.dart';
import 'package:teste_app/components/header.dart' hide HomePage;
import 'package:teste_app/components/menu_drawer.dart';

// 2. IMPORT DAS PÁGINAS DE DESTINO
import 'package:teste_app/pages/home_page.dart';
import 'package:teste_app/pages/favoritos_pages.dart';

// -----------------------------------------------------------------
// CLASSE DA PÁGINA (A "Casca" da página)
// -----------------------------------------------------------------
class PaginaPerguntas extends StatefulWidget {
  const PaginaPerguntas({Key? key}) : super(key: key);

  @override
  State<PaginaPerguntas> createState() => _PaginaPerguntasState();
}

class _PaginaPerguntasState extends State<PaginaPerguntas> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppHeader(
        title: "Perguntas Frequentes",
        scaffoldKey: _scaffoldKey,
      ),
      drawer: const MenuDrawer(),

      // O body agora é o nosso novo conteúdo de FAQ
      body: const ConteudoPerguntas(),

      extendBody: true, // Mantém o footer flutuante
      bottomNavigationBar: BottomMenu(
        forceAllOff: true, // Correto, pois FAQ não está no menu
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          // Lógica de navegação (só Home e Favoritos)
          switch (index) {
            case 0: // Início
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
              break;
            case 3: // Favoritos
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const FavoritosPage()),
              );
              break;
            // Cases para Loja, Chat, Perfil foram removidos daqui também
            // pois os placeholders foram removidos.
          }
        },
      ),
    );
  }
}

// -----------------------------------------------------------------
// CLASSE DO CONTEÚDO (O "Miolo" com FAQ e Formulário)
// -----------------------------------------------------------------
class ConteudoPerguntas extends StatefulWidget {
  const ConteudoPerguntas({Key? key}) : super(key: key);

  @override
  State<ConteudoPerguntas> createState() => _ConteudoPerguntasState();
}

class _ConteudoPerguntasState extends State<ConteudoPerguntas> {
  // Chave do Formulário
  final _formKey = GlobalKey<FormState>();

  // Controladores do Formulário
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _perguntaController = TextEditingController();

  // Estado de envio
  bool _isEnviando = false;

  // --- Dados das Perguntas Frequentes ---
  final List<Map<String, String>> _faqItems = [
    {
      'pergunta': 'Como funciona o processo de adoção?',
      'resposta':
          'O Petninho conecta você a ONGs. Você encontra o pet, preenche o formulário de interesse e a ONG parceira entrará em contato para continuar o processo de entrevista e adoção.',
    },
    {
      'pergunta': 'O Petninho cobra alguma taxa?',
      'resposta':
          'Não! O Petninho é 100% gratuito para adotantes. As ONGs podem solicitar uma taxa de adoção simbólica para cobrir custos de vacinas e castração, mas isso é uma relação direta com a ONG.',
    },
    {
      'pergunta': 'Todos os animais são castrados e vacinados?',
      'resposta':
          'A grande maioria sim! Nossas ONGs parceiras se comprometem a entregar os animais com o protocolo de saúde básico em dia (vacinas, vermífugo e castração). Casos de filhotes que ainda não têm idade para castrar são entregues com uma garantia de castração futura.',
    },
    {
      'pergunta': 'Posso cadastrar um animal para adoção?',
      'resposta':
          'No momento, apenas ONGs e protetores parceiros verificados podem cadastrar animais. Se você resgatou um animal, entre em contato com uma de nossas ONGs parceiras da sua região.',
    },
  ];

  // Controla qual card da FAQ está expandido
  int? _expandedIndex;

  // --- Funções ---

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
            content: Text('Pergunta enviada com sucesso! 🐾'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Limpa os campos
      _nomeController.clear();
      _emailController.clear();
      _perguntaController.clear();

      setState(() {
        _isEnviando = false;
      });
    } else {
      // Mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos corretamente.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _perguntaController.dispose();
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
            // --- 1. SEÇÃO DE PERGUNTAS FREQUENTES ---
            const Text(
              'Perguntas Frequentes',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Veja as dúvidas mais comuns dos nossos usuários sobre o processo de adoção.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 20),

            // Lista Dinâmica de Perguntas (Acordeão)
            ExpansionPanelList(
              elevation: 2,
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  if (index == _expandedIndex) {
                    _expandedIndex = null;
                  } else {
                    _expandedIndex = index;
                  }
                });
              },
              children: _faqItems.asMap().entries.map<ExpansionPanel>((entry) {
                int index = entry.key;
                Map<String, String> item = entry.value;

                return ExpansionPanel(
                  canTapOnHeader: true,
                  isExpanded:
                      _expandedIndex == index, // Controla se está aberto
                  // Cabeçalho (A Pergunta)
                  headerBuilder: (context, isExpanded) {
                    return Container(
                      // Muda a cor do fundo se estiver expandido
                      color: isExpanded
                          ? const Color(0xFFB3E0DB).withOpacity(0.1)
                          : Colors.white,
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        item['pergunta']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    );
                  },
                  // Corpo (A Resposta)
                  body: Container(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    width:
                        double.infinity, // Garante que o texto quebre a linha
                    child: Text(
                      item['resposta']!,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.4,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 40), // Espaçador entre as seções
            // --- 2. SEÇÃO DO FORMULÁRIO ---
            const Text(
              'Não encontrou sua dúvida?',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Envie sua pergunta para nossa equipe. Responderemos o mais rápido possível no seu e-mail!',
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
                    controller: _perguntaController,
                    label: 'Sua Pergunta',
                    hint: 'Digite sua dúvida aqui...',
                    icon: Icons.quiz_outlined, // Ícone de pergunta
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite sua pergunta';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Botão de Envio
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
                              'Enviar Pergunta',
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

  // Método auxiliar para construir o campo de texto (reaproveitado)
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

// ✅ PLACEHOLDERS REMOVIDOS
