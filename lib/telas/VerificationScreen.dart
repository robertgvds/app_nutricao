import 'package:app/database/nutricionista_repository.dart';
import 'package:app/database/paciente_repository.dart';
import 'package:app/telas/LoginScreen.dart';
import 'package:app/telas/RegisterScreen.dart';

import '/classes/usuario.dart'; // Import do seu model
import '/classes/paciente.dart';
import '/classes/nutricionista.dart';

import 'package:flutter/material.dart';
import 'app_colors.dart';

class TelaConfirmacaoCodigo extends StatefulWidget {
  final Usuario usuario;
  final UserType userType;
  final String crn;

  const TelaConfirmacaoCodigo({
    super.key,
    required this.usuario,
    required this.userType,
    required this.crn,
  });

  @override
  State<TelaConfirmacaoCodigo> createState() => _TelaConfirmacaoCodigoState();
}

class _TelaConfirmacaoCodigoState extends State<TelaConfirmacaoCodigo> {
  final _codigoController = TextEditingController();

  final _repoPaciente = PacienteRepository();
  final _repoNutricionista = NutricionistaRepository();

  bool _codigoInvalido = false;

  @override
  void dispose() {
    _codigoController.dispose();
    super.dispose();
  }

  void _verificarCodigo() async {
    if (_codigoController.text == "1234") {
      // ALTERAR VERIFICAÇÃO
      setState(() => _codigoInvalido = false);

      try {
        if (widget.userType == UserType.paciente) {
          // Cria um objeto Paciente a partir dos dados do widget.usuario (que veio da tela de registro)
          Paciente novoPaciente = Paciente(
            nome: widget.usuario.nome,
            email: widget.usuario.email,
            senha: widget.usuario.senha,
            dataNascimento:
                "0000-00-00", // Placeholder, ajustar conforme necessário dps
            codigo: widget.usuario.codigo,
          );

          await _repoPaciente.inserir(novoPaciente);
          print("✅ PACIENTE SALVO");
        } else {
          Nutricionista novoNutri = Nutricionista(
            nome: widget.usuario.nome,
            email: widget.usuario.email,
            senha: widget.usuario.senha,
            codigo: widget.usuario.codigo,
            dataNascimento:
                "0000-00-00", // Placeholder, ajustar conforme necessário dps
            crn: widget.crn,
          );

          await _repoNutricionista.inserir(novoNutri);
          print("✅ NUTRICIONISTA SALVO");
        }

        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      } catch (e) {
        print("Erro detalhado: $e");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Erro ao salvar: $e")));
      }
    } else {
      setState(() => _codigoInvalido = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.branco,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.preto,
                  size: 28,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 10),
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: Image.asset(
                        'assets/fruta_logo.png',
                        fit: BoxFit.contain,
                        errorBuilder:
                            (context, error, stackTrace) => const Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 100,
                              color: AppColors.laranja,
                            ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.preto,
                        ),
                        children: [
                          const TextSpan(text: "Olá, "),
                          TextSpan(
                            text:
                                widget
                                    .usuario
                                    .nome, // Puxa o nome do objeto usuario
                            style: const TextStyle(
                              color: AppColors.verdeEscuro,
                            ),
                          ),
                          const TextSpan(text: "!"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Um código de verificação foi enviado para o seu e-mail.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Divider(thickness: 1, color: AppColors.cinza),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _codigoController,
                      keyboardType: TextInputType.number,
                      cursorColor: AppColors.roxoEscuro,
                      decoration: InputDecoration(
                        hintText: "Digite o código de confirmação",
                        filled: true,
                        fillColor: AppColors.cinzaClaro,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 18,
                        ),
                      ),
                    ),
                    if (_codigoInvalido)
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 15, top: 10),
                          child: Text(
                            "Código Incorreto!",
                            style: TextStyle(
                              color: AppColors.laranjaEscuro,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _verificarCodigo,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.roxoEscuro,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Entrar",
                          style: TextStyle(
                            color: AppColors.branco,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TelaLoginMock extends StatelessWidget {
  const TelaLoginMock({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text("Tela de Login")));
}
