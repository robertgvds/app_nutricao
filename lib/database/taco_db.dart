import '../classes/alimento.dart';

class TacoDB {
  // Dados extraídos da Tabela TACO - Edição 4 (CSV)
  // Colunas mapeadas: Descrição, Calorias (kcal), Proteína (g), Carboidrato (g), Lipídeos (g)
  static final List<Alimento> list = [
    // Cereais e derivados
    Alimento(id: '1', nome: 'Arroz integral cozido', calorias: 124, proteinas: 2.6, carboidratos: 25.8, gorduras: 1.0, quantidade: 100),
    Alimento(id: '2', nome: 'Arroz tipo 1 cozido', calorias: 128, proteinas: 2.5, carboidratos: 28.1, gorduras: 0.2, quantidade: 100),
    Alimento(id: '7', nome: 'Aveia flocos crua', calorias: 394, proteinas: 13.9, carboidratos: 66.6, gorduras: 8.5, quantidade: 100),
    Alimento(id: '13', nome: 'Biscoito Cream Cracker', calorias: 432, proteinas: 10.1, carboidratos: 68.7, gorduras: 14.4, quantidade: 100),
    Alimento(id: '35', nome: 'Farinha de trigo', calorias: 360, proteinas: 9.8, carboidratos: 75.1, gorduras: 1.4, quantidade: 100),
    Alimento(id: '40', nome: 'Macarrão de trigo cru', calorias: 371, proteinas: 10.0, carboidratos: 77.9, gorduras: 1.3, quantidade: 100),
    Alimento(id: '53', nome: 'Pão francês', calorias: 300, proteinas: 8.0, carboidratos: 58.6, gorduras: 3.1, quantidade: 100),
    Alimento(id: '56', nome: 'Pastel de carne frito', calorias: 388, proteinas: 10.1, carboidratos: 43.8, gorduras: 20.1, quantidade: 100),
    
    // Verduras, hortaliças e derivados
    Alimento(id: '64', nome: 'Abóbora cabotian cozida', calorias: 48, proteinas: 1.4, carboidratos: 10.8, gorduras: 0.7, quantidade: 100),
    Alimento(id: '77', nome: 'Alface americana crua', calorias: 9, proteinas: 0.6, carboidratos: 1.7, gorduras: 0.1, quantidade: 100),
    Alimento(id: '82', nome: 'Alho cru', calorias: 113, proteinas: 7.0, carboidratos: 23.9, gorduras: 0.2, quantidade: 100),
    Alimento(id: '88', nome: 'Batata doce cozida', calorias: 77, proteinas: 0.6, carboidratos: 18.4, gorduras: 0.1, quantidade: 100),
    Alimento(id: '91', nome: 'Batata inglesa cozida', calorias: 52, proteinas: 1.2, carboidratos: 11.9, gorduras: 0.0, quantidade: 100),
    Alimento(id: '93', nome: 'Batata frita', calorias: 267, proteinas: 5.0, carboidratos: 35.6, gorduras: 13.1, quantidade: 100),
    Alimento(id: '100', nome: 'Brócolis cozido', calorias: 25, proteinas: 2.1, carboidratos: 4.4, gorduras: 0.5, quantidade: 100),
    Alimento(id: '109', nome: 'Cenoura cozida', calorias: 30, proteinas: 0.8, carboidratos: 6.7, gorduras: 0.2, quantidade: 100),
    Alimento(id: '125', nome: 'Feijão broto cru', calorias: 39, proteinas: 4.2, carboidratos: 7.8, gorduras: 0.1, quantidade: 100),
    Alimento(id: '133', nome: 'Manjericão cru', calorias: 21, proteinas: 2.0, carboidratos: 3.6, gorduras: 0.4, quantidade: 100),
    
    // (Pode adicionar mais itens do CSV aqui seguindo o padrão)
  ];
}