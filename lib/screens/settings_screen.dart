import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: const Center(
        child: Text('À venir…', style: TextStyle(color: Colors.white70)),
      ),
      backgroundColor: const Color(0xFF0A192F),
    );
  }
}
