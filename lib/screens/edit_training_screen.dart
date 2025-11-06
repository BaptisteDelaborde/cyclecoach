import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/training.dart';

class EditTrainingScreen extends StatefulWidget {
  final int trainingKey; // Clé Hive de la séance à modifier
  const EditTrainingScreen({super.key, required this.trainingKey});

  @override
  State<EditTrainingScreen> createState() => _EditTrainingScreenState();
}

class _EditTrainingScreenState extends State<EditTrainingScreen> {
  final _formKey = GlobalKey<FormState>();
  late Training _training;

  final _titleController = TextEditingController();
  final _durationController = TextEditingController();
  String _zone = 'Z1';
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    final trainingBox = Hive.box<Training>('trainings');
    _training = trainingBox.get(widget.trainingKey)!;

    _titleController.text = _training.title;
    _durationController.text = _training.duration.toString();
    _zone = _training.zone;
    _selectedDate = _training.date;
  }

  Future<void> _updateTraining() async {
    if (_formKey.currentState!.validate()) {
      final trainingBox = Hive.box<Training>('trainings');

      final updatedTraining = Training(
        title: _titleController.text,
        duration: int.parse(_durationController.text),
        zone: _zone,
        date: _selectedDate,
      );

      await trainingBox.put(widget.trainingKey, updatedTraining);

      Navigator.pop(context);
    }
  }

  Future<void> _deleteTraining() async {
    final trainingBox = Hive.box<Training>('trainings');
    await trainingBox.delete(widget.trainingKey);
    Navigator.pop(context);
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF64FFDA),
              surface: Color(0xFF112240),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier l'entraînement"),
        backgroundColor: const Color(0xFF112240),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: const Color(0xFF0A192F),
                  title: const Text(
                    "Supprimer cette séance ?",
                    style: TextStyle(color: Colors.white),
                  ),
                  content: const Text(
                    "Cette action est irréversible.",
                    style: TextStyle(color: Colors.white70),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Annuler",
                          style: TextStyle(color: Colors.white70)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Supprimer",
                          style: TextStyle(color: Colors.redAccent)),
                    ),
                  ],
                ),
              );
              if (confirm == true) _deleteTraining();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nom de séance
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Nom de la séance",
                  filled: true,
                  fillColor: Color(0xFF112240),
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                v == null || v.isEmpty ? "Entre un nom de séance" : null,
              ),
              const SizedBox(height: 16),

              // Durée
              TextFormField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Durée (minutes)",
                  filled: true,
                  fillColor: Color(0xFF112240),
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                v == null || v.isEmpty ? "Entre une durée" : null,
              ),
              const SizedBox(height: 16),

              // Zone
              DropdownButtonFormField<String>(
                value: _zone,
                decoration: const InputDecoration(
                  labelText: "Zone d’intensité",
                  filled: true,
                  fillColor: Color(0xFF112240),
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: "Z1", child: Text("Z1 - Endurance")),
                  DropdownMenuItem(value: "Z2", child: Text("Z2 - Tempo")),
                  DropdownMenuItem(value: "Z3", child: Text("Z3 - Seuil")),
                  DropdownMenuItem(value: "Z4", child: Text("Z4 - VO2Max")),
                  DropdownMenuItem(value: "Z5", child: Text("Z5 - Sprint")),
                ],
                onChanged: (val) => setState(() => _zone = val!),
              ),
              const SizedBox(height: 16),

              // Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Date : ${_selectedDate.toLocal().toString().split(' ')[0]}",
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF64FFDA),
                      foregroundColor: Colors.black,
                    ),
                    child: const Text("Changer"),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Bouton de sauvegarde
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateTraining,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF64FFDA),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  child: const Text("Sauvegarder les modifications"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
