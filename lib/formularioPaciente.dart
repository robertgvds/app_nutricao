import 'package:flutter/material.dart';
import 'database/paciente_repository.dart';
import '/classes/paciente.dart';

class CadastroPacientePage extends StatefulWidget {
  const CadastroPacientePage({Key? key}) : super(key: key);

  @override
  _CadastroPacientePageState createState() => _CadastroPacientePageState();
}

class _CadastroPacientePageState extends State<CadastroPacientePage> {
  // 1. Controladores
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _codigoController = TextEditingController();
  // Controlador especial para a lista
  final _refeicoesController = TextEditingController();

  // 2. Repositório correto
  final _repoPaciente = PacienteRepository();

  // Função para salvar
  void _salvarPaciente() async {
    // Validação básica
    if (_nomeController.text.isEmpty || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha pelo menos Nome e Email!')),
      );
      return;
    }

    // --- LÓGICA IMPORTANTE: STRING PARA LISTA ---
    // Pega o texto "Café, Almoço, Jantar" e transforma em ["Café", "Almoço", "Jantar"]
    List<String> listaRefeicoes =
        _refeicoesController.text
            .split(',') // Corta onde tem vírgula
            .map(
              (e) => e.trim(),
            ) // Remove espaços em branco antes/depois (ex: " Almoço " vira "Almoço")
            .where((e) => e.isNotEmpty) // Garante que não fiquem itens vazios
            .toList();

    // 3. Criar o objeto Paciente
    final novoPaciente = Paciente(
      nome: _nomeController.text,
      email: _emailController.text,
      senha: _senhaController.text,
      codigo: _codigoController.text,
      refeicoes: listaRefeicoes, // Passamos a lista processada aqui
    );

    // 4. Salvar no banco
    await _repoPaciente.inserir(novoPaciente);

    // Feedback
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Paciente ${_nomeController.text} salvo!')),
    );

    // Limpar campos
    _nomeController.clear();
    _emailController.clear();
    _senhaController.clear();
    _codigoController.clear();
    _refeicoesController.clear();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _codigoController.dispose();
    _refeicoesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Novo Paciente"),
        backgroundColor: Colors.orange, // Cor laranja para diferenciar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Icon(Icons.person_outline, size: 80, color: Colors.orange),
              const SizedBox(height: 20),

              // --- CAMPOS ---
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Paciente',
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

              // CAMPO ESPECIAL DE REFEIÇÕES
              TextField(
                controller: _refeicoesController,
                decoration: const InputDecoration(
                  labelText: 'Refeições (Separe por vírgula)',
                  hintText: 'Ex: Café, Almoço, Lanche da Tarde',
                  prefixIcon: Icon(Icons.restaurant),
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
                onPressed: _salvarPaciente,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Cadastrar Paciente"),
              ),

              const SizedBox(height: 10),

              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Cancelar / Voltar",
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
