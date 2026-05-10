import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/localization_service.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = true;
  bool _hasChanges = false;
  Timer? _autosaveTimer;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notes = prefs.getString('notes') ?? '';
    if (mounted) {
      setState(() {
        _controller.text = notes;
        _isLoading = false;
        _hasChanges = false;
      });
    }
  }

  Future<void> _saveNotes() async {
    if (!_hasChanges) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('notes', _controller.text);
    if (mounted) {
      setState(() => _hasChanges = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tr(context, 'notes_saved')),
          duration: const Duration(milliseconds: 1500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: colors.outlineVariant,
                  ),
                  color: colors.surface,
                ),
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 16,
                    color: colors.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: tr(context, 'notes_hint'),
                    hintStyle: GoogleFonts.cormorantGaramond(
                      fontSize: 18,
                      color: colors.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  onChanged: (_) {
                    if (!_hasChanges) {
                      setState(() => _hasChanges = true);
                    }
                    _autosaveTimer?.cancel();
                    _autosaveTimer = Timer(const Duration(seconds: 2), _saveNotes);
                  },
                ),
              ),
            ),
          ),
          if (_hasChanges)
            Padding(
              padding: const EdgeInsets.all(14),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveNotes,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    tr(context, 'save'),
                    style: GoogleFonts.cinzel(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.04,
                    ),
                  ),
                ),
              ),
            ),
        ],
    );
  }

  @override
  void dispose() {
    _autosaveTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }
}