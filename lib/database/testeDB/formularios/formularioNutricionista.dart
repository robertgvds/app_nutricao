import 'package:flutter/material.dart';
import '../../nutricionista_repository.dart';
import '/classes/nutricionista.dart';

class CadastroNutricionistaPage extends StatefulWidget {
  const CadastroNutricionistaPage({super.key});

  @override
  CadastroNutricionistaPageState createState() =>
      CadastroNutricionistaPageState();
}

class CadastroNutricionistaPageState extends State<CadastroNutricionistaPage> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _codigoController = TextEditingController();
  final _crnController = TextEditingController(); // CRN manual opcional

  final _repoNutri = NutricionistaRepository();

  void _salvarNutricionista() async {
    if (_nomeController.text.isEmpty || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha Nome e Email!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final novoNutri = Nutricionista(
      nome: _nomeController.text,
      email: _emailController.text,
      senha: _senhaController.text,
      codigo: _codigoController.text,
      crn: _crnController.text,
      dataNascimento: "", // Data de nascimento vazia por enquanto
      pacientesIds: [], // Inicializa a lista de pacientes vazia
    );

    try {
      await _repoNutri.inserir(novoNutri);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Nutricionista ${novoNutri.nome} cadastrado! CRN: ${novoNutri.crn}',
          ),
          backgroundColor: Colors.blue,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Novo Nutricionista"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Icon(
                Icons.health_and_safety,
                size: 80,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome Completo',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: _crnController,
                decoration: const InputDecoration(
                  labelText: 'CRN',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Profissional',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 15),

              TextField(
                controller: _senhaController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _salvarNutricionista,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Cadastrar Profissional"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
