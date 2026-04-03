import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

class NoteService {
  final CollectionReference _notesCollection =
      FirebaseFirestore.instance.collection('notes');

  Stream<List<Note>> getNotes() {
    return _notesCollection
        .snapshots()
        .map((snapshot) {
      final notes = snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList();
      // Trier: d'abord par order, sinon par date
      notes.sort((a, b) {
        if (a.order != 0 || b.order != 0) {
          return a.order.compareTo(b.order);
        }
        return b.createdAt.compareTo(a.createdAt);
      });
      return notes;
    });
  }

  Future<void> addNote({required String title, required String content}) async {
    final snapshot = await _notesCollection.get();
    final order = snapshot.docs.length;
    await _notesCollection.add({
      'title': title.trim(),
      'content': content.trim(),
      'createdAt': Timestamp.fromDate(DateTime.now()),
      'order': order,
    });
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
