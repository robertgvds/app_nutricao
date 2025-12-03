import 'package:flutter/material.dart';
import 'database/usuario_repository.dart';
import 'database/usuario.dart';
import 'database/paciente.dart';
import 'database/paciente_repository.dart';
import 'database/nutricionista.dart';
import 'database/nutricionista_repository.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final repoUsuario = UsuarioRepository();
  final repoPaciente = PacienteRepository();
  final repoNutricionista = NutricionistaRepository();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Teste SQLite")),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              // inserir um usuário
              await repoUsuario.inserir(
                Usuario(
                  nome: "Yuri",
                  email: "teste@gmail.com",
                  senha: '',
                  codigo: '12345',
                ),
              );

              // inserir um paciente
              await repoPaciente.inserir(
                Paciente(
                  nome: "Ana",
                  email: '',
                  senha: '',
                  codigo: '54321',
                  refeicoes: ['Café da manhã', 'Almoço'],
                ),
              );

              // inserir um nutricionista
              await repoNutricionista.inserir(
                Nutricionista(
                  nome: "Carlos",
                  email: '',
                  senha: '',
                  codigo: '67890',
                  crn: 'CRN1234',
                ),
              );

              // listar usuários
              final listaUsuario = await repoUsuario.listar();
              print("Usuários cadastrados:");
              for (var u in listaUsuario) {
                print("${u.id} - ${u.nome} - ${u.email}");
              }
              // listar pacientes
              final listaPaciente = await repoUsuario.listar();
              print("Usuários cadastrados:");
              for (var u in listaPaciente) {
                print("${u.id} - ${u.nome} - ${u.email}");
              }

              // listar nutricionistas
              final listaNutricionista = await repoUsuario.listar();
              print("Usuários cadastrados:");
              for (var u in listaNutricionista) {
                print("${u.id} - ${u.nome} - ${u.email}");
              }
            },
            child: const Text("Executar teste"),
          ),
        ),
      ),
    );
  }
}
