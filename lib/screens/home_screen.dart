import 'package:exani/const/const.dart';
import 'package:exani/data/data.dart';
import 'package:exani/screens/exam_screen.dart';
import 'package:exani/screens/favorites_screen.dart';
import 'package:exani/screens/guide_screen.dart';
import 'package:exani/screens/pdf_viewer_screen.dart';
import 'package:exani/screens/category_screen.dart';
import 'package:exani/screens/info_screen.dart';
import 'package:exani/screens/pro_screen.dart';
import 'package:exani/screens/progress_screen.dart';
import 'package:exani/services/database_service.dart';
import 'package:exani/services/notification_service.dart';
import 'package:exani/services/purchase_service.dart';
import 'package:exani/services/sound_service.dart';
import 'package:exani/services/theme_service.dart';
import 'package:exani/theme/app_theme.dart';
import 'package:exani/widgets/ad_banner_widget.dart';
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

  int _totalExams = 0;
  int _bestScore = 0;
  int _streak = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
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

  Future<void> _loadStats() async {
    try {
      final stats = await DatabaseService().getAllStats();
      if (mounted) {
        setState(() {
          _totalExams = stats['totalExams'] as int;
          _bestScore = (stats['bestScore'] as num).round();
          _streak = stats['streak'] as int;
        });
      }
    } catch (_) {}
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
                    const SizedBox(height: 12),
                    // Theme toggle
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          SoundService().playTap();
                          ThemeService().toggleTheme();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          child: Icon(
                            ThemeService().isDark
                                ? Icons.light_mode_rounded
                                : Icons.dark_mode_rounded,
                            color:
                                ThemeService().isDark
                                    ? AppColors.orange
                                    : AppColors.textSecondary,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Logo
                    /* Container(
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
                    const SizedBox(height: 8), */
                    Text(
                      '¡Prepárate para aprobar tu examen! 📝',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Quick Stats
                    _buildAnimatedWidget(0, _buildStatsRow()),
                    const SizedBox(height: 24),

                    // Main CTA: Examen Simulado
                    _buildAnimatedWidget(1, _buildMainCTA()),
                    const SizedBox(height: 16),

                    // Study Cards
                    _buildAnimatedCard(
                      index: 2,
                      icon: Icons.menu_book_rounded,
                      color: AppColors.secondary,
                      title: 'Guía de Estudio',
                      subtitle:
                          'Aprende las ${questions.length} preguntas con sus respuestas',
                      onTap:
                          () => Navigator.push(
                            context,
                            _slideRoute(GuideScreen(allQuestions: questions)),
                          ).then((_) => _loadStats()),
                    ),
                    const SizedBox(height: 12),
                    _buildAnimatedCard(
                      index: 3,
                      icon: Icons.category_rounded,
                      color: AppColors.orange,
                      title: 'Práctica por Categoría',
                      subtitle: 'Enfócate en tus áreas débiles',
                      onTap:
                          () => Navigator.push(
                            context,
                            _slideRoute(const CategoryScreen()),
                          ).then((_) => _loadStats()),
                    ),
                    const SizedBox(height: 20),

                    // Herramientas Grid
                    _buildAnimatedWidget(
                      4,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 4, bottom: 12),
                            child: Text(
                              'Herramientas',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textSecondary,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: _CompactCard(
                                  icon: Icons.picture_as_pdf_rounded,
                                  color: AppColors.secondaryDark,
                                  title: 'Guía PDF',
                                  onTap:
                                      () => Navigator.push(
                                        context,
                                        _slideRoute(
                                          PdfViewerScreen(pdfUrl: PDF_URL),
                                        ),
                                      ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _CompactCard(
                                  icon: Icons.bookmark_rounded,
                                  color: AppColors.orange,
                                  title: 'Guardadas',
                                  onTap:
                                      () => Navigator.push(
                                        context,
                                        _slideRoute(const FavoritesScreen()),
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _CompactCard(
                                  icon: Icons.bar_chart_rounded,
                                  color: AppColors.purple,
                                  title: 'Progreso',
                                  onTap:
                                      () => Navigator.push(
                                        context,
                                        _slideRoute(const ProgressScreen()),
                                      ).then((_) => _loadStats()),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _CompactCard(
                                  icon: Icons.info_outline_rounded,
                                  color: AppColors.secondaryDark,
                                  title: 'Info Examen',
                                  onTap:
                                      () => Navigator.push(
                                        context,
                                        _slideRoute(const InfoScreen()),
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Pro Banner
                    ValueListenableBuilder<bool>(
                      valueListenable: PurchaseService().isPro,
                      builder: (context, isPro, _) {
                        return _buildAnimatedWidget(5, _buildProBanner(isPro));
                      },
                    ),

                    const SizedBox(height: 20),

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

  Widget _buildAnimatedWidget(int index, Widget child) {
    return SlideTransition(
      position: _slideAnimations[index],
      child: FadeTransition(opacity: _fadeAnimations[index], child: child),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatChip('🎯', '$_totalExams', 'exámenes'),
        const SizedBox(width: 10),
        _buildStatChip('⭐', '$_bestScore%', 'mejor'),
        const SizedBox(width: 10),
        _buildStatChip('🔥', '$_streak', 'días racha'),
      ],
    );
  }

  Widget _buildStatChip(String emoji, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCTA() {
    return GestureDetector(
      onTap: () {
        SoundService().playTap();
        Navigator.push(
          context,
          _slideRoute(ExamScreen(allQuestions: questions)),
        ).then((_) => _loadStats());
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.quiz_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Examen Simulado',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pon a prueba lo que has aprendido',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProBanner(bool isPro) {
    return GestureDetector(
      onTap: () {
        SoundService().playTap();
        Navigator.push(context, _slideRoute(const ProScreen()));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD700).withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              isPro
                  ? Icons.check_circle_rounded
                  : Icons.workspace_premium_rounded,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isPro ? 'Eres Pro ⭐' : 'Versión Pro',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    isPro
                        ? 'Disfruta la app sin anuncios'
                        : 'Sin anuncios · Compra única',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 18,
            ),
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
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Arrow
              Icon(
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

// ─── Compact Card for grid items ─────────────────────────────────────────────

class _CompactCard extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String title;
  final VoidCallback onTap;

  const _CompactCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.onTap,
  });

  @override
  State<_CompactCard> createState() => _CompactCardState();
}

class _CompactCardState extends State<_CompactCard> {
  bool _isPressed = false;

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
        margin: EdgeInsets.only(top: _isPressed ? 2 : 0),
        padding: EdgeInsets.only(bottom: _isPressed ? 0 : 2),
        decoration: BoxDecoration(
          color: AppColors.darken(widget.color, 0.18),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder, width: 2),
          ),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(widget.icon, color: widget.color, size: 22),
              ),
              const SizedBox(height: 8),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
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
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
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
                    Text(
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
                      style: TextStyle(
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
