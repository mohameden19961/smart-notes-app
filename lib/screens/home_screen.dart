import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/note.dart';
import '../services/note_service.dart';
import '../widgets/note_card.dart';
import 'add_note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NoteService _noteService = NoteService();
  List<Note> _notes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Expanded(
              child: StreamBuilder<List<Note>>(
                stream: _noteService.getNotes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Color(0xFF6366F1)),
                    );
                  }
                  if (snapshot.hasError) {
                    return _buildErrorState(snapshot.error.toString());
                  }

                  _notes = snapshot.data ?? [];

                  if (_notes.isEmpty) return _buildEmptyState();

                  return ReorderableListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 100),
                    itemCount: _notes.length,
                    onReorder: (oldIndex, newIndex) async {
                      if (newIndex > oldIndex) newIndex -= 1;
                      final updatedNotes = List<Note>.from(_notes);
                      final item = updatedNotes.removeAt(oldIndex);
                      updatedNotes.insert(newIndex, item);
                      setState(() => _notes = updatedNotes);
                      await _noteService.reorderNotes(updatedNotes);
                    },
                    proxyDecorator: (child, index, animation) {
                      return Material(
                        elevation: 8,
                        borderRadius: BorderRadius.circular(16),
                        shadowColor: const Color(0xFF6366F1).withOpacity(0.3),
                        child: child,
                      );
                    },
                    itemBuilder: (context, index) {
                      return KeyedSubtree(
                        key: ValueKey(_notes[index].id),
                        child: NoteCard(
                          note: _notes[index],
                          onDelete: () => _noteService.deleteNote(_notes[index].id),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddNoteScreen()),
        ),
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded),
        label: Text('Nouvelle note', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.notes_rounded, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Text(
                'Smart Notes',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.drag_indicator_rounded, size: 14, color: Color(0xFF9CA3AF)),
              const SizedBox(width: 4),
              Text(
                'Maintenez et glissez pour réorganiser',
                style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF9CA3AF)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(color: Color(0xFFEEF2FF), shape: BoxShape.circle),
            child: const Icon(Icons.note_add_outlined, size: 48, color: Color(0xFF6366F1)),
          ),
          const SizedBox(height: 20),
          Text(
            'Aucune note pour l\'instant',
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: const Color(0xFF374151)),
          ),
          const SizedBox(height: 8),
          Text(
            'Appuyez sur "Nouvelle note" pour commencer',
            style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF9CA3AF)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded, size: 48, color: Color(0xFFE53935)),
          const SizedBox(height: 12),
          Text('Une erreur est survenue',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
          Text(error, style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF9CA3AF))),
        ],
      ),
    );
  }
}
