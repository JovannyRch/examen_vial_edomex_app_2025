import 'package:exani/data/data.dart';
import 'package:exani/models/option.dart';
import 'package:exani/screens/guide_screen.dart';
import 'package:exani/services/database_service.dart';
import 'package:exani/services/sound_service.dart';
import 'package:exani/theme/app_theme.dart';
import 'package:exani/widgets/duo_button.dart';
import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  List<Question> _favoriteQuestions = [];
  bool _loading = true;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _loadFavorites();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    final ids = await DatabaseService().getFavoriteIds();
    final favQuestions = questions.where((q) => ids.contains(q.id)).toList();
    if (mounted) {
      setState(() {
        _favoriteQuestions = favQuestions;
        _loading = false;
      });
      _animController.forward(from: 0);
    }
  }

  Future<void> _removeFavorite(int questionId) async {
    SoundService().playTap();
    await DatabaseService().removeFavorite(questionId);
    await _loadFavorites();
  }

  Future<void> _clearAll() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: AppColors.orange),
                SizedBox(width: 10),
                Text('¿Borrar todas?', style: TextStyle(fontSize: 18)),
              ],
            ),
            content: Text(
              'Se eliminarán todas las preguntas guardadas. Esta acción no se puede deshacer.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text(
                  'Borrar',
                  style: TextStyle(color: AppColors.red),
                ),
              ),
            ],
          ),
    );

    if (confirm == true) {
      await DatabaseService().clearAllFavorites();
      await _loadFavorites();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Preguntas Guardadas',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          if (_favoriteQuestions.isNotEmpty)
            IconButton(
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.red,
              ),
              tooltip: 'Borrar todas',
              onPressed: _clearAll,
            ),
        ],
      ),
      body:
          _loading
              ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
              : _favoriteQuestions.isEmpty
              ? _buildEmptyState()
              : _buildList(),
      bottomNavigationBar:
          _favoriteQuestions.isNotEmpty
              ? Container(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: DuoButton(
                  text:
                      'Estudiar ${_favoriteQuestions.length} pregunta${_favoriteQuestions.length == 1 ? '' : 's'}',
                  color: AppColors.primary,
                  icon: Icons.menu_book_rounded,
                  onPressed: () {
                    SoundService().playTap();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => GuideScreen(
                              allQuestions: _favoriteQuestions,
                              title: 'Preguntas Guardadas',
                            ),
                      ),
                    ).then((_) => _loadFavorites());
                  },
                ),
              )
              : null,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.orange.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.bookmark_border_rounded,
                size: 50,
                color: AppColors.orange,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Sin preguntas guardadas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Marca preguntas con el ícono de bookmark en la guía de estudio o revisión de examen.\n\nLas preguntas que falles en exámenes se guardarán automáticamente aquí.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      itemCount: _favoriteQuestions.length,
      itemBuilder: (context, index) {
        final q = _favoriteQuestions[index];
        final correctOption = q.options.firstWhere(
          (o) => o.id == q.correctOptionId,
        );

        final delay = (index * 0.06).clamp(0.0, 0.5);
        final curvedAnim = CurvedAnimation(
          parent: _animController,
          curve: Interval(delay, 1.0, curve: Curves.easeOutCubic),
        );

        return AnimatedBuilder(
          animation: curvedAnim,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - curvedAnim.value)),
              child: Opacity(
                opacity: curvedAnim.value.clamp(0.0, 1.0),
                child: child,
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.cardBorder, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 8, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${q.category.emoji} ${q.category.label}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Remove button
                      IconButton(
                        icon: const Icon(
                          Icons.bookmark_rounded,
                          color: AppColors.orange,
                          size: 24,
                        ),
                        tooltip: 'Quitar de guardadas',
                        onPressed: () => _removeFavorite(q.id),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                      ),
                    ],
                  ),
                ),

                // Question text
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
                  child: Text(
                    q.text,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),

                // Correct answer
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          correctOption.text.replaceAll('[br]', '\n'),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darken(AppColors.primary, 0.15),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Explanation
                if (q.explanation != null && q.explanation!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.lightbulb_rounded,
                            size: 16,
                            color: AppColors.secondary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              q.explanation!,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.darken(
                                  AppColors.secondary,
                                  0.2,
                                ),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 14),
              ],
            ),
          ),
        );
      },
    );
  }
}
