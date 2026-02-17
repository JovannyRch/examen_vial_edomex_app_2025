import 'package:examen_vial_edomex_app_2025/models/option.dart';
import 'package:examen_vial_edomex_app_2025/services/database_service.dart';
import 'package:examen_vial_edomex_app_2025/services/sound_service.dart';
import 'package:examen_vial_edomex_app_2025/theme/app_theme.dart';
import 'package:examen_vial_edomex_app_2025/widgets/ad_banner_widget.dart';
import 'package:examen_vial_edomex_app_2025/widgets/duo_button.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GuideScreen extends StatefulWidget {
  final List<Question> allQuestions;
  final String? title;

  const GuideScreen({super.key, required this.allQuestions, this.title});

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  late final PageController _controller;
  int _currentPage = 0;
  Set<int> _favoriteIds = {};

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _controller.addListener(() {
      final page = _controller.page?.round() ?? 0;
      if (page != _currentPage) {
        setState(() => _currentPage = page);
      }
    });
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final ids = await DatabaseService().getFavoriteIds();
    if (mounted) setState(() => _favoriteIds = ids.toSet());
  }

  Future<void> _toggleFavorite(int questionId) async {
    SoundService().playTap();
    final isNowFav = await DatabaseService().toggleFavorite(questionId);
    if (mounted) {
      setState(() {
        if (isNowFav) {
          _favoriteIds.add(questionId);
        } else {
          _favoriteIds.remove(questionId);
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    _controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.allQuestions.length;
    final progress = (_currentPage + 1) / total;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Expanded(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: progress),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                builder:
                    (context, value, _) => ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: value,
                        minHeight: 14,
                        backgroundColor: AppColors.progressTrack(context),
                        valueColor: const AlwaysStoppedAnimation(
                          AppColors.secondary,
                        ),
                      ),
                    ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${_currentPage + 1}/$total',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary(context),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: total,
              itemBuilder: (context, index) {
                final q = widget.allQuestions[index];
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question number badge + bookmark
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Pregunta ${index + 1}',
                              style: const TextStyle(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _toggleFavorite(q.id),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, animation) {
                                return ScaleTransition(
                                  scale: animation,
                                  child: child,
                                );
                              },
                              child: Icon(
                                _favoriteIds.contains(q.id)
                                    ? Icons.bookmark_rounded
                                    : Icons.bookmark_border_rounded,
                                key: ValueKey(_favoriteIds.contains(q.id)),
                                color:
                                    _favoriteIds.contains(q.id)
                                        ? AppColors.orange
                                        : AppColors.textLight(context),
                                size: 28,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Image if exists
                      if (q.imagePath != null) ...[
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: q.imagePath!,
                              height: 140,
                              fit: BoxFit.cover,
                              placeholder:
                                  (context, url) => Container(
                                    height: 140,
                                    decoration: BoxDecoration(
                                      color: AppColors.progressTrack(context),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(
                                          AppColors.secondary,
                                        ),
                                      ),
                                    ),
                                  ),
                              errorWidget:
                                  (context, url, error) => Container(
                                    height: 140,
                                    decoration: BoxDecoration(
                                      color: AppColors.progressTrack(context),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.broken_image_outlined,
                                          size: 40,
                                          color: AppColors.textLight(context),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Error al cargar imagen',
                                          style: TextStyle(
                                            color: AppColors.textSecondary(
                                              context,
                                            ),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Question text
                      Text(
                        q.text,
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary(context),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // "Correct answer" label
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Respuesta correcta',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Answer card with green accent
                      ...q.options
                          .where((o) => o.id == q.correctOptionId)
                          .map(
                            (o) => Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(
                                  alpha: 0.06,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.25,
                                  ),
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                o.text.replaceAll('[br]', '\n'),
                                style: TextStyle(
                                  color: AppColors.textPrimary(context),
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Bottom navigation bar
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            decoration: BoxDecoration(
              color: AppColors.surface(context),
              border: Border(
                top: BorderSide(color: AppColors.cardBorder(context), width: 2),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  if (_currentPage > 0)
                    Expanded(
                      child: DuoButton(
                        text: 'Anterior',
                        outlined: true,
                        color: AppColors.secondary,
                        onPressed: () => _goToPage(_currentPage - 1),
                      ),
                    )
                  else
                    const Expanded(child: SizedBox()),
                  const SizedBox(width: 12),
                  if (_currentPage < total - 1)
                    Expanded(
                      child: DuoButton(
                        text: 'Siguiente',
                        color: AppColors.primary,
                        onPressed: () => _goToPage(_currentPage + 1),
                      ),
                    )
                  else
                    Expanded(
                      child: DuoButton(
                        text: 'Finalizar',
                        color: AppColors.primary,
                        icon: Icons.check_rounded,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const AdBannerWidget(),
        ],
      ),
    );
  }
}
