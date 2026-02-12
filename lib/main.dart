import 'package:examen_vial_edomex_app_2025/screens/home_screen.dart';
import 'package:examen_vial_edomex_app_2025/services/admob_service.dart';
import 'package:examen_vial_edomex_app_2025/services/notification_service.dart';
import 'package:examen_vial_edomex_app_2025/services/purchase_service.dart';
import 'package:examen_vial_edomex_app_2025/services/sound_service.dart';
import 'package:examen_vial_edomex_app_2025/services/theme_service.dart';
import 'package:examen_vial_edomex_app_2025/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  await ThemeService().initialize();
  await AdMobService.initialize();
  await SoundService().initialize();
  await NotificationService().initialize();
  await PurchaseService().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService().themeMode,
      builder: (context, mode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Examen Vial EdoMéx',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: mode,
          home: const HomeScreen(),
        );
      },
    );
  }
}
