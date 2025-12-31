// arquivo: main.dart
import 'dart:io';
import 'package:app/telas/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'database/testeDB/teste_db.dart';

// --- NOVOS IMPORTS DO FIREBASE ---
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 
// ---------------------------------

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();

  // --- INICIALIZAÇÃO DO FIREBASE ---
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // ---------------------------------

  // 2. Inicializa o driver para Windows/Linux/macOS (SQLite)
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  
  runApp(const MyApp());
}

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
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text("Ir para Tela de Login"),
            ),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}