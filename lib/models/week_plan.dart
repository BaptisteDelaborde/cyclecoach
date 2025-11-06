import 'package:hive/hive.dart';
part 'week_plan.g.dart';

@HiveType(typeId: 2)
class WeekPlan extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  DateTime startDate;

  @HiveField(2)
  List<DayTraining> days;

  WeekPlan({
    required this.title,
    required this.startDate,
    required this.days,
  });
}

@HiveType(typeId: 3)
class DayTraining {
  @HiveField(0)
  String dayName; // Lundi, Mardi...

  @HiveField(1)
  String type; // Repos ou Entraînement

  @HiveField(2)
  String zone;

  @HiveField(3)
  int duration;

  @HiveField(4)
  String notes;

  DayTraining({
    required this.dayName,
    required this.type,
    this.zone = '',
    this.duration = 0,
    this.notes = '',
  });
}
