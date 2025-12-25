import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'app_colors.dart';
import 'VerificationScreen.dart';
import '/classes/usuario.dart';

enum UserType { paciente, nutricionista }

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  UserType _selectedUser = UserType.paciente;

  // Controladores de texto
  final _nomeController = TextEditingController();
  final _dataNascController = TextEditingController();
  final _crnController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  // Máscara para a data
  final maskFormatter = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  bool _senhasNaoCoincidem = false;
  bool _formularioCompleto = false; // Nova variável de controle

  @override
  void initState() {
    super.initState();

    // Criamos uma lista com todos os controllers para monitorar mudanças
    List<TextEditingController> controllers = [
      _nomeController,
      _dataNascController,
      _crnController,
      _emailController,
      _senhaController,
      _confirmarSenhaController,
    ];

    // Adiciona um listener para cada campo
    for (var controller in controllers) {
      controller.addListener(_atualizarEstadoFormulario);
    }
  }

  // Função centralizada que valida senhas e preenchimento
  void _atualizarEstadoFormulario() {
    final senha = _senhaController.text;
    final confirmar = _confirmarSenhaController.text;

    // 1. Validação de coincidência de senhas
    final coincidem =
        senha.isNotEmpty && confirmar.isNotEmpty && senha != confirmar;

    // 2. Validação de campos obrigatórios preenchidos
    final camposBasicosOk =
        _nomeController.text.isNotEmpty &&
        _dataNascController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _senhaController.text.isNotEmpty &&
        _confirmarSenhaController.text.isNotEmpty;

    // 3. Validação específica do Nutricionista (CRN obrigatório se selecionado)
    final crnOk =
        (_selectedUser == UserType.paciente) || _crnController.text.isNotEmpty;

    setState(() {
      _senhasNaoCoincidem = coincidem;
      _formularioCompleto = camposBasicosOk && crnOk;
    });
  }

  void _irParaVerificacao() {
    final usuarioTemporario = Usuario(
      nome: _nomeController.text,
      email: _emailController.text,
      senha: _senhaController.text,
      codigo: "1234",
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => TelaConfirmacaoCodigo(
              usuario: usuarioTemporario,
              userType: _selectedUser, // Passamos o tipo selecionado
              crn:
                  _crnController.text, // Passamos o CRN (vazio se for paciente)
            ),
      ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _dataNascController.dispose();
    _crnController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller, {
    bool obscure = false,
    List<MaskTextInputFormatter>? inputFormatters,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        cursorColor: AppColors.roxoEscuro,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.cinzaEscuro),
          filled: true,
          fillColor: AppColors.cinzaClaro,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.branco,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.preto,
                size: 28,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(height: 10),

            // Toggle de Seleção de Usuário
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.cinza),
                ),
                child: ToggleButtons(
                  borderRadius: BorderRadius.circular(30),
                  isSelected: [
                    _selectedUser == UserType.paciente,
                    _selectedUser == UserType.nutricionista,
                  ],
                  onPressed: (index) {
                    setState(() {
                      _selectedUser =
                          index == 0
                              ? UserType.paciente
                              : UserType.nutricionista;
                      _atualizarEstadoFormulario(); // Revalida ao trocar o tipo
                    });
                  },
                  fillColor: AppColors.roxoClaro,
                  selectedColor: AppColors.preto,
                  color: AppColors.cinzaEscuro,
                  constraints: BoxConstraints(
                    minWidth: (MediaQuery.of(context).size.width - 45) / 2,
                    minHeight: 45,
                  ),
                  children: const [Text("Paciente"), Text("Nutricionista")],
                ),
              ),
            ),

            const SizedBox(height: 25),
            const Text(
              "Dados Pessoais",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            _buildTextField("Insira seu nome completo", _nomeController),

            _buildTextField(
              "Insira sua Data de Nascimento",
              _dataNascController,
              inputFormatters: [maskFormatter],
              keyboardType: TextInputType.number,
            ),

            if (_selectedUser == UserType.nutricionista)
              _buildTextField("Insira seu CRN", _crnController),

            const SizedBox(height: 20),
            const Text(
              "Dados de Acesso",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            _buildTextField("E-mail", _emailController),
            _buildTextField(
              "Defina sua senha",
              _senhaController,
              obscure: true,
            ),
            _buildTextField(
              "Confirme sua senha",
              _confirmarSenhaController,
              obscure: true,
            ),

            // MENSAGENS DE ERRO/ALERTA
            const SizedBox(height: 10),
            if (_senhasNaoCoincidem)
              const Center(
                child: Text(
                  "As senhas não coincidem.",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            if (!_formularioCompleto)
              const Center(
                child: Text(
                  "Preencha todos os campos para realizar o cadastro",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // BOTÃO DE CADASTRO
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                // Botão só habilita se estiver tudo preenchido E senhas coincidirem
                onPressed:
                    (_formularioCompleto && !_senhasNaoCoincidem)
                        ? _irParaVerificacao
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.roxoEscuro,
                  disabledBackgroundColor:
                      AppColors.cinza, // Cor quando desativado
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Realizar Cadastro",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
