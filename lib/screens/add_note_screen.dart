import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/note_service.dart';
import '../widgets/custom_text_field.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _noteService = NoteService();

  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  /// Sauvegarder la note dans Firestore puis retourner
  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _noteService.addNote(
        title: _titleController.text,
        content: _contentController.text,
      );

      if (mounted) {
        // Snackbar de succès
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✅ Note ajoutée avec succès !',
              style: GoogleFonts.inter(),
            ),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        // Retour automatique à la page d'accueil
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '❌ Erreur : ${e.toString()}',
              style: GoogleFonts.inter(),
            ),
            backgroundColor: const Color(0xFFE53935),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Column(
          children: [
            // ─── App Bar personnalisé ───
            _buildHeader(context),

            // ─── Formulaire ───
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Carte contenant le formulaire
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Champ titre
                            CustomTextField(
                              controller: _titleController,
                              label: 'Titre',
                              hint: 'Ex: Liste de courses',
                              icon: Icons.title_rounded,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Le titre est obligatoire';
                                }
                                if (value.trim().length < 3) {
                                  return 'Minimum 3 caractères';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Champ contenu
                            CustomTextField(
                              controller: _contentController,
                              label: 'Contenu',
                              hint: 'Écrivez votre note ici...',
                              icon: Icons.notes_rounded,
                              maxLines: 8,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Le contenu est obligatoire';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Bouton sauvegarder
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveNote,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6366F1),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor:
                                const Color(0xFF6366F1).withOpacity(0.6),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.save_rounded, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Sauvegarder la note',
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 16, 24, 16),
      child: Row(
        children: [
          // Bouton retour
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF1A1A2E),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Nouvelle note',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A2E),
            ),
          ),
        ],
      ),
    );
  }
}
