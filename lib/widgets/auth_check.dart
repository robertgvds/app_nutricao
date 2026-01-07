import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../telas/login_screen.dart'; 
import '../telas/home_screen.dart';  
import '../telas/verification_screen.dart';

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    if (auth.estaCarregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (auth.usuario == null) {
      return const LoginScreen();
    } else if (!auth.usuario!.emailVerified) {
      return const VerificationScreen();
    } else {
      return const HomeScreen();
    }
  }
}