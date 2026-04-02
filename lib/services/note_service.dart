import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

class NoteService {
  // Référence à la collection "notes" dans Firestore
  final CollectionReference _notesCollection =
      FirebaseFirestore.instance.collection('notes');

  /// Stream en temps réel de toutes les notes (triées par date décroissante)
  Stream<List<Note>> getNotes() {
    return _notesCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList();
    });
  }

  /// Ajouter une nouvelle note
  Future<void> addNote({
    required String title,
    required String content,
  }) async {
    final note = Note(
      id: '',
      title: title.trim(),
      content: content.trim(),
      createdAt: DateTime.now(),
    );
    await _notesCollection.add(note.toMap());
  }

  /// Supprimer une note par son ID
  Future<void> deleteNote(String id) async {
    await _notesCollection.doc(id).delete();
  }
}
