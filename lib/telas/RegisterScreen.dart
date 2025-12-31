import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  bool _estaCarregando = false;

  final _nomeController = TextEditingController();
  final _dataNascController = TextEditingController();
  final _crnController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  final maskFormatter = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  bool _senhasNaoCoincidem = false;
  bool _formularioCompleto = false;
  String? _erroRequisitoSenha;

  @override
  void initState() {
    super.initState();
    List<TextEditingController> controllers = [
      _nomeController, _dataNascController, _crnController,
      _emailController, _senhaController, _confirmarSenhaController,
    ];
    for (var controller in controllers) {
      controller.addListener(_atualizarEstadoFormulario);
    }
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

  // --- MÉTODOS DE VALIDAÇÃO ORIGINAIS MANTIDOS ---

  String? _validarRequisitosSenha(String senha) {
    if (senha.isEmpty) return null;
    if (senha.length < 8) return "A senha deve ter pelo menos 8 caracteres";
    if (!RegExp(r'[A-Z]').hasMatch(senha)) return "Adicione pelo menos uma letra maiúscula";
    if (!RegExp(r'[0-9]').hasMatch(senha)) return "Adicione pelo menos um número";
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(senha)) return "Adicione um caractere especial (ex: @, #, %)";
    return null;
  }

  String? _validarDataNascimento(String data) {
    if (data.isEmpty || data.length < 10) return null;
    try {
      List<String> partes = data.split('/');
      int dia = int.parse(partes[0]);
      int mes = int.parse(partes[1]);
      int ano = int.parse(partes[2]);
      final dataInformada = DateTime(ano, mes, dia);
      final hoje = DateTime.now();
      if (dataInformada.day != dia || dataInformada.month != mes || dataInformada.year != ano) return "Data inválida";
      if (dataInformada.isAfter(hoje)) return "A data não pode ser no futuro";
      if (ano < 1900) return "Ano inválido";
      return null;
    } catch (e) {
      return "Formato de data incorreto";
    }
  }

  void _atualizarEstadoFormulario() {
    final senha = _senhaController.text;
    final confirmar = _confirmarSenhaController.text;
    final erroSenha = _validarRequisitosSenha(senha);
    final erroData = _validarDataNascimento(_dataNascController.text);
    final coincidem = senha.isNotEmpty && confirmar.isNotEmpty && senha != confirmar;

    final camposBasicosOk = _nomeController.text.isNotEmpty &&
        _dataNascController.text.length == 10 &&
        _emailController.text.isNotEmpty &&
        senha.isNotEmpty &&
        confirmar.isNotEmpty;

    final crnOk = (_selectedUser == UserType.paciente) || _crnController.text.isNotEmpty;

    setState(() {
      _erroRequisitoSenha = erroSenha;
      _senhasNaoCoincidem = coincidem;
      _formularioCompleto = camposBasicosOk && crnOk && erroSenha == null && erroData == null;
    });
  }

  // --- LÓGICA DE CADASTRO CORRIGIDA ---

  Future<void> _cadastrarNoFirebase() async {
    setState(() => _estaCarregando = true);
    try {
      // 1. Cria o usuário no Firebase
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _senhaController.text.trim(),
      );

      // 2. Envia e-mail de verificação (com tratamento de erro interno)
      try {
        print("Tentando enviar e-mail para: ${userCredential.user?.email}");
        await userCredential.user?.sendEmailVerification();
        print("✅ Firebase aceitou a solicitação de envio.");
      } catch (e) {
        print("❌ ERRO ESPECÍFICO DO FIREBASE: $e");
      }

      final novoUsuario = Usuario(
        nome: _nomeController.text,
        email: _emailController.text.trim(),
        senha: _senhaController.text.trim(),
        codigo: userCredential.user!.uid,
        dataNascimento: _dataNascController.text,
      );

      if (mounted) {
        // 3. USO DO pushReplacement: Crucial para não permitir voltar e cadastrar de novo
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TelaConfirmacaoCodigo(
              usuario: novoUsuario,
              userType: _selectedUser,
              crn: _crnController.text,
            ),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String erro = "Erro ao cadastrar";
      if (e.code == 'email-already-in-use') erro = "E-mail já cadastrado.";
      if (e.code == 'invalid-email') erro = "E-mail inválido.";
      if (e.code == 'weak-password') erro = "A senha é muito fraca.";

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(erro), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _estaCarregando = false);
    }
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildErrorMessage(String message, {Color color = Colors.red}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Text(
        message,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, {bool obscure = false, List<MaskTextInputFormatter>? inputFormatters, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: AppColors.cinzaClaro,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
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
            Center(
              child: ToggleButtons(
                borderRadius: BorderRadius.circular(30),
                isSelected: [_selectedUser == UserType.paciente, _selectedUser == UserType.nutricionista],
                onPressed: (index) => setState(() {
                  _selectedUser = index == 0 ? UserType.paciente : UserType.nutricionista;
                  _atualizarEstadoFormulario();
                }),
                fillColor: AppColors.roxoClaro,
                selectedColor: AppColors.preto,
                constraints: BoxConstraints(minWidth: (MediaQuery.of(context).size.width - 45) / 2, minHeight: 45),
                children: const [Text("Paciente"), Text("Nutricionista")],
              ),
            ),
            const SizedBox(height: 25),
            const Text("Dados Pessoais", style: TextStyle(fontWeight: FontWeight.bold)),
            _buildTextField("Insira seu nome completo", _nomeController),
            _buildTextField("Insira sua Data de Nascimento", _dataNascController, inputFormatters: [maskFormatter], keyboardType: TextInputType.number),
            
            if (_dataNascController.text.length == 10 && _validarDataNascimento(_dataNascController.text) != null)
              _buildErrorMessage(_validarDataNascimento(_dataNascController.text)!),

            if (_selectedUser == UserType.nutricionista) _buildTextField("Insira seu CRN", _crnController),
            
            const SizedBox(height: 20),
            const Text("Dados de Acesso", style: TextStyle(fontWeight: FontWeight.bold)),
            _buildTextField("E-mail", _emailController, keyboardType: TextInputType.emailAddress),
            _buildTextField("Defina sua senha", _senhaController, obscure: true),
            
            if (_erroRequisitoSenha != null) _buildErrorMessage(_erroRequisitoSenha!, color: Colors.orange),

            _buildTextField("Confirme sua senha", _confirmarSenhaController, obscure: true),
            
            if (_senhasNaoCoincidem) _buildErrorMessage("As senhas não coincidem."),
            
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                // O botão fica desabilitado (null) enquanto carrega
                onPressed: (_formularioCompleto && !_senhasNaoCoincidem && !_estaCarregando) ? _cadastrarNoFirebase : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.roxoEscuro,
                  disabledBackgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: _estaCarregando 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text("Realizar Cadastro", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}