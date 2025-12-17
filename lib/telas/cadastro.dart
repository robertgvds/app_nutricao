import 'package:flutter/material.dart';

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
      _senhasNaoCoincidem =
          senha.isNotEmpty &&
          confirmar.isNotEmpty &&
          senha != confirmar;
    });
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
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFFF0F0F0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TOGGLE PACIENTE / NUTRICIONISTA
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: ToggleButtons(
                  borderRadius: BorderRadius.circular(30),
                  isSelected: [
                    _selectedUser == UserType.paciente,
                    _selectedUser == UserType.nutricionista,
                  ],
                  onPressed: (index) {
                    setState(() {
                      _selectedUser = index == 0
                          ? UserType.paciente
                          : UserType.nutricionista;
                    });
                  },
                  fillColor: const Color(0xFFE1D5F5),
                  selectedColor: Colors.black87,
                  constraints: BoxConstraints(
                    minWidth:
                        (MediaQuery.of(context).size.width - 45) / 2,
                    minHeight: 45,
                  ),
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _selectedUser == UserType.paciente
                              ? Icons.check
                              : Icons.person,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        const Text("Paciente"),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _selectedUser == UserType.nutricionista
                              ? Icons.check
                              : Icons.person,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        const Text("Nutricionista"),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text("Dados Pessoais",
                style: TextStyle(fontWeight: FontWeight.bold)),
            _buildTextField("Insira seu nome completo", _nomeController),
            _buildTextField(
                "Insira sua data de nascimento", _dataNascController),

            if (_selectedUser == UserType.nutricionista)
              _buildTextField("Insira seu CRN", _crnController),

            const SizedBox(height: 20),

            const Text("Dados de Acesso",
                style: TextStyle(fontWeight: FontWeight.bold)),
            _buildTextField("E-mail", _emailController),
            _buildTextField("Defina sua senha", _senhaController,
                obscure: true),

            const Padding(
              padding: EdgeInsets.only(left: 10, bottom: 10),
              child: Text(
                "Digite uma senha de pelo menos 8 caracteres, incluindo letras e números.",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),

            _buildTextField("Confirme sua senha",
                _confirmarSenhaController,
                obscure: true),

            if (_senhasNaoCoincidem)
              const Padding(
                padding: EdgeInsets.only(left: 10, bottom: 10),
                child: Text(
                  "As senhas não coincidem.",
                  style: TextStyle(fontSize: 12, color: Colors.red),
                ),
              ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                "Após a validação dos dados, enviaremos um código de verificação para o seu e-mail.",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),

            /// BOTÃO ENTRAR
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _senhasNaoCoincidem
                    ? null
                    : () {
                        // salvar usuário
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB39DDB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Realizar Cadastro",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
