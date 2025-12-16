import 'package:flutter/material.dart';
import '../../../classes/antropometria.dart';
import '../../paciente_repository.dart';

// Página responsável por adicionar ou atualizar
// as medidas antropométricas de um paciente
class AdicionarMedidasPage extends StatefulWidget {
  const AdicionarMedidasPage({super.key});

  @override
  State<AdicionarMedidasPage> createState() => _AdicionarMedidasPageState();
}

class _AdicionarMedidasPageState extends State<AdicionarMedidasPage> {
  // Chave do formulário para controle de validação
  final _formKey = GlobalKey<FormState>();

  // Repositório responsável pelo acesso aos dados de Paciente
  final _repoPaciente = PacienteRepository();

  // ------------------------------------------------------------------
  // CONTROLADORES DOS CAMPOS DE TEXTO
  // ------------------------------------------------------------------

  // Campo para informar o ID do paciente
  final _idPacienteCtrl = TextEditingController();

  // Campos relacionados à composição corporal
  final _massaCorporalCtrl = TextEditingController();
  final _massaGorduraCtrl = TextEditingController();
  final _percGorduraCtrl = TextEditingController();
  final _massaEsqueleticaCtrl = TextEditingController();
  final _imcCtrl = TextEditingController();
  final _cmbCtrl = TextEditingController();
  final _relacaoCinturaQuadrilCtrl = TextEditingController();

  // Libera os recursos dos controladores ao destruir a tela
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

  // ------------------------------------------------------------------
  // MÉTODO PRINCIPAL DE SALVAMENTO
  // ------------------------------------------------------------------
  // Valida o formulário, busca o paciente no banco,
  // cria o objeto Antropometria e salva no SQLite
  void _salvarDados() async {
    // Validação dos campos do formulário
    if (_formKey.currentState!.validate()) {
      // Converte o ID digitado para inteiro
      final int? idDigitado = int.tryParse(_idPacienteCtrl.text);

      // Verifica se o ID é válido
      if (idDigitado == null) {
        _mostrarMensagem("ID do paciente inválido", Colors.red);
        return;
      }

      // 1. Busca o paciente no banco de dados
      final paciente = await _repoPaciente.buscarPorId(idDigitado);

      // Caso o paciente não exista
      if (paciente == null) {
        _mostrarMensagem("Paciente não encontrado!", Colors.red);
        return;
      }

      // 2. Cria o objeto Antropometria com os valores informados
      final novasMedidas = Antropometria(
        massaCorporal: _parse(_massaCorporalCtrl.text),
        massaGordura: _parse(_massaGorduraCtrl.text),
        percentualGordura: _parse(_percGorduraCtrl.text),
        massaEsqueletica: _parse(_massaEsqueleticaCtrl.text),
        imc: _parse(_imcCtrl.text),
        cmb: _parse(_cmbCtrl.text),
        relacaoCinturaQuadril: _parse(_relacaoCinturaQuadrilCtrl.text),
      );

      // 3. Associa as medidas ao paciente
      paciente.antropometria = novasMedidas;

      // 4. Atualiza o paciente no banco
      try {
        await _repoPaciente.atualizar(paciente);

        // Verifica se o widget ainda está montado
        if (!mounted) return;

        // Feedback de sucesso
        _mostrarMensagem(
          "Dados salvos com sucesso para ${paciente.nome}!",
          Colors.green,
        );

        // Retorna para a tela anterior
        Navigator.pop(context);
      } catch (e) {
        // Feedback de erro
        _mostrarMensagem("Erro ao atualizar banco: $e", Colors.red);
      }
    }
  }

  // ------------------------------------------------------------------
  // FUNÇÕES AUXILIARES
  // ------------------------------------------------------------------

  // Converte texto para double
  // Aceita tanto vírgula quanto ponto como separador decimal
  double? _parse(String text) => double.tryParse(text.replaceAll(',', '.'));

  // Exibe mensagens usando SnackBar
  void _mostrarMensagem(String texto, Color cor) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(texto), backgroundColor: cor));
  }

  // Cria um campo numérico reutilizável
  // Usado para todos os inputs de medidas
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
        // Validação: se preenchido, deve ser numérico
        validator: (value) {
          if (value != null && value.isNotEmpty) {
            if (_parse(value) == null) {
              return 'Valor numérico inválido';
            }
          }
          return null;
        },
      ),
    );
  }

  // ------------------------------------------------------------------
  // CONSTRUÇÃO DA INTERFACE
  // ------------------------------------------------------------------
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
              // Campo de identificação do paciente
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

              // ---------------- COMPOSIÇÃO CORPORAL ----------------
              _buildNumericInput(
                controller: _massaCorporalCtrl,
                label: 'Peso (Massa Corporal)',
                suffix: 'kg',
                icon: Icons.monitor_weight_outlined,
              ),

              _buildNumericInput(
                controller: _massaEsqueleticaCtrl,
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

              // ---------------- ÍNDICES ----------------
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

              // Botão de salvamento
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
