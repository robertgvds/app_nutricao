import 'package:flutter/material.dart';
import '../../paciente_repository.dart';
import '../../nutricionista_repository.dart'; // Importação necessária
import '/classes/paciente.dart';
import '/classes/nutricionista.dart'; // Importação necessária

class CadastroPacientePage extends StatefulWidget {
  const CadastroPacientePage({super.key});

  @override
  CadastroPacientePageState createState() => CadastroPacientePageState();
}

class CadastroPacientePageState extends State<CadastroPacientePage> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _codigoController = TextEditingController();
  final _crnNutricionistaController = TextEditingController();

  final _repoPaciente = PacienteRepository();
  final _repoNutri = NutricionistaRepository(); // Repositório do Nutricionista

  void _salvarPaciente() async {
    // 1. Validação básica
    if (_nomeController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _crnNutricionistaController.text.isEmpty) {
      _mostrarMensagem('Nome, Email e CRN são obrigatórios!', Colors.red);
      return;
    }

    try {
      // 2. Verificar se o Nutricionista com esse CRN existe
      final Nutricionista? nutri = await _repoNutri.buscarPorCRN(
        _crnNutricionistaController.text,
      );

      if (nutri == null) {
        _mostrarMensagem(
          'Nenhum nutricionista encontrado com este CRN!',
          Colors.red,
        );
        return;
      }

      // 3. Criar e Inserir o novo Paciente
      final novoPaciente = Paciente(
        nome: _nomeController.text,
        email: _emailController.text,
        senha: _senhaController.text,
        codigo: _codigoController.text,
        dataNascimento: "", // Data de nascimento vazia por enquanto
        nutricionistaCrn: _crnNutricionistaController.text,
      );

      // O método inserir deve retornar o ID (int) gerado pelo banco
      final int novoIdPaciente = await _repoPaciente.inserir(novoPaciente);

      // 4. Atualizar a lista de IDs do Nutricionista
      nutri.adicionarPaciente(novoIdPaciente);

      // 5. Salvar a alteração do Nutricionista no banco de dados
      await _repoNutri.atualizar(nutri);

      if (!mounted) return;

      _mostrarMensagem(
        'Paciente cadastrado e vinculado ao Dr(a). ${nutri.nome}!',
        Colors.green,
      );
      _limparCampos();
    } catch (e) {
      _mostrarMensagem('Erro ao realizar vínculo: $e', Colors.red);
    }
  }

  void _mostrarMensagem(String texto, Color cor) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(texto), backgroundColor: cor));
  }

  void _limparCampos() {
    _nomeController.clear();
    _emailController.clear();
    _senhaController.clear();
    _codigoController.clear();
    _crnNutricionistaController.clear();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _codigoController.dispose();
    _crnNutricionistaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ... (O restante do seu build permanece igual)
    return Scaffold(
      appBar: AppBar(
        title: const Text("Novo Paciente"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Icon(Icons.person_add, size: 80, color: Colors.orange),
              const SizedBox(height: 20),
              TextField(
                controller: _crnNutricionistaController,
                decoration: const InputDecoration(
                  labelText: 'CRN do seu Nutricionista',
                  prefixIcon: Icon(Icons.assignment_ind, color: Colors.orange),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome Completo',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
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
                onPressed: _salvarPaciente,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Finalizar Cadastro"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
