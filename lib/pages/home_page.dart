// lib/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // NOVO: para chamadas de API
import 'dart:convert'; // NOVO: para decodificar a resposta JSON
import 'package:shared_preferences/shared_preferences.dart'; // NOVO: para salvar localmente

import '../components/header.dart';
import '../components/bottom_menu.dart';
import '../components/pet_catalog.dart';
import '../components/categories.dart';
import '../components/location_widget.dart';

// Simulação de componentes que não foram fornecidos:
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    return const Drawer(child: Center(child: Text('Menu Lateral')));
  }
}

// =========================
// HomePage
// =========================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static const int _kMenuSize = 5;

  int _selectedIndex = 0;
  int _selectedCategory = 0;
  // ALTERADO: Valor inicial mais genérico
  String _locationText = "Clique para definir o local";

  // NOVO: Chave para salvar/ler o endereço
  static const String _kLocationKey = 'user_location';

  @override
  void initState() {
    super.initState();
    // NOVO: Carrega o endereço salvo quando a tela inicia
    _loadSavedLocation();
  }

  // NOVO: Função para carregar o endereço salvo
  Future<void> _loadSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    // Busca o endereço salvo; se não houver, mantém o texto padrão
    final savedLocation = prefs.getString(_kLocationKey);
    if (savedLocation != null && savedLocation.isNotEmpty) {
      setState(() {
        _locationText = savedLocation;
      });
    }
  }

  // NOVO: Função para salvar o endereço
  Future<void> _saveLocation(String location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLocationKey, location);
  }

  // ALTERADO: A função agora busca o endereço pelo CEP
  Future<void> _showEditCepDialog() async {
    final cepController = TextEditingController();

    // Mostra um pop-up para o usuário digitar o CEP
    await showDialog<void>(
      context: context,
      builder: (ctx) {
        bool isLoading = false; // Estado de loading dentro do dialog

        return StatefulBuilder(
          // Usamos StatefulBuilder para atualizar o estado do dialog (ex: loading)
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Alterar Localização'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: cepController,
                    keyboardType: TextInputType.number,
                    maxLength: 8,
                    decoration: const InputDecoration(
                      hintText: 'Digite o CEP (só números)',
                      counterText: "", // Esconde o contador de caracteres
                    ),
                  ),
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          // Desabilita o botão durante o loading
                          final cep = cepController.text.trim();
                          if (cep.length != 8) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'CEP inválido. Digite 8 números.',
                                ),
                              ),
                            );
                            return;
                          }

                          setDialogState(
                            () => isLoading = true,
                          ); // Inicia o loading

                          try {
                            final url = Uri.parse(
                              'https://viacep.com.br/ws/$cep/json/',
                            );
                            final response = await http.get(url);

                            if (response.statusCode == 200) {
                              final data = json.decode(response.body);

                              if (data.containsKey('erro')) {
                                throw Exception('CEP não encontrado.');
                              }

                              // Formata o texto da localização
                              final newLocation =
                                  "${data['logradouro']}, ${data['bairro']} - ${data['localidade']}, ${data['uf']}";

                              setState(() {
                                _locationText = newLocation;
                              });

                              await _saveLocation(
                                newLocation,
                              ); // Salva a nova localização

                              Navigator.of(
                                ctx,
                              ).pop(); // Fecha o dialog com sucesso
                            } else {
                              throw Exception('Falha ao buscar o CEP.');
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Erro: ${e.toString()}')),
                            );
                          } finally {
                            setDialogState(
                              () => isLoading = false,
                            ); // Termina o loading
                          }
                        },
                  child: const Text('Buscar e Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _onItemTapped(int index) {
    if (index >= 0 && index < _kMenuSize) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Widget _buildBody(int index) {
    if (index == 0) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CategoriesBar(
              initialIndex: _selectedCategory,
              onChanged: (i) {
                setState(() {
                  _selectedCategory = i;
                });
              },
            ),
            const SizedBox(height: 12),
            // ALTERADO: O onTap agora chama a nova função _showEditCepDialog
            LocationWidget(
              locationText: _locationText,
              onTap: _showEditCepDialog,
            ),
            const SizedBox(height: 12),
            const Expanded(child: PetCatalog()),
          ],
        ),
      );
    }

    if (index > 0 && index < _kMenuSize) {
      final menuItems = ["Loja", "Chat", "Favoritos", "Perfil"];
      final title = menuItems[index - 1];
      return Center(
        child: Text(
          'Esta é a tela de $title',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      );
    }

    return const Center(
      child: Text('Página não encontrada', style: TextStyle(fontSize: 24)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppHeader(title: "Adoção de Pets", scaffoldKey: _scaffoldKey),
      drawer: const AppDrawer(),
      body: _buildBody(_selectedIndex),
      bottomNavigationBar: BottomMenu(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        forceAllOff: false,
      ),
    );
  }
}
