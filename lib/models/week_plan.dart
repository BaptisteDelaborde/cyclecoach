import 'package:hive/hive.dart';
import 'training.dart';

part 'week_plan.g.dart';

@HiveType(typeId: 2)
class WeekPlan extends HiveObject {
  @HiveField(0)
  String name; // ex: "Prépa hiver"

  @HiveField(1)
  DateTime startDate;

  @HiveField(2)
  int weeks; // nombre de semaines du bloc

  @HiveField(3)
  Map<int, TrainingTemplate> template; // lundi..dimanche

  WeekPlan({
    required this.name,
    required this.startDate,
    required this.weeks,
    required this.template,
  });

  // Récupère l’index de la semaine à partir d’une date
  int weekIndexAt(DateTime date) {
    final diff = date.difference(startDate).inDays ~/ 7;
    return (diff < 0)
        ? -1
        : (diff >= weeks)
        ? weeks - 1
        : diff;
  }

  // Génère un Training pour une date donnée
  Training? trainingForDate(DateTime date) {
    final weekday = date.weekday; // 1=lundi
    final model = template[weekday];
    if (model == null || model.isRest) return null;
    return Training(
      title: model.title,
      duration: model.duration,
      zone: model.zone,
      date: date,
      details: model.details,
    );
  }

  // Met à jour un jour-type (et donc toutes les occurrences)
  void updateTemplateDay(int weekday, TrainingTemplate newTemplate) {
    template[weekday] = newTemplate;
    save();
  }
}

@HiveType(typeId: 3)
class TrainingTemplate {
  @HiveField(0)
  bool isRest;

  @HiveField(1)
  String title;

  @HiveField(2)
  int duration;

  @HiveField(3)
  String zone;

  @HiveField(4)
  String details;

  TrainingTemplate({
    required this.isRest,
    required this.title,
    required this.duration,
    required this.zone,
    this.details = '',
  });

  TrainingTemplate.rest()
      : isRest = true,
        title = '',
        duration = 0,
        zone = '',
        details = '';
}
