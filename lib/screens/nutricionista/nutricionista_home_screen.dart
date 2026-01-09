import 'package:flutter/material.dart';
// REMOVIDO: import 'package:app/database/testeDB/teste_db.dart';
import 'package:app/services/auth_service.dart';
import 'package:provider/provider.dart';

class HomeTabScreen extends StatelessWidget {
  const HomeTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tela Principal"),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => context.read<AuthService>().logout(),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView( 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Bem-vindo ao App!", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 30),

              // Botão Teste DB removido

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}