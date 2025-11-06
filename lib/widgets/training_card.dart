import 'package:flutter/material.dart';
import '../models/training.dart';

class TrainingCard extends StatelessWidget {
  final DateTime date;
  final Training? training;

  const TrainingCard({
    super.key,
    required this.date,
    this.training,
  });

  String getDayName(int weekday) {
    const days = [
      'Lundi',
      'Mardi',
      'Mercredi',
      'Jeudi',
      'Vendredi',
      'Samedi',
      'Dimanche'
    ];
    return days[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final isRest = training == null;
    final color = isRest ? Colors.grey[900] : const Color(0xFF112240);

    return GestureDetector(
      onTap: () {
        if (!isRest) {
          showDialog(
            context: context,
            builder: (_) => _TrainingDetailDialog(training: training!),
          );
        }
      },
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isRest ? Colors.grey.shade700 : const Color(0xFF00BFA6),
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Jour + date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getDayName(date.weekday),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "${date.day}/${date.month}/${date.year}",
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              if (isRest)
                Row(
                  children: const [
                    Icon(Icons.bedtime_rounded, color: Colors.grey, size: 20),
                    SizedBox(width: 8),
                    Text(
                      "Repos",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      training!.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined,
                            size: 16, color: Colors.white54),
                        const SizedBox(width: 6),
                        Text(
                          "${training!.duration} min",
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.whatshot_outlined,
                            size: 16, color: Colors.orangeAccent),
                        const SizedBox(width: 6),
                        Text(
                          training!.zone,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                    if (training!.details.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        training!.details,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrainingDetailDialog extends StatelessWidget {
  final Training training;
  const _TrainingDetailDialog({required this.training});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF112240),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Row(
        children: [
          const Icon(Icons.fitness_center, color: Color(0xFF00BFA6)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              training.title,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoLine(Icons.timer_outlined, "${training.duration} minutes"),
            _infoLine(Icons.whatshot_outlined, "Zone : ${training.zone}"),
            if (training.details.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                "Détails :",
                style: TextStyle(
                    color: Color(0xFF00BFA6), fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                training.details,
                style: const TextStyle(color: Colors.white70, height: 1.4),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Fermer", style: TextStyle(color: Colors.white70)),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _infoLine(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.white54),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
