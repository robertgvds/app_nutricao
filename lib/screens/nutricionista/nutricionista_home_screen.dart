import 'package:flutter/material.dart';
import 'package:app/database/testeDB/teste_db.dart';
import 'package:app/services/auth_service.dart';
import 'package:provider/provider.dart';

class HomeTabScreen extends StatelessWidget {
  const HomeTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tela Principal"),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => context.read<AuthService>().logout(),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView( // Permite rolagem se necessário
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Bem-vindo ao App!", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TesteDb()),
                  );
                },
                child: const Text("Ir para Tela de Teste de BD"),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}