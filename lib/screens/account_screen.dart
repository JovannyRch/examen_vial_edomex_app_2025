import 'package:examen_vial_edomex_app_2025/services/sound_service.dart';
import 'package:examen_vial_edomex_app_2025/services/supabase_auth_service.dart';
import 'package:examen_vial_edomex_app_2025/theme/app_theme.dart';
import 'package:examen_vial_edomex_app_2025/widgets/duo_button.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _emailController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _upgradeWithEmail() async {
    setState(() => _submitting = true);
    try {
      await SupabaseAuthService().sendEmailUpgradeLink(_emailController.text);
      if (mounted) {
        _showSnack('Revisa tu correo para confirmar tu cuenta.');
      }
    } catch (e) {
      if (mounted) _showSnack(e.toString());
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _sendMagicLink() async {
    setState(() => _submitting = true);
    try {
      await SupabaseAuthService().sendMagicLink(_emailController.text);
      if (mounted) {
        _showSnack('Te enviamos un enlace mágico para iniciar sesión.');
      }
    } catch (e) {
      if (mounted) _showSnack(e.toString());
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textPrimary(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Cuenta'),
      ),
      body: ValueListenableBuilder<AuthStateSnapshot>(
        valueListenable: SupabaseAuthService().state,
        builder: (context, authState, _) {
          if (authState.loading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AccountStatusCard(authState: authState),
                const SizedBox(height: 22),
                if (!authState.configured)
                  _SetupInstructions(message: authState.message)
                else ...[
                  Text(
                    authState.isAnonymous
                        ? 'Guardar tu progreso'
                        : 'Entrar con otro correo',
                    style: TextStyle(
                      color: AppColors.textPrimary(context),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    authState.isAnonymous
                        ? 'Agrega tu correo para convertir esta sesión invitada en una cuenta recuperable.'
                        : 'Puedes enviar un enlace mágico si quieres usar otra cuenta.',
                    style: TextStyle(
                      color: AppColors.textSecondary(context),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'Correo electrónico',
                      prefixIcon: const Icon(Icons.email_rounded),
                      filled: true,
                      fillColor: AppColors.surface(context),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: AppColors.cardBorder(context),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DuoButton(
                    text:
                        _submitting
                            ? 'Enviando...'
                            : authState.isAnonymous
                            ? 'Confirmar correo'
                            : 'Enviar enlace mágico',
                    color: AppColors.primary,
                    icon: Icons.mark_email_read_rounded,
                    onPressed:
                        _submitting
                            ? null
                            : authState.isAnonymous
                            ? _upgradeWithEmail
                            : _sendMagicLink,
                  ),
                  const SizedBox(height: 12),
                  DuoButton(
                    text: 'Reiniciar como invitado',
                    color: AppColors.secondary,
                    icon: Icons.person_outline_rounded,
                    outlined: true,
                    onPressed:
                        _submitting
                            ? null
                            : () async {
                              SoundService().playTap();
                              await SupabaseAuthService().signOutToAnonymous();
                            },
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AccountStatusCard extends StatelessWidget {
  final AuthStateSnapshot authState;

  const _AccountStatusCard({required this.authState});

  @override
  Widget build(BuildContext context) {
    final color =
        !authState.configured
            ? AppColors.orange
            : authState.isAnonymous
            ? AppColors.secondary
            : AppColors.primary;
    final title =
        !authState.configured
            ? 'Supabase pendiente'
            : authState.isAnonymous
            ? 'Sesión invitada'
            : 'Cuenta conectada';
    final subtitle =
        !authState.configured
            ? authState.message ?? 'Falta configurar Supabase.'
            : '${authState.displayEmail}${authState.shortUserId == null ? '' : ' · ID ${authState.shortUserId}'}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder(context), width: 2),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              authState.configured
                  ? Icons.person_rounded
                  : Icons.cloud_off_rounded,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textPrimary(context),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.textSecondary(context),
                    fontSize: 13,
                    height: 1.35,
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

class _SetupInstructions extends StatelessWidget {
  final String? message;

  const _SetupInstructions({this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.orange.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.orange.withValues(alpha: 0.3)),
      ),
      child: Text(
        [
          message ?? 'Supabase no está configurado.',
          '',
          'Ejecuta la app con:',
          'flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...',
          '',
          'En Supabase Auth, habilita Anonymous Sign-Ins y Email provider.',
        ].join('\n'),
        style: TextStyle(
          color: AppColors.textPrimary(context),
          height: 1.45,
          fontSize: 13,
        ),
      ),
    );
  }
}
