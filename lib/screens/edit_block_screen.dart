import 'package:flutter/material.dart';
import '../models/week_plan.dart';

class EditBlockScreen extends StatefulWidget {
  final WeekPlan plan;

  const EditBlockScreen({super.key, required this.plan});

  @override
  State<EditBlockScreen> createState() => _EditBlockScreenState();
}

class _EditBlockScreenState extends State<EditBlockScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late int _weeks;
  late DateTime _startDate;
  late Map<int, TrainingTemplate> _template;

  final days = const [
    'Lundi',
    'Mardi',
    'Mercredi',
    'Jeudi',
    'Vendredi',
    'Samedi',
    'Dimanche',
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.plan;
    _name = p.name;
    _weeks = p.weeks;
    _startDate = p.startDate;
    _template = Map<int, TrainingTemplate>.from(p.template);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier le bloc"),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: "Nom du bloc"),
                validator: (v) => v!.isEmpty ? "Entrez un nom" : null,
                onSaved: (v) => _name = v!,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _weeks.toString(),
                decoration: const InputDecoration(labelText: "Nombre de semaines"),
                keyboardType: TextInputType.number,
                onSaved: (v) => _weeks = int.tryParse(v ?? '4') ?? 4,
              ),
              const SizedBox(height: 12),
              ListTile(
                title: Text("Date de début : ${_startDate.toLocal().toString().split(' ')[0]}"),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _startDate,
                    firstDate: DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) setState(() => _startDate = date);
                },
              ),
              const Divider(),
              const Text("Modèle de semaine :", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),

              // Entrées jour par jour
              ...List.generate(days.length, (i) {
                final dayIndex = i + 1;
                final dayName = days[i];
                final current = _template[dayIndex];

                return ListTile(
                  title: Text(dayName),
                  subtitle: Text(current == null
                      ? "Aucune séance"
                      : current.isRest
                      ? "Repos 💤"
                      : "${current.title} – ${current.zone} – ${current.duration} min"),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      final newTemplate = await showDialog<TrainingTemplate>(
                        context: context,
                        builder: (_) => _EditDayDialog(existing: current),
                      );
                      if (newTemplate != null) {
                        setState(() => _template[dayIndex] = newTemplate);
                      }
                    },
                  ),
                );
              }),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    widget.plan
                      ..name = _name
                      ..weeks = _weeks
                      ..startDate = _startDate
                      ..template = _template
                      ..save();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Bloc mis à jour ✅")),
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00BFA6),
                ),
                child: const Text("Enregistrer les modifications"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditDayDialog extends StatefulWidget {
  final TrainingTemplate? existing;
  const _EditDayDialog({this.existing});

  @override
  State<_EditDayDialog> createState() => _EditDayDialogState();
}

class _EditDayDialogState extends State<_EditDayDialog> {
  final _formKey = GlobalKey<FormState>();
  late bool _isRest;
  String _title = '';
  int _duration = 60;
  String _zone = 'Z1';
  String _details = '';

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _isRest = e?.isRest ?? false;
    _title = e?.title ?? '';
    _duration = e?.duration ?? 60;
    _zone = e?.zone ?? 'Z1';
    _details = e?.details ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Modifier la séance"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SwitchListTile(
                title: const Text("Jour de repos"),
                value: _isRest,
                onChanged: (v) => setState(() => _isRest = v),
              ),
              if (!_isRest) ...[
                TextFormField(
                  initialValue: _title,
                  decoration: const InputDecoration(labelText: "Nom"),
                  onSaved: (v) => _title = v ?? '',
                ),
                TextFormField(
                  initialValue: '$_duration',
                  decoration: const InputDecoration(labelText: "Durée (min)"),
                  keyboardType: TextInputType.number,
                  onSaved: (v) => _duration = int.tryParse(v ?? '60') ?? 60,
                ),
                TextFormField(
                  initialValue: _zone,
                  decoration: const InputDecoration(labelText: "Zone (Z1..Z5)"),
                  onSaved: (v) => _zone = v ?? 'Z1',
                ),
                TextFormField(
                  initialValue: _details,
                  decoration: const InputDecoration(labelText: "Détail"),
                  maxLines: 4,
                  onSaved: (v) => _details = v ?? '',
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Annuler"),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00BFA6)),
          child: const Text("OK"),
          onPressed: () {
            _formKey.currentState!.save();
            Navigator.pop(
              context,
              _isRest
                  ? TrainingTemplate.rest()
                  : TrainingTemplate(
                isRest: false,
                title: _title,
                duration: _duration,
                zone: _zone,
                details: _details,
              ),
            );
          },
        ),
      ],
    );
  }
}
