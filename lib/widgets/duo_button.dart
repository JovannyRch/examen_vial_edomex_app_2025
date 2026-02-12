import 'package:flutter/material.dart';
import 'package:my_quiz_app/theme/app_theme.dart';
import 'package:my_quiz_app/services/sound_service.dart';

/// Duolingo-style 3D button with press animation.
/// The button has a darker bottom border that disappears on press,
/// creating a satisfying "push" effect.
class DuoButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color color;
  final IconData? icon;
  final bool fullWidth;
  final bool outlined;

  const DuoButton({
    super.key,
    required this.text,
    this.onPressed,
    this.color = const Color(0xFF58CC02),
    this.icon,
    this.fullWidth = true,
    this.outlined = false,
  });

  @override
  State<DuoButton> createState() => _DuoButtonState();
}

class _DuoButtonState extends State<DuoButton> {
  bool _isPressed = false;

  bool get _enabled => widget.onPressed != null;
  Color get _darkColor => AppColors.darken(widget.color, 0.18);

  void _handleTapDown(TapDownDetails _) {
    if (_enabled) setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails _) {
    if (_enabled) {
      setState(() => _isPressed = false);
      SoundService().playTap();
      widget.onPressed?.call();
    }
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final double bottomPad = _isPressed ? 0.0 : 4.0;
    final double topMargin = _isPressed ? 4.0 : 0.0;

    if (widget.outlined) {
      return _buildOutlined(topMargin, bottomPad);
    }
    return _buildFilled(topMargin, bottomPad);
  }

  Widget _buildFilled(double topMargin, double bottomPad) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        width: widget.fullWidth ? double.infinity : null,
        margin: EdgeInsets.only(top: topMargin),
        padding: EdgeInsets.only(bottom: bottomPad),
        decoration: BoxDecoration(
          color: _enabled ? _darkColor : Colors.grey.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: _enabled ? widget.color : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(16),
          ),
          child: _buildContent(Colors.white),
        ),
      ),
    );
  }

  Widget _buildOutlined(double topMargin, double bottomPad) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        width: widget.fullWidth ? double.infinity : null,
        margin: EdgeInsets.only(top: topMargin),
        padding: EdgeInsets.only(bottom: bottomPad),
        decoration: BoxDecoration(
          color: AppColors.cardBorder,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder, width: 2),
          ),
          child: _buildContent(widget.color),
        ),
      ),
    );
  }

  Widget _buildContent(Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (widget.icon != null) ...[
          Icon(widget.icon, color: textColor, size: 20),
          const SizedBox(width: 8),
        ],
        Text(
          widget.text,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}
