# 📝 Smart Notes App — Flutter + Firebase

Application mobile et web de gestion de notes développée avec **Flutter** et **Firebase Firestore**.

🌐 **Live Demo** : [smart-notes-abdy.web.app](https://smart-notes-abdy.web.app)

---

## 📋 Fonctionnalités

| Fonctionnalité | Statut |
|---|---|
| ✅ Afficher toutes les notes | Implémenté |
| ✅ Ajouter une note (titre + contenu) | Implémenté |
| ✅ Supprimer une note (avec confirmation) | Implémenté |
| ✅ Copier le contenu d'une note | Implémenté |
| ✅ Réorganiser les notes (Drag & Drop) | Implémenté |
| ✅ Mise à jour en temps réel (Firestore Stream) | Implémenté |
| ✅ Navigation entre pages | Implémenté |
| ✅ Validation des formulaires | Implémenté |
| ✅ Gestion des états (chargement, vide, erreur) | Implémenté |
| ✅ Déployé sur Web (Firebase Hosting) | Implémenté |

---

## 🗂️ Architecture du Projet
lib/
├── main.dart                  # Point d'entrée, init Firebase
├── firebase_options.dart      # Configuration Firebase (non versionné)
├── models/
│   └── note.dart              # Modèle Note (fromFirestore / toMap / order)
├── services/
│   └── note_service.dart      # CRUD Firestore + Stream + Reorder
├── screens/
│   ├── home_screen.dart       # Page d'accueil avec ReorderableListView
│   └── add_note_screen.dart   # Page d'ajout de note
└── widgets/
├── note_card.dart         # Carte note (copier + supprimer)
└── custom_text_field.dart # Champ texte réutilisable
---

## ⚙️ Installation & Configuration

### Prérequis
- Flutter SDK ≥ 3.0.0
- Compte Firebase
- Firebase CLI + FlutterFire CLI

### Étape 1 — Cloner le projet
```bash
git clone https://github.com/mohameden19961/smart-notes-app.git
cd smart-notes-app
flutter pub get
```

### Étape 2 — Configurer Firebase
```bash
# Installer FlutterFire CLI
dart pub global activate flutterfire_cli

# Connecter au projet Firebase
flutterfire configure --project=VOTRE_PROJECT_ID
```

### Étape 3 — Activer Firestore

1. Accédez à [console.firebase.google.com](https://console.firebase.google.com)
2. **Firestore Database** → **Créer une base de données** → **Mode test**

### Étape 4 — Lancer l'application
```bash
# Mobile
flutter run

# Web
flutter run -d chrome
```

---

## 🔥 Structure Firestore

**Collection** : `notes`

| Champ | Type | Description |
|---|---|---|
| `title` | String | Titre de la note |
| `content` | String | Contenu de la note |
| `createdAt` | Timestamp | Date de création |
| `order` | Number | Ordre d'affichage (drag & drop) |

---

## 🚀 Déploiement Web
```bash
# Build
flutter build web

# Deploy
firebase deploy
```

---

## 📦 Dépendances

| Package | Usage |
|---|---|
| `firebase_core` | Initialisation Firebase |
| `cloud_firestore` | Base de données temps réel |
| `google_fonts` | Typographie (Poppins + Inter) |
| `flutter_staggered_animations` | Animations de liste |
| `intl` | Formatage des dates |

---

## 🎨 Design

- **Couleur principale** : `#6366F1` (Indigo)
- **Typographies** : Poppins (titres) + Inter (corps)
- **Thème** : Clair, moderne, épuré
- **Animations** : Staggered animations + Drag & Drop feedback

---

## 🧠 Concepts Flutter Appris

- ✅ **Everything is a Widget** : NoteCard, CustomTextField, etc.
- ✅ **Widgets de base** : Column, Row, Container, ListView
- ✅ **ReorderableListView** : Drag & Drop natif Flutter
- ✅ **Navigation** : `Navigator.push()` / `Navigator.pop()`
- ✅ **StatefulWidget** / `setState()`
- ✅ **StreamBuilder** : Mise à jour temps réel depuis Firestore
- ✅ **Formulaires** : `Form`, `GlobalKey`, `validator`
- ✅ **Async/Await** : Appels Firebase asynchrones
- ✅ **Batch Write** : Mise à jour multiple Firestore en une seule opération
