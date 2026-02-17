import 'package:examen_vial_edomex_app_2025/services/sound_service.dart';
import 'package:examen_vial_edomex_app_2025/theme/app_theme.dart';
import 'package:examen_vial_edomex_app_2025/widgets/ad_banner_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.textPrimary(context),
                    ),
                    onPressed: () {
                      SoundService().playTap();
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Información del Examen',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ],
              ),
            ),

            // ─── Content ─────────────────────────────────────
            Expanded(
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: _controller,
                  curve: Curves.easeOut,
                ),
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    const SizedBox(height: 8),

                    // Hero banner
                    _buildHeroBanner(),
                    const SizedBox(height: 24),

                    // Quick info chips
                    _buildQuickInfoRow(),
                    const SizedBox(height: 24),

                    // Sections
                    _InfoSection(
                      icon: Icons.checklist_rounded,
                      color: AppColors.primary,
                      title: '¿Cómo tramitar la licencia?',
                      children: [
                        const _InfoText(
                          'Sigue estos pasos para obtener tu licencia de conducir en el Estado de México:',
                        ),
                        const SizedBox(height: 12),
                        _buildStep(
                          1,
                          'Acude al módulo de la Secretaría de Movilidad del Estado de México.',
                        ),
                        _buildStep(
                          2,
                          'Ten a la mano: INE, comprobante de domicilio, CURP y acta de nacimiento.',
                        ),
                        _buildStep(
                          3,
                          'Horarios: Lunes a viernes de 9:00 a 18:00 hrs.',
                        ),
                        _buildStep(
                          4,
                          'Consulta los costos y escoge el tipo de licencia.',
                        ),
                        _buildStep(5, 'Solicita tu formato de pago.'),
                        _buildStep(
                          6,
                          'Llena el formato, toma de foto y huellas dactilares.',
                        ),
                        _buildStep(
                          7,
                          'Recibe un comprobante temporal mientras esperas tu licencia definitiva.',
                        ),
                        const SizedBox(height: 8),
                        _buildTip(
                          'Tu pago tarda 24-72 horas en acreditarse. Realízalo a través del portal de Servicios al Contribuyente del EdoMex.',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _InfoSection(
                      icon: Icons.folder_rounded,
                      color: AppColors.secondary,
                      title: 'Documentos necesarios',
                      children: [
                        _buildDocItem(
                          Icons.badge_rounded,
                          'Identificación oficial vigente',
                          'INE, pasaporte o cédula profesional',
                        ),
                        _buildDocItem(
                          Icons.home_rounded,
                          'Comprobante de domicilio',
                          'No mayor a 3 meses de antigüedad',
                        ),
                        _buildDocItem(
                          Icons.person_rounded,
                          'CURP',
                          'Clave Única de Registro de Población',
                        ),
                        _buildDocItem(
                          Icons.description_rounded,
                          'Acta de nacimiento',
                          'Original o copia certificada',
                        ),
                        const SizedBox(height: 8),
                        const _InfoText(
                          '* Extranjeros: presentar documentación migratoria correspondiente.',
                          isSmall: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _InfoSection(
                      icon: Icons.attach_money_rounded,
                      color: AppColors.orange,
                      title: 'Costos de la licencia',
                      initiallyExpanded: true,
                      children: [
                        _buildCostRow('Licencia 1 año', '\$678.00 MXN'),
                        _buildCostRow('Licencia 2 años', '\$909.00 MXN'),
                        const SizedBox(height: 8),
                        const _InfoText(
                          'Los costos pueden variar. Consulta la página oficial para precios actualizados.',
                          isSmall: true,
                        ),
                        const SizedBox(height: 8),
                        _buildLinkButton(
                          'Ver costos oficiales',
                          'https://smovilidad.edomex.gob.mx/licencias_permisos',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _InfoSection(
                      icon: Icons.calendar_month_rounded,
                      color: AppColors.purple,
                      title: '¿Cómo agendar tu cita?',
                      children: [
                        _buildStep(
                          1,
                          'Ingresa al portal de citas en línea de la Secretaría de Movilidad.',
                        ),
                        _buildStep(
                          2,
                          'Llena el formulario con tus datos personales y selecciona el tipo de trámite.',
                        ),
                        _buildStep(
                          3,
                          'Verifica tus datos y ten a la mano tu CURP y correo electrónico.',
                        ),
                        _buildStep(
                          4,
                          'Elige la fecha y hora que más te acomode.',
                        ),
                        _buildStep(
                          5,
                          'Preséntate con 15 minutos de anticipación.',
                        ),
                        const SizedBox(height: 8),
                        _buildLinkButton(
                          'Agendar cita en línea',
                          'https://smovilidad.edomex.gob.mx/citas_internet',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _InfoSection(
                      icon: Icons.timer_rounded,
                      color: AppColors.secondaryDark,
                      title: 'Vigencia de la licencia',
                      children: [
                        _buildVigenciaItem(
                          'Conductores particulares',
                          '3 años',
                        ),
                        _buildVigenciaItem(
                          'Automovilistas y motos',
                          '1, 2, 3 o 4 años',
                        ),
                        _buildVigenciaItem(
                          'Choferes servicio particular',
                          '1, 2, 3 o 4 años',
                        ),
                        const SizedBox(height: 8),
                        _buildTip(
                          'La vigencia comienza desde la fecha de expedición. No esperes a que caduque para renovarla.',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _InfoSection(
                      icon: Icons.school_rounded,
                      color: AppColors.primary,
                      title: '¿Qué viene en el examen?',
                      initiallyExpanded: true,
                      children: [
                        _buildExamTopic(
                          '🚦',
                          'Señales de tránsito',
                          'Preventivas, restrictivas e informativas.',
                        ),
                        _buildExamTopic(
                          '🚗',
                          'Reglas de circulación',
                          'Preferencia en cruces, rebases y distancia de seguridad.',
                        ),
                        _buildExamTopic(
                          '🛡️',
                          'Normas de seguridad vial',
                          'Cinturón, límites de velocidad y uso de espejos.',
                        ),
                        _buildExamTopic(
                          '🏥',
                          'Primeros auxilios',
                          'Cómo actuar en caso de accidente.',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _InfoSection(
                      icon: Icons.lightbulb_rounded,
                      color: AppColors.orange,
                      title: 'Tips para el día del examen',
                      initiallyExpanded: true,
                      children: [
                        _buildTipItem(
                          '📖',
                          'Estudia con nuestra guía',
                          'Repasa las 54 preguntas y sus explicaciones.',
                        ),
                        _buildTipItem(
                          '😴',
                          'Descansa bien la noche anterior',
                          'Un buen descanso mejora tu concentración.',
                        ),
                        _buildTipItem(
                          '⏰',
                          'Llega 15 min antes',
                          'Evita prisas y estrés innecesario.',
                        ),
                        _buildTipItem(
                          '📄',
                          'Lleva todos tus documentos',
                          'INE, CURP, comprobante de domicilio y acta.',
                        ),
                        _buildTipItem(
                          '🧘',
                          'Lee cada pregunta con calma',
                          'No te apures, lee todas las opciones.',
                        ),
                        _buildTipItem(
                          '✅',
                          'Confía en tu preparación',
                          'Si estudiaste con esta app, estás listo.',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _InfoSection(
                      icon: Icons.warning_amber_rounded,
                      color: AppColors.red,
                      title: 'Multa por conducir sin licencia',
                      children: [
                        const _InfoText(
                          'Conducir sin licencia en el Estado de México tiene una multa de:',
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: AppColors.red.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.red.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '\$2,171.00 MXN',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.red,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '20 veces la UMA',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildStep(1, 'Renueva tu licencia a tiempo.'),
                        _buildStep(
                          2,
                          'Siempre lleva tu licencia contigo al conducir.',
                        ),
                        _buildStep(3, 'Respeta las leyes de tránsito.'),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _InfoSection(
                      icon: Icons.report_problem_rounded,
                      color: AppColors.orangeDark,
                      title: '¿Perdiste tu licencia?',
                      children: [
                        _buildStep(
                          1,
                          'Reporta la pérdida en el sitio de constancia de extravío.',
                        ),
                        _buildStep(
                          2,
                          'Reúne de nuevo tu documentación: INE, comprobante, CURP.',
                        ),
                        _buildStep(
                          3,
                          'Acude a un módulo de la Secretaría de Movilidad para solicitar la reposición.',
                        ),
                        const SizedBox(height: 8),
                        _buildLinkButton(
                          'Reportar extravío en línea',
                          'https://constancia.fiscaliaedomex.gob.mx/denuncias/denunciainternet',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _InfoSection(
                      icon: Icons.person_rounded,
                      color: AppColors.secondaryDark,
                      title: 'Licencia para menores de edad',
                      children: [
                        const _InfoText(
                          'Si tienes entre 16 y 17 años puedes solicitar un permiso provisional. A los 18 ya puedes tramitar tu licencia tipo A.',
                        ),
                        const SizedBox(height: 12),
                        _buildStep(
                          1,
                          'Acude a la Secretaría de Movilidad del EdoMex.',
                        ),
                        _buildStep(
                          2,
                          'Un padre o tutor debe acompañarte (menores de 18).',
                        ),
                        _buildStep(
                          3,
                          'Lleva tu identificación oficial y comprobante de domicilio.',
                        ),
                        _buildStep(
                          4,
                          'Toma el curso de educación vial obligatorio.',
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // Official links
                    _buildOfficialLinksCard(),

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

  // ─── Builders ──────────────────────────────────────────────────────────────

  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.directions_car_rounded,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: 12),
          const Text(
            'Licencia de Conducir\nEstado de México',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tu guía completa para el trámite',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInfoRow() {
    return Row(
      children: [
        _buildQuickChip('📋', 'Examen\nteórico', AppColors.secondary),
        const SizedBox(width: 10),
        _buildQuickChip('💰', 'Desde\n\$678', AppColors.orange),
        const SizedBox(width: 10),
        _buildQuickChip('🕐', 'Lun-Vie\n9-18 hrs', AppColors.purple),
      ],
    );
  }

  Widget _buildQuickChip(String emoji, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary(context),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTip(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.orange.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.orange.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.tips_and_updates_rounded,
            color: AppColors.orange,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary(context),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.secondary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary(context),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.check_circle_outlined,
            color: AppColors.primary,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildCostRow(String label, String price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.orange.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.orange.withValues(alpha: 0.15)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 15, color: AppColors.textPrimary(context)),
            ),
            Text(
              price,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkButton(String label, String url) {
    return GestureDetector(
      onTap: () {
        SoundService().playTap();
        _openUrl(url);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.secondary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.secondary.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.open_in_new_rounded,
              color: AppColors.secondary,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVigenciaItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(
            Icons.access_time_rounded,
            color: AppColors.secondaryDark,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: AppColors.textPrimary(context)),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.secondaryDark.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamTopic(String emoji, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary(context),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String emoji, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary(context),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfficialLinksCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder(context), width: 2),
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
          Row(
            children: [
              Icon(
                Icons.language_rounded,
                color: AppColors.secondary,
                size: 22,
              ),
              SizedBox(width: 10),
              Text(
                'Enlaces oficiales',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildOfficialLink(
            'Secretaría de Movilidad EdoMex',
            'https://smovilidad.edomex.gob.mx/',
          ),
          _buildOfficialLink(
            'Licencias y permisos',
            'https://smovilidad.edomex.gob.mx/licencias_permisos',
          ),
          _buildOfficialLink(
            'Agendar cita en línea',
            'https://smovilidad.edomex.gob.mx/citas_internet',
          ),
          _buildOfficialLink(
            'Gobierno del Estado de México',
            'https://edomex.gob.mx/',
          ),
        ],
      ),
    );
  }

  Widget _buildOfficialLink(String title, String url) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () {
          SoundService().playTap();
          _openUrl(url);
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.secondary,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Expandable Section Widget ──────────────────────────────────────────────

class _InfoSection extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String title;
  final List<Widget> children;
  final bool initiallyExpanded;

  const _InfoSection({
    required this.icon,
    required this.color,
    required this.title,
    required this.children,
    this.initiallyExpanded = false,
  });

  @override
  State<_InfoSection> createState() => _InfoSectionState();
}

class _InfoSectionState extends State<_InfoSection>
    with SingleTickerProviderStateMixin {
  late bool _expanded;
  late AnimationController _expandController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
    _expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: _expanded ? 1.0 : 0.0,
    );
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  void _toggle() {
    SoundService().playTap();
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _expandController.forward();
      } else {
        _expandController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color:
              _expanded
                  ? widget.color.withValues(alpha: 0.3)
                  : AppColors.cardBorder(context),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header — always visible
          GestureDetector(
            onTap: _toggle,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(widget.icon, color: widget.color, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: _expanded ? widget.color : AppColors.textLight(context),
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    color: widget.color.withValues(alpha: 0.15),
                    height: 1,
                  ),
                  const SizedBox(height: 14),
                  ...widget.children,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Small Helpers ──────────────────────────────────────────────────────────

class _InfoText extends StatelessWidget {
  final String text;
  final bool isSmall;

  const _InfoText(this.text, {this.isSmall = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: isSmall ? 12 : 14,
        color: isSmall ? AppColors.textSecondary(context) : AppColors.textPrimary(context),
        height: 1.5,
      ),
    );
  }
}
