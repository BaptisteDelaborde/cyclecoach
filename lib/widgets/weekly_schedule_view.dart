import 'package:flutter/material.dart';
import '../models/week_plan.dart';

class WeeklyScheduleView extends StatelessWidget {
  final WeekPlan week;

  const WeeklyScheduleView({super.key, required this.week});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView.builder(
        itemCount: week.days.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 colonnes, Lundi-Mardi etc.
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.3,
        ),
        itemBuilder: (context, index) {
          final day = week.days[index];
          final isRest = day.type == "Repos";

          return Container(
            decoration: BoxDecoration(
              color: isRest ? const Color(0xFF1B2735) : const Color(0xFF112240),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isRest ? Colors.grey.shade700 : const Color(0xFF64FFDA),
                width: 1.5,
              ),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day.dayName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isRest
                      ? "Repos 💤"
                      : "${day.zone} — ${day.duration} min",
                  style: TextStyle(
                    color: isRest ? Colors.white70 : const Color(0xFF64FFDA),
                    fontSize: 14,
                  ),
                ),
                if (day.notes.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text(
                      day.notes,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
