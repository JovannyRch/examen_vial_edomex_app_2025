import 'package:examen_vial_edomex_app_2025/data/data.dart';
import 'package:examen_vial_edomex_app_2025/models/option.dart';
import 'package:examen_vial_edomex_app_2025/screens/guide_screen.dart';
import 'package:examen_vial_edomex_app_2025/services/sound_service.dart';
import 'package:examen_vial_edomex_app_2025/theme/app_theme.dart';
import 'package:examen_vial_edomex_app_2025/widgets/ad_banner_widget.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  List<Question> _questionsFor(QuestionCategory category) {
    return questions.where((q) => q.category == category).toList();
  }

  static const _categoryStyles = <QuestionCategory, _CategoryStyle>{
    QuestionCategory.senales: _CategoryStyle(
      icon: Icons.traffic_rounded,
      color: AppColors.secondary,
    ),
    QuestionCategory.circulacion: _CategoryStyle(
      icon: Icons.swap_horiz_rounded,
      color: AppColors.primary,
    ),
    QuestionCategory.multas: _CategoryStyle(
      icon: Icons.gavel_rounded,
      color: AppColors.red,
    ),
    QuestionCategory.seguridad: _CategoryStyle(
      icon: Icons.shield_rounded,
      color: AppColors.orange,
    ),
    QuestionCategory.vehiculo: _CategoryStyle(
      icon: Icons.directions_car_rounded,
      color: AppColors.purple,
    ),
    QuestionCategory.prioridades: _CategoryStyle(
      icon: Icons.warning_amber_rounded,
      color: AppColors.secondaryDark,
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Práctica por Categoría'),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.secondary,
                            AppColors.secondary.withValues(alpha: 0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '🎯 Enfócate en tus áreas débiles',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Selecciona una categoría para practicar solo esas preguntas con sus respuestas correctas.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.9),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Category cards
                    ...QuestionCategory.values.map((cat) {
                      final style = _categoryStyles[cat]!;
                      final qs = _questionsFor(cat);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _CategoryCard(
                          category: cat,
                          icon: style.icon,
                          color: style.color,
                          questionCount: qs.length,
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (_, __, ___) => GuideScreen(
                                      allQuestions: qs,
                                      title: cat.label,
                                    ),
                                transitionsBuilder: (_, animation, __, child) {
                                  return SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(1, 0),
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeOutCubic,
                                      ),
                                    ),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const AdBannerWidget(),
          ],
        ),
      ),
    );
  }
}

// ─── Internal style mapping ─────────────────────────────────────────────────

class _CategoryStyle {
  final IconData icon;
  final Color color;

  const _CategoryStyle({required this.icon, required this.color});
}

// ─── Category Card with 3D press effect ─────────────────────────────────────

class _CategoryCard extends StatefulWidget {
  final QuestionCategory category;
  final IconData icon;
  final Color color;
  final int questionCount;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.icon,
    required this.color,
    required this.questionCount,
    required this.onTap,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _isPressed = false;

  Color get _darkColor => AppColors.darken(widget.color, 0.18);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        SoundService().playTap();
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        margin: EdgeInsets.only(top: _isPressed ? 3 : 0),
        padding: EdgeInsets.only(bottom: _isPressed ? 0 : 3),
        decoration: BoxDecoration(
          color: _darkColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: AppColors.surface(context),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.cardBorder(context), width: 2),
          ),
          child: Row(
            children: [
              // Emoji + Icon
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    widget.category.emoji,
                    style: const TextStyle(fontSize: 26),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.category.label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.questionCount} preguntas',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
              // Badge + arrow
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: widget.color,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
