import 'package:hive/hive.dart';
part 'training.g.dart';

@HiveType(typeId: 1)
class Training extends HiveObject {
  @HiveField(0)
  String title;       // Nom de la séance
  @HiveField(1)
  int duration;       // Durée (min)
  @HiveField(2)
  String zone;        // Zone d’intensité
  @HiveField(3)
  DateTime date;      // Date précise
  @HiveField(4)
  String details;     // Détail complet (échauffement, bloc, retour...)

  Training({
    required this.title,
    required this.duration,
    required this.zone,
    required this.date,
    this.details = '',
  });
}
