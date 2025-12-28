import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/classes/usuario.dart';
import '/classes/paciente.dart';
import '/classes/nutricionista.dart';

import '/database/paciente_repository.dart';
import '/database/nutricionista_repository.dart';

import 'app_colors.dart';
import 'LoginScreen.dart';
import 'RegisterScreen.dart';

class TelaConfirmacaoCodigo extends StatefulWidget {
  final Usuario usuario;
  final UserType userType;
  final String crn;

  const TelaConfirmacaoCodigo({super.key, required this.usuario, required this.userType, required this.crn});

  @override
  State<TelaConfirmacaoCodigo> createState() => _TelaConfirmacaoCodigoState();
}

class _TelaConfirmacaoCodigoState extends State<TelaConfirmacaoCodigo> {
  Timer? _timer;
  bool _emailVerificado = false;

  @override
  void initState() {
    super.initState();
    // Checa o status do e-mail a cada 3 segundos automaticamente
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _checarEmailVerificado());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _checarEmailVerificado() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload(); // Atualiza o estado do Firebase

    if (user != null && user.emailVerified && !_emailVerificado) {
      _timer?.cancel();
      setState(() => _emailVerificado = true);
      _finalizarCadastro();
    }
  }

  Future<void> _finalizarCadastro() async {
    try {
      if (widget.userType == UserType.paciente) {
        final repo = PacienteRepository();
        await repo.inserir(Paciente(
          nome: widget.usuario.nome,
          email: widget.usuario.email,
          senha: widget.usuario.senha,
          dataNascimento: widget.usuario.dataNascimento,
          codigo: widget.usuario.codigo,
        ));
      } else {
        final repo = NutricionistaRepository();
        await repo.inserir(Nutricionista(
          nome: widget.usuario.nome,
          email: widget.usuario.email,
          senha: widget.usuario.senha,
          dataNascimento: widget.usuario.dataNascimento,
          codigo: widget.usuario.codigo,
          crn: widget.crn,
        ));
      }
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
      }
    } catch (e) {
      print("Erro ao salvar no banco: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.branco,
      body: Center(
        child: Padding (
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.mark_email_read_outlined, size: 80, color: AppColors.verdeEscuro),
              const SizedBox(height: 20),
              Text("Olá, ${widget.usuario.nome}!", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text(
                "Enviamos um link de verificação para o seu e-mail. Por favor, clique no link para ativar sua conta.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              const CircularProgressIndicator(color: AppColors.roxoEscuro),
              const SizedBox(height: 20),
              const Text("Aguardando verificação...", style: TextStyle(fontStyle: FontStyle.italic)),
              const SizedBox(height: 40),
              TextButton(
                onPressed: () => FirebaseAuth.instance.currentUser?.sendEmailVerification(),
                child: const Text("Reenviar e-mail de verificação", style: TextStyle(color: AppColors.roxoEscuro, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        )
      ),
    );
  }
}