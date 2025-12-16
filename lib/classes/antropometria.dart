class Antropometria {
  double? massaCorporal;
  double? massaGordura;
  double? percentualGordura;
  double? massaEsqueletica;
  double? imc;
  double? cmb;
  double? relacaoCinturaQuadril;

  Antropometria({
    this.massaCorporal,
    this.massaGordura,
    this.percentualGordura,
    this.massaEsqueletica,
    this.imc,
    this.cmb,
    this.relacaoCinturaQuadril,
  });

  // Converte para Map (para salvar no BD)
  Map<String, dynamic> toMap() {
    return {
      'massaCorporal': massaCorporal,
      'massaGordura': massaGordura,
      'percentualGordura': percentualGordura,
      'massaEsqueletica': massaEsqueletica,
      'imc': imc,
      'cmb': cmb,
      'relacaoCinturaQuadril': relacaoCinturaQuadril,
    };
  }

  // Cria a partir de um Map (para ler do BD)
  factory Antropometria.fromMap(Map<String, dynamic> map) {
    return Antropometria(
      massaCorporal: (map['massaCorporal'] as num?)?.toDouble(),
      massaGordura: (map['massaGordura'] as num?)?.toDouble(),
      percentualGordura: (map['percentualGordura'] as num?)?.toDouble(),
      massaEsqueletica: (map['massaEsqueletica'] as num?)?.toDouble(),
      imc: (map['imc'] as num?)?.toDouble(),
      cmb: (map['cmb'] as num?)?.toDouble(),
      relacaoCinturaQuadril: (map['relacaoCinturaQuadril'] as num?)?.toDouble(),
    );
  }
}
