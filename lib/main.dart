// arquivo: main.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'database/testeDB/teste_db.dart';
import 'telas/cadastro.dart';

void main() {
  // 1. Garante que o Flutter carregue os plugins antes de iniciar
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializa o driver para Windows/Linux/macOS
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  runApp(const MyApp());
}

// ----------------------------------------------------
// 1. Tela Principal (Home)
// ----------------------------------------------------

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tela Principal")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Bem-vindo ao App!", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 30),

            // Botão que fará o redirecionamento
            ElevatedButton(
              onPressed: () {
                // MÉTODO DE REDIRECIONAMENTO DE TELA
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TesteDb()),
                );
              },
              child: const Text("Ir para Tela de Teste de BD"),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // MÉTODO DE REDIRECIONAMENTO DE TELA
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TelaCadastro()),
                );
              },
              child: const Text("Ir para Tela de Cadastro"),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// 2. Widget Raiz (MyApp)
// ----------------------------------------------------

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // Define a tela principal como HomePage
      home: HomePage(),
    );
  }
}
