import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:examen_vial_edomex_app_2025/models/option.dart';
import 'package:examen_vial_edomex_app_2025/services/database_service.dart';
import 'package:examen_vial_edomex_app_2025/services/sound_service.dart';
import 'package:examen_vial_edomex_app_2025/theme/app_theme.dart';
import 'package:examen_vial_edomex_app_2025/widgets/ad_banner_widget.dart';
import 'package:examen_vial_edomex_app_2025/widgets/duo_button.dart';
import 'package:flutter/material.dart';

class SignQuizScreen extends StatefulWidget {
  final List<Question> signQuestions;

  const SignQuizScreen({super.key, required this.signQuestions});

  @override
  State<SignQuizScreen> createState() => _SignQuizScreenState();
}

class _SignQuizScreenState extends State<SignQuizScreen> {
  static const int _normalQuestionCount = 10;
  static const int _speedQuestionCount = 12;
  static const int _speedSecondsPerQuestion = 12;

  late List<Question> _roundQuestions;
  late Map<int, List<Option>> _optionsByQuestion;

  Timer? _timer;
  bool _speedMode = false;
  bool _showResults = false;
  bool _savingResults = false;
  int _currentIndex = 0;
  int _secondsRemaining = _speedSecondsPerQuestion;
  final Map<int, int?> _answers = {};

  @override
  void initState() {
    super.initState();
    _startRound(speedMode: false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startRound({required bool speedMode}) {
    _timer?.cancel();
    final available =
        widget.signQuestions.where((q) => q.imagePath != null).toList()
          ..shuffle();
    final count = speedMode ? _speedQuestionCount : _normalQuestionCount;
    final selected = available.take(count).toList();

    setState(() {
      _speedMode = speedMode;
      _showResults = false;
      _savingResults = false;
      _currentIndex = 0;
      _secondsRemaining = _speedSecondsPerQuestion;
      _answers.clear();
      _roundQuestions = selected;
      _optionsByQuestion = {
        for (final q in selected) q.id: q.getShuffledOptions(),
      };
    });

    if (speedMode) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsRemaining = _speedSecondsPerQuestion;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || _showResults) {
        timer.cancel();
        return;
      }

      if (_secondsRemaining <= 1) {
        _selectAnswer(null, timedOut: true);
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  Future<void> _selectAnswer(int? optionId, {bool timedOut = false}) async {
    final question = _roundQuestions[_currentIndex];
    if (_answers.containsKey(question.id)) return;

    final isCorrect = optionId == question.correctOptionId;
    setState(() {
      _answers[question.id] = optionId;
      _secondsRemaining = _speedSecondsPerQuestion;
    });

    if (isCorrect) {
      await SoundService().playCorrect();
    } else {
      await SoundService().playIncorrect();
    }

    if (timedOut || _speedMode) {
      Future.delayed(const Duration(milliseconds: 650), () {
        if (mounted) _goNext();
      });
    }
  }

  Future<void> _finishRound() async {
    _timer?.cancel();
    if (_savingResults) return;

    setState(() {
      _showResults = true;
      _savingResults = true;
    });

    final outcomes = {
      for (final q in _roundQuestions)
        q.id: _answers[q.id] == q.correctOptionId,
    };
    await DatabaseService().recordReviewOutcomes(outcomes);

    if (mounted) {
      setState(() => _savingResults = false);
    }
  }

  void _goNext() {
    if (_currentIndex >= _roundQuestions.length - 1) {
      _finishRound();
      return;
    }

    setState(() {
      _currentIndex++;
      _secondsRemaining = _speedSecondsPerQuestion;
    });

    if (_speedMode) {
      _startTimer();
    }
  }

  int get _correctCount {
    return _roundQuestions
        .where((q) => _answers[q.id] == q.correctOptionId)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    if (_showResults) {
      return _buildResults();
    }

    final question = _roundQuestions[_currentIndex];
    final options = _optionsByQuestion[question.id] ?? question.options;
    final selectedOptionId = _answers[question.id];
    final hasAnswered = _answers.containsKey(question.id);
    final progress = (_currentIndex + 1) / _roundQuestions.length;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 14,
                  backgroundColor: AppColors.progressTrack(context),
                  valueColor: const AlwaysStoppedAnimation(AppColors.orange),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${_currentIndex + 1}/${_roundQuestions.length}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary(context),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _ModePill(
              speedMode: _speedMode,
              secondsRemaining: _secondsRemaining,
              onToggle:
                  hasAnswered
                      ? null
                      : () => _startRound(speedMode: !_speedMode),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxHeight < 610;
                final imageHeight = isCompact ? 132.0 : 178.0;
                final horizontalPadding = isCompact ? 16.0 : 20.0;

                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    isCompact ? 8 : 12,
                    horizontalPadding,
                    16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _speedMode ? 'Ronda rápida' : 'Reconoce la señal',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.orange,
                        ),
                      ),
                      SizedBox(height: isCompact ? 6 : 10),
                      Text(
                        '¿Qué señal de tránsito es esta?',
                        style: TextStyle(
                          fontSize: isCompact ? 19 : 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                      SizedBox(height: isCompact ? 12 : 18),
                      _SignImage(
                        imageUrl: question.imagePath!,
                        imageHeight: imageHeight,
                        compact: isCompact,
                      ),
                      SizedBox(height: isCompact ? 14 : 20),
                      ...options.map((option) {
                        final isSelected = selectedOptionId == option.id;
                        final isCorrect = option.id == question.correctOptionId;
                        return Padding(
                          padding: EdgeInsets.only(bottom: isCompact ? 8 : 12),
                          child: _AnswerTile(
                            text: option.text,
                            enabled: !hasAnswered,
                            isSelected: isSelected,
                            isCorrect: isCorrect,
                            revealAnswer: hasAnswered,
                            compact: isCompact,
                            onTap: () => _selectAnswer(option.id),
                          ),
                        );
                      }),
                      if (hasAnswered && question.explanation != null) ...[
                        const SizedBox(height: 4),
                        _ExplanationBox(text: question.explanation!),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
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
              child: DuoButton(
                text:
                    _currentIndex == _roundQuestions.length - 1
                        ? 'Ver resultado'
                        : 'Siguiente',
                color:
                    hasAnswered
                        ? AppColors.primary
                        : AppColors.cardBorder(context),
                icon:
                    _currentIndex == _roundQuestions.length - 1
                        ? Icons.emoji_events_rounded
                        : Icons.arrow_forward_rounded,
                onPressed: hasAnswered ? _goNext : null,
              ),
            ),
          ),
          const AdBannerWidget(),
        ],
      ),
    );
  }

