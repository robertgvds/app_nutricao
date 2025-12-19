// Arrumar uso do código de verificação
// Adicionar usuário no banco de dados somente após verificação do código

import 'package:flutter/material.dart';
import 'package:app/database/usuario_repository.dart'; 
import '/classes/usuario.dart'; 
import 'app_colors.dart';
import 'codigoVerificacao.dart';

enum UserType { paciente, nutricionista }

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  TelaCadastroState createState() => TelaCadastroState();
}

class TelaCadastroState extends State<TelaCadastro> {
  UserType _selectedUser = UserType.paciente;

  // Controllers para capturar o texto dos campos
  final _nomeController = TextEditingController();
  final _dataNascController = TextEditingController();
  final _crnController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  final _repoUsuario = UsuarioRepository();
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
          senha.isNotEmpty && confirmar.isNotEmpty && senha != confirmar;
    });
  }

  // Função de salvamento no banco local 
  void _executarCadastroLocal() async {
    // 1. Criar o objeto de usuário com os dados dos controllers
    final novoUsuario = Usuario(
      nome: _nomeController.text,
      email: _emailController.text,
      senha: _senhaController.text,
      codigo: "", 
    );

    // 2. Inserir no repositório (Banco de Dados)
    await _repoUsuario.inserir(novoUsuario);

    if (!mounted) return;

    // 4. Navegar para a tela de confirmação (como solicitado no seu fluxo)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaConfirmacaoCodigo(
          nomeUsuario: _nomeController.text,
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

  Widget _buildTextField(String hint, TextEditingController controller, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: obscure,
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
            _buildTextField("Insira sua data de nascimento", _dataNascController),

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

            // BOTÃO REALIZAR CADASTRO
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _senhasNaoCoincidem ? null : _executarCadastroLocal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.roxoEscuro,
                  disabledBackgroundColor: AppColors.cinza,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
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