import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:surmeti/firebase_options.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/ver_equipos_screen.dart';
import 'screens/agregar_alerta_screen.dart';
import 'screens/realizar_mantenimiento_screen.dart';
import 'screens/realizar_validacion_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SURMETI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/ver_equipos': (context) => const VerEquiposScreen(),
        '/agregar_alerta': (context) => const AgregarAlertaScreen(),
        '/realizar_mantenimiento': (context) => const RealizarMantenimientoScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/realizar_validacion') {
          final DocumentSnapshot doc = settings.arguments as DocumentSnapshot;//CODIGO POR LUIS RODOLFO SANCHEZ MUNGUÍA (LM)
          return MaterialPageRoute(
            builder: (context) => RealizarValidacionScreen(doc: doc),
          );
        }
        return null;
      },
    );
  }
}
