import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/week_plan.dart';
import '../services/database_service.dart';
import 'add_block_screen.dart';
import 'edit_block_screen.dart';

class BlocksScreen extends StatelessWidget {
  const BlocksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = DatabaseService.weekBox;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes blocs d'entraînement"),
        backgroundColor: Colors.transparent,
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<WeekPlan> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text("Aucun bloc créé pour l’instant."));
          }

          final plans = box.values.toList();
          return ListView.builder(
            itemCount: plans.length,
            itemBuilder: (context, index) {
              final plan = plans[index];
              return Card(
                color: const Color(0xFF112240),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(plan.name),
                  subtitle: Text(
                    "Début : ${plan.startDate.day}/${plan.startDate.month}/${plan.startDate.year} — ${plan.weeks} semaines",
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditBlockScreen(plan: plan),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🟩 Bouton Dupliquer
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.lightBlueAccent),
                        tooltip: "Dupliquer le bloc",
                        onPressed: () {
                          _duplicatePlan(context, plan);
                        },
                      ),
                      // 🔴 Bouton Supprimer
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                        tooltip: "Supprimer le bloc",
                        onPressed: () => DatabaseService.deletePlan(plan),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF00BFA6),
        label: const Text("Nouveau bloc"),
        icon: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddBlockScreen()),
        ),
      ),
    );
  }

  void _duplicatePlan(BuildContext context, WeekPlan plan) async {
    final duplicated = WeekPlan(
      name: "${plan.name} (copie)",
      startDate: plan.startDate,
      weeks: plan.weeks,
      template: Map<int, TrainingTemplate>.from(plan.template),
    );

    await DatabaseService.addPlan(duplicated);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Bloc « ${plan.name} » dupliqué avec succès ✅"),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
