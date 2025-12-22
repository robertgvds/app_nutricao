import 'package:flutter/material.dart';
import 'package:app/database/usuario_repository.dart'; // Import do seu repositório
import '/classes/usuario.dart'; // Import do seu model
import 'app_colors.dart';

class TelaConfirmacaoCodigo extends StatefulWidget {
  final Usuario usuario;

  const TelaConfirmacaoCodigo({super.key, required this.usuario});

  @override
  State<TelaConfirmacaoCodigo> createState() => _TelaConfirmacaoCodigoState();
}

class _TelaConfirmacaoCodigoState extends State<TelaConfirmacaoCodigo> {
  final _codigoController = TextEditingController();
  final _repoUsuario = UsuarioRepository(); // Instância do repositório
  bool _codigoInvalido = false;

  @override
  void dispose() {
    _codigoController.dispose();
    super.dispose();
  }

  // FUNÇÃO ATUALIZADA: Salva no banco antes de navegar
  void _verificarCodigo() async {
    // Verificação Mock (simulada)
    if (_codigoController.text == "1234") {
      setState(() => _codigoInvalido = false);

      try {
        await _repoUsuario.inserir(widget.usuario);

        if (!mounted) return;

        // 2. Feedback de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Cadastro realizado com sucesso!"),
            backgroundColor: AppColors.verdeEscuro,
          ),
        );

        // 3. Navega para a tela de Login e limpa a pilha de navegação
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const TelaLoginMock()),
          (route) => false,
        );
      } catch (e) {
        // Tratar erro de inserção no banco
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao salvar no banco de dados.")),
        );
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
                icon: const Icon(Icons.arrow_back, color: AppColors.preto, size: 28),
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
                        errorBuilder: (context, error, stackTrace) => 
                          const Icon(Icons.add_photo_alternate_outlined, size: 100, color: AppColors.laranja),
                      ),
                    ),
                    const SizedBox(height: 20),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.preto),
                        children: [
                          const TextSpan(text: "Olá, "),
                          TextSpan(
                            text: widget.usuario.nome, // Puxa o nome do objeto usuario
                            style: const TextStyle(color: AppColors.verdeEscuro),
                          ),
                          const TextSpan(text: "!"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Após a validação dos dados, enviaremos um código de verificação para o seu e-mail.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
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
                        contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                      ),
                    ),
                    if (_codigoInvalido)
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 15, top: 10),
                          child: Text(
                            "Digite o código correto!",
                            style: TextStyle(color: AppColors.laranjaEscuro, fontSize: 14),
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
                          style: TextStyle(color: AppColors.branco, fontSize: 18, fontWeight: FontWeight.bold),
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
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text("Tela de Login")));
}