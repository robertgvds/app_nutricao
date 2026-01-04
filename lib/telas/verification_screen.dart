import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../widgets/auth_check.dart'; // Ou a tua tela principal/Home
import 'app_colors.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  bool _estaCarregandoVerificacao = false;
  bool _estaCarregandoReenvio = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // ESTRATÉGIA MAIS VIÁVEL: Verificar automaticamente a cada 3 segundos
    // Assim o utilizador não precisa de clicar em nada após validar o e-mail
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _verificarStatus(silencioso: true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // IMPORTANTE: Cancela o timer ao sair da tela
    super.dispose();
  }

  // Função para checar o status (manual ou automática)
  Future<void> _verificarStatus({bool silencioso = false}) async {
    if (!silencioso) setState(() => _estaCarregandoVerificacao = true);
    
    final auth = Provider.of<AuthService>(context, listen: false);
    bool ok = await auth.checarEmailVerificado();
    
    if (mounted && ok) {
      _timer?.cancel();
      // Se verificado, manda para o AuthCheck que redirecionará para a Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthCheck()),
      );
    } else if (mounted && !silencioso) {
      // Só mostra mensagem se o utilizador clicou manualmente e não está verificado
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("O e-mail ainda não foi verificado. Verifique a sua caixa de entrada."),
          backgroundColor: Colors.orange,
        ),
      );
    }

    if (mounted && !silencioso) setState(() => _estaCarregandoVerificacao = false);
  }

  Future<void> _reenviarEmail() async {
    setState(() => _estaCarregandoReenvio = true);
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      await auth.reenviarEmailVerificacao();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Novo link de ativação enviado!"),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao reenviar: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _estaCarregandoReenvio = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.branco,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.mark_email_read_outlined, size: 100, color: AppColors.roxoEscuro),
              const SizedBox(height: 20),
              const Text(
                "Quase lá!",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.roxoEscuro),
              ),
              const SizedBox(height: 15),
              const Text(
                "Enviámos um link de confirmação para o seu e-mail.\nPor favor, clique no link para ativar a sua conta.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 40),
              
              // Botão Principal
              SizedBox(
                width: double.infinity, 
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.roxoEscuro,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: _estaCarregandoVerificacao ? null : () => _verificarStatus(),
                  child: _estaCarregandoVerificacao 
                      ? const CircularProgressIndicator(color: Colors.white) 
                      : const Text("JÁ VERIFIQUEI", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              
              const SizedBox(height: 20),

              // Reenviar E-mail
              TextButton(
                onPressed: _estaCarregandoReenvio ? null : _reenviarEmail,
                child: _estaCarregandoReenvio 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text("Não recebeu o e-mail? Reenviar agora", style: TextStyle(color: AppColors.roxoEscuro)),
              ),

              const SizedBox(height: 50),
              
              // Sair/Trocar conta
              TextButton(
                onPressed: () {
                  _timer?.cancel();
                  Provider.of<AuthService>(context, listen: false).logout();
                },
                child: const Text("Sair ou usar outra conta", style: TextStyle(color: Colors.redAccent)),
              )
            ],
          ),
        ),
      ),
    );
  }
}