import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart'; // Máscara para formatar a data para ##/##/####
import 'app_colors.dart';
import 'codigoVerificacao.dart';
import '/classes/usuario.dart';

enum UserType { paciente, nutricionista }

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  TelaCadastroState createState() => TelaCadastroState();
}

class TelaCadastroState extends State<TelaCadastro> {
  UserType _selectedUser = UserType.paciente;

  final _nomeController = TextEditingController();
  final _dataNascController = TextEditingController();
  final _crnController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  // Definição da máscara para a data
  final maskFormatter = MaskTextInputFormatter(
    mask: '##/##/####', 
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  bool _senhasNaoCoincidem = false;

  @override
  void initState() {
    super.initState();
    _senhaController.addListener(_validarSenhas);
    _confirmarSenhaController.addListener(_validarSenhas);
  }

  void _validarSenhas() {
    final senha = _senhaController.text;
    final confirmar = _confirmarSenhaController.text;
    setState(() {
      _senhasNaoCoincidem = senha.isNotEmpty && confirmar.isNotEmpty && senha != confirmar;
    });
  }

  void _irParaVerificacao() {
    // Criamos um objeto temporário para passar os dados
    // Os dados devem ser enviados para a tela de confirmação do código, e não salvos no bd antes da confirmação
    final usuarioTemporario = Usuario(
      nome: _nomeController.text,
      email: _emailController.text,
      senha: _senhaController.text,
      codigo: "1234", 
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaConfirmacaoCodigo(
          usuario: usuarioTemporario, // Passamos o objeto completo
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

  // Widget de TextField atualizado para aceitar máscara
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
        inputFormatters: inputFormatters, // Aplica a máscara aqui
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
              icon: const Icon(Icons.arrow_back, color: AppColors.preto, size: 28),
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
                      _selectedUser = index == 0 ? UserType.paciente : UserType.nutricionista;
                    });
                  },
                  fillColor: AppColors.roxoClaro,
                  selectedColor: AppColors.preto,
                  color: AppColors.cinzaEscuro,
                  constraints: BoxConstraints(
                    minWidth: (MediaQuery.of(context).size.width - 45) / 2,
                    minHeight: 45,
                  ),
                  children: const [
                    Text("Paciente"),
                    Text("Nutricionista"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),
            const Text("Dados Pessoais", style: TextStyle(fontWeight: FontWeight.bold)),
            _buildTextField("Insira seu nome completo", _nomeController),
            
            // CAMPO COM MÁSCARA DE DATA
            _buildTextField(
              "Insira sua Data de Nascimento", 
              _dataNascController,
              inputFormatters: [maskFormatter], // Máscara aplicada
              keyboardType: TextInputType.number,
            ),

            if (_selectedUser == UserType.nutricionista)
              _buildTextField("Insira seu CRN", _crnController),

            
            const SizedBox(height: 20),
            const Text("Dados de Acesso", style: TextStyle(fontWeight: FontWeight.bold)),
            _buildTextField("E-mail", _emailController),
            _buildTextField("Defina sua senha", _senhaController, obscure: true),
            _buildTextField("Confirme sua senha", _confirmarSenhaController, obscure: true),

            if (_senhasNaoCoincidem)
              const Padding(
                padding: EdgeInsets.only(left: 10, top: 5),
                child: Text("As senhas não coincidem.", style: TextStyle(color: Colors.red, fontSize: 12)),
              ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _senhasNaoCoincidem ? null : _irParaVerificacao,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.roxoEscuro,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text(
                  "Realizar Cadastro",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}