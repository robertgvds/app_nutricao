import 'package:flutter/material.dart';
import '../../usuario_repository.dart';
import '/classes/usuario.dart';

class CadastroUsuarioPage extends StatefulWidget {
  @override
  CadastroUsuarioPageState createState() => CadastroUsuarioPageState();
}

class CadastroUsuarioPageState extends State<CadastroUsuarioPage> {
  // Controllers do Formulário de Cadastro
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _codigoController = TextEditingController();

  // Controller e Variável para o Teste de Verificação
  final _pesquisaEmailController = TextEditingController();
  String _resultadoPesquisa = ''; // Vai armazenar o texto do resultado
  Color _corResultado = Colors.black; // Para mudar a cor (Verde/Vermelho)

  final _repoUsuario = UsuarioRepository();

  // Função para salvar no banco (Cadastro)
  void _salvarUsuario() async {
    final novoUsuario = Usuario(
      nome: _nomeController.text,
      email: _emailController.text,
      senha: _senhaController.text,
      codigo: _codigoController.text,
      dataNascimento: "", // Data de nascimento vazia por enquanto
    );
    await _repoUsuario.inserir(novoUsuario);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Usuário ${_nomeController.text} salvo com sucesso!'),
      ),
    );
    _nomeController.clear();
    _emailController.clear();
    _senhaController.clear();
    _codigoController.clear();
  }

  // NOVA FUNÇÃO: Testa se o email existe
  void _verificarEmail() async {
    final emailParaVerificar = _pesquisaEmailController.text.trim();

    if (emailParaVerificar.isEmpty) {
      setState(() {
        _resultadoPesquisa = "Digite um email para pesquisar.";
        _corResultado = Colors.orange;
      });
      return;
    }

    // Chama o método novo do repositório
    final bool existe = await _repoUsuario.verificarEmailExiste(
      emailParaVerificar,
    );

    setState(() {
      if (existe) {
        _resultadoPesquisa = "True (Email encontrado no banco)";
        _corResultado = Colors.green; // Verde para positivo/encontrado
      } else {
        _resultadoPesquisa = "False (Email não existe)";
        _corResultado = Colors.red; // Vermelho para negativo
      }
    });
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _codigoController.dispose();
    _pesquisaEmailController
        .dispose(); // Não esquecer de limpar o novo controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Novo Usuário")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ==========================================
              // ÁREA DE CADASTRO
              // ==========================================
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _senhaController,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
              ),
              TextField(
                controller: _codigoController,
                decoration: const InputDecoration(labelText: 'Código'),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _salvarUsuario,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Salvar no Banco de Dados"),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Voltar para a Tela Principal"),
              ),

              const SizedBox(height: 40),

              // ==========================================
              // ÁREA DE TESTE DA NOVA FUNÇÃO
              // ==========================================
              const Divider(thickness: 2, color: Colors.blueGrey),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Área de Teste: Verificar Email",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),

              TextField(
                controller: _pesquisaEmailController,
                decoration: const InputDecoration(
                  labelText: 'Pesquisar Email existente',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 10),

              ElevatedButton.icon(
                onPressed: _verificarEmail,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text("Verificar no Banco"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                ),
              ),

              const SizedBox(height: 15),

              // Exibição do Resultado
              if (_resultadoPesquisa.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  color: _corResultado.withValues(alpha: 0.5),
                  child: Text(
                    _resultadoPesquisa,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _corResultado,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),

              const SizedBox(height: 30), // Espaço extra no final da rolagem
            ],
          ),
        ),
      ),
    );
  }
}
