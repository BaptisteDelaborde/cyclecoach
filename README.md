# 🚴‍♂️ CycleCoach

CycleCoach est une application Flutter conçue pour **planifier, suivre et visualiser des blocs d'entraînement cycliste**.  
Elle permet d’organiser des programmes structurés par semaines, avec la possibilité d’ajouter des détails précis pour chaque journée d’entraînement.

---

## 🧭 Fonctionnalités actuelles

### 🗓️ Vue "Semaine"
- Affiche **la semaine en cours** à partir du lundi.  
- Montre chaque jour (Lundi → Dimanche) avec :
  - le **type d'entraînement** (ex : endurance, seuil, FTP…),
  - la **zone de puissance** (Z1 à Z5),
  - la **durée** (en minutes),
  - et le **détail de séance** (échauffement, séries, récupération…).
- Les jours de repos sont affichés en gris.

### 🧱 Vue "Blocs"
- Liste tous les blocs d’entraînement enregistrés (ex : “Prépa hiver”, “Affûtage”, etc.).
- Chaque bloc contient :
  - une **date de début**,
  - un **nombre de semaines**,
  - une **semaine-type** répliquée automatiquement sur toute la durée du bloc.
- Chaque bloc est sauvegardé localement dans une base **Hive** (aucune connexion internet requise).

### ⚙️ Vue "Paramètres"
- Regroupe les futures options de personnalisation (notifications, gestion des blocs, etc.).

---

## 🧩 Structure du projet

```
lib/
 ├── main.dart                       # Point d’entrée de l’application
 ├── widgets/
 │    ├── main_navigation.dart       # Barre de navigation (Semaine / Blocs / Paramètres)
 │    └── training_card.dart         # Carte d’affichage d’un entraînement
 ├── models/
 │    ├── training.dart              # Modèle d'une séance d'entraînement
 │    ├── training.g.dart            # Code généré Hive
 │    ├── week_plan.dart             # Modèle d’un bloc d’entraînement (plusieurs semaines)
 │    └── week_plan.g.dart           # Code généré Hive
 ├── screens/
 │    ├── home_screen.dart           # Vue principale : semaine en cours
 │    ├── blocks_screen.dart         # Liste et gestion des blocs
 │    ├── add_block_screen.dart      # Création d’un bloc d’entraînement
 │    └── settings_screen.dart       # Paramètres de l’application
 └── services/
      ├── database_service.dart      # Initialisation et gestion Hive
      ├── notification_service.dart  # (préparé pour notifications locales)
      └── settings_service.dart      # (préparé pour préférences utilisateur)
```

---

## 💾 Architecture et stockage

- **Hive** est utilisé pour stocker localement les blocs et les entraînements.
- Les modèles Hive :
  - `WeekPlan` → représente un bloc d’entraînement.
  - `TrainingTemplate` → modèle d’un jour-type.
  - `Training` → séance concrète affichée sur la semaine.
- Toutes les données sont sauvegardées dans :
  - `week_plans`
  - `trainings`

---

## ⚙️ Installation & Lancement

### 1. Cloner le dépôt
```bash
git clone https://github.com/tonpseudo/cyclecoach.git
cd cyclecoach
```

### 2. Installer les dépendances
```bash
flutter pub get
```

### 3. Générer le code Hive
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 4. Lancer l’application
```bash
flutter run
```

---

## 🚀 Fonctionnalités prévues

- ✏️ Édition d’un bloc d’entraînement (modifier les jours / détails).  
- 🗑️ Suppression complète d’un bloc.  
- 🧩 Duplication d’un bloc (créer une nouvelle période identique).  
- 📅 Extension automatique d’un bloc (ajout de semaines).  
- 🔔 Notifications quotidiennes d’entraînement.  
- 📊 Statistiques d’entraînement (heures par semaine, répartition par zones).  
- 💾 Export PDF ou sauvegarde Hive.

---

## 🧠 Technologies

- **Flutter 3.x**
- **Dart 3.x**
- **Hive / Hive Flutter** pour le stockage local
- **Material Design 3**
- **StatefulWidgets** simples (pas de provider pour le moment)

---

## 👤 Auteur

Développé par **Baptiste Delaborde** dans le cadre du projet personnel *CycleCoach*.  
Projet initié en 2025 — IUT Nancy-Charlemagne (BUT Informatique, parcours DWM).

---

## 🖼️ Aperçu

| Écran | Description |
|-------|--------------|
| ![week](docs/week.png) | Vue "Semaine en cours" — jours et séances |
| ![blocks](docs/blocks.png) | Vue "Blocs" — gestion des périodes d'entraînement |

---

## 📂 Licence

Projet à usage pédagogique — tous droits réservés © 2025 Baptiste Delaborde.
