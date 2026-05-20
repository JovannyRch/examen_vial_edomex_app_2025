import 'package:examen_vial_edomex_app_2025/models/option.dart';
import 'package:examen_vial_edomex_app_2025/screens/exam_screen.dart';
import 'package:examen_vial_edomex_app_2025/services/sound_service.dart';
import 'package:examen_vial_edomex_app_2025/theme/app_theme.dart';
import 'package:examen_vial_edomex_app_2025/widgets/ad_banner_widget.dart';
import 'package:examen_vial_edomex_app_2025/widgets/duo_button.dart';
import 'package:flutter/material.dart';

class CustomExamScreen extends StatefulWidget {
  final List<Question> allQuestions;

  const CustomExamScreen({super.key, required this.allQuestions});

  @override
  State<CustomExamScreen> createState() => _CustomExamScreenState();
}

class _CustomExamScreenState extends State<CustomExamScreen> {
  static const _questionCountOptions = [10, 20, 30, 50];

  final Set<QuestionCategory> _selectedCategories = {
    ...QuestionCategory.values,
  };
  int _questionCount = 10;
  bool _timed = true;

  List<Question> get _availableQuestions {
    return widget.allQuestions
        .where((q) => _selectedCategories.contains(q.category))
        .toList();
  }

  int get _effectiveQuestionCount {
    final availableCount = _availableQuestions.length;
    if (availableCount == 0) return 0;
    return _questionCount.clamp(1, availableCount);
  }

  int get _durationMinutes => _effectiveQuestionCount.clamp(5, 60);

  void _toggleCategory(QuestionCategory category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    });
  }

  void _startExam() {
    final selectedQuestions = _availableQuestions;
    if (selectedQuestions.isEmpty) return;

    SoundService().playTap();
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder:
            (_, __, ___) => ExamScreen(
              allQuestions: selectedQuestions,
              customQuestionCount: _effectiveQuestionCount,
              customDurationMinutes: _durationMinutes,
              customPassingPercentage: 70,
              isTimed: _timed,
            ),
        transitionsBuilder: (_, animation, __, child) {
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
    final availableCount = _availableQuestions.length;
    final canStart = availableCount > 0;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Crear Examen'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeaderCard(
                    availableCount: availableCount,
                    questionCount: _effectiveQuestionCount,
                    timed: _timed,
                    durationMinutes: _durationMinutes,
                  ),
                  const SizedBox(height: 24),
                  const _SectionTitle(
                    icon: Icons.category_rounded,
                    title: 'Categorías',
                    subtitle: 'Elige los temas que quieres practicar',
                  ),
                  const SizedBox(height: 12),
                  ...QuestionCategory.values.map(
                    (category) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _CategoryToggle(
                        category: category,
                        selected: _selectedCategories.contains(category),
                        count:
                            widget.allQuestions
                                .where((q) => q.category == category)
                                .length,
                        onTap: () => _toggleCategory(category),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  const _SectionTitle(
                    icon: Icons.format_list_numbered_rounded,
                    title: 'Número de preguntas',
                    subtitle: 'Se ajustará si una categoría tiene menos',
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children:
                        _questionCountOptions.map((count) {
                          final selected = _questionCount == count;
                          return ChoiceChip(
                            selected: selected,
                            showCheckmark: false,
                            label: Text('$count'),
                            labelStyle: TextStyle(
                              color:
                                  selected
                                      ? Colors.white
                                      : AppColors.textPrimary(context),
                              fontWeight: FontWeight.bold,
                            ),
                            selectedColor: AppColors.primary,
                            backgroundColor: AppColors.surface(context),
                            side: BorderSide(
                              color:
                                  selected
                                      ? AppColors.primary
                                      : AppColors.cardBorder(context),
                              width: 2,
                            ),
                            onSelected:
                                (_) => setState(() => _questionCount = count),
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 24),
                  _TimedSwitch(
                    timed: _timed,
                    durationMinutes: _durationMinutes,
                    onChanged: (value) => setState(() => _timed = value),
                  ),
                ],
              ),
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
                    canStart
                        ? 'Iniciar $_effectiveQuestionCount preguntas'
                        : 'Selecciona una categoría',
                color:
                    canStart
                        ? AppColors.primary
                        : AppColors.cardBorder(context),
                icon: Icons.play_arrow_rounded,
                onPressed: canStart ? _startExam : null,
              ),
            ),
          ),
          const AdBannerWidget(),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final int availableCount;
  final int questionCount;
  final bool timed;
  final int durationMinutes;

  const _HeaderCard({
    required this.availableCount,
    required this.questionCount,
    required this.timed,
    required this.durationMinutes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.tune_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Examen a tu medida',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$questionCount de $availableCount disponibles · ${timed ? '$durationMinutes min' : 'sin límite'}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.88),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.secondary, size: 22),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: AppColors.textSecondary(context),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryToggle extends StatelessWidget {
  final QuestionCategory category;
  final bool selected;
  final int count;
  final VoidCallback onTap;

  const _CategoryToggle({
    required this.category,
    required this.selected,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color:
              selected
                  ? AppColors.secondary.withValues(alpha: 0.09)
                  : AppColors.surface(context),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color:
                selected ? AppColors.secondary : AppColors.cardBorder(context),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Text(category.emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.label,
                    style: TextStyle(
                      color: AppColors.textPrimary(context),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$count preguntas',
                    style: TextStyle(
                      color: AppColors.textSecondary(context),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color:
                  selected ? AppColors.secondary : AppColors.textLight(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimedSwitch extends StatelessWidget {
  final bool timed;
  final int durationMinutes;
  final ValueChanged<bool> onChanged;

  const _TimedSwitch({
    required this.timed,
    required this.durationMinutes,
    required this.onChanged,
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
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.orange.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              timed ? Icons.timer_rounded : Icons.timer_off_rounded,
              color: AppColors.orange,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  timed ? 'Con tiempo' : 'Sin límite de tiempo',
                  style: TextStyle(
                    color: AppColors.textPrimary(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  timed
                      ? '$durationMinutes minutos para terminar'
                      : 'Practica con calma',
                  style: TextStyle(
                    color: AppColors.textSecondary(context),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: timed,
            activeThumbColor: AppColors.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
