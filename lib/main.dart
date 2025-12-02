import 'package:flutter/material.dart';
import 'database/usuario_repository.dart';
import 'database/usuario.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final repo = UsuarioRepository();

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
              await repo.inserir(
                Usuario(nome: "Yuri", email: "teste@gmail.com", senha: ''),
              );

              // listar usuários
              final lista = await repo.listar();
              print("Usuários cadastrados:");
              for (var u in lista) {
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
