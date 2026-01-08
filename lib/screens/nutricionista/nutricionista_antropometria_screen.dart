import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../classes/antropometria.dart';
import '../../database/antropometria_repository.dart';
import '../../widgets/app_colors.dart';

class NutricionistaAntropometriaScreen extends StatefulWidget {
  final int pacienteId;

  const NutricionistaAntropometriaScreen({
    Key? key,
    required this.pacienteId,
  }) : super(key: key);

  @override
  State<NutricionistaAntropometriaScreen> createState() =>
      _NutricionistaAntropometriaScreenState();
}

class _NutricionistaAntropometriaScreenState extends State<NutricionistaAntropometriaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _repository = AntropometriaRepository();

  List<Antropometria> _historico = [];
  bool _isLoading = true;

  String? _idAvaliacaoEmEdicao;
  DateTime? _dataOriginalEmEdicao;

  // Controllers Numéricos
  final _obsCtrl = TextEditingController();
  final _massaCorporalCtrl = TextEditingController();
  final _massaGorduraCtrl = TextEditingController();
  final _percentualGorduraCtrl = TextEditingController();
  final _massaEsqueleticaCtrl = TextEditingController();
  final _imcCtrl = TextEditingController();
  final _cmbCtrl = TextEditingController();
  final _rcqCtrl = TextEditingController();

  String _classMassaCorporal = 'Ideal';
  String _classMassaGordura = 'Ideal';
  String _classPercentualGordura = 'Ideal';
  String _classMassaEsqueletica = 'Ideal';
  String _classImc = 'Ideal';
  String _classCmb = 'Ideal';
  String _classRcq = 'Ideal';

  @override
  void initState() {
    super.initState();
    _carregarHistorico();
  }

  Future<void> _carregarHistorico() async {
    final lista = await _repository.buscarHistorico(widget.pacienteId);
    lista.sort((a, b) =>
        (b.data ?? DateTime.now()).compareTo(a.data ?? DateTime.now()));

    setState(() {
      _historico = lista;
      _isLoading = false;
    });
  }

  void _carregarParaEdicao(Antropometria item) {
    setState(() {
      _idAvaliacaoEmEdicao = item.id_avaliacao;
      _dataOriginalEmEdicao = item.data;

      _classMassaCorporal = item.classMassaCorporal ?? 'Ideal';
      _classMassaGordura = item.classMassaGordura ?? 'Ideal';
      _classPercentualGordura = item.classPercentualGordura ?? 'Ideal';
      _classMassaEsqueletica = item.classMassaEsqueletica ?? 'Ideal';
      _classImc = item.classImc ?? 'Ideal';
      _classCmb = item.classCmb ?? 'Ideal';
      _classRcq = item.classRcq ?? 'Ideal';
    });

    _massaCorporalCtrl.text = item.massaCorporal?.toString() ?? '';
    _massaGorduraCtrl.text = item.massaGordura?.toString() ?? '';
    _percentualGorduraCtrl.text = item.percentualGordura?.toString() ?? '';
    _massaEsqueleticaCtrl.text = item.massaEsqueletica?.toString() ?? '';
    _imcCtrl.text = item.imc?.toString() ?? '';
    _cmbCtrl.text = item.cmb?.toString() ?? '';
    _rcqCtrl.text = item.relacaoCinturaQuadril?.toString() ?? '';
    _obsCtrl.text = item.observacoes ?? '';

    Scrollable.ensureVisible(_formKey.currentContext!,
        duration: const Duration(milliseconds: 500));
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    DateTime dataFinal = (_idAvaliacaoEmEdicao != null && _dataOriginalEmEdicao != null)
        ? _dataOriginalEmEdicao!
        : DateTime.now();

    final novaAvaliacao = Antropometria(
      id_avaliacao: _idAvaliacaoEmEdicao,
      massaCorporal: double.tryParse(_massaCorporalCtrl.text.replaceAll(',', '.')),
      massaGordura: double.tryParse(_massaGorduraCtrl.text.replaceAll(',', '.')),
      percentualGordura: double.tryParse(_percentualGorduraCtrl.text.replaceAll(',', '.')),
      massaEsqueletica: double.tryParse(_massaEsqueleticaCtrl.text.replaceAll(',', '.')),
      imc: double.tryParse(_imcCtrl.text.replaceAll(',', '.')),
      cmb: double.tryParse(_cmbCtrl.text.replaceAll(',', '.')),
      relacaoCinturaQuadril: double.tryParse(_rcqCtrl.text.replaceAll(',', '.')),
   
      classMassaCorporal: _classMassaCorporal,
      classMassaGordura: _classMassaGordura,
      classPercentualGordura: _classPercentualGordura,
      classMassaEsqueletica: _classMassaEsqueletica,
      classImc: _classImc,
      classCmb: _classCmb,
      classRcq: _classRcq,

      observacoes: _obsCtrl.text,
      data: dataFinal,
    );

    await _repository.salvarAvaliacao(widget.pacienteId, novaAvaliacao);

    _limparCampos();
    await _carregarHistorico();

    setState(() => _isLoading = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Salvo com sucesso!'), backgroundColor: Colors.green),
    );
  }

  void _limparCampos() {
    setState(() {
      _idAvaliacaoEmEdicao = null;
      _dataOriginalEmEdicao = null;
      _classMassaCorporal = 'Ideal';
      _classMassaGordura = 'Ideal';
      _classPercentualGordura = 'Ideal';
      _classMassaEsqueletica = 'Ideal';
      _classImc = 'Ideal';
      _classCmb = 'Ideal';
      _classRcq = 'Ideal';
    });
    _massaCorporalCtrl.clear();
    _massaGorduraCtrl.clear();
    _percentualGorduraCtrl.clear();
    _massaEsqueleticaCtrl.clear();
    _imcCtrl.clear();
    _cmbCtrl.clear();
    _rcqCtrl.clear();
    _obsCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    String dataExibida = _dataOriginalEmEdicao != null
        ? DateFormat('dd/MM/yyyy').format(_dataOriginalEmEdicao!)
        : DateFormat('dd/MM/yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: AppColors.roxo,
      appBar: AppBar(
        backgroundColor: AppColors.roxo,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Adicionar/Editar Avaliação', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(_idAvaliacaoEmEdicao != null ? 'Editando' : 'Nova Avaliação',
                                      style: TextStyle(color: AppColors.roxo, fontWeight: FontWeight.bold, fontSize: 16)),
                                    Text(dataExibida, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _obsCtrl,
                                  maxLines: 2,
                                  decoration: InputDecoration(
                                    hintText: 'Observações...',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),
                          Text('Classificação dos Índices', style: TextStyle(color: AppColors.roxo, fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          const Text('Preencha o valor e selecione a classificação:', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          const SizedBox(height: 16),

                          _buildInputComStatus('Massa Corporal', _massaCorporalCtrl, _classMassaCorporal, (val) => setState(() => _classMassaCorporal = val)),
                          _buildInputComStatus('Massa de Gordura', _massaGorduraCtrl, _classMassaGordura, (val) => setState(() => _classMassaGordura = val)),
                          _buildInputComStatus('Percentual de Gordura', _percentualGorduraCtrl, _classPercentualGordura, (val) => setState(() => _classPercentualGordura = val)),
                          _buildInputComStatus('Massa Esquelética', _massaEsqueleticaCtrl, _classMassaEsqueletica, (val) => setState(() => _classMassaEsqueletica = val)),
                          _buildInputComStatus('IMC', _imcCtrl, _classImc, (val) => setState(() => _classImc = val)),
                          _buildInputComStatus('CMB', _cmbCtrl, _classCmb, (val) => setState(() => _classCmb = val)),
                          _buildInputComStatus('Relação C/Q', _rcqCtrl, _classRcq, (val) => setState(() => _classRcq = val)),

                          const SizedBox(height: 24),

                          SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: _salvar, icon: const Icon(Icons.check, color: Colors.white), label: const Text('Salvar'), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4CAF50), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)))),
                          const SizedBox(height: 12),
                          SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: (){ _limparCampos(); Navigator.pop(context); }, icon: const Icon(Icons.close, color: Colors.white), label: const Text('Cancelar'), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF5722), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)))),

                          const SizedBox(height: 30),
                          if (_historico.isNotEmpty) ...[
                             Text('Histórico', style: TextStyle(color: AppColors.roxo, fontSize: 18, fontWeight: FontWeight.bold)),
                             const SizedBox(height: 10),
                             ListView.builder(
                               shrinkWrap: true,
                               physics: const NeverScrollableScrollPhysics(),
                               itemCount: _historico.length,
                               itemBuilder: (ctx, i) => _buildHistoricoItem(_historico[i]),
                             )
                          ]
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInputComStatus(String label, TextEditingController ctrl, String statusAtual, Function(String) onStatusChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
              SizedBox(
                width: 80,
                height: 35,
                child: TextFormField(
                  controller: ctrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(bottom: 10),
                    hintText: '0.0',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildChoiceChip('Abaixo', const Color(0xFF5E6EE6), statusAtual, onStatusChanged), // Azul
              _buildChoiceChip('Ideal', const Color(0xFF4CAF50), statusAtual, onStatusChanged),  // Verde
              _buildChoiceChip('Acima', const Color(0xFFFF7043), statusAtual, onStatusChanged),  // Laranja
            ],
          )
        ],
      ),
    );
  }

  Widget _buildChoiceChip(String label, Color color, String currentSelection, Function(String) onSelect) {
    bool isSelected = currentSelection == label;
    return GestureDetector(
      onTap: () => onSelect(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? color : Colors.grey[300]!),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontSize: 11,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

  Widget _buildHistoricoItem(Antropometria item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
             Text(DateFormat('dd/MM/yyyy').format(item.data!), style: const TextStyle(fontWeight: FontWeight.bold)),
             Text('Peso: ${item.massaCorporal ?? '-'} | Gordura: ${item.percentualGordura ?? '-'}%', style: const TextStyle(fontSize: 12))
           ]),
           ElevatedButton(
             onPressed: () => _carregarParaEdicao(item),
             style: ElevatedButton.styleFrom(backgroundColor: AppColors.roxo, minimumSize: const Size(60, 30)),
             child: const Text('Editar', style: TextStyle(color: Colors.white, fontSize: 10)),
           )
        ],
      ),
    );
  }
}