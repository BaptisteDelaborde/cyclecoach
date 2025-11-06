import 'package:hive_flutter/hive_flutter.dart';
import '../models/week_plan.dart';
import '../models/training.dart';

class DatabaseService {
  // 🔹 Initialisation Hive
  static Future<void> init() async {
    await Hive.initFlutter();

    // Enregistre les adaptateurs si pas déjà faits
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TrainingAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(WeekPlanAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(TrainingTemplateAdapter());
    }

    // Ouvre les box Hive
    await Hive.openBox<WeekPlan>('week_plans_v3');
    await Hive.openBox<Training>('trainings_v3');

  }

  // 🔹 Raccourci pour accéder aux box
  static Box<WeekPlan> get weekBox => Hive.box<WeekPlan>('week_plans_v3');
  static Box<Training> get trainingBox => Hive.box<Training>('trainings_v3');

  // 🔹 Ajout / suppression de blocs
  static Future<void> addPlan(WeekPlan plan) async {
    await weekBox.add(plan);
  }

  static Future<void> deletePlan(WeekPlan plan) async {
    await plan.delete();
  }
}
