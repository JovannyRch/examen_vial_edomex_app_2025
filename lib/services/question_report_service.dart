import 'package:examen_vial_edomex_app_2025/models/option.dart';
import 'package:examen_vial_edomex_app_2025/services/supabase_auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class QuestionReportReason {
  final String id;
  final String label;
  final IconData icon;

  const QuestionReportReason({
    required this.id,
    required this.label,
    required this.icon,
  });
}

class QuestionReportService {
  static const List<QuestionReportReason> reasons = [
    QuestionReportReason(
      id: 'confusing',
      label: 'Pregunta confusa',
      icon: Icons.help_outline_rounded,
    ),
    QuestionReportReason(
      id: 'wrong_answer',
      label: 'Respuesta incorrecta',
      icon: Icons.cancel_outlined,
    ),
    QuestionReportReason(
      id: 'outdated',
      label: 'Información desactualizada',
      icon: Icons.update_rounded,
    ),
    QuestionReportReason(
      id: 'image_issue',
      label: 'Imagen/problema visual',
      icon: Icons.broken_image_outlined,
    ),
    QuestionReportReason(
      id: 'other',
      label: 'Otro',
      icon: Icons.more_horiz_rounded,
    ),
  ];

  Future<void> submitReport({
    required Question question,
    required String reasonId,
    required String source,
    String? comment,
  }) async {
    final auth = SupabaseAuthService();
    if (!auth.isConfigured) {
      throw StateError(
        'Supabase no está configurado. Por ahora no se puede enviar el reporte.',
      );
    }

    await auth.ensureAnonymousSession();
    final client = auth.requireClient;
    final userId = client.auth.currentUser?.id;
    if (userId == null) {
      throw StateError('No se pudo crear una sesión anónima para reportar.');
    }

    await client.from('question_reports').insert({
      'question_id': question.id,
      'question_text': question.text,
      'category': question.category.name,
      'category_label': question.category.label,
      'reason': reasonId,
      'comment': _emptyToNull(comment),
      'source': source,
      'image_url': question.imagePath,
      'user_id': userId,
      'status': 'pending',
      'app_version': const String.fromEnvironment(
        'APP_VERSION',
        defaultValue: 'dev',
      ),
      'platform': defaultTargetPlatform.name,
    });
  }

  String? _emptyToNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }
}
