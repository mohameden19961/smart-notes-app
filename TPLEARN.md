# 📝 Smart Notes App — Flutter + Firebase
### Guide d'apprentissage complet — chaque mot expliqué

> Ce README est conçu pour **apprendre Flutter** à travers ce projet concret.
> Chaque concept, mot-clé et ligne de code importante est expliqué en détail.

---

## 📋 Table des matières

1. [C'est quoi Flutter ?](#1-cest-quoi-flutter-)
2. [Structure du projet](#2-structure-du-projet)
3. [pubspec.yaml — Le fichier de configuration](#3-pubspecyaml--le-fichier-de-configuration)
4. [main.dart — Point d'entrée de l'app](#4-maindart--point-dentrée-de-lapp)
5. [Les Widgets — "Everything is a Widget"](#5-les-widgets--everything-is-a-widget)
6. [Le modèle Note](#6-le-modèle-note)
7. [Le service Firestore](#7-le-service-firestore)
8. [HomeScreen — Page d'accueil](#8-homescreen--page-daccueil)
9. [AddNoteScreen — Page d'ajout](#9-addnotescreen--page-dajout)
10. [NoteCard — Widget carte](#10-notecard--widget-carte)
11. [CustomTextField — Widget champ texte](#11-customtextfield--widget-champ-texte)
12. [La Navigation](#12-la-navigation)
13. [Firebase & Firestore](#13-firebase--firestore)
14. [Les concepts Dart utilisés](#14-les-concepts-dart-utilisés)
15. [Glossaire complet](#15-glossaire-complet)

---

## 1. C'est quoi Flutter ?

**Flutter** est un framework créé par Google qui permet de créer des applications mobiles (Android & iOS), web et desktop avec **un seul code**.

```
Un seul code Dart  →  Android + iOS + Web + Desktop
```

### Le principe fondamental : "Everything is a Widget"
En Flutter, **tout est un Widget** — un bouton, un texte, une image, une mise en page, même l'application entière. Un Widget est simplement un **élément visuel** ou **structurel** de l'interface.

```dart
// Un texte = un Widget
Text("Bonjour")

// Une image = un Widget
Image.asset("photo.png")

// Une mise en page = un Widget
Column(children: [...])

// L'app entière = un Widget
MaterialApp(home: HomeScreen())
```

---

## 2. Structure du projet

```
smart_notes/
│
├── lib/                          ← Tout le code Dart est ici
│   ├── main.dart                 ← Point d'entrée (1er fichier exécuté)
│   │
│   ├── models/
│   │   └── note.dart             ← La définition d'une Note
│   │
│   ├── services/
│   │   └── note_service.dart     ← Communication avec Firebase
│   │
│   ├── screens/
│   │   ├── home_screen.dart      ← Page d'accueil (liste des notes)
│   │   └── add_note_screen.dart  ← Page d'ajout d'une note
│   │
│   └── widgets/
│       ├── note_card.dart        ← Carte visuelle d'une note
│       └── custom_text_field.dart← Champ de saisie personnalisé
│
├── android/                      ← Code natif Android (généré automatiquement)
├── ios/                          ← Code natif iOS (généré automatiquement)
├── pubspec.yaml                  ← Configuration + dépendances
└── README.md                     ← Ce fichier
```

### Pourquoi cette structure ?
- **models/** : contient les objets de données (ce qu'est une Note)
- **services/** : contient la logique métier (comment sauvegarder une Note)
- **screens/** : contient les pages complètes de l'app
- **widgets/** : contient les composants réutilisables

> 💡 Cette séparation s'appelle **l'architecture en couches**. Elle rend le code plus organisé et facile à maintenir.

---

## 3. pubspec.yaml — Le fichier de configuration

```yaml
name: smart_notes          # Nom de l'application
description: Smart Notes   # Description courte
version: 1.0.0+1           # Version: 1.0.0 (numéro build: 1)
```

### Les dépendances (packages)

```yaml
dependencies:
  flutter:
    sdk: flutter            # Le framework Flutter lui-même

  firebase_core: ^2.24.2   # Initialisation de Firebase
  cloud_firestore: ^4.14.0 # Base de données Firestore
  google_fonts: ^6.1.0     # Polices Google (Poppins, Inter...)
  flutter_staggered_animations: ^1.1.1  # Animations de liste
  intl: ^0.18.1             # Formatage des dates
```

> 💡 Le **`^`** devant la version signifie "cette version ou une version compatible plus récente".
> Par exemple `^2.24.2` accepte `2.24.3`, `2.25.0` mais pas `3.0.0`.

### Comment ajouter un package ?
1. Ajoutez-le dans `pubspec.yaml`
2. Exécutez `flutter pub get` dans le terminal
3. Importez-le dans votre fichier Dart : `import 'package:nom_package/nom_package.dart';`

---

## 4. main.dart — Point d'entrée de l'app

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
```

### Les imports
- `import` : mot-clé pour utiliser du code d'un autre fichier
- `package:flutter/material.dart` : importe tous les widgets Material Design de Flutter
- `firebase_options.dart` : fichier généré automatiquement par FlutterFire CLI

```dart
void main() async {
```
- `void` : cette fonction ne retourne rien
- `main()` : c'est le **point d'entrée** — le premier code exécuté au démarrage
- `async` : indique que la fonction contient des opérations **asynchrones** (qui prennent du temps)

```dart
  WidgetsFlutterBinding.ensureInitialized();
```
- Cette ligne est **obligatoire** avant toute opération async dans `main()`
- Elle s'assure que Flutter est prêt avant d'exécuter du code

```dart
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
```
- `await` : attend que Firebase finisse de s'initialiser avant de continuer
- `DefaultFirebaseOptions.currentPlatform` : choisit automatiquement la config Android ou iOS

```dart
  runApp(const SmartNotesApp());
```
- `runApp()` : démarre l'application Flutter avec le widget donné
- `const` : indique que ce widget ne changera jamais (optimisation mémoire)

```dart
class SmartNotesApp extends StatelessWidget {
```
- `class` : définit une nouvelle classe (un plan pour créer des objets)
- `SmartNotesApp` : le nom de notre widget racine
- `extends StatelessWidget` : hérite de StatelessWidget (widget sans état interne)

```dart
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
```
- `@override` : indique qu'on réécrit une méthode de la classe parente
- `build()` : méthode appelée par Flutter pour construire l'interface
- `BuildContext context` : contient les informations sur la position du widget dans l'arbre
- `MaterialApp` : widget racine qui configure l'app avec Material Design

```dart
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),  // Couleur principale (indigo)
        ),
      ),
```
- `ThemeData` : définit le thème visuel de toute l'application
- `Color(0xFF6366F1)` : couleur en hexadécimal (FF = opacité max, 6366F1 = indigo)

---

## 5. Les Widgets — "Everything is a Widget"

### StatelessWidget vs StatefulWidget

| | StatelessWidget | StatefulWidget |
|---|---|---|
| **État** | Pas d'état interne | A un état qui peut changer |
| **Rebuild** | Ne se reconstruit pas | Se reconstruit quand l'état change |
| **Utilisation** | Affichage fixe | Formulaires, animations, compteurs |
| **Exemple dans ce projet** | `NoteCard`, `HomeScreen` | `AddNoteScreen` |

```dart
// StatelessWidget — interface qui ne change pas
class NoteCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(...); // Toujours pareil
  }
}

// StatefulWidget — interface qui peut changer
class AddNoteScreen extends StatefulWidget {
  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  bool _isLoading = false; // ← État interne

  void _saveNote() {
    setState(() => _isLoading = true); // ← Déclenche un rebuild
  }
}
```

### Les widgets de mise en page utilisés

#### Column — disposition verticale
```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start, // Aligner à gauche
  children: [
    Text("Premier"),
    Text("Deuxième"),    // ↕ Empilés verticalement
    Text("Troisième"),
  ],
)
```

#### Row — disposition horizontale
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text("Gauche"),
    Icon(Icons.delete),  // ↔ Côte à côte
  ],
)
```

#### Container — boîte personnalisable
```dart
Container(
  padding: EdgeInsets.all(16),          // Espace intérieur
  margin: EdgeInsets.symmetric(         // Espace extérieur
    horizontal: 16, vertical: 8
  ),
  decoration: BoxDecoration(
    color: Colors.white,                // Couleur de fond
    borderRadius: BorderRadius.circular(16), // Coins arrondis
    boxShadow: [BoxShadow(...)],        // Ombre portée
  ),
  child: Text("Contenu"),
)
```

#### Expanded — prend tout l'espace disponible
```dart
Row(
  children: [
    Expanded(
      child: Text("Ce texte prend tout l'espace disponible"),
    ),
    Icon(Icons.delete), // Cet icône garde sa taille naturelle
  ],
)
```

#### SafeArea — évite les encoches et barres système
```dart
SafeArea(
  child: Column(...), // Le contenu ne sera pas caché par l'encoche
)
```

---

## 6. Le modèle Note

```dart
// lib/models/note.dart

class Note {
  final String id;        // Identifiant unique Firestore
  final String title;     // Titre de la note
  final String content;   // Contenu de la note
  final DateTime createdAt; // Date de création
```

- `class Note` : définit le plan d'une note
- `final` : la valeur ne peut pas être modifiée après initialisation
- `String` : type texte
- `DateTime` : type date + heure

```dart
  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });
```
- `{}` : paramètres **nommés** (on écrit `Note(id: '1', title: 'Ma note', ...)`)
- `required` : ce paramètre est **obligatoire**
- `this.id` : assigne directement à la propriété de la classe

### fromFirestore — Lire depuis Firebase
```dart
  factory Note.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Note(
      id: doc.id,
      title: data['title'] ?? '',      // ?? = si null, utilise ''
      content: data['content'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
```
- `factory` : constructeur spécial qui peut retourner un objet existant ou créer un nouveau
- `DocumentSnapshot` : un document Firestore
- `as Map<String, dynamic>` : conversion de type (casting)
- `??` : opérateur "null-coalescing" — si la valeur gauche est null, utilise la valeur droite
- `?.` : opérateur "null-safe" — appelle la méthode seulement si l'objet n'est pas null

### toMap — Envoyer vers Firebase
```dart
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
```
- `Map<String, dynamic>` : dictionnaire clé-valeur (comme JSON)
- `Timestamp.fromDate()` : convertit DateTime en format Firestore

---

## 7. Le service Firestore

```dart
// lib/services/note_service.dart

class NoteService {
  final CollectionReference _notesCollection =
      FirebaseFirestore.instance.collection('notes');
```
- `CollectionReference` : référence à une collection Firestore
- `FirebaseFirestore.instance` : instance singleton de Firestore
- `.collection('notes')` : pointe vers la collection "notes" dans la base de données
- `_notesCollection` : le `_` indique que c'est **privé** (accessible seulement dans cette classe)

### Stream — Temps réel
```dart
  Stream<List<Note>> getNotes() {
    return _notesCollection
        .orderBy('createdAt', descending: true)  // Trier par date décroissante
        .snapshots()                              // ← Écoute en temps réel !
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Note.fromFirestore(doc))
          .toList();
    });
  }
```
- `Stream` : flux de données qui émet de nouvelles valeurs au fil du temps
- `snapshots()` : retourne un Stream qui émet à chaque modification Firestore
- `.map()` : transforme chaque élément du Stream/liste
- `.toList()` : convertit en liste

> 💡 La différence entre `Future` et `Stream` :
> - **Future** : une seule valeur dans le futur (comme une promesse)
> - **Stream** : plusieurs valeurs dans le temps (comme un robinet qui coule)

### Future — Opérations asynchrones
```dart
  Future<void> addNote({
    required String title,
    required String content,
  }) async {
    await _notesCollection.add(note.toMap());
  }
```
- `Future<void>` : opération asynchrone qui ne retourne rien
- `async` : marque la fonction comme asynchrone
- `await` : attend la fin de l'opération avant de continuer

```dart
  Future<void> deleteNote(String id) async {
    await _notesCollection.doc(id).delete();
  }
```
- `.doc(id)` : référence un document spécifique par son ID
- `.delete()` : supprime ce document

---

## 8. HomeScreen — Page d'accueil

```dart
class HomeScreen extends StatelessWidget {
```
`StatelessWidget` car la page elle-même n'a pas d'état — c'est le **StreamBuilder** qui gère les mises à jour.

### StreamBuilder — Écouter le Stream en temps réel
```dart
StreamBuilder<List<Note>>(
  stream: noteService.getNotes(),  // Le Stream à écouter
  builder: (context, snapshot) {   // Appelé à chaque nouvelle donnée
```
- `StreamBuilder` : widget qui se reconstruit automatiquement quand le Stream émet
- `snapshot` : contient l'état actuel du Stream

```dart
    // États possibles du snapshot :
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator(); // Chargement en cours
    }
    if (snapshot.hasError) {
      return Text("Erreur"); // Une erreur est survenue
    }
    final notes = snapshot.data ?? []; // Les données (ou liste vide)
    if (notes.isEmpty) {
      return _buildEmptyState(); // Aucune note
    }
    return ListView.builder(...); // Afficher les notes
```

### ListView.builder — Liste performante
```dart
ListView.builder(
  itemCount: notes.length,        // Nombre d'éléments
  itemBuilder: (context, index) { // Construit chaque élément
    return NoteCard(note: notes[index]);
  },
)
```
- `ListView.builder` : crée les éléments **à la demande** (plus performant que `ListView`)
- `itemCount` : nombre total d'éléments
- `itemBuilder` : fonction appelée pour chaque élément visible

### FloatingActionButton
```dart
FloatingActionButton.extended(
  onPressed: () => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const AddNoteScreen()),
  ),
  icon: Icon(Icons.add_rounded),
  label: Text('Nouvelle note'),
)
```
- `FloatingActionButton` : bouton flottant (le bouton rond en bas à droite)
- `.extended` : version avec icône + texte

---

## 9. AddNoteScreen — Page d'ajout

```dart
class AddNoteScreen extends StatefulWidget {
  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}
```
`StatefulWidget` car on a besoin de gérer `_isLoading` (état du chargement).

### GlobalKey — Clé de formulaire
```dart
final _formKey = GlobalKey<FormState>();
```
- `GlobalKey` : identifiant unique pour accéder au formulaire depuis n'importe où
- `FormState` : l'état du formulaire (valide, invalide, etc.)

### TextEditingController — Contrôleur de champ
```dart
final _titleController = TextEditingController();
```
- Permet de **lire** la valeur du champ : `_titleController.text`
- Permet de **modifier** la valeur : `_titleController.clear()`
- **Important** : toujours libérer la mémoire dans `dispose()` !

```dart
@override
void dispose() {
  _titleController.dispose();  // Libère la mémoire
  _contentController.dispose();
  super.dispose();
}
```
- `dispose()` : appelé quand le widget est supprimé de l'arbre
- `super.dispose()` : appelle aussi le dispose de la classe parente

### La méthode _saveNote
```dart
Future<void> _saveNote() async {
  if (!_formKey.currentState!.validate()) return; // Valider le formulaire

  setState(() => _isLoading = true); // Afficher le spinner

  try {
    await _noteService.addNote(...); // Sauvegarder dans Firebase
    if (mounted) {
      Navigator.of(context).pop(); // Retour automatique
    }
  } catch (e) {
    // Afficher l'erreur
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}
```
- `validate()` : déclenche la validation de tous les champs du formulaire
- `mounted` : vérifie si le widget est toujours dans l'arbre (évite les erreurs après navigation)
- `try/catch/finally` : gestion des erreurs
  - `try` : code à essayer
  - `catch (e)` : code exécuté si une erreur survient
  - `finally` : code toujours exécuté (même en cas d'erreur)

---

## 10. NoteCard — Widget carte

```dart
class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onDelete;
```
- `VoidCallback` : type d'une fonction sans paramètres et sans retour `() => void`
- Ce widget reçoit la note à afficher et la fonction à appeler pour supprimer

### ClipRRect — Rogner avec coins arrondis
```dart
ClipRRect(
  borderRadius: BorderRadius.circular(16),
  child: Material(
    child: InkWell(
      onTap: () {},
      child: ...,
    ),
  ),
)
```
- `ClipRRect` : rogne le widget avec des coins arrondis
- `Material` : nécessaire pour que `InkWell` affiche l'effet de ripple
- `InkWell` : rend le widget cliquable avec animation

### Dialogue de confirmation
```dart
void _confirmDelete(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Supprimer la note ?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(), // Fermer le dialogue
          child: Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(ctx).pop(); // Fermer le dialogue
            onDelete();              // Supprimer la note
          },
          child: Text('Supprimer'),
        ),
      ],
    ),
  );
}
```
- `showDialog()` : affiche un dialogue par-dessus l'interface
- `AlertDialog` : dialogue standard avec titre, contenu et boutons
- `Navigator.of(ctx).pop()` : ferme le dialogue

---

## 11. CustomTextField — Widget champ texte

```dart
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;
  final IconData icon;
  final String? Function(String?)? validator;
```
- `String? Function(String?)?` :
  - `String?` : retourne un String ou null (null = valide, String = message d'erreur)
  - `Function(String?)` : prend un String nullable en paramètre
  - Le `?` final : le validator lui-même est optionnel

```dart
TextFormField(
  controller: controller,
  validator: validator,    // Fonction de validation
  decoration: InputDecoration(
    hintText: hint,        // Texte fantôme quand le champ est vide
    prefixIcon: Icon(icon),// Icône à gauche
    filled: true,          // Active la couleur de fond
    fillColor: Color(...), // Couleur de fond
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF6366F1), width: 2),
    ),
  ),
)
```
- `TextFormField` : champ texte avec support de validation (à utiliser dans un `Form`)
- `InputDecoration` : personnalise l'apparence du champ
- `focusedBorder` : bordure quand le champ est sélectionné

---

## 12. La Navigation

Flutter utilise un système de **pile de pages** (stack) :

```
[HomeScreen]  →  push  →  [HomeScreen, AddNoteScreen]
[HomeScreen]  ←  pop   ←  [HomeScreen, AddNoteScreen]
```

### Aller vers une nouvelle page
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const AddNoteScreen(),
  ),
);
```
- `Navigator.push()` : empile une nouvelle page par-dessus l'actuelle
- `MaterialPageRoute` : définit la transition (slide depuis la droite sur Android)
- `builder` : fonction qui crée la page

### Revenir à la page précédente
```dart
Navigator.of(context).pop();
```
- `pop()` : retire la page actuelle de la pile (retour arrière)

### Navigation avec résultat (bonus)
```dart
// Envoyer un résultat
Navigator.of(context).pop('note_ajoutée');

// Récupérer le résultat
final result = await Navigator.push(...);
if (result == 'note_ajoutée') { ... }
```

---

## 13. Firebase & Firestore

### Architecture Firebase dans ce projet

```
Application Flutter
       ↕
  NoteService (lib/services/note_service.dart)
       ↕
  Cloud Firestore (Firebase)
       ↕
  Base de données NoSQL
```

### Structure des données Firestore

```
firestore/
└── notes/                    ← Collection
    ├── Ir5XJWCjNCg06uJBFAoR  ← Document (ID auto-généré)
    │   ├── title: "abdy"
    │   ├── content: "phone"
    │   └── createdAt: 2 avril 2026
    └── qgamsGLk4BzT2MC07lT5  ← Document
        ├── title: "abdy's test"
        ├── content: "mon premier projet"
        └── createdAt: 2 avril 2026
```

### CRUD Firestore

```dart
// CREATE — Ajouter un document
await collection.add({'title': 'Ma note'});

// READ — Lire une fois
final snapshot = await collection.get();

// READ — Écouter en temps réel
collection.snapshots().listen((snapshot) { ... });

// UPDATE — Modifier un document
await collection.doc(id).update({'title': 'Nouveau titre'});

// DELETE — Supprimer un document
await collection.doc(id).delete();
```

### Les règles de sécurité Firestore

```javascript
// Pour le développement (tout le monde peut lire/écrire)
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}

// Pour la production (seulement les utilisateurs authentifiés)
allow read, write: if request.auth != null;
```

> ⚠️ **Important** : En production, ne jamais laisser `if true`. Toujours sécuriser avec l'authentification.

---

## 14. Les concepts Dart utilisés

### Variables et types
```dart
String name = "Flutter";        // Texte
int age = 5;                    // Entier
double price = 9.99;            // Décimal
bool isActive = true;           // Booléen
List<String> items = ["a","b"]; // Liste
Map<String, int> scores = {};   // Dictionnaire

// Nullable (peut être null)
String? optionalName;           // Peut être null

// Inférence de type
var note = Note(...);           // Dart devine le type
final note = Note(...);         // final = ne peut pas être réassigné
const PI = 3.14;                // const = valeur connue à la compilation
```

### Fonctions fléchées
```dart
// Fonction normale
String getTitle() {
  return note.title;
}

// Fonction fléchée (équivalent)
String getTitle() => note.title;

// Fonction anonyme
onPressed: () {
  saveNote();
}

// Fonction anonyme fléchée
onPressed: () => saveNote(),
```

### async / await
```dart
// Sans async/await (difficile à lire)
firebase.add(data).then((result) {
  print("Sauvegardé !");
}).catchError((error) {
  print("Erreur : $error");
});

// Avec async/await (plus lisible)
try {
  await firebase.add(data);
  print("Sauvegardé !");
} catch (error) {
  print("Erreur : $error");
}
```

### String interpolation
```dart
String name = "Abdy";
int count = 5;

// Mauvaise façon
print("Bonjour " + name + ", tu as " + count.toString() + " notes");

// Bonne façon (interpolation)
print("Bonjour $name, tu as $count notes");

// Expression complexe
print("Tu as ${notes.length} notes");
```

### Opérateurs utiles
```dart
// ?? — null-coalescing
String title = data['title'] ?? 'Sans titre';
// Si data['title'] est null → utilise 'Sans titre'

// ?. — null-safe call
String? name;
int? length = name?.length;
// Si name est null → length est null (pas d'erreur)

// ! — force non-null
String? name = "Flutter";
String definitelyName = name!;
// Attention : erreur si name est null !
```

---

## 15. Glossaire complet

| Terme | Définition |
|---|---|
| **Widget** | Élément de base de l'interface Flutter (tout est un widget) |
| **StatelessWidget** | Widget sans état interne (immuable) |
| **StatefulWidget** | Widget avec état interne (peut se reconstruire) |
| **setState()** | Méthode qui déclenche la reconstruction du widget |
| **BuildContext** | Contexte qui contient la position du widget dans l'arbre |
| **Scaffold** | Structure de base d'une page (appBar, body, FAB...) |
| **MaterialApp** | Widget racine qui configure le thème Material Design |
| **Navigator** | Gestionnaire de la pile de pages |
| **Stream** | Flux de données qui émet plusieurs valeurs dans le temps |
| **Future** | Valeur qui sera disponible dans le futur (une seule fois) |
| **async/await** | Syntaxe pour écrire du code asynchrone lisiblement |
| **StreamBuilder** | Widget qui se reconstruit à chaque émission d'un Stream |
| **FutureBuilder** | Widget qui se reconstruit quand un Future se résout |
| **TextEditingController** | Contrôleur pour lire/modifier un champ texte |
| **GlobalKey** | Identifiant unique pour accéder à l'état d'un widget |
| **Form** | Widget qui regroupe des champs avec validation |
| **validator** | Fonction qui vérifie la valeur d'un champ |
| **mounted** | Booléen qui indique si le widget est encore dans l'arbre |
| **dispose()** | Méthode appelée quand le widget est détruit |
| **Column** | Disposition verticale des widgets enfants |
| **Row** | Disposition horizontale des widgets enfants |
| **Container** | Boîte polyvalente avec padding, margin, décoration... |
| **Expanded** | Prend tout l'espace disponible dans une Row/Column |
| **ListView.builder** | Liste scrollable performante (construction à la demande) |
| **SafeArea** | Évite les zones non sûres (encoche, barre de statut) |
| **Firestore** | Base de données NoSQL temps réel de Firebase |
| **Collection** | Groupe de documents dans Firestore (comme une table) |
| **Document** | Unité de données dans Firestore (comme une ligne) |
| **Snapshot** | Instantané des données Firestore à un moment donné |
| **import** | Importer du code d'un autre fichier/package |
| **final** | Variable qui ne peut être assignée qu'une seule fois |
| **const** | Valeur constante connue à la compilation |
| **?** | Rend un type nullable (peut être null) |
| **??** | Retourne la valeur droite si la gauche est null |
| **?.** | Appelle une méthode seulement si l'objet n'est pas null |
| **factory** | Constructeur spécial pour créer des objets de manière flexible |
| **@override** | Indique qu'on réécrit une méthode de la classe parente |
| **VoidCallback** | Type d'une fonction sans paramètres et sans retour |
| **ClipRRect** | Rogne un widget avec des coins arrondis |
| **InkWell** | Rend un widget cliquable avec animation ripple |
| **BoxDecoration** | Décoration d'un Container (couleur, bordure, ombre...) |
| **EdgeInsets** | Définit les espacements (padding/margin) |

---

## 🚀 Pour aller plus loin

Après ce projet, vous pouvez apprendre :

1. **Authentification Firebase** — connexion avec email/mot de passe
2. **Provider / Riverpod** — gestion d'état plus avancée
3. **Hive / SQLite** — base de données locale (sans internet)
4. **Flutter Animations** — animations avancées
5. **Tests unitaires** — vérifier que le code fonctionne correctement

---

*Projet réalisé dans le cadre de l'apprentissage Flutter — Supnum 2026* 🎓
