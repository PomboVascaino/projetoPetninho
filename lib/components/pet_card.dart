import 'package:flutter/material.dart';

class PetCard extends StatelessWidget {
  final String name;
  final String gender; // 'm' or 'f'
  final String place;
  final String age;
  final List<String> tags;
  final String imageUrl;

  const PetCard({
    Key? key,
    required this.name,
    required this.gender,
    required this.place,
    required this.age,
    required this.tags,
    required this.imageUrl,
  }) : super(key: key);

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
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(cardRadius),
              ),
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
                            Text(
                              name,
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              gender == 'm' ? Icons.male : Icons.female,
                              size: 16,
                              color: gender == 'm'
                                  ? Colors.blueAccent
                                  : Colors.pinkAccent,
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          "($place)",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          age,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // coração (favorito)
                  Icon(
                    Icons.favorite_border,
                    size: 20,
                    color: Colors.grey[700],
                  ),
                ],
              ),
            ),

            // tags (chips)
            Flexible(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: tags.map((t) => _smallTag(t)).toList(),
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
