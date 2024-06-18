import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:surmeti/theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final LocalAuthentication auth = LocalAuthentication();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Future<void> _authenticate() async {
  //   bool authenticated = false;
  //   try {
  //     authenticated = await auth.authenticate(
  //         localizedReason: 'Scan your fingerprint to authenticate',
  //         options: const AuthenticationOptions(biometricOnly: true));
  //   } on PlatformException catch (e) {
  //     print(e);
  //   }
  //   if (authenticated) {
  //     Navigator.of(context).pushReplacementNamed('/welcome');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Inicia tu sesión',
            style: AppTheme.appBarTextStyle,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Usuario'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add login logic here
                Navigator.of(context).pushReplacementNamed('/welcome');
              },
              child: const Text('Iniciar'),
            ),
            // ElevatedButton(
            //   onPressed: _authenticate,
            //   child: Text('Use Fingerprint'),
            // ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/register');
              },
              child: const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
