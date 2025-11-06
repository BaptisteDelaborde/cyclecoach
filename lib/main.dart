import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/training.dart';
import 'models/week_plan.dart';
import 'services/database_service.dart';
import 'widgets/main_navigation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseService.init(); // ✅ ouvre bien toutes les box avant le runApp()

  runApp(const CycleCoachApp());
}

class CycleCoachApp extends StatelessWidget {
  const CycleCoachApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CycleCoach',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
        primaryColor: const Color(0xFF00C2CB),
      ),
      home: const MainNavigation(),
    );
  }
}
