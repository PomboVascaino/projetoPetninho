import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _senhaVisivel = false;

  @override
  Widget build(BuildContext context) {
    Color verdeClaro = const Color(0xFFB3E0DB);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const SizedBox(height: 100),

            // Logo maior
            Center(
              child: Image.network(
                "https://i.imgur.com/AYEweBY.png",
                height: 200, // Aumentado
              ),
            ),

            const SizedBox(height: 50),

            // Texto "Ou com e-mail"
            const Center(
              child: Text(
                "Ou com e-mail",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),

            const SizedBox(height: 30),

            // Campo de Email
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "Email",
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: verdeClaro),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: verdeClaro),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: verdeClaro, width: 2),
                ),
                suffixIcon: Icon(Icons.check, color: verdeClaro),
              ),
            ),

            const SizedBox(height: 20),

            // Campo de Senha
            TextFormField(
              controller: _senhaController,
              obscureText: !_senhaVisivel,
              decoration: InputDecoration(
                hintText: "Senha",
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: verdeClaro),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: verdeClaro),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: verdeClaro, width: 2),
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Forgot?",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _senhaVisivel
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _senhaVisivel = !_senhaVisivel;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 35),

            // Botões Sociais
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: _socialButton(
                        Icons.g_mobiledata, "Com Google", verdeClaro)),
                const SizedBox(width: 12),
                _circleButton(Icons.facebook, verdeClaro),
                const SizedBox(width: 12),
                _circleButton(Icons.alternate_email, verdeClaro),
              ],
            ),

            const SizedBox(height: 50),

            // Botão "Comece"
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: verdeClaro,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: const Size(double.infinity, 55),
              ),
              onPressed: () {
                print("Email: ${_emailController.text}");
                print("Senha: ${_senhaController.text}");
              },
              child: const Text(
                "Comece",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Texto final
            Center(
              child: GestureDetector(
                onTap: () {},
                child: RichText(
                  text: const TextSpan(
                    text: "Novo usuário? ",
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: "Inscreva-se",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Botão Social com texto
  Widget _socialButton(IconData icon, String label, Color color) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        minimumSize: const Size(10, 50),
      ),
      onPressed: () {},
      icon: Icon(icon, color: Colors.black),
      label: Text(
        label,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  // Botão Social Circular
  Widget _circleButton(IconData icon, Color color) {
    return Ink(
      decoration: ShapeDecoration(
        color: color,
        shape: const CircleBorder(),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black),
        onPressed: () {},
      ),
    );
  }
}
