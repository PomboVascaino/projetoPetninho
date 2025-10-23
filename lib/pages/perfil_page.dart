import 'package:flutter/material.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarOpacity: 0.7,
        foregroundColor: Colors.black,
        backgroundColor: Colors.deepPurpleAccent,

        title: Text("Meu perfil"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipOval(
                child: Image.network(
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                  "https://static1.cbrimages.com/wordpress/wp-content/uploads/2020/04/kid-buu-2-1.jpg?q=50&fit=crop&w=1100&h=618&dpr=1.5",
                ),
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.person_4,
                  color: const Color.fromARGB(233, 238, 28, 28),
                ),
                SizedBox(width: 5),
                Text(
                  "Meu nome:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text("Arthur"),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(
                  Icons.email,
                  color: const Color.fromARGB(108, 252, 42, 14),
                ),
                SizedBox(width: 5),
                Text(
                  "Meu email:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text("Eusoufoda@gmail.com"),
            SizedBox(height: 20),

            Row(
              children: [
                Icon(Icons.person_2),
                SizedBox(width: 5),
                Text(
                  "bio",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Text(
                "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit..."
                "There is no one who loves pain itself, who seeks after it and wants to have it, simply because it is pain..."
                "There is no one who loves pain itself, who seeks after it and wants to have it, simply because it is pain..."
                "There is no one who loves pain itself, who seeks after it and wants to have it, simply because it is pain..."
                "There is no one who loves pain itself, who seeks after it and wants to have it, simply because it is pain..."
                "There is no one who loves pain itself, who seeks after it and wants to have it, simply because it is pain..."
                "There is no one who loves pain itself, who seeks after it and wants to have it, simply because it is pain..."
                "There is no one who loves pain itself, who seeks after it and wants to have it, simply because it is pain..."
                "There is no one who loves pain itself, who seeks after it and wants to have it, simply because it is pain..."
                "There is no one who loves pain itself, who seeks after it and wants to have it, simply because it is pain..."
                "There is no one who loves pain itself, who seeks after it and wants to have it, simply because it is pain...",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
