import 'package:flutter/material.dart';
import 'package:exani/services/sound_service.dart';
import 'package:exani/theme/app_theme.dart';

/// Widgets reutilizables para el MVP EXANI.

// ─── StatChip ────────────────────────────────────────────────────────────────

/// Chip compacto para mostrar una estadística con emoji.
class StatChip extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;

  const StatChip({
    super.key,
    required this.emoji,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
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
}

// ─── SectionHeader ───────────────────────────────────────────────────────────

/// Encabezado de sección con opción de acción.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          if (actionText != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionText!,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── ProgressCard ────────────────────────────────────────────────────────────

/// Card con barra de progreso, título y valor.
class ProgressCard extends StatelessWidget {
  final String title;
  final double progress; // 0.0 – 1.0
  final String trailingText;
  final Color color;

  const ProgressCard({
    super.key,
    required this.title,
    required this.progress,
    required this.trailingText,
    this.color = AppColors.primary,
  });

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                trailingText,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: AppColors.progressTrack,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── SkillBadge ──────────────────────────────────────────────────────────────

/// Badge que muestra nivel de una habilidad.
class SkillBadge extends StatelessWidget {
  final String name;
  final String level; // 'alto', 'medio', 'bajo'

  const SkillBadge({super.key, required this.name, required this.level});

  Color get _color {
    switch (level) {
      case 'alto':
        return AppColors.primary;
      case 'medio':
        return AppColors.orange;
      default:
        return AppColors.red;
    }
  }

  IconData get _icon {
    switch (level) {
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, color: _color, size: 16),
          const SizedBox(width: 6),
          Text(
            name,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _color,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Pressable3DCard ─────────────────────────────────────────────────────────

/// Card reutilizable con efecto 3D Duolingo-style.
class Pressable3DCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color accentColor;
  final EdgeInsets padding;

  const Pressable3DCard({
    super.key,
    required this.child,
    required this.onTap,
    this.accentColor = AppColors.primary,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  });

  @override
  State<Pressable3DCard> createState() => _Pressable3DCardState();
}

class _Pressable3DCardState extends State<Pressable3DCard> {
  bool _isPressed = false;

  Color get _darkColor => AppColors.darken(widget.accentColor, 0.18);

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
          padding: widget.padding,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.cardBorder, width: 2),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

// ─── DaysCountdownChip ───────────────────────────────────────────────────────

/// Chip que muestra días restantes con color contextual.
class DaysCountdownChip extends StatelessWidget {
  final int daysLeft;

  const DaysCountdownChip({super.key, required this.daysLeft});

  Color get _color {
    if (daysLeft <= 7) return AppColors.red;
    if (daysLeft <= 14) return AppColors.orange;
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_today_rounded, color: _color, size: 13),
          const SizedBox(width: 4),
          Text(
            '$daysLeft días restantes',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: _color,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── EmptyStateWidget ────────────────────────────────────────────────────────

/// Widget genérico para estados vacíos.
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.textLight, size: 56),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            if (actionText != null) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: onAction,
                child: Text(
                  actionText!,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
