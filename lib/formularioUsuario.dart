import 'package:flutter/material.dart';
import 'database/usuario_repository.dart';
import '/classes/usuario.dart';

class CadastroUsuarioPage extends StatefulWidget {
  @override
  _CadastroUsuarioPageState createState() => _CadastroUsuarioPageState();
}

class _CadastroUsuarioPageState extends State<CadastroUsuarioPage> {
  // 1. Criar os controladores para capturar o texto
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _codigoController = TextEditingController();

  final _repoUsuario = UsuarioRepository();

  // Função para salvar no banco
  void _salvarUsuario() async {
    // Validação simples
    if (_nomeController.text.isEmpty || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Preencha nome e email!')));
      return;
    }

    // 2. Criar o objeto com os dados dos controladores (.text)
    final novoUsuario = Usuario(
      nome: _nomeController.text,
      email: _emailController.text,
      senha: _senhaController.text,
      codigo: _codigoController.text,
    );

    // 3. Chamar o repositório
    await _repoUsuario.inserir(novoUsuario);

    // Feedback visual e limpar campos
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Usuário ${_nomeController.text} salvo com sucesso!'),
      ),
    );

    // Opcional: Voltar para a tela anterior após salvar
    // Navigator.pop(context);

    // Ou apenas limpar os campos para novo cadastro:
    _nomeController.clear();
    _emailController.clear();
    _senhaController.clear();
    _codigoController.clear();
  }

  @override
  void dispose() {
    // Sempre limpe os controladores quando a tela for fechada
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _codigoController.dispose();
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
              // CAMPOS DE TEXTO
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
                obscureText: true, // Ocultar senha
              ),
              TextField(
                controller: _codigoController,
                decoration: const InputDecoration(labelText: 'Código'),
              ),
              const SizedBox(height: 20),

              // BOTÃO SALVAR
              ElevatedButton(
                onPressed: _salvarUsuario,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50), // Botão largo
                ),
                child: const Text("Salvar no Banco de Dados"),
              ),

              const SizedBox(height: 20),

              // BOTÃO PARA VOLTAR
              ElevatedButton(
                // 👈 A chave é esta função: Navigator.pop(context)
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Voltar para a Tela Principal"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