  Widget _buildResults() {
    final percentage =
        _roundQuestions.isEmpty
            ? 0
            : (_correctCount / _roundQuestions.length) * 100;
    final passed = percentage >= 70;
    final accent = passed ? AppColors.primary : AppColors.orange;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Resultado'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${percentage.round()}%',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: accent,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                passed ? '¡Buen ojo!' : 'Vamos a reforzar señales',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Respondiste $_correctCount de ${_roundQuestions.length} correctamente.',
                style: TextStyle(
                  color: AppColors.textSecondary(context),
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              if (_savingResults) ...[
                const SizedBox(height: 22),
                const CircularProgressIndicator(color: AppColors.primary),
              ],
              const Spacer(),
              DuoButton(
                text: 'Nueva ronda',
                color: AppColors.orange,
                icon: Icons.refresh_rounded,
                onPressed: () => _startRound(speedMode: _speedMode),
              ),
              const SizedBox(height: 12),
              DuoButton(
                text: _speedMode ? 'Modo normal' : 'Ronda rápida',
                color: AppColors.secondary,
                icon: _speedMode ? Icons.school_rounded : Icons.timer_rounded,
                outlined: true,
                onPressed: () => _startRound(speedMode: !_speedMode),
              ),
              const SizedBox(height: 12),
              DuoButton(
                text: 'Volver al inicio',
                color: AppColors.primary,
                icon: Icons.home_rounded,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModePill extends StatelessWidget {
  final bool speedMode;
  final int secondsRemaining;
  final VoidCallback? onToggle;

  const _ModePill({
    required this.speedMode,
    required this.secondsRemaining,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: (speedMode ? AppColors.red : AppColors.orange).withValues(
            alpha: 0.12,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              speedMode ? Icons.timer_rounded : Icons.signpost_rounded,
              color: speedMode ? AppColors.red : AppColors.orange,
              size: 18,
            ),
            const SizedBox(width: 5),
            Text(
              speedMode ? '${secondsRemaining}s' : 'Normal',
              style: TextStyle(
                color: speedMode ? AppColors.red : AppColors.orange,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignImage extends StatelessWidget {
  final String imageUrl;
  final double imageHeight;
  final bool compact;

  const _SignImage({
    required this.imageUrl,
    required this.imageHeight,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(compact ? 10 : 16),
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder(context), width: 2),
        ),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          height: imageHeight,
          fit: BoxFit.contain,
          placeholder:
              (context, url) => SizedBox(
                height: imageHeight,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.orange,
                    backgroundColor: AppColors.progressTrack(context),
                  ),
                ),
              ),
          errorWidget:
              (context, url, error) => SizedBox(
                height: imageHeight,
                child: Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: AppColors.textLight(context),
                    size: 44,
                  ),
                ),
              ),
        ),
      ),
    );
  }
}

class _AnswerTile extends StatelessWidget {
  final String text;
  final bool enabled;
  final bool isSelected;
  final bool isCorrect;
  final bool revealAnswer;
  final bool compact;
  final VoidCallback onTap;

  const _AnswerTile({
    required this.text,
    required this.enabled,
    required this.isSelected,
    required this.isCorrect,
    required this.revealAnswer,
    required this.compact,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        revealAnswer && isCorrect
            ? AppColors.primary
            : revealAnswer && isSelected
            ? AppColors.red
            : isSelected
            ? AppColors.secondary
            : AppColors.cardBorder(context);

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 12 : 16,
          vertical: compact ? 11 : 16,
        ),
        decoration: BoxDecoration(
          color:
              revealAnswer && (isCorrect || isSelected)
                  ? color.withValues(alpha: 0.1)
                  : AppColors.surface(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 2),
        ),
        child: Row(
          children: [
            Icon(
              revealAnswer && isCorrect
                  ? Icons.check_circle_rounded
                  : revealAnswer && isSelected
                  ? Icons.cancel_rounded
                  : Icons.radio_button_unchecked_rounded,
              color:
                  revealAnswer && (isCorrect || isSelected)
                      ? color
                      : AppColors.textLight(context),
              size: compact ? 21 : 24,
            ),
            SizedBox(width: compact ? 9 : 12),
            Expanded(
              child: Text(
                text.replaceAll('[br]', '\n'),
                style: TextStyle(
                  fontSize: compact ? 14 : 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary(context),
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExplanationBox extends StatelessWidget {
  final String text;

  const _ExplanationBox({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_rounded,
            color: AppColors.secondary,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text.replaceAll('[br]', '\n'),
              style: TextStyle(
                color: AppColors.textSecondary(context),
                height: 1.45,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
