import 'package:flutter/material.dart';
import 'database/nutricionista_repository.dart';
import '/classes/nutricionista.dart';

class CadastroNutricionistaPage extends StatefulWidget {
  const CadastroNutricionistaPage({Key? key}) : super(key: key);

  @override
  _CadastroNutricionistaPageState createState() =>
      _CadastroNutricionistaPageState();
}

class _CadastroNutricionistaPageState extends State<CadastroNutricionistaPage> {
  // 1. Controladores (Incluindo o CRN)
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _crnController = TextEditingController(); // Novo controlador
  final _codigoController = TextEditingController();

  // 2. Repositório correto
  final _repoNutricionista = NutricionistaRepository();

  // Função para salvar
  void _salvarNutricionista() async {
    // Validação simples
    if (_nomeController.text.isEmpty || _crnController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nome e CRN são obrigatórios!')),
      );
      return;
    }

    // 3. Criar o objeto Nutricionista
    final novoNutricionista = Nutricionista(
      nome: _nomeController.text,
      email: _emailController.text,
      senha: _senhaController.text,
      crn: _crnController.text, // Campo específico
      codigo: _codigoController.text,
    );

    // 4. Salvar usando o repositório de Nutricionista
    await _repoNutricionista.inserir(novoNutricionista);

    // Feedback
    if (!mounted) return; // Checagem de segurança do Flutter
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Nutri ${_nomeController.text} salvo com sucesso!'),
      ),
    );

    // Limpar campos
    _nomeController.clear();
    _emailController.clear();
    _senhaController.clear();
    _crnController.clear();
    _codigoController.clear();
  }

  @override
  void dispose() {
    // Limpeza da memória
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _crnController.dispose();
    _codigoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Novo Nutricionista"),
        backgroundColor: Colors.green, // Cor diferente para diferenciar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Icon(
                Icons.health_and_safety,
                size: 80,
                color: Colors.green,
              ),
              const SizedBox(height: 20),

              // --- CAMPOS ---
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome Completo',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 15),

              TextField(
                controller: _crnController,
                decoration: const InputDecoration(
                  labelText: 'CRN (Registro)',
                  prefixIcon: Icon(Icons.badge),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: _senhaController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 15),

              TextField(
                controller: _codigoController,
                decoration: const InputDecoration(
                  labelText: 'Código de Acesso',
                  prefixIcon: Icon(Icons.vpn_key),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),

              // --- BOTÃO SALVAR ---
              ElevatedButton(
                onPressed: _salvarNutricionista,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Cadastrar Nutricionista"),
              ),

              const SizedBox(height: 10),

              // BOTÃO VOLTAR
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancelar / Voltar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
