import 'package:flutter/material.dart';
import 'package:exani/screens/auth_screen.dart';
import 'package:exani/screens/home_screen.dart';
import 'package:exani/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Widget raíz que escucha el estado de autenticación y muestra
/// AuthScreen o HomeScreen según corresponda.
///
/// Flujo:
///   No logueado → AuthScreen
///   Logueado    → HomeScreen (existente)
///
/// Cuando se integren ExamSelectionScreen y OnboardingScreen,
/// el flujo post-login será:
///   Logueado + !onboarding_done → ExamSelectionScreen → OnboardingScreen
///   Logueado + onboarding_done  → ExaniHomeScreen
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _sb = SupabaseService();
  late final Stream<AuthState> _authStream;

  @override
  void initState() {
    super.initState();
    _authStream = _sb.authStateChanges;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: _authStream,
      builder: (context, snapshot) {
        // Mientras espera el primer evento, revisar si ya hay sesión
        if (!snapshot.hasData) {
          if (_sb.isLoggedIn) {
            return const HomeScreen();
          }
          return const _SplashLoading();
        }

        final session = snapshot.data!.session;

        if (session != null) {
          return const HomeScreen();
        }

        return const AuthScreen();
      },
    );
  }
}

/// Splash breve mientras se resuelve el estado de autenticación.
class _SplashLoading extends StatelessWidget {
  const _SplashLoading();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(color: Color(0xFF58CC02))),
    );
  }
}
