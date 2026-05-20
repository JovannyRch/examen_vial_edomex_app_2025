import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthStateSnapshot {
  final bool configured;
  final bool loading;
  final User? user;
  final String? message;

  const AuthStateSnapshot({
    required this.configured,
    required this.loading,
    this.user,
    this.message,
  });

  bool get isSignedIn => user != null;
  bool get isAnonymous => user != null && user!.email == null;
  String get displayEmail => user?.email ?? 'Invitado anónimo';
  String? get shortUserId {
    final id = user?.id;
    if (id == null || id.length <= 8) return id;
    return id.substring(0, 8);
  }
}

class SupabaseAuthService {
  static final SupabaseAuthService _instance = SupabaseAuthService._internal();
  factory SupabaseAuthService() => _instance;
  SupabaseAuthService._internal();

  static const String _supabaseUrl = 'https://zbobrfeagwawjkrbtecf.supabase.co';
  static const String _supabaseAnonKey = 'sb_publishable_56EooVv1rU1ouMAjHXDIwQ_fqk1pPrK';


  final ValueNotifier<AuthStateSnapshot> state =
      ValueNotifier<AuthStateSnapshot>(
        const AuthStateSnapshot(configured: false, loading: true),
      );

  bool _initialized = false;

  bool get isConfigured =>
      _supabaseUrl.trim().isNotEmpty && _supabaseAnonKey.trim().isNotEmpty;

  SupabaseClient? get _client {
    if (!_initialized || !isConfigured) return null;
    return Supabase.instance.client;
  }

  SupabaseClient get requireClient {
    final client = _client;
    if (client == null) {
      throw StateError('Supabase no está configurado.');
    }
    return client;
  }

  Future<void> initialize() async {
    if (!isConfigured) {
      state.value = const AuthStateSnapshot(
        configured: false,
        loading: false,
        message:
            'Supabase no está configurado. Agrega SUPABASE_URL y SUPABASE_ANON_KEY con --dart-define.',
      );
      return;
    }

    try {
      await Supabase.initialize(url: _supabaseUrl, anonKey: _supabaseAnonKey);
      _initialized = true;
      Supabase.instance.client.auth.onAuthStateChange.listen((data) {
        _publish(user: data.session?.user);
      });
      await ensureAnonymousSession();
    } catch (e) {
      state.value = AuthStateSnapshot(
        configured: true,
        loading: false,
        message: 'No se pudo inicializar Supabase: $e',
      );
    }
  }

  Future<void> ensureAnonymousSession() async {
    final client = _client;
    if (client == null) return;

    try {
      final currentUser = client.auth.currentUser;
      if (currentUser != null) {
        _publish(user: currentUser);
        return;
      }

      state.value = const AuthStateSnapshot(configured: true, loading: true);
      final response = await client.auth.signInAnonymously(
        data: {'app': 'examen_vial_edomex'},
      );
      _publish(user: response.user);
    } catch (e) {
      state.value = AuthStateSnapshot(
        configured: true,
        loading: false,
        message: 'No se pudo iniciar sesión anónima: $e',
      );
    }
  }

  Future<void> sendEmailUpgradeLink(String email) async {
    final client = _client;
    if (client == null) {
      throw StateError('Supabase no está configurado.');
    }

    final normalizedEmail = email.trim();
    if (normalizedEmail.isEmpty || !normalizedEmail.contains('@')) {
      throw ArgumentError('Ingresa un correo válido.');
    }

    if (client.auth.currentUser == null) {
      await ensureAnonymousSession();
    }

    await client.auth.updateUser(UserAttributes(email: normalizedEmail));
    _publish(
      user: client.auth.currentUser,
      message: 'Revisa tu correo para confirmar la cuenta.',
    );
  }

  Future<void> sendMagicLink(String email) async {
    final client = _client;
    if (client == null) {
      throw StateError('Supabase no está configurado.');
    }

    final normalizedEmail = email.trim();
    if (normalizedEmail.isEmpty || !normalizedEmail.contains('@')) {
      throw ArgumentError('Ingresa un correo válido.');
    }

    await client.auth.signInWithOtp(email: normalizedEmail);
    _publish(
      user: client.auth.currentUser,
      message: 'Te enviamos un enlace mágico para iniciar sesión.',
    );
  }

  Future<void> signOutToAnonymous() async {
    final client = _client;
    if (client == null) return;

    await client.auth.signOut();
    await ensureAnonymousSession();
  }

  void _publish({User? user, String? message}) {
    state.value = AuthStateSnapshot(
      configured: true,
      loading: false,
      user: user ?? _client?.auth.currentUser,
      message: message,
    );
  }
}
