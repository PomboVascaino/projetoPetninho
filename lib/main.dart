import 'package:flutter/material.dart';

void main() {
  runApp(const PetninhoApp()); // agora é const
}

class PetninhoApp extends StatelessWidget {
  const PetninhoApp({super.key}); // adiciona o construtor const

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Petninho',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFb3e0db),
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(), // coloca const aqui também
    );
  }
}

class HomePage extends StatelessWidget {
  final List<String> categories = ["Todos", "Cachorros", "Gatos", "Peixes", "Aves"];
  final String locationText = "Vila Romana - São Paulo";

  final List<Map<String, dynamic>> pets = [
    {
      "name": "Theo",
      "gender": "m",
      "place": "Barra Funda - São Paulo",
      "age": "8 meses",
      "tags": ["Gosta de brincar","Dócil","Agitado"],
      "img": "https://i.imgur.com/IyLen7R.png"
    },
    {
      "name": "Crystal",
      "gender": "f",
      "place": "Cachoeirinha - São Paulo",
      "age": "1 ano",
      "tags": ["Gosta de passear","Dócil","Calma"],
      "img": "https://i.imgur.com/ZbttlFX.png"
    },
    // duplicados só para preencher o grid
    {
      "name": "Theo",
      "gender": "m",
      "place": "Barra Funda - São Paulo",
      "age": "8 meses",
      "tags": ["Gosta de brincar","Dócil","Agitado"],
      "img": "https://i.imgur.com/IyLen7R.png"
    },
    {
      "name": "Crystal",
      "gender": "f",
      "place": "Cachoeirinha - São Paulo",
      "age": "1 ano",
      "tags": ["Gosta de passear","Dócil","Calma"],
      "img": "https://i.imgur.com/ZbttlFX.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final primary = Color(0xFFb3e0db);
    final accent = Color(0xFF3FBFAD);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // AppBar custom
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.menu, size: 28),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Center(
                      child: Image.network(
                        // logo de exemplo (substitua pela sua)
                        'https://i.imgur.com/AYEweBY.png',
                        height: 125,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      _roundIconButton(Icons.search),
                      SizedBox(width: 8),
                      _roundIconButton(Icons.notifications_none),
                    ],
                  )
                ],
              ),
            ),

            // categorias (chips)
            Container(
              height: 56,
              padding: EdgeInsets.only(left: 12),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => SizedBox(width: 10),
                itemBuilder: (context, i) {
                  final isSelected = i == 0;
                  return ChoiceChip(
                    label: Text(categories[i], style: TextStyle(fontSize: 14)),
                    selected: isSelected,
                    selectedColor: primary,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: isSelected ? primary : Color(0xFFEAEAEA)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onSelected: (_) {},
                  );
                },
              ),
            ),

            // localização
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
              child: Row(
                children: [
                  Text("Localização", style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(Icons.location_on, color: Colors.grey[700], size: 18),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(locationText, style: TextStyle(fontWeight: FontWeight.w600)),
                  )
                ],
              ),
            ),

            SizedBox(height: 12),

            // grid de pets
            Expanded(
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    child: GridView.builder(
      itemCount: pets.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65, // valor ajustado
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final pet = pets[index];
        return PetCard(
          name: pet['name'],
          gender: pet['gender'],
          place: pet['place'],
          age: pet['age'],
          tags: List<String>.from(pet['tags']),
          imageUrl: pet['img'],
        );
      },
    ),
  ),
),
          ],
        ),
      ),

      // bottom nav
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: accent,
        unselectedItemColor: Colors.grey[500],
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Início"),
          BottomNavigationBarItem(icon: Icon(Icons.storefront_outlined), label: "Loja"),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "Favoritos"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Perfil"),
        ],
      ),
    );
  }

  Widget _roundIconButton(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0,2))],
      ),
      child: Icon(icon, size: 20),
    );
  }
}

class PetCard extends StatelessWidget {
  final String name;
  final String gender; // 'm' or 'f'
  final String place;
  final String age;
  final List<String> tags;
  final String imageUrl;

  const PetCard({
    super.key,
    required this.name,
    required this.gender,
    required this.place,
    required this.age,
    required this.tags,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final cardRadius = 16.0;

    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(cardRadius),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(cardRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // imagem com canto arredondado
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(cardRadius)),
              child: Image.network(
                imageUrl,
                height: 130,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // nome e ícone de gênero
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(name, style: TextStyle(fontWeight: FontWeight.w700)),
                            SizedBox(width: 6),
                            Icon(
                              gender == 'm' ? Icons.male : Icons.female,
                              size: 16,
                              color: gender == 'm' ? Colors.blueAccent : Colors.pinkAccent,
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text("($place)", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        SizedBox(height: 4),
                        Text(age, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                      ],
                    ),
                  ),

                  // coração (favorito)
                  Icon(Icons.favorite_border, size: 20, color: Colors.grey[700]),
                ],
              ),
            ),

            // tags (chips)
           Flexible(
  child: Padding(
    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
    child: SingleChildScrollView(
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: tags.map((t) => _smallTag(t)).toList(),
      ),
    ),
  ),
),
          ],
        ),
      ),
    );
  }

  Widget _smallTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Color(0xFFb3e0db),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: TextStyle(fontSize: 11, color: Colors.black87)),
    );
  }
}
