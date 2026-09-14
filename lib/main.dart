import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KoodamApp());
}

class KoodamApp extends StatelessWidget {
  const KoodamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Koodam (കൂടം) — Kerala Hyperlocal Social & Intentional Dating',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
