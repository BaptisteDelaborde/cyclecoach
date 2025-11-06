import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/week_plan.dart';

class EditWeekScreen extends StatefulWidget {
  final int weekKey;

  const EditWeekScreen({super.key, required this.weekKey});

  @override
  State<EditWeekScreen> createState() => _EditWeekScreenState();
}

class _EditWeekScreenState extends State<EditWeekScreen> {
  late Box<WeekPlan> weekBox;
  late WeekPlan week;

  @override
  void initState() {
    super.initState();
    weekBox = Hive.box<WeekPlan>('week_plans');
    week = weekBox.get(widget.weekKey)!;
  }

  void _saveWeek() async {
    await week.save();
    Navigator.pop(context);
  }

  void _duplicateWeek(int numberOfWeeks) async {
    for (int i = 1; i <= numberOfWeeks; i++) {
      final newStart = week.startDate.add(Duration(days: 7 * i));
      final newWeek = WeekPlan(
        title: "${week.title} +$i",
        startDate: newStart,
        days: [
          for (final d in week.days)
            DayTraining(
              dayName: d.dayName,
              type: d.type,
              zone: d.zone,
              duration: d.duration,
              notes: d.notes,
            ),
        ],
      );
      await weekBox.add(newWeek);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Semaine dupliquée $numberOfWeeks fois !")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final zones = ["Z1", "Z2", "Z3", "Z4", "Z5", "Z6"];

    return Scaffold(
      appBar: AppBar(
        title: Text(week.title),
        backgroundColor: const Color(0xFF112240),
      ),
      body: ListView.builder(
        itemCount: week.days.length,
        itemBuilder: (context, index) {
          final day = week.days[index];
          return Card(
            color: const Color(0xFF112240),
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(day.dayName,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    value: day.type,
                    dropdownColor: const Color(0xFF0A192F),
                    onChanged: (val) {
                      setState(() => day.type = val!);
                    },
                    items: ["Repos", "Entraînement"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                  ),
                  if (day.type == "Entraînement") ...[
                    DropdownButton<String>(
                      value: day.zone.isNotEmpty ? day.zone : "Z1",
                      dropdownColor: const Color(0xFF0A192F),
                      onChanged: (val) {
                        setState(() => day.zone = val!);
                      },
                      items: zones
                          .map((z) =>
                          DropdownMenuItem(value: z, child: Text(z)))
                          .toList(),
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Durée (minutes)",
                      ),
                      onChanged: (v) =>
                      day.duration = int.tryParse(v) ?? day.duration,
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: "Notes"),
                      onChanged: (v) => day.notes = v,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: _saveWeek,
              child: const Text("Enregistrer la semaine"),
            ),
            const SizedBox(height: 10),
            DropdownButton<int>(
              hint: const Text("Dupliquer la semaine sur..."),
              items: [1, 2, 4, 8, 16]
                  .map((n) =>
                  DropdownMenuItem(value: n, child: Text("$n semaines")))
                  .toList(),
              onChanged: (val) {
                if (val != null) _duplicateWeek(val);
              },
            ),
          ],
        ),
      ),
    );
  }
}
