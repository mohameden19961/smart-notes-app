import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

class NoteService {
  final CollectionReference _notesCollection =
      FirebaseFirestore.instance.collection('notes');

  Stream<List<Note>> getNotes() {
    return _notesCollection.snapshots().map((snapshot) {
      final notes = snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList();
      notes.sort((a, b) => a.order.compareTo(b.order));
      return notes;
    });
  }

  Future<void> addNote({required String title, required String content}) async {
    final snapshot = await _notesCollection.get();
    
    // Décaler toutes les notes existantes de +1
    final batch = FirebaseFirestore.instance.batch();
    for (final doc in snapshot.docs) {
      final currentOrder = (doc.data() as Map<String, dynamic>)['order'] ?? 0;
      batch.update(doc.reference, {'order': currentOrder + 1});
    }
    
    // Ajouter la nouvelle note en position 0 (début)
    final newNoteRef = _notesCollection.doc();
    batch.set(newNoteRef, {
      'title': title.trim(),
      'content': content.trim(),
      'createdAt': Timestamp.fromDate(DateTime.now()),
      'order': 0,
    });
    
    await batch.commit();
  }

  Future<void> deleteNote(String id) async {
    await _notesCollection.doc(id).delete();
  }

  Future<void> reorderNotes(List<Note> notes) async {
    final batch = FirebaseFirestore.instance.batch();
    for (int i = 0; i < notes.length; i++) {
      batch.update(_notesCollection.doc(notes[i].id), {'order': i});
    }
    await batch.commit();
  }
}
