import 'package:hive/hive.dart';

part 'training.g.dart';

@HiveType(typeId: 1)
class Training extends HiveObject {
  @HiveField(0)
  String title; // nom de la séance

  @HiveField(1)
  int duration; // en minutes

  @HiveField(2)
  String zone; // exemple : "Z2"

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  String notes; // remarques / commentaires facultatifs

  Training({
    required this.title,
    required this.duration,
    required this.zone,
    required this.date,
    this.notes = '',
  });
}
