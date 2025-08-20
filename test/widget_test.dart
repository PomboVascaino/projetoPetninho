import 'package:flutter/material.dart';

class PetCard extends StatelessWidget {
  final String nome;
  final String imagemUrl;
  final List<String> tags;

  const PetCard({
    Key? key,
    required this.nome,
    required this.imagemUrl,
    required this.tags,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              imagemUrl,
              fit: BoxFit.cover,
              height: 150,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              nome,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
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
    );
  }

  Widget _smallTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: Colors.black),
      ),
    );
  }
}