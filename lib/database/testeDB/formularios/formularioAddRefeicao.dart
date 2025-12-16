import 'package:flutter/material.dart';
import '../../paciente_repository.dart'; // Seu repositório
import '../../../classes/paciente.dart'; // Sua classe Paciente
import '../../../classes/refeicao.dart'; // A classe Refeicao criada anteriormente
import '../../../classes/alimento.dart'; // A classe Alimento criada anteriormente

class AdicionarRefeicaoPage extends StatefulWidget {
  const AdicionarRefeicaoPage({super.key});

  @override
  AdicionarRefeicaoPageState createState() => AdicionarRefeicaoPageState();
}

class AdicionarRefeicaoPageState extends State<AdicionarRefeicaoPage> {
  final _repoPaciente = PacienteRepository();

  // Controladores
  final _idBuscaController = TextEditingController();
  final _nomeRefeicaoController = TextEditingController();

  // Controladores para um alimento inicial (opcional, para a refeição não ficar vazia)
  final _alimentoNomeController = TextEditingController();
  final _alimentoPesoController = TextEditingController();
  final _alimentoCaloriasController = TextEditingController();

  // Estado da tela
  Paciente? _pacienteEncontrado;
  String _mensagemStatus = '';
  bool _buscando = false;

  // 1. Função de Busca
  void _buscarPaciente() async {
    setState(() {
      _buscando = true;
      _mensagemStatus = '';
      _pacienteEncontrado = null;
    });

    if (_idBuscaController.text.isEmpty) {
      setState(() {
        _mensagemStatus = 'Por favor, digite um ID.';
        _buscando = false;
      });
      return;
    }

    try {
      int id = int.parse(_idBuscaController.text);

      // OBS: Você precisará implementar o método buscarPorId no seu repositório
      final paciente = await _repoPaciente.buscarPorId(id);

      setState(() {
        if (paciente != null) {
          _pacienteEncontrado = paciente;
          _mensagemStatus = 'Paciente encontrado: ${paciente.nome}';
        } else {
          _mensagemStatus = 'Paciente com ID $id não encontrado.';
        }
        _buscando = false;
      });
    } catch (e) {
      setState(() {
        _mensagemStatus = 'Erro ao buscar: $e';
        _buscando = false;
      });
    }
  }

  // 2. Função de Adicionar Refeição
  void _adicionarRefeicao() async {
    if (_pacienteEncontrado == null) return;
    if (_nomeRefeicaoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dê um nome para a refeição (ex: Almoço)'),
        ),
      );
      return;
    }

    // Cria o objeto Alimento (opcional, apenas se preenchido)
    List<Alimento> listaAlimentos = [];
    if (_alimentoNomeController.text.isNotEmpty) {
      listaAlimentos.add(
        Alimento(
          nome: _alimentoNomeController.text,
          peso: double.tryParse(_alimentoPesoController.text) ?? 0,
          calorias: double.tryParse(_alimentoCaloriasController.text) ?? 0,
        ),
      );
    }

    // Cria a nova Refeição
    final novaRefeicao = Refeicao(
      nome: _nomeRefeicaoController.text,
      alimentos: listaAlimentos,
    );

    // Adiciona na lista do paciente existente
    // Precisamos criar uma nova lista baseada na antiga para o Flutter detectar mudança se necessário,
    // ou apenas adicionar direto.
    _pacienteEncontrado!.refeicoes.add(novaRefeicao);

    // Salva no banco (Update)
    // OBS: Você precisará implementar o método atualizar no seu repositório
    await _repoPaciente.atualizar(_pacienteEncontrado!);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Refeição adicionada para ${_pacienteEncontrado!.nome}!'),
      ),
    );

    // Limpa campos da refeição
    _nomeRefeicaoController.clear();
    _alimentoNomeController.clear();
    _alimentoPesoController.clear();
    _alimentoCaloriasController.clear();
    // Força atualização da tela para mostrar totais se quiser
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Adicionar Refeição")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // --- ÁREA DE BUSCA ---
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      "Buscar Paciente",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _idBuscaController,
                            decoration: const InputDecoration(
                              labelText: 'ID do Paciente',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _buscarPaciente,
                          child:
                              _buscando
                                  ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                  : const Icon(Icons.search),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _mensagemStatus,
                      style: TextStyle(
                        color:
                            _pacienteEncontrado != null
                                ? Colors.green
                                : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // --- ÁREA DE EDIÇÃO (Só aparece se encontrou paciente) ---
            if (_pacienteEncontrado != null) ...[
              const Divider(),
              Text(
                "Adicionar Refeição para: ${_pacienteEncontrado!.nome}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: _nomeRefeicaoController,
                decoration: const InputDecoration(
                  labelText: 'Nome da Refeição (ex: Jantar)',
                  prefixIcon: Icon(Icons.restaurant_menu),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                "Adicionar 1º Alimento (Opcional)",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _alimentoNomeController,
                      decoration: const InputDecoration(
                        labelText: 'Alimento (ex: Arroz)',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _alimentoPesoController,
                      decoration: const InputDecoration(labelText: 'Peso (g)'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              TextField(
                controller: _alimentoCaloriasController,
                decoration: const InputDecoration(labelText: 'Calorias (kcal)'),
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _adicionarRefeicao,
                icon: const Icon(Icons.save),
                label: const Text("Salvar Refeição no Paciente"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
