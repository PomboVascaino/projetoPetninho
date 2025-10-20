import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../components/header.dart';
import '../components/bottom_menu.dart';
import '../components/menu_drawer.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // NOVO: Adicionado para controlar a visibilidade do botão de enviar
  bool _canSend = false;
  // NOVO: Adicionado dispose para os controllers
  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Mantendo a sua chave de API
  static const String _apiKey = "AIzaSyBUpMXiAW-GGRhJzIgef0yexsmJL0BX88Y";

  // --- IMAGENS DOS AVATARES ---
  static const String _biduAvatarUrl = "https://i.imgur.com/oqhJ4IP.png";
  static const String _userAvatarUrl = "https://i.imgur.com/6QgSD9A.png";

  late final GenerativeModel _model;
  late final ChatSession _chat;

  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // NOVO: Listener para mostrar/esconder o botão de enviar dinamicamente
    _textController.addListener(() {
      if (_textController.text.isNotEmpty != _canSend) {
        setState(() {
          _canSend = _textController.text.isNotEmpty;
        });
      }
    });

    // Ajustando o nome do modelo para a versão correta e mais recente
    _model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: _apiKey);

    // Mantendo a sua personalidade customizada para o Bidu
    _chat = _model.startChat(
      history: [
        Content.model([
          TextPart(
            'Você é o Bidu, o assistente virtual amigável e carinhoso do app Petninho. '
            'Sua missão é ajudar os usuários a encontrar o pet perfeito para adoção. '
            'Seja sempre gentil, positivo e focado em adoção responsável. '
            'Você pode dar dicas sobre cuidados com pets, raças, e como se preparar para receber um novo amigo. '
            'NUNCA sugira comprar animais. Promova sempre a adoção.'
            'Você deve somente responder a perguntas referentes ao aplicativo.'
            'Você deve falar somente em português do Brasil.'
            'Você deve ser mais objetivo, sem dar muitas voltas.'
            'Você deve sugerir opções de ajuda caso o usuário peça.'
            'Quando for listar algo, ao inves de * use -.',
          ),
        ]),
      ],
    );

    // Mensagem inicial do chatbot
    _messages.add(
      Message(
        text:
            'Olá! Sou o Bidu, seu assistente virtual do Petninho. Como posso ajudar você a encontrar seu novo amigo hoje?',
        isUser: false,
        avatarUrl: _biduAvatarUrl,
      ),
    );
  }

  void _sendMessage() async {
    final text = _textController.text;
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        Message(text: text, isUser: true, avatarUrl: _userAvatarUrl),
      );
      _isLoading = true;
    });
    _textController.clear();
    _scrollToBottom();

    try {
      final response = await _chat.sendMessage(Content.text(text));
      final responseText = response.text;

      setState(() {
        _messages.add(
          Message(
            text:
                responseText ??
                "Não consegui gerar uma resposta. Tente outra pergunta.",
            isUser: false,
            avatarUrl: _biduAvatarUrl,
          ),
        );
        _isLoading = false;
      });
    } catch (e) {
      print("!!!!!!!!!!!! ERRO NA API DO GEMINI !!!!!!!!!!!!\n$e");
      setState(() {
        _messages.add(
          Message(
            text:
                "Ocorreu um erro ao me comunicar com a IA. Por favor, verifique o console de depuração.",
            isUser: false,
            avatarUrl: _biduAvatarUrl,
          ),
        );
        _isLoading = false;
      });
    } finally {
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppHeader(title: "Bidu Assistente", scaffoldKey: _scaffoldKey),
      drawer: const MenuDrawer(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return MessageBubble(message: message);
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: const [
                  SizedBox(width: 16),
                  CircleAvatar(backgroundImage: NetworkImage(_biduAvatarUrl)),
                  SizedBox(width: 12),
                  Text(
                    "Bidu está digitando...",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          _buildTextInput(),
        ],
      ),
      bottomNavigationBar: BottomMenu(
        currentIndex: 2, // 2 é o índice do "Chat"
        onTap: (index) {
          if (index != 2) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  // ==============  MÉTODO ATUALIZADO  ==============
  Widget _buildTextInput() {
    const Color primaryColor = Color(0xFFB3E0DB);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.white,
      child: SafeArea(
        child: Row(
          children: [
            // Campo de texto expandido
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: "Converse com o Bidu...",
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Botão de enviar com animação
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: _canSend
                  ? InkWell(
                      onTap: _sendMessage,
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        key: const ValueKey('send_button'),
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    )
                  : const SizedBox(
                      key: ValueKey('empty_space'),
                      width: 48,
                    ), // Mantém o espaço
            ),
          ],
        ),
      ),
    );
  }
}

class Message {
  final String text;
  final bool isUser;
  final String avatarUrl;

  Message({required this.text, required this.isUser, required this.avatarUrl});
}

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final bubbleRadius = BorderRadius.only(
      topLeft: const Radius.circular(20),
      topRight: const Radius.circular(20),
      bottomLeft: message.isUser
          ? const Radius.circular(20)
          : const Radius.circular(0),
      bottomRight: message.isUser
          ? const Radius.circular(0)
          : const Radius.circular(20),
    );

    final avatar = CircleAvatar(
      radius: 22, // Raio do círculo externo (a borda)
      backgroundColor: const Color(0xFFb3e0db), // Cor da borda
      child: CircleAvatar(
        radius: 20, // Raio do círculo interno (a imagem)
        backgroundImage: NetworkImage(message.avatarUrl),
      ),
    );

    final bubble = Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: message.isUser ? const Color(0xFFb3e0db) : Colors.grey[200],
        borderRadius: bubbleRadius,
      ),
      child: Text(
        message.text,
        style: const TextStyle(color: Colors.black87, fontSize: 16),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: message.isUser
            ? [bubble, const SizedBox(width: 8), avatar]
            : [avatar, const SizedBox(width: 8), bubble],
      ),
    );
  }
}
