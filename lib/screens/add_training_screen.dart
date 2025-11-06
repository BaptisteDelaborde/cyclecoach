import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/training.dart';

class AddTrainingScreen extends StatefulWidget {
  const AddTrainingScreen({super.key});

  @override
  State<AddTrainingScreen> createState() => _AddTrainingScreenState();
}

class _AddTrainingScreenState extends State<AddTrainingScreen> {
  final _durationController = TextEditingController();
  final _notesController = TextEditingController();

  int _selectedWeekday = DateTime.now().weekday;
  DateTime _selectedDate = DateTime.now();
  String _selectedZone = 'Z1 - Endurance';
  bool _repeatWeekly = false;
  int _repeatWeeks = 8; // Valeur par défaut

  final List<String> _zones = const [
    'Z1 - Endurance',
    'Z2 - Tempo',
    'Z3 - Seuil',
    'Z4 - VO2',
    'Z5 - Anaérobie',
  ];

  final List<String> _weekdaysFr = const [
    'Lundi',
    'Mardi',
    'Mercredi',
    'Jeudi',
    'Vendredi',
    'Samedi',
    'Dimanche',
  ];

  @override
  void dispose() {
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  DateTime _dateForWeekday(DateTime base, int weekday) {
    final monday = base.subtract(Duration(days: base.weekday - 1));
    final target = monday.add(Duration(days: weekday - 1));
    return DateTime(target.year, target.month, target.day, 12, 0);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
      locale: const Locale('fr'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: const Color(0xFF64FFDA),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _save() async {
    final duration = int.tryParse(_durationController.text.trim());
    if (duration == null || duration <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Durée invalide')),
      );
      return;
    }

    final shortZone = _selectedZone.split(' ').first;
    final baseDate = _dateForWeekday(_selectedDate, _selectedWeekday);
    final title = _weekdaysFr[_selectedWeekday - 1];
    final box = Hive.box<Training>('trainings');

    await box.add(
      Training(
        title: title,
        duration: duration,
        zone: shortZone,
        date: baseDate,
        notes: _notesController.text.trim(),
      ),
    );

    if (_repeatWeekly) {
      for (int i = 1; i < _repeatWeeks; i++) {
        await box.add(
          Training(
            title: title,
            duration: duration,
            zone: shortZone,
            date: baseDate.add(Duration(days: 7 * i)),
            notes: _notesController.text.trim(),
          ),
        );
      }
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvel entraînement'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<int>(
              value: _selectedWeekday,
              decoration: const InputDecoration(
                labelText: 'Jour de la semaine',
                border: OutlineInputBorder(),
              ),
              items: List.generate(7, (i) {
                final wk = i + 1;
                return DropdownMenuItem(
                  value: wk,
                  child: Text(_weekdaysFr[i]),
                );
              }),
              onChanged: (v) {
                if (v != null) {
                  setState(() => _selectedWeekday = v);
                }
              },
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Durée (minutes)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _selectedZone,
              decoration: const InputDecoration(
                labelText: 'Zone d’intensité',
                border: OutlineInputBorder(),
              ),
              items: _zones
                  .map((z) => DropdownMenuItem(value: z, child: Text(z)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedZone = v ?? _selectedZone),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Text(
                    'Date : ${_selectedDate.toLocal().toString().split(' ').first}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: _pickDate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Choisir'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notes (optionnel)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Répéter chaque semaine'),
                Switch(
                  value: _repeatWeekly,
                  onChanged: (v) => setState(() => _repeatWeekly = v),
                ),
              ],
            ),

            // Sélecteur du nombre de semaines
            if (_repeatWeekly) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Durée du plan (semaines)'),
                  DropdownButton<int>(
                    value: _repeatWeeks,
                    items: const [
                      DropdownMenuItem(value: 4, child: Text('4')),
                      DropdownMenuItem(value: 8, child: Text('8')),
                      DropdownMenuItem(value: 12, child: Text('12')),
                      DropdownMenuItem(value: 16, child: Text('16')),
                    ],
                    onChanged: (v) => setState(() => _repeatWeeks = v ?? 8),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF64FFDA),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text('Enregistrer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
