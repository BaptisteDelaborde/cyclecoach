import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/week_plan.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(WeekPlanAdapter());
  Hive.registerAdapter(DayTrainingAdapter());
  await Hive.openBox<WeekPlan>('week_plans');

  runApp(const CycleCoachApp());
}

class CycleCoachApp extends StatelessWidget {
  const CycleCoachApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CycleCoach',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A192F),
        primaryColor: const Color(0xFF64FFDA),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF64FFDA),
          secondary: Color(0xFF00BFA5),
          surface: Color(0xFF112240),
          background: Color(0xFF0A192F),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
