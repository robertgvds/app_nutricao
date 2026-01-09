import 'package:firebase_database/firebase_database.dart';
import '../classes/paciente.dart';

class PacienteRepository {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  // Busca paciente pelo ID (UID do Firebase)
  Future<Paciente?> buscarPorId(String id) async {
    try {
      final ref = _db.ref('usuarios/$id');
      final snapshot = await ref.get();

      if (snapshot.exists && snapshot.value != null) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        data['id'] = id; // Garante que o ID venha da chave se não estiver no map
        return Paciente.fromMap(data);
      }
      return null;
    } catch (e) {
      print("Erro ao buscar paciente: $e");
      return null;
    }
  }

  // Lista todos os usuários que são do tipo "Paciente"
  Future<List<Paciente>> listar() async {
    try {
      final ref = _db.ref('usuarios');
      // Filtra onde o campo 'tipo' é igual a 'Paciente'
      final snapshot = await ref.orderByChild('tipo').equalTo('Paciente').get();

      if (snapshot.exists && snapshot.value != null) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        
        return data.entries.map((e) {
          final map = Map<String, dynamic>.from(e.value as Map);
          map['id'] = e.key;
          return Paciente.fromMap(map);
        }).toList();
      }
      return [];
    } catch (e) {
      print("Erro ao listar pacientes: $e");
      return [];
    }
  }
  
  Future<void> atualizar(Paciente paciente) async {
    if (paciente.id == null) return;
    await _db.ref('usuarios/${paciente.id}').update(paciente.toMap());
  }
}