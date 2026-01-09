import 'package:flutter/material.dart';
import 'package:app/screens/nutricionista/nutricionista_antropometria_screen.dart';
import 'package:app/services/auth_service.dart';
import 'package:provider/provider.dart';
import '../../widgets/app_colors.dart';

class NutricionistaListaPacientesScreen extends StatefulWidget {
  const NutricionistaListaPacientesScreen({super.key});

  @override
  State<NutricionistaListaPacientesScreen> createState() => _NutricionistaListaPacientesScreenState();
}

class _NutricionistaListaPacientesScreenState extends State<NutricionistaListaPacientesScreen> {
  // Controller para o ID manual
  final TextEditingController _idController = TextEditingController();

  // Função centralizada de navegação
  void _navegarParaAntropometria(String idPaciente) {
    if (idPaciente.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, insira ou selecione um ID de paciente.")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NutricionistaAntropometriaScreen(
          pacienteId: idPaciente,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Pacientes", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.roxo,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () => context.read<AuthService>().logout(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- SEÇÃO 1: BUSCA/ID MANUAL ---
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Acesso Rápido / Manual",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _idController,
                      decoration: const InputDecoration(
                        labelText: "Insira o ID (UID) do Paciente",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.vpn_key),
                        hintText: "Cole o ID do Firebase aqui",
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.edit),
                        label: const Text("Abrir Antropometria (Manual)"),
                        onPressed: () {
                          // Aqui usamos o ID digitado manualmente
                          _navegarParaAntropometria(_idController.text.trim());
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Divider(thickness: 2),
            const SizedBox(height: 10),

            // --- SEÇÃO 2: LISTA DE PACIENTES (FUTURO) ---
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Lista de Pacientes Cadastrados",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.roxo),
              ),
            ),
            const SizedBox(height: 10),
            
            Expanded(
              // No futuro, aqui entrará um StreamBuilder ou FutureBuilder buscando do Firebase
              child: ListView.builder(
                itemCount: 0, // Zero por enquanto, pois não há lista implementada ainda
                itemBuilder: (context, index) {
                  // Exemplo de como será a integração futura:
                  /*
                  final paciente = listaPacientes[index];
                  return ListTile(
                    title: Text(paciente.nome),
                    subtitle: Text(paciente.email),
                    onTap: () {
                      // Ao clicar na lista, usamos o ID do objeto, ignorando o campo manual
                      _navegarParaAntropometria(paciente.id!);
                    },
                  );
                  */
                  return const SizedBox(); 
                },
              ),
            ),
            
            // Placeholder visual enquanto a lista está vazia
            const Center(
              child: Text(
                "A lista de pacientes aparecerá aqui.\nUse a busca manual acima por enquanto.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}