import 'package:flutter/material.dart';
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

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

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
        padding: const EdgeInsets.all(20), // Ajustado para alinhar com o botão
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Alinha o botão à esquerda
          children: [
            const SizedBox(height: 30),
            // BOTÃO VOLTAR
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
                    decoration: BoxDecoration(
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

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      // Lógica de login futura
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.verdeEscuro,
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

                const SizedBox(height: 15),

                // Esqueci a senha
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {},
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

                // Opção de Cadastro
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
