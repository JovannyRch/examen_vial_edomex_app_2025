import 'package:examen_vial_edomex_app_2025/const/const.dart';
import 'package:examen_vial_edomex_app_2025/data/data.dart';
import 'package:examen_vial_edomex_app_2025/screens/exam_screen.dart';
import 'package:examen_vial_edomex_app_2025/screens/favorites_screen.dart';
import 'package:examen_vial_edomex_app_2025/screens/guide_screen.dart';
import 'package:examen_vial_edomex_app_2025/screens/pdf_viewer_screen.dart';
import 'package:examen_vial_edomex_app_2025/screens/category_screen.dart';
import 'package:examen_vial_edomex_app_2025/screens/progress_screen.dart';
import 'package:examen_vial_edomex_app_2025/services/notification_service.dart';
import 'package:examen_vial_edomex_app_2025/services/sound_service.dart';
import 'package:examen_vial_edomex_app_2025/theme/app_theme.dart';
import 'package:examen_vial_edomex_app_2025/widgets/ad_banner_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<Offset>> _slideAnimations;
  late final List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(6, (index) {
      return AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500 + (index * 150)),
      );
    });

    _slideAnimations =
        _controllers.map((c) {
          return Tween<Offset>(
            begin: const Offset(0, 0.3),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: c, curve: Curves.easeOutCubic));
        }).toList();

    _fadeAnimations =
        _controllers.map((c) {
          return Tween<double>(
            begin: 0,
            end: 1,
          ).animate(CurvedAnimation(parent: c, curve: Curves.easeOut));
        }).toList();

    for (var c in _controllers) {
      c.forward();
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Route _slideRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    // Logo
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset('assets/logo.png', height: 72),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Examen Vial EdoMex',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '¡Prepárate para aprobar tu examen de manejo! 🚗',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 36),

                    // Action Cards
                    _buildAnimatedCard(
                      index: 0,
                      icon: Icons.menu_book_rounded,
                      color: AppColors.secondary,
                      title: 'Guía de Estudio',
                      subtitle:
                          'Aprende las ${questions.length} preguntas con sus respuestas',
                      onTap:
                          () => Navigator.push(
                            context,
                            _slideRoute(GuideScreen(allQuestions: questions)),
                          ),
                    ),
                    const SizedBox(height: 16),
                    _buildAnimatedCard(
                      index: 1,
                      icon: Icons.category_rounded,
                      color: AppColors.orange,
                      title: 'Práctica por Categoría',
                      subtitle: 'Enfócate en tus áreas débiles',
                      onTap:
                          () => Navigator.push(
                            context,
                            _slideRoute(const CategoryScreen()),
                          ),
                    ),
                    const SizedBox(height: 16),
                    _buildAnimatedCard(
                      index: 2,
                      icon: Icons.quiz_rounded,
                      color: AppColors.primary,
                      title: 'Examen Simulado',
                      subtitle: 'Pon a prueba lo que has aprendido',
                      onTap:
                          () => Navigator.push(
                            context,
                            _slideRoute(ExamScreen(allQuestions: questions)),
                          ),
                    ),
                    const SizedBox(height: 16),
                    _buildAnimatedCard(
                      index: 3,
                      icon: Icons.picture_as_pdf_rounded,
                      color: AppColors.secondaryDark,
                      title: 'Guía en PDF',
                      subtitle: 'Descarga y consulta la guía oficial',
                      onTap:
                          () => Navigator.push(
                            context,
                            _slideRoute(PdfViewerScreen(pdfUrl: PDF_URL)),
                          ),
                    ),
                    const SizedBox(height: 16),
                    _buildAnimatedCard(
                      index: 4,
                      icon: Icons.bookmark_rounded,
                      color: AppColors.orange,
                      title: 'Preguntas Guardadas',
                      subtitle: 'Tus preguntas marcadas y las que fallaste',
                      onTap:
                          () => Navigator.push(
                            context,
                            _slideRoute(const FavoritesScreen()),
                          ),
                    ),
                    const SizedBox(height: 16),
                    _buildAnimatedCard(
                      index: 5,
                      icon: Icons.bar_chart_rounded,
                      color: AppColors.purple,
                      title: 'Mi Progreso',
                      subtitle: 'Historial, estadísticas y racha de estudio',
                      onTap:
                          () => Navigator.push(
                            context,
                            _slideRoute(const ProgressScreen()),
                          ),
                    ),
                    const SizedBox(height: 24),

                    // Reminder Banner
                    const _ReminderBanner(),
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

  Widget _buildAnimatedCard({
    required int index,
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return SlideTransition(
      position: _slideAnimations[index],
      child: FadeTransition(
        opacity: _fadeAnimations[index],
        child: _ActionCard(
          icon: icon,
          color: color,
          title: title,
          subtitle: subtitle,
          onTap: onTap,
        ),
      ),
    );
  }
}

// ─── Action Card with Duolingo-style 3D press effect ────────────────────────

class _ActionCard extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<_ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<_ActionCard> {
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
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.cardBorder, width: 2),
          ),
          child: Row(
            children: [
              // Icon container
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(widget.icon, color: widget.color, size: 28),
              ),
              const SizedBox(width: 16),
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Arrow
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textLight,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Reminder Banner ────────────────────────────────────────────────────────

class _ReminderBanner extends StatefulWidget {
  const _ReminderBanner();

  @override
  State<_ReminderBanner> createState() => _ReminderBannerState();
}

class _ReminderBannerState extends State<_ReminderBanner> {
  bool _enabled = false;
  TimeOfDay _time = const TimeOfDay(hour: 20, minute: 0);
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final ns = NotificationService();
    final enabled = await ns.isReminderEnabled();
    final hour = await ns.getReminderHour();
    final minute = await ns.getReminderMinute();
    if (mounted) {
      setState(() {
        _enabled = enabled;
        _time = TimeOfDay(hour: hour, minute: minute);
        _loading = false;
      });
    }
  }

  Future<void> _toggle(bool value) async {
    SoundService().playTap();
    if (value) {
      final granted = await NotificationService().requestPermissions();
      if (!granted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Necesitas permitir notificaciones en los ajustes del dispositivo',
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }
      await NotificationService().scheduleDailyReminder(
        _time.hour,
        _time.minute,
      );
    } else {
      await NotificationService().cancelReminder();
    }
    setState(() => _enabled = value);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _time) {
      SoundService().playTap();
      setState(() => _time = picked);
      if (_enabled) {
        await NotificationService().scheduleDailyReminder(
          picked.hour,
          picked.minute,
        );
      }
    }
  }

  String _formatTime(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $period';
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
        children: [
          // Toggle row
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.purple.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.notifications_active_rounded,
                  color: AppColors.purple,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recordatorio diario',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      _enabled
                          ? 'Te avisamos a las ${_formatTime(_time)}'
                          : 'No olvides practicar',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: _enabled,
                onChanged: _toggle,
                activeColor: AppColors.primary,
              ),
            ],
          ),

          // Time picker (only if enabled)
          if (_enabled) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _pickTime,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatTime(_time),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Cambiar hora',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.primary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
