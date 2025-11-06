import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/week_plan.dart';
import 'edit_week_screen.dart';

class WeeksScreen extends StatefulWidget {
  const WeeksScreen({super.key});

  @override
  State<WeeksScreen> createState() => _WeeksScreenState();
}

class _WeeksScreenState extends State<WeeksScreen> {
  late Box<WeekPlan> weekBox;

  @override
  void initState() {
    super.initState();
    weekBox = Hive.box<WeekPlan>('week_plans');
  }

  void _addNewWeek() async {
    final startDate = DateTime.now();
    final week = WeekPlan(
      title: "Semaine ${weekBox.length + 1}",
      startDate: startDate,
      days: [
        for (final day in [
          "Lundi",
          "Mardi",
          "Mercredi",
          "Jeudi",
          "Vendredi",
          "Samedi",
          "Dimanche"
        ])
          DayTraining(dayName: day, type: "Repos"),
      ],
    );
    await weekBox.add(week);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Plans hebdomadaires"),
        backgroundColor: const Color(0xFF112240),
      ),
      body: ValueListenableBuilder(
        valueListenable: weekBox.listenable(),
        builder: (context, Box<WeekPlan> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text("Aucune semaine créée pour l’instant."),
            );
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final week = box.getAt(index)!;
              return Card(
                color: const Color(0xFF112240),
                child: ListTile(
                  title: Text(week.title),
                  subtitle: Text(
                    "Début : ${week.startDate.toLocal().toString().split(' ')[0]}",
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditWeekScreen(weekKey: week.key),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewWeek,
        child: const Icon(Icons.add),
      ),
    );
  }
}
