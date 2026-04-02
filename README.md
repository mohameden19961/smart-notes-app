# 📝 Smart Notes App — Flutter + Firebase

Application mobile de gestion de notes développée avec **Flutter** et **Firebase Firestore**.

---

## 📋 Fonctionnalités

| Fonctionnalité | Statut |
|---|---|
| ✅ Afficher toutes les notes | Implémenté |
| ✅ Ajouter une note (titre + contenu) | Implémenté |
| ✅ Supprimer une note (avec confirmation) | Implémenté |
| ✅ Mise à jour en temps réel (Firestore Stream) | Implémenté |
| ✅ Navigation entre pages | Implémenté |
| ✅ Validation des formulaires | Implémenté |
| ✅ Gestion des états (chargement, vide, erreur) | Implémenté |

---

## 🗂️ Architecture du Projet

```
lib/
├── main.dart                  # Point d'entrée, init Firebase
├── models/
│   └── note.dart              # Modèle Note (fromFirestore / toMap)
├── services/
│   └── note_service.dart      # CRUD Firestore + Stream temps réel
├── screens/
│   ├── home_screen.dart       # Page d'accueil avec liste des notes
│   └── add_note_screen.dart   # Page d'ajout de note
└── widgets/
    ├── note_card.dart         # Widget carte de note
    └── custom_text_field.dart # Widget champ texte réutilisable
```

---

## ⚙️ Configuration Firebase

### Étape 1 — Créer un projet Firebase

1. Accédez à [console.firebase.google.com](https://console.firebase.google.com)
2. Cliquez sur **"Ajouter un projet"**
3. Donnez un nom : `smart-notes-app`
4. Désactivez Google Analytics (optionnel) → **Créer le projet**

### Étape 2 — Activer Firestore

1. Dans le menu gauche → **Firestore Database**
2. Cliquez **"Créer une base de données"**
3. Choisissez **"Mode test"** (pour le développement)
4. Sélectionnez une région → **Activer**

### Étape 3 — Connecter l'app Android

1. Dans la console Firebase → ⚙️ Paramètres du projet → **Ajouter une application Android**
2. **Nom du package** : `com.example.smart_notes`
3. Téléchargez `google-services.json`
4. Placez le fichier dans : `android/app/google-services.json`

### Étape 4 — Connecter l'app iOS (si nécessaire)

1. Dans Firebase → Ajouter une application iOS
2. **Bundle ID** : `com.example.smartNotes`
3. Téléchargez `GoogleService-Info.plist`
4. Placez le fichier dans : `ios/Runner/GoogleService-Info.plist`

### Étape 5 — Installer FlutterFire CLI (recommandé)

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

---

## 🚀 Lancer le Projet

```bash
# 1. Installer les dépendances
flutter pub get

# 2. Vérifier la configuration
flutter doctor

# 3. Lancer l'application
flutter run
```

---

## 🔥 Structure Firestore

**Collection** : `notes`

| Champ | Type | Description |
|---|---|---|
| `title` | String | Titre de la note |
| `content` | String | Contenu de la note |
| `createdAt` | Timestamp | Date de création |

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
- **Animations** : Staggered list animations + feedback visuel

---

## 🧠 Concepts Flutter Appris

- ✅ **Everything is a Widget** : NoteCard, CustomTextField, etc.
- ✅ **Widgets de base** : Column, Row, Container, Stack, ListView
- ✅ **Navigation** : `Navigator.push()` / `Navigator.pop()`
- ✅ **État** : `StatefulWidget`, `setState()`
- ✅ **StreamBuilder** : Mise à jour temps réel depuis Firestore
- ✅ **Formulaires** : `Form`, `GlobalKey`, `validator`
- ✅ **Async/Await** : Appels Firebase asynchrones
