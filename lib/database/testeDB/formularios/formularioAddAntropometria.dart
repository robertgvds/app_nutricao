import 'package:flutter/material.dart';
import '../../../classes/antropometria.dart';
import '../../paciente_repository.dart';

class AdicionarMedidasPage extends StatefulWidget {
  const AdicionarMedidasPage({super.key});

  @override
  State<AdicionarMedidasPage> createState() => _AdicionarMedidasPageState();
}

class _AdicionarMedidasPageState extends State<AdicionarMedidasPage> {
  final _formKey = GlobalKey<FormState>();
  final _repoPaciente = PacienteRepository();

  // Controladores
  final _idPacienteCtrl = TextEditingController();
  final _massaCorporalCtrl = TextEditingController();
  final _massaGorduraCtrl = TextEditingController();
  final _percGorduraCtrl = TextEditingController();
  final _massaEsqueleticaCtrl = TextEditingController(); // Mantido
  final _imcCtrl = TextEditingController();
  final _cmbCtrl = TextEditingController(); // Mantido
  final _relacaoCinturaQuadrilCtrl = TextEditingController(); // Mantido

  @override
  void dispose() {
    _idPacienteCtrl.dispose();
    _massaCorporalCtrl.dispose();
    _massaGorduraCtrl.dispose();
    _percGorduraCtrl.dispose();
    _massaEsqueleticaCtrl.dispose();
    _imcCtrl.dispose();
    _cmbCtrl.dispose();
    _relacaoCinturaQuadrilCtrl.dispose();
    super.dispose();
  }

  void _salvarDados() async {
    if (_formKey.currentState!.validate()) {
      final int? idDigitado = int.tryParse(_idPacienteCtrl.text);

      if (idDigitado == null) {
        _mostrarMensagem("ID do paciente inválido", Colors.red);
        return;
      }

      // 1. Busca o paciente no SQLite
      final paciente = await _repoPaciente.buscarPorId(idDigitado);

      if (paciente == null) {
        _mostrarMensagem("Paciente não encontrado!", Colors.red);
        return;
      }

      // 2. Cria o objeto Antropometria com todos os campos mantidos
      final novasMedidas = Antropometria(
        massaCorporal: _parse(_massaCorporalCtrl.text),
        massaGordura: _parse(_massaGorduraCtrl.text),
        percentualGordura: _parse(_percGorduraCtrl.text),
        massaEsqueletica: _parse(_massaEsqueleticaCtrl.text), // Mantido
        imc: _parse(_imcCtrl.text),
        cmb: _parse(_cmbCtrl.text), // Mantido
        relacaoCinturaQuadril: _parse(
          _relacaoCinturaQuadrilCtrl.text,
        ), // Mantido
      );

      // 3. Vincula e Atualiza no Banco
      paciente.antropometria = novasMedidas;

      try {
        await _repoPaciente.atualizar(paciente);
        if (!mounted) return;
        _mostrarMensagem(
          "Dados salvos com sucesso para ${paciente.nome}!",
          Colors.green,
        );
        Navigator.pop(context);
      } catch (e) {
        _mostrarMensagem("Erro ao atualizar banco: $e", Colors.red);
      }
    }
  }

  // Função auxiliar para tratar vírgulas e pontos
  double? _parse(String text) => double.tryParse(text.replaceAll(',', '.'));

  void _mostrarMensagem(String texto, Color cor) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(texto), backgroundColor: cor));
  }

  Widget _buildNumericInput({
    required TextEditingController controller,
    required String label,
    required String suffix,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          suffixText: suffix,
          prefixIcon: icon != null ? Icon(icon) : null,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value != null && value.isNotEmpty) {
            if (_parse(value) == null) return 'Valor numérico inválido';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Avaliação'),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Identificação
              TextFormField(
                controller: _idPacienteCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'ID do Paciente',
                  prefixIcon: Icon(Icons.person_search),
                  border: OutlineInputBorder(),
                ),
                validator:
                    (val) =>
                        (val == null || val.isEmpty)
                            ? 'Campo obrigatório'
                            : null,
              ),
              const Divider(height: 32),

              // Composição Corporal
              _buildNumericInput(
                controller: _massaCorporalCtrl,
                label: 'Peso (Massa Corporal)',
                suffix: 'kg',
                icon: Icons.monitor_weight_outlined,
              ),

              _buildNumericInput(
                controller: _massaEsqueleticaCtrl, // MANTIDO
                label: 'Massa Esquelética',
                suffix: 'kg',
                icon: Icons.accessibility_new,
              ),

              Row(
                children: [
                  Expanded(
                    child: _buildNumericInput(
                      controller: _massaGorduraCtrl,
                      label: 'Massa Gorda',
                      suffix: 'kg',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildNumericInput(
                      controller: _percGorduraCtrl,
                      label: '% Gordura',
                      suffix: '%',
                    ),
                  ),
                ],
              ),

              const Divider(height: 32),

              // Índices Mantidos
              _buildNumericInput(
                controller: _imcCtrl,
                label: 'IMC',
                suffix: 'kg/m²',
                icon: Icons.calculate_outlined,
              ),

              _buildNumericInput(
                controller: _cmbCtrl,
                label: 'Circunferência Muscular do Braço (CMB)',
                suffix: 'cm',
                icon: Icons.fitness_center,
              ),

              _buildNumericInput(
                controller: _relacaoCinturaQuadrilCtrl,
                label: 'Relação Cintura/Quadril (RCQ)',
                suffix: '',
                icon: Icons.straighten,
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _salvarDados,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                child: const Text('SALVAR AVALIAÇÃO'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
