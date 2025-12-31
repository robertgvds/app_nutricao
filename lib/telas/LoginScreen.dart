import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'app_colors.dart';
import 'RegisterScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _estaCarregando = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  // --- LÓGICA DE AUTENTICAÇÃO ---
  Future<void> _fazerLogin() async {
    setState(() => _estaCarregando = true);

    try {
      // 1. Tenta autenticar no Firebase com e-mail e senha
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _senhaController.text.trim(),
          );

      User? user = userCredential.user;

      // Importante: Recarregar o usuário para garantir que o status do e-mail está atualizado
      await user?.reload();
      user = FirebaseAuth.instance.currentUser;

      // 2. VERIFICAÇÃO DE E-MAIL
      if (user != null && !user.emailVerified) {
        // Se não estiver verificado, deslogamos para impedir a sessão ativa
        await FirebaseAuth.instance.signOut();

        if (mounted) {
          _mostrarDialogoVerificacao();
        }
      } else {
        // 3. SUCESSO: E-mail verificado e credenciais corretas
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Login realizado com sucesso!"),
              backgroundColor: Colors.green,
            ),
          );
          // Redirecionar para a Home/Dashboard aqui:
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
        }
      }
    } on FirebaseAuthException catch (e) {
      // Trata erros de credenciais
      String mensagem = "Ocorreu um erro ao entrar.";
      if (e.code == 'user-not-found' || e.code == 'invalid-email')
        mensagem = "E-mail não cadastrado.";
      if (e.code == 'wrong-password' || e.code == 'invalid-credential')
        mensagem = "Senha incorreta.";

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mensagem), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _estaCarregando = false);
    }
  }

  void _mostrarDialogoVerificacao() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("E-mail não verificado"),
            content: const Text(
              "Seu cadastro ainda não está ativo. Por favor, clique no link enviado para o seu e-mail para validar sua conta.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "OK",
                  style: TextStyle(color: AppColors.roxoEscuro),
                ),
              ),
              TextButton(
                onPressed: () async {
                  // Opcional: Reenviar e-mail de verificação (exige login temporário)
                  Navigator.pop(context);
                },
                child: const Text(
                  "Entendi",
                  style: TextStyle(color: AppColors.verdeEscuro),
                ),
              ),
            ],
          ),
    );
  }

  // --- WIDGETS DE DESIGN (MANTIDOS) ---

  // --- LÓGICA DE AUTENTICAÇÃO ---
  Future<void> _fazerLogin() async {
    setState(() => _estaCarregando = true);

    try {
      // 1. Tenta autenticar no Firebase com e-mail e senha
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _senhaController.text.trim(),
          );

      User? user = userCredential.user;

      // Importante: Recarregar o usuário para garantir que o status do e-mail está atualizado
      await user?.reload();
      user = FirebaseAuth.instance.currentUser;

      // 2. VERIFICAÇÃO DE E-MAIL
      if (user != null && !user.emailVerified) {
        // Se não estiver verificado, deslogamos para impedir a sessão ativa
        await FirebaseAuth.instance.signOut();

        if (mounted) {
          _mostrarDialogoVerificacao();
        }
      } else {
        // 3. SUCESSO: E-mail verificado e credenciais corretas
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Login realizado com sucesso!"),
              backgroundColor: Colors.green,
            ),
          );
          // Redirecionar para a Home/Dashboard aqui:
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
        }
      }
    } on FirebaseAuthException catch (e) {
      // Trata erros de credenciais
      String mensagem = "Ocorreu um erro ao entrar.";
      if (e.code == 'user-not-found' || e.code == 'invalid-email')
        mensagem = "E-mail não cadastrado.";
      if (e.code == 'wrong-password' || e.code == 'invalid-credential')
        mensagem = "Senha incorreta.";

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mensagem), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _estaCarregando = false);
    }
  }

  void _mostrarDialogoVerificacao() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("E-mail não verificado"),
            content: const Text(
              "Seu cadastro ainda não está ativo. Por favor, clique no link enviado para o seu e-mail para validar sua conta.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "OK",
                  style: TextStyle(color: AppColors.roxoEscuro),
                ),
              ),
              TextButton(
                onPressed: () async {
                  // Opcional: Reenviar e-mail de verificação (exige login temporário)
                  Navigator.pop(context);
                },
                child: const Text(
                  "Entendi",
                  style: TextStyle(color: AppColors.verdeEscuro),
                ),
              ),
            ],
          ),
    );
  }

  // --- WIDGETS DE DESIGN (MANTIDOS) ---

  Widget _buildLoginTextField(
    String hint,
    TextEditingController controller, {
    bool obscure = false,
  }) {
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
          crossAxisAlignment:
              CrossAxisAlignment.start, // Alinha o botão à esquerda
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
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

            // CONTEÚDO CENTRALIZADO
            Column(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: const BoxDecoration(
                      color: AppColors.roxoClaro,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/fruta_logo.png',
                        fit: BoxFit.contain,
                        errorBuilder:
                            (context, error, stackTrace) => const Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 100,
                              color: AppColors.laranja,
                            ),
                        errorBuilder:
                            (context, error, stackTrace) => const Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 100,
                              color: AppColors.laranja,
                            ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.preto,
                  ),
                ),
                const SizedBox(height: 30),
                _buildLoginTextField("E-mail", _emailController),
                _buildLoginTextField("Senha", _senhaController, obscure: true),
                const SizedBox(height: 25),

                // BOTÃO ENTRAR
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _estaCarregando ? null : _fazerLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.verdeEscuro,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child:
                        _estaCarregando
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              "Entrar",
                              style: TextStyle(
                                color: AppColors.branco,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),

                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      // Lógica de "Esqueci a senha" pode ser adicionada aqui futuramente
                    },
                    child: const Text(
                      "Esqueci a senha",
                      style: TextStyle(
                        color: AppColors.verdeEscuro,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Não tem uma conta? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Cadastre-se",
                        style: TextStyle(
                          color: AppColors.roxoEscuro,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
