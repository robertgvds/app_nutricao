import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../widgets/app_colors.dart';

class NovaAvaliacaoScreen extends StatefulWidget {
  final String pacienteId;
  // Parâmetro opcional: se vier preenchido, é EDIÇÃO. Se null, é CRIAÇÃO.
  final Map<String, dynamic>? dadosExistentes;

  const NovaAvaliacaoScreen({
    super.key,
    required this.pacienteId,
    this.dadosExistentes,
  });

  @override
  State<NovaAvaliacaoScreen> createState() => _NovaAvaliacaoScreenState();
}

class _NovaAvaliacaoScreenState extends State<NovaAvaliacaoScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores de Texto
  final _pesoController = TextEditingController();
  final _gorduraKgController = TextEditingController();
  final _gorduraPercController = TextEditingController();
  final _esqueleticaController = TextEditingController();
  final _imcController = TextEditingController();
  final _cmbController = TextEditingController();
  final _rcqController = TextEditingController();

  // Variáveis para Classificações (Dropdowns)
  String _classPeso = 'Ideal';
  String _classGorduraKg = 'Ideal';
  String _classGorduraPerc = 'Ideal';
  String _classEsqueletica = 'Ideal';
  String _classImc = 'Ideal';
  String _classCmb = 'Ideal';
  String _classRcq = 'Ideal';

  final List<String> _opcoesClassificacao = ['Abaixo', 'Ideal', 'Acima'];

  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    // SE FOR EDIÇÃO, PREENCHE OS CAMPOS
    if (widget.dadosExistentes != null) {
      _preencherCampos(widget.dadosExistentes!);
    }
  }

  void _preencherCampos(Map<String, dynamic> dados) {
    _pesoController.text = dados['massaCorporal']?.toString() ?? '';
    _classPeso = _validarDropdown(dados['classMassaCorporal']);

    _gorduraKgController.text = dados['massaGordura']?.toString() ?? '';
    _classGorduraKg = _validarDropdown(dados['classMassaGordura']);

    _gorduraPercController.text = dados['percentualGordura']?.toString() ?? '';
    _classGorduraPerc = _validarDropdown(dados['classPercentualGordura']);

    _esqueleticaController.text = dados['massaEsqueletica']?.toString() ?? '';
    _classEsqueletica = _validarDropdown(dados['classMassaEsqueletica']);

    _imcController.text = dados['imc']?.toString() ?? '';
    _classImc = _validarDropdown(dados['classImc']);

    _cmbController.text = dados['cmb']?.toString() ?? '';
    _classCmb = _validarDropdown(dados['classCmb']);

    _rcqController.text = dados['relacaoCinturaQuadril']?.toString() ?? '';
    _classRcq = _validarDropdown(dados['classRcq']);
  }

  String _validarDropdown(dynamic valor) {
    if (valor is String && _opcoesClassificacao.contains(valor)) {
      return valor;
    }
    return 'Ideal'; // Valor padrão de segurança
  }

  Future<void> _salvarNoFirebase() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);

    try {
      // Se for edição, mantém o ID e a Data originais. Se for novo, cria novos.
      final bool isEdicao = widget.dadosExistentes != null;

      final String idAvaliacao =
          isEdicao
              ? widget.dadosExistentes!['id_avaliacao']
              : DateTime.now().millisecondsSinceEpoch.toString();

      final String dataRegistro =
          isEdicao
              ? widget.dadosExistentes!['data']
              : DateTime.now().toIso8601String();

      final ref = FirebaseDatabase.instance.ref().child(
        'antropometria/${widget.pacienteId}/$idAvaliacao',
      );

      await ref.set({
        "id_avaliacao": idAvaliacao,
        "data": dataRegistro,
        "massaCorporal": double.tryParse(_pesoController.text) ?? 0.0,
        "classMassaCorporal": _classPeso,
        "massaGordura": double.tryParse(_gorduraKgController.text) ?? 0.0,
        "classMassaGordura": _classGorduraKg,
        "percentualGordura":
            double.tryParse(_gorduraPercController.text) ?? 0.0,
        "classPercentualGordura": _classGorduraPerc,
        "massaEsqueletica": double.tryParse(_esqueleticaController.text) ?? 0.0,
        "classMassaEsqueletica": _classEsqueletica,
        "imc": double.tryParse(_imcController.text) ?? 0.0,
        "classImc": _classImc,
        "cmb": double.tryParse(_cmbController.text) ?? 0.0,
        "classCmb": _classCmb,
        "relacaoCinturaQuadril": double.tryParse(_rcqController.text) ?? 0.0,
        "classRcq": _classRcq,
        "observacoes": isEdicao ? "Atualizado via App" : "Inserido via App",
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEdicao ? "Avaliação atualizada!" : "Avaliação criada!",
          ),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao salvar: $e")));
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = AppColors.laranja;
    final bool isEdicao = widget.dadosExistentes != null;

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text(
          isEdicao ? "Editar Avaliação" : "Nova Avaliação",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildInputGroup(
                      "Massa Corporal (kg)",
                      _pesoController,
                      _classPeso,
                      (val) => setState(() => _classPeso = val!),
                    ),
                    _buildInputGroup(
                      "Massa de Gordura (kg)",
                      _gorduraKgController,
                      _classGorduraKg,
                      (val) => setState(() => _classGorduraKg = val!),
                    ),
                    _buildInputGroup(
                      "% de Gordura",
                      _gorduraPercController,
                      _classGorduraPerc,
                      (val) => setState(() => _classGorduraPerc = val!),
                    ),
                    _buildInputGroup(
                      "Massa Esquelética (kg)",
                      _esqueleticaController,
                      _classEsqueletica,
                      (val) => setState(() => _classEsqueletica = val!),
                    ),
                    _buildInputGroup(
                      "IMC",
                      _imcController,
                      _classImc,
                      (val) => setState(() => _classImc = val!),
                    ),
                    _buildInputGroup(
                      "CMB (cm)",
                      _cmbController,
                      _classCmb,
                      (val) => setState(() => _classCmb = val!),
                    ),
                    _buildInputGroup(
                      "RCQ",
                      _rcqController,
                      _classRcq,
                      (val) => setState(() => _classRcq = val!),
                    ),

                    const SizedBox(height: 30),
                    SizedBox(
                      height: 55,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _salvando ? null : _salvarNoFirebase,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child:
                            _salvando
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : Text(
                                  isEdicao
                                      ? "ATUALIZAR DADOS"
                                      : "SALVAR AVALIAÇÃO",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputGroup(
    String label,
    TextEditingController controller,
    String valorDropdown,
    ValueChanged<String?> onChangedDropdown,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    hintText: "0.0",
                    isDense: true,
                  ),
                  validator: (v) => v!.isEmpty ? "Obrigatório" : null,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<String>(
                  value: valorDropdown,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    isDense: true,
                    labelText: "Status",
                  ),
                  items:
                      _opcoesClassificacao.map((String status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(
                            status,
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                  onChanged: onChangedDropdown,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
