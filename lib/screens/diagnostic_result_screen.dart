import 'package:flutter/material.dart';
import 'package:exani/services/sound_service.dart';
import 'package:exani/theme/app_theme.dart';
import 'package:exani/widgets/duo_button.dart';

/// Pantalla 3 del MVP: Resultados del diagnóstico.
/// Muestra nivel por área con recomendaciones.
class DiagnosticResultScreen extends StatefulWidget {
  final List<AreaResult> areaResults;
  final double overallAccuracy;
  final int totalQuestions;
  final int correctAnswers;
  final VoidCallback onContinue;

  const DiagnosticResultScreen({
    super.key,
    required this.areaResults,
    required this.overallAccuracy,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.onContinue,
  });

  @override
  State<DiagnosticResultScreen> createState() => _DiagnosticResultScreenState();
}

class _DiagnosticResultScreenState extends State<DiagnosticResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _animController.forward();
    SoundService().playCorrect(); // celebración sutil
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Column(
                    children: [
                      // Score circle
                      _ScoreCircle(
                        accuracy: widget.overallAccuracy,
                        correct: widget.correctAnswers,
                        total: widget.totalQuestions,
                      ),
                      const SizedBox(height: 24),

                      // Título
                      Text(
                        _getTitle(widget.overallAccuracy),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getSubtitle(widget.overallAccuracy),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Resultados por área
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Resultado por área',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      ...widget.areaResults.map(
                        (area) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _AreaResultCard(area: area),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // CTA
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: DuoButton(
                  text: 'Comenzar a practicar',
                  color: AppColors.primary,
                  icon: Icons.rocket_launch_rounded,
                  onPressed: widget.onContinue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTitle(double accuracy) {
    if (accuracy >= 80) return '¡Excelente punto de partida!';
    if (accuracy >= 60) return 'Buen inicio, hay potencial';
    if (accuracy >= 40) return 'Tienes oportunidades claras';
    return 'No te preocupes, para eso estamos';
  }

  String _getSubtitle(double accuracy) {
    if (accuracy >= 80) {
      return 'Ya tienes una base sólida. Enfócate en afinar los detalles.';
    }
    if (accuracy >= 60) {
      return 'Con práctica dirigida puedes mejorar rápidamente.';
    }
    if (accuracy >= 40) {
      return 'Identificamos exactamente dónde enfocar tu estudio.';
    }
    return 'Este diagnóstico nos ayuda a crear tu plan personalizado.';
  }
}

// ─── Score Circle ───────────────────────────────────────────────────────────

class _ScoreCircle extends StatelessWidget {
  final double accuracy;
  final int correct;
  final int total;

  const _ScoreCircle({
    required this.accuracy,
    required this.correct,
    required this.total,
  });

  Color get _color {
    if (accuracy >= 80) return AppColors.primary;
    if (accuracy >= 60) return AppColors.orange;
    return AppColors.red;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background track
          SizedBox(
            width: 140,
            height: 140,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 10,
              strokeCap: StrokeCap.round,
              valueColor: AlwaysStoppedAnimation(AppColors.progressTrack),
            ),
          ),
          // Progress
          SizedBox(
            width: 140,
            height: 140,
            child: CircularProgressIndicator(
              value: accuracy / 100,
              strokeWidth: 10,
              strokeCap: StrokeCap.round,
              valueColor: AlwaysStoppedAnimation(_color),
            ),
          ),
          // Text
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${accuracy.round()}%',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: _color,
                ),
              ),
              Text(
                '$correct/$total',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Area Result Card ───────────────────────────────────────────────────────

class AreaResult {
  final String areaName;
  final double accuracy;
  final int correct;
  final int total;
  final String level; // 'alto', 'medio', 'bajo'

  const AreaResult({
    required this.areaName,
    required this.accuracy,
    required this.correct,
    required this.total,
    required this.level,
  });

  factory AreaResult.fromStats({
    required String areaName,
    required int correct,
    required int total,
  }) {
    final acc = total > 0 ? (correct / total) * 100 : 0.0;
    return AreaResult(
      areaName: areaName,
      accuracy: acc,
      correct: correct,
      total: total,
      level: acc >= 70 ? 'alto' : (acc >= 40 ? 'medio' : 'bajo'),
    );
  }
}

class _AreaResultCard extends StatelessWidget {
  final AreaResult area;
  const _AreaResultCard({required this.area});

  Color get _color {
    switch (area.level) {
      case 'alto':
        return AppColors.primary;
      case 'medio':
        return AppColors.orange;
      default:
        return AppColors.red;
    }
  }

  String get _levelLabel {
    switch (area.level) {
      case 'alto':
        return 'Alto';
      case 'medio':
        return 'Medio';
      default:
        return 'Bajo';
    }
  }

  IconData get _levelIcon {
    switch (area.level) {
      case 'alto':
        return Icons.trending_up_rounded;
      case 'medio':
        return Icons.trending_flat_rounded;
      default:
        return Icons.trending_down_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  area.areaName,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_levelIcon, color: _color, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      _levelLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Progress bar
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: area.accuracy / 100,
                    minHeight: 8,
                    backgroundColor: AppColors.progressTrack,
                    valueColor: AlwaysStoppedAnimation(_color),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${area.accuracy.round()}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${area.correct}/${area.total} correctas',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
