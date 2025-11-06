import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/week_plan.dart';
import '../widgets/weekly_schedule_view.dart';
import 'edit_week_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<WeekPlan> weekBox;
  int currentWeekIndex = 0;

  @override
  void initState() {
    super.initState();
    weekBox = Hive.box<WeekPlan>('week_plans');

    if (weekBox.isEmpty) {
      _createFirstWeek();
    }
  }

  void _createFirstWeek() async {
    final startDate = DateTime.now();
    final firstWeek = WeekPlan(
      title: "Semaine 1",
      startDate: startDate,
      days: [
        for (final d in [
          "Lundi",
          "Mardi",
          "Mercredi",
          "Jeudi",
          "Vendredi",
          "Samedi",
          "Dimanche"
        ])
          DayTraining(dayName: d, type: "Repos"),
      ],
    );
    await weekBox.add(firstWeek);
    setState(() {});
  }

  void _nextWeek() {
    if (currentWeekIndex < weekBox.length - 1) {
      setState(() => currentWeekIndex++);
    }
  }

  void _previousWeek() {
    if (currentWeekIndex > 0) {
      setState(() => currentWeekIndex--);
    }
  }

  void _editCurrentWeek() {
    final currentWeek = weekBox.getAt(currentWeekIndex)!;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditWeekScreen(weekKey: currentWeek.key),
      ),
    ).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    if (weekBox.isEmpty) {
      return const Scaffold(
        backgroundColor: Color(0xFF0A192F),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentWeek = weekBox.getAt(currentWeekIndex)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF112240),
        title: Text(currentWeek.title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editCurrentWeek,
          ),
        ],
      ),
      backgroundColor: const Color(0xFF0A192F),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _previousWeek,
                  icon: const Icon(Icons.arrow_back_ios),
                ),
                Text(
                  "${currentWeek.startDate.day}/${currentWeek.startDate.month}/${currentWeek.startDate.year}",
                  style: const TextStyle(color: Colors.white70),
                ),
                IconButton(
                  onPressed: _nextWeek,
                  icon: const Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ),
          Expanded(child: WeeklyScheduleView(week: currentWeek)),
        ],
      ),
    );
  }
}
