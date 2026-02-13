import 'package:flutter/material.dart';
import 'package:exani/data/data.dart';
import 'package:exani/screens/exam_screen.dart';
import 'package:exani/services/sound_service.dart';
import 'package:exani/theme/app_theme.dart';
import 'package:exani/widgets/duo_button.dart';

/// Pantalla 6 MVP — Pre-simulacro.
/// Muestra reglas y condiciones del simulacro antes de iniciarlo.
class SimulationScreen extends StatefulWidget {
  final String examId;
  final String examName;

  const SimulationScreen({
    super.key,
    required this.examId,
    required this.examName,
  });

  @override
  State<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends State<SimulationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  // Simulacro config — TODO: cargar de SessionRepository
  static const int _totalQuestions = 120;
  static const int _timeLimitMinutes = 180;
  static const int _sectionsCount = 4;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
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

  void _startSimulation() {
    SoundService().playTap();
    // TODO: Crear SessionConfig.simulation() y lanzar SessionEngine
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) =>
                ExamScreen(allQuestions: questions),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Simulacro',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                  child: Column(
                    children: [
                      // Icon
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.orange.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.timer_rounded,
                          color: AppColors.orange,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Simulacro ${widget.examName}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Reproduce las condiciones reales del examen.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Info cards
                      _InfoRow(
                        icon: Icons.quiz_rounded,
                        label: 'Reactivos',
                        value: '$_totalQuestions preguntas',
                      ),
                      const SizedBox(height: 10),
                      _InfoRow(
                        icon: Icons.timer_outlined,
                        label: 'Tiempo límite',
                        value:
                            '${_timeLimitMinutes ~/ 60}h ${_timeLimitMinutes % 60}min',
                      ),
                      const SizedBox(height: 10),
                      _InfoRow(
                        icon: Icons.view_list_rounded,
                        label: 'Secciones',
                        value: '$_sectionsCount secciones',
                      ),
                      const SizedBox(height: 10),
                      _InfoRow(
                        icon: Icons.shuffle_rounded,
                        label: 'Orden',
                        value: 'Aleatorio',
                      ),
                      const SizedBox(height: 28),

                      // Rules
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.orange.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.orange.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  color: AppColors.orange,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Recomendaciones',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.orange,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            _BulletPoint(
                              'Busca un lugar tranquilo y sin distracciones.',
                            ),
                            _BulletPoint('No podrás pausar el cronómetro.'),
                            _BulletPoint(
                              'Puedes regresar a preguntas anteriores.',
                            ),
                            _BulletPoint(
                              'Tus resultados se guardarán al terminar.',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // CTA
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: Column(
                  children: [
                    DuoButton(
                      text: 'Iniciar simulacro',
                      color: AppColors.orange,
                      icon: Icons.play_arrow_rounded,
                      onPressed: _startSimulation,
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Volver',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Info Row ────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 22),
          const SizedBox(width: 14),
          Text(
            label,
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Bullet Point ────────────────────────────────────────────────────────────

class _BulletPoint extends StatelessWidget {
  final String text;
  const _BulletPoint(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.textSecondary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
