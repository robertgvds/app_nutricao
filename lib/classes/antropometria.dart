// Classe responsável por armazenar dados antropométricos de uma pessoa
class Antropometria {
  // Massa corporal total do indivíduo (geralmente em kg)
  double? massaCorporal;

  // Massa de gordura corporal (em kg)
  double? massaGordura;

  // Percentual de gordura corporal (%)
  double? percentualGordura;

  // Massa esquelética ou massa muscular (em kg)
  double? massaEsqueletica;

  // Índice de Massa Corporal (IMC)
  double? imc;

  // Circunferência Muscular do Braço (CMB)
  double? cmb;

  // Relação Cintura–Quadril (RCQ)
  double? relacaoCinturaQuadril;

  // Construtor da classe
  // Todos os parâmetros são opcionais, permitindo criar o objeto mesmo que nem todos os dados estejam disponíveis
  Antropometria({
    this.massaCorporal,
    this.massaGordura,
    this.percentualGordura,
    this.massaEsqueletica,
    this.imc,
    this.cmb,
    this.relacaoCinturaQuadril,
  });

  // Converte o objeto Antropometria em um Map
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

  // Construtor factory que cria um objeto Antropometria a partir de um Map<String, dynamic>
  factory Antropometria.fromMap(Map<String, dynamic> map) {
    return Antropometria(
      // O toDouble() padroniza o tipo para double
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
