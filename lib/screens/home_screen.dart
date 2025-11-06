import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/week_plan.dart';
import '../models/training.dart';
import '../widgets/training_card.dart';
import '../services/database_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = DatabaseService.weekBox;
    final today = DateTime.now();

    if (box.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Aucun bloc d'entraînement pour l’instant.",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    // On récupère le bloc actif par rapport à la date actuelle
    final active = _findActiveWeekPlan(box.values.toList(), today);

    if (active == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Aucun bloc actif actuellement.",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    // Calcule la semaine courante dans le bloc
    final weekIndex = active.weekIndexAt(today);

    // On génère les 7 jours de cette semaine
    final weekDays = List.generate(7, (i) {
      final monday = active.startDate.add(Duration(days: weekIndex * 7));
      return monday.add(Duration(days: i));
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Semaine en cours",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              active.name, // <-- nom du bloc
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF00BFA6),
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: weekDays.length,
        itemBuilder: (context, index) {
          final date = weekDays[index];
          final training = active.trainingForDate(date);
          return TrainingCard(date: date, training: training);
        },
      ),
    );
  }

  WeekPlan? _findActiveWeekPlan(List<WeekPlan> plans, DateTime date) {
    for (final plan in plans) {
      final start = plan.startDate;
      final end = start.add(Duration(days: plan.weeks * 7));
      if (date.isAfter(start.subtract(const Duration(days: 1))) &&
          date.isBefore(end)) {
        return plan;
      }
    }
    return null;
  }
}
