import 'package:examen_vial_edomex_app_2025/models/exam_result.dart';
import 'package:examen_vial_edomex_app_2025/services/database_service.dart';
import 'package:examen_vial_edomex_app_2025/const/const.dart';
import 'package:examen_vial_edomex_app_2025/theme/app_theme.dart';
import 'package:examen_vial_edomex_app_2025/widgets/ad_banner_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  bool _isLoading = true;
  Map<String, dynamic> _stats = {};
  List<ExamResult> _lastResults = [];

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
    _loadStats();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loadStats() async {
    final stats = await DatabaseService().getAllStats();
    final results = stats['lastResults'] as List<ExamResult>;
    if (mounted) {
      setState(() {
        _stats = stats;
        _lastResults = results;
        _isLoading = false;
      });
      _animController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Mi Progreso'),
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
              : _stats['totalExams'] == 0
              ? _buildEmptyState()
              : FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            _buildStreakBanner(),
                            const SizedBox(height: 20),
                            _buildStatsGrid(),
                            const SizedBox(height: 24),
                            _buildScoreChart(),
                            const SizedBox(height: 24),
                            _buildRecentResults(),
                            const SizedBox(height: 24),
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

  // ─── Empty State ──────────────────────────────────────────────────────────

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.bar_chart_rounded,
                size: 64,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Aún no hay datos',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Realiza tu primer examen simulado\npara comenzar a ver tu progreso aquí.',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary(context),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ─── Streak Banner ────────────────────────────────────────────────────────

  Widget _buildStreakBanner() {
    final int streak = _stats['streak'] ?? 0;
    final bool hasStreak = streak > 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              hasStreak
                  ? [AppColors.orange, const Color(0xFFFFB347)]
                  : [AppColors.cardBorder(context), AppColors.cardBorder(context)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow:
            hasStreak
                ? [
                  BoxShadow(
                    color: AppColors.orange.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
                : [],
      ),
      child: Row(
        children: [
          Text(hasStreak ? '🔥' : '❄️', style: const TextStyle(fontSize: 36)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasStreak
                      ? '$streak ${streak == 1 ? 'día' : 'días'} de racha'
                      : '¡Comienza tu racha!',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: hasStreak ? Colors.white : AppColors.textSecondary(context),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hasStreak
                      ? '¡Sigue así! No pierdas tu racha 💪'
                      : 'Practica hoy para iniciar',
                  style: TextStyle(
                    fontSize: 13,
                    color:
                        hasStreak
                            ? Colors.white.withValues(alpha: 0.85)
                            : AppColors.textLight(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Stats Grid ───────────────────────────────────────────────────────────

  Widget _buildStatsGrid() {
    final int totalExams = _stats['totalExams'] ?? 0;
    final double avgScore = _stats['avgScore'] ?? 0;
    final double bestScore = _stats['bestScore'] ?? 0;
    final double passRate = _stats['passRate'] ?? 0;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.assignment_rounded,
                label: 'Exámenes',
                value: '$totalExams',
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.trending_up_rounded,
                label: 'Promedio',
                value: '${avgScore.round()}%',
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.emoji_events_rounded,
                label: 'Mejor nota',
                value: '${bestScore.round()}%',
                color: AppColors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.check_circle_rounded,
                label: 'Aprobados',
                value: '${passRate.round()}%',
                color: passRate >= 70 ? AppColors.primary : AppColors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─── Score Chart ──────────────────────────────────────────────────────────

  Widget _buildScoreChart() {
    if (_lastResults.length < 2) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder(context), width: 2),
        ),
        child: Column(
          children: [
            Icon(
              Icons.show_chart_rounded,
              size: 40,
              color: AppColors.textLight(context),
            ),
            const SizedBox(height: 12),
            Text(
              'Necesitas al menos 2 exámenes\npara ver la gráfica de evolución',
              style: TextStyle(
                color: AppColors.textSecondary(context),
                fontSize: 14,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final spots =
        _lastResults.asMap().entries.map((e) {
          return FlSpot(e.key.toDouble(), e.value.percentage);
        }).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 20, 20, 12),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder(context), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8),
            child: Text(
              'Evolución de calificaciones',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: 100,
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 20,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine:
                      (value) =>
                          FlLine(color: AppColors.cardBorder(context), strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      interval: 20,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}%',
                          style: TextStyle(
                            color: AppColors.textLight(context),
                            fontSize: 11,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval:
                          _lastResults.length > 10
                              ? (_lastResults.length / 5).ceilToDouble()
                              : 1,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= _lastResults.length) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          '#${idx + 1}',
                          style: TextStyle(
                            color: AppColors.textLight(context),
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    curveSmoothness: 0.3,
                    color: AppColors.secondary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, bar, index) {
                        final isPassed = spot.y >= EXAM_PASSING_PERCENTAGE;
                        return FlDotCirclePainter(
                          radius: 4,
                          color: isPassed ? AppColors.primary : AppColors.red,
                          strokeWidth: 2,
                          strokeColor: AppColors.surface(context),
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.secondary.withValues(alpha: 0.08),
                    ),
                  ),
                  // Pass threshold line
                  LineChartBarData(
                    spots: [
                      FlSpot(0, EXAM_PASSING_PERCENTAGE),
                      FlSpot(
                        (_lastResults.length - 1).toDouble(),
                        EXAM_PASSING_PERCENTAGE,
                      ),
                    ],
                    isCurved: false,
                    color: AppColors.primary.withValues(alpha: 0.4),
                    barWidth: 2,
                    dashArray: [6, 4],
                    dotData: const FlDotData(show: false),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (spot) => AppColors.textPrimary(context),
                    getTooltipItems: (spots) {
                      return spots.map((spot) {
                        if (spot.barIndex == 1)
                          return null; // Skip threshold line
                        final idx = spot.x.toInt();
                        if (idx < 0 || idx >= _lastResults.length) return null;
                        final result = _lastResults[idx];
                        return LineTooltipItem(
                          '${result.correctAnswers}/${result.totalQuestions}\n${result.percentage.round()}%',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 10,
                height: 3,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Línea de aprobación (${EXAM_PASSING_PERCENTAGE.round()}%)',
                style: TextStyle(color: AppColors.textLight(context), fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Recent Results ───────────────────────────────────────────────────────

  Widget _buildRecentResults() {
    // Show last 5 only
    final recent = _lastResults.reversed.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Últimos resultados',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary(context),
          ),
        ),
        const SizedBox(height: 12),
        ...recent.map((r) {
          final color = r.passed ? AppColors.primary : AppColors.red;
          final timeMin = r.timeSpentSeconds ~/ 60;
          final timeSec = r.timeSpentSeconds % 60;

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface(context),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.cardBorder(context), width: 2),
            ),
            child: Row(
              children: [
                // Score badge
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '${r.percentage.round()}%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: color,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${r.correctAnswers}/${r.totalQuestions} correctas',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${timeMin}m ${timeSec}s  •  ${_formatDate(r.date)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary(context),
                        ),
                      ),
                    ],
                  ),
                ),
                // Pass/fail icon
                Icon(
                  r.passed ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  color: color,
                  size: 24,
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'Ahora';
    if (diff.inHours < 1) return 'Hace ${diff.inMinutes}min';
    if (diff.inDays == 0) return 'Hoy';
    if (diff.inDays == 1) return 'Ayer';
    if (diff.inDays < 7) return 'Hace ${diff.inDays} días';

    return DateFormat('dd/MM/yy').format(date);
  }
}

// ─── Stat Card Widget ───────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder(context), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary(context)),
          ),
        ],
      ),
    );
  }
}
