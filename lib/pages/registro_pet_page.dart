import 'package:flutter/material.dart';
import 'package:teste_app/Models/pets_model.dart';
import '../components/menu_drawer.dart';
import '../components/header.dart';
import '../components/bottom_menu.dart'; // Import do BottomMenu

class RegistroPetPage extends StatefulWidget {
  final Function(Pet) onPetRegistered;

  const RegistroPetPage({super.key, required this.onPetRegistered});

  @override
  State<RegistroPetPage> createState() => _RegistroPetPageState();
}

class _RegistroPetPageState extends State<RegistroPetPage> {
  // NOVO: Uma lista de chaves de formulário, uma para cada etapa.
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Controllers
  final _nomeController = TextEditingController();
  final _idadeController = TextEditingController();
  final _racaController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _tagController = TextEditingController();

  // Variáveis de estado
  String? _sexoSelecionado;
  String? _ongSelecionada = 'Não faço parte';
  bool _encontrado = false;
  final List<String> _tags = [];
  int _currentStep = 0;

  @override
  void dispose() {
    _nomeController.dispose();
    _idadeController.dispose();
    _racaController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _telefoneController.dispose();
    _descricaoController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _adicionarTag() {
    if (_tagController.text.isNotEmpty &&
        !_tags.contains(_tagController.text)) {
      setState(() {
        _tags.add(_tagController.text.trim());
        _tagController.clear();
      });
    }
  }

  void _submeterFormulario() {
    // Valida o último passo antes de submeter
    if (_formKeys[_currentStep].currentState!.validate()) {
      final novoPet = Pet(
        nome: _nomeController.text,
        idade: _idadeController.text,
        sexo: _sexoSelecionado!,
        raca: _racaController.text,
        tags: List.from(_tags),
        descricao: _descricaoController.text,
        bairro: _bairroController.text,
        cidade: _cidadeController.text,
        telefone: _telefoneController.text,
        encontrado: _encontrado,
        ong: _ongSelecionada == 'Não faço parte' ? null : _ongSelecionada,
        imagens: [], // Lógica de upload de imagem a ser adicionada no futuro
      );

      widget.onPetRegistered(novoPet);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${novoPet.nome} foi cadastrado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context); // Volta para a home page
    }
  }

  // ALTERADO: Lógica de continuação do Stepper
  void _onStepContinue() {
    // Valida o formulário da etapa atual
    if (_formKeys[_currentStep].currentState!.validate()) {
      final isLastStep = _currentStep == getSteps().length - 1;
      if (isLastStep) {
        _submeterFormulario();
      } else {
        setState(() => _currentStep += 1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppHeader(title: "Cadastrar Novo Pet", scaffoldKey: _scaffoldKey),
      drawer: const MenuDrawer(),
      backgroundColor: Colors.grey[50],
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepContinue: _onStepContinue, // Usa a nova função
        onStepCancel: _currentStep == 0
            ? null
            : () => setState(() => _currentStep -= 1),
        onStepTapped: (step) => setState(() => _currentStep = step),
        steps: getSteps(),
        controlsBuilder: (context, details) {
          final isLastStep = _currentStep == getSteps().length - 1;
          return Container(
            margin: const EdgeInsets.only(top: 24),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3FBFAD),
                      foregroundColor: Colors.white,
                    ),
                    child: Text(isLastStep ? 'CADASTRAR' : 'PRÓXIMO'),
                  ),
                ),
                if (_currentStep != 0) const SizedBox(width: 12),
                if (_currentStep != 0)
                  Expanded(
                    child: TextButton(
                      onPressed: details.onStepCancel,
                      child: const Text('VOLTAR'),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomMenu(
        currentIndex: -1,
        forceAllOff: true,
        onTap: (index) {
          Navigator.pop(context);
        },
      ),
    );
  }

  List<Step> getSteps() => [
    Step(
      isActive: _currentStep >= 0,
      title: const Text('Informações Básicas'),
      // NOVO: Envolve o conteúdo em um Form com a chave correspondente
      content: Form(
        key: _formKeys[0],
        child: Column(
          children: [
            _buildTextField(_nomeController, 'Nome do Pet'),
            const SizedBox(height: 16),
            _buildTextField(_idadeController, 'Idade (Ex: 2 anos, 8 meses)'),
            const SizedBox(height: 16),
            _buildDropdown(
              ['Macho', 'Fêmea'],
              'Sexo',
              _sexoSelecionado,
              (val) => setState(() => _sexoSelecionado = val),
            ),
            const SizedBox(height: 16),
            _buildTextField(_racaController, 'Raça (Ex: SRD, Golden)'),
          ],
        ),
      ),
    ),
    Step(
      isActive: _currentStep >= 1,
      title: const Text('Detalhes e Localização'),
      content: Form(
        key: _formKeys[1],
        child: Column(
          children: [
            _buildTextField(_bairroController, 'Bairro'),
            const SizedBox(height: 16),
            _buildTextField(_cidadeController, 'Cidade'),
            const SizedBox(height: 16),
            _buildTextField(
              _telefoneController,
              'Telefone para Contato',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              _descricaoController,
              'Descrição do Pet',
              maxLines: 3,
            ),
          ],
        ),
      ),
    ),
    Step(
      isActive: _currentStep >= 2,
      title: const Text('Informações Adicionais'),
      content: Form(
        key: _formKeys[2],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTagInput(),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: _tags
                  .map(
                    (tag) => Chip(
                      label: Text(tag),
                      onDeleted: () => setState(() => _tags.remove(tag)),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              ['Não faço parte', 'Em prol do Amor', 'Porta da Rua'],
              'Faz parte de ONG?',
              _ongSelecionada,
              (val) => setState(() => _ongSelecionada = val),
            ),
            const SizedBox(height: 16),
            const Text('O pet foi encontrado na rua?'),
            Row(
              children: [
                ChoiceChip(
                  label: const Text('Sim'),
                  selected: _encontrado,
                  onSelected: (val) => setState(() => _encontrado = true),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Não'),
                  selected: !_encontrado,
                  onSelected: (val) => setState(() => _encontrado = false),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  ];

  // O validador foi mantido aqui para os outros campos
  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool isRequired = true, // Parâmetro para controlar a validação
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: isRequired
          ? (value) =>
                (value == null || value.isEmpty) ? 'Campo obrigatório' : null
          : null, // Validador condicional
    );
  }

  Widget _buildDropdown(
    List<String> items,
    String label,
    String? value,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      items: items
          .map(
            (String val) =>
                DropdownMenuItem<String>(value: val, child: Text(val)),
          )
          .toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Selecione uma opção' : null,
    );
  }

  // ALTERADO: O campo de tags agora não é mais obrigatório
  Widget _buildTagInput() {
    return Row(
      children: [
        Expanded(
          // isRequired é false para não validar este campo como obrigatório no formulário
          child: _buildTextField(
            _tagController,
            'Adicionar Tags (Ex: Dócil)',
            isRequired: false,
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.add_circle,
            color: Color(0xFF3FBFAD),
            size: 30,
          ),
          onPressed: _adicionarTag,
        ),
      ],
    );
  }
}
