import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/training.dart';
import '../screens/edit_training_screen.dart';

class CalendarWeekView extends StatefulWidget {
  const CalendarWeekView({super.key});

  @override
  State<CalendarWeekView> createState() => _CalendarWeekViewState();
}

class _CalendarWeekViewState extends State<CalendarWeekView> {
  DateTime _selectedWeek = DateTime.now();

  List<Training> _getTrainingsForSelectedWeek(Box<Training> box) {
    final startOfWeek = _selectedWeek.subtract(Duration(days: _selectedWeek.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 7));
    return box.values
        .where((t) => t.date.isAfter(startOfWeek.subtract(const Duration(days: 1))) && t.date.isBefore(endOfWeek))
        .toList();
  }

  void _previousWeek() {
    setState(() {
      _selectedWeek = _selectedWeek.subtract(const Duration(days: 7));
    });
  }

  void _nextWeek() {
    setState(() {
      _selectedWeek = _selectedWeek.add(const Duration(days: 7));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Training>('trainings').listenable(),
      builder: (context, Box<Training> box, _) {
        final trainings = _getTrainingsForSelectedWeek(box);

        return Column(
          children: [
            // === En-tête de la semaine ===
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: _previousWeek,
                ),
                Text(
                  "Semaine du ${_selectedWeek.subtract(Duration(days: _selectedWeek.weekday - 1)).toLocal().toString().split(' ')[0]}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onPressed: _nextWeek,
                ),
              ],
            ),
            const SizedBox(height: 10),

            // === Liste des entraînements ===
            if (trainings.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Text(
                    "Aucun entraînement cette semaine",
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: trainings.length,
                  itemBuilder: (context, index) {
                    final t = trainings[index];
                    return Card(
                      color: const Color(0xFF112240),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(
                          t.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          "${t.duration} min • ${t.zone}\n${t.date.toLocal().toString().split(' ')[0]}",
                          style: const TextStyle(color: Colors.white70),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit, color: Color(0xFF64FFDA)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditTrainingScreen(trainingKey: t.key),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
