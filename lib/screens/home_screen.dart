import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/note.dart';
import '../services/note_service.dart';
import '../widgets/note_card.dart';
import 'add_note_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final noteService = NoteService();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── App Bar personnalisé ───
            _buildHeader(context),

            // ─── Liste des notes (temps réel) ───
            Expanded(
              child: StreamBuilder<List<Note>>(
                stream: noteService.getNotes(),
                builder: (context, snapshot) {
                  // Chargement
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF6366F1),
                      ),
                    );
                  }

                  // Erreur
                  if (snapshot.hasError) {
                    return _buildErrorState(snapshot.error.toString());
                  }

                  final notes = snapshot.data ?? [];

                  // Liste vide
                  if (notes.isEmpty) {
                    return _buildEmptyState();
                  }

                  // Liste des notes avec animation
                  return AnimationLimiter(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 8, bottom: 100),
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: NoteCard(
                                note: notes[index],
                                onDelete: () =>
                                    noteService.deleteNote(notes[index].id),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ─── Bouton d'ajout ───
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddNoteScreen()),
        ),
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded),
        label: Text(
          'Nouvelle note',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  /// En-tête de l'application
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
                child: const Icon(
                  Icons.notes_rounded,
                  color: Colors.white,
                  size: 22,
                ),
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
          Text(
            'Toutes vos notes en un seul endroit',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  /// État vide : aucune note
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.note_add_outlined,
              size: 48,
              color: Color(0xFF6366F1),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Aucune note pour l\'instant',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Appuyez sur "Nouvelle note" pour commencer',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF9CA3AF),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// État d'erreur
  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded,
              size: 48, color: Color(0xFFE53935)),
          const SizedBox(height: 12),
          Text(
            'Une erreur est survenue',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            error,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF9CA3AF),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
