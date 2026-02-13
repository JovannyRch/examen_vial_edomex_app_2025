import 'package:flutter/material.dart';
import 'package:exani/services/sound_service.dart';
import 'package:exani/theme/app_theme.dart';
import 'package:exani/widgets/duo_button.dart';

/// Pantalla 5 MVP — Seleccionar sección → área → habilidad para práctica.
/// Navegación drill-down con 3D cards.
class PracticeSetupScreen extends StatefulWidget {
  final String examId;

  const PracticeSetupScreen({super.key, required this.examId});

  @override
  State<PracticeSetupScreen> createState() => _PracticeSetupScreenState();
}

class _PracticeSetupScreenState extends State<PracticeSetupScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  // Mock data — TODO: cargar desde SessionRepository
  late final List<_Section> _sections;
  _Section? _selectedSection;
  _Area? _selectedArea;

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
    _loadSections();
  }

  void _loadSections() {
    // TODO: Cargar datos reales desde Supabase/SQLite
    _sections = [
      _Section(
        id: 's1',
        name: 'Pensamiento Matemático',
        icon: Icons.calculate_rounded,
        color: AppColors.secondary,
        areas: [
          _Area(
            id: 'a1',
            name: 'Aritmética',
            skills: ['Operaciones básicas', 'Fracciones', 'Porcentajes'],
            questionCount: 15,
          ),
          _Area(
            id: 'a2',
            name: 'Álgebra',
            skills: [
              'Ecuaciones lineales',
              'Sistemas de ecuaciones',
              'Funciones',
            ],
            questionCount: 18,
          ),
          _Area(
            id: 'a3',
            name: 'Geometría y Trigonometría',
            skills: ['Perímetro y área', 'Razones trigonométricas', 'Cónicas'],
            questionCount: 12,
          ),
        ],
      ),
      _Section(
        id: 's2',
        name: 'Pensamiento Analítico',
        icon: Icons.psychology_rounded,
        color: AppColors.purple,
        areas: [
          _Area(
            id: 'a4',
            name: 'Integración de información',
            skills: ['Tablas', 'Gráficas', 'Diagramas'],
            questionCount: 10,
          ),
          _Area(
            id: 'a5',
            name: 'Interpretación de relaciones lógicas',
            skills: ['Analogías', 'Series numéricas', 'Conclusiones lógicas'],
            questionCount: 14,
          ),
        ],
      ),
      _Section(
        id: 's3',
        name: 'Comprensión Lectora',
        icon: Icons.auto_stories_rounded,
        color: AppColors.orange,
        areas: [
          _Area(
            id: 'a6',
            name: 'Mensaje del texto',
            skills: [
              'Idea principal',
              'Ideas secundarias',
              'Intención del autor',
            ],
            questionCount: 12,
          ),
          _Area(
            id: 'a7',
            name: 'Coherencia textual',
            skills: ['Conectores', 'Estructura textual', 'Vocabulario'],
            questionCount: 10,
          ),
        ],
      ),
      _Section(
        id: 's4',
        name: 'Estructura de la Lengua',
        icon: Icons.spellcheck_rounded,
        color: AppColors.primary,
        areas: [
          _Area(
            id: 'a8',
            name: 'Gramática y sintaxis',
            skills: [
              'Concordancia',
              'Uso de preposiciones',
              'Tiempos verbales',
            ],
            questionCount: 14,
          ),
        ],
      ),
    ];
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _goBack() {
    if (_selectedArea != null) {
      setState(() => _selectedArea = null);
    } else if (_selectedSection != null) {
      setState(() => _selectedSection = null);
    } else {
      Navigator.pop(context);
    }
  }

  String get _title {
    if (_selectedArea != null) return _selectedArea!.name;
    if (_selectedSection != null) return _selectedSection!.name;
    return 'Práctica por tema';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App bar
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _goBack,
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    // Breadcrumb hint
                    if (_selectedSection != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _selectedSection!.color.withValues(
                            alpha: 0.12,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _selectedArea != null ? 'Habilidad' : 'Área',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _selectedSection!.color,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Content
              Expanded(child: _buildContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_selectedArea != null) {
      return _buildSkillList(_selectedArea!);
    }
    if (_selectedSection != null) {
      return _buildAreaList(_selectedSection!);
    }
    return _buildSectionList();
  }

  // ─── Level 1: Secciones ──────────────────────────────────────────────────

  Widget _buildSectionList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      itemCount: _sections.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final section = _sections[index];
        final totalQuestions = section.areas.fold<int>(
          0,
          (sum, a) => sum + a.questionCount,
        );
        return _Pressable3DCard(
          onTap: () => setState(() => _selectedSection = section),
          darkColor: AppColors.darken(section.color, 0.18),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: section.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(section.icon, color: section.color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${section.areas.length} áreas · $totalQuestions reactivos',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textLight,
                size: 24,
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── Level 2: Áreas ──────────────────────────────────────────────────────

  Widget _buildAreaList(_Section section) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      itemCount: section.areas.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final area = section.areas[index];
        return _Pressable3DCard(
          onTap: () => setState(() => _selectedArea = area),
          darkColor: AppColors.darken(section.color, 0.18),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: section.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: section.color,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      area.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${area.skills.length} habilidades · ${area.questionCount} reactivos',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textLight,
                size: 24,
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── Level 3: Habilidades ────────────────────────────────────────────────

  Widget _buildSkillList(_Area area) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        // Practicar toda el área
        DuoButton(
          text: 'Practicar toda el área',
          color: _selectedSection!.color,
          icon: Icons.play_arrow_rounded,
          onPressed: () {
            // TODO: Lanzar SessionEngine con config area
            SoundService().playTap();
          },
        ),
        const SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            'O elige una habilidad específica',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),

        ...area.skills.map((skill) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _Pressable3DCard(
              darkColor: AppColors.darken(_selectedSection!.color, 0.18),
              onTap: () {
                // TODO: Lanzar SessionEngine con config skill
                SoundService().playTap();
              },
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _selectedSection!.color.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lightbulb_outline_rounded,
                      color: _selectedSection!.color,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      skill,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.play_circle_outline_rounded,
                    color: _selectedSection!.color,
                    size: 22,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

// ─── Data ────────────────────────────────────────────────────────────────────

class _Section {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final List<_Area> areas;

  const _Section({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.areas,
  });
}

class _Area {
  final String id;
  final String name;
  final List<String> skills;
  final int questionCount;

  const _Area({
    required this.id,
    required this.name,
    required this.skills,
    required this.questionCount,
  });
}

// ─── Reusable 3D pressable card ──────────────────────────────────────────────

class _Pressable3DCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color darkColor;

  const _Pressable3DCard({
    required this.child,
    required this.onTap,
    required this.darkColor,
  });

  @override
  State<_Pressable3DCard> createState() => _Pressable3DCardState();
}

class _Pressable3DCardState extends State<_Pressable3DCard> {
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
        margin: EdgeInsets.only(top: _isPressed ? 3 : 0),
        padding: EdgeInsets.only(bottom: _isPressed ? 0 : 3),
        decoration: BoxDecoration(
          color: widget.darkColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
