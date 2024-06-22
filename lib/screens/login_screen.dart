import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:surmeti/theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<void> _login() async {
    String username = usernameController.text;
    String password = passwordController.text;

    try {
      QuerySnapshot userSnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .where('password', isEqualTo: password)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        Navigator.of(context).pushReplacementNamed('/welcome');
      } else {
        _showErrorDialog('Usuario o contraseña incorrectos');
      }
    } catch (e) {
      _showErrorDialog('Error al iniciar sesión: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 5), // Espacio entre el AppBar y la imagen
            // Imagen
            Image.asset(
              'assets/surmeti.png', // Ruta del logo
              height: 200, // Ajuste del tamaño de la imagen
            ),
            const SizedBox(height: 20), // Espacio entre la imagen y los campos de texto

            // Campo de entrada para Usuario
            Container(
              alignment: Alignment.center,
              child: TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Usuario',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 74, 20, 84)),
                ),
              ),
            ),
            const SizedBox(height: 10), // Espacio entre los campos

            // Campo de entrada para Contraseña
            Container(
              alignment: Alignment.center,
              child: TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 74, 20, 84)),
                ),
                obscureText: true,
              ),
            ),
            const SizedBox(height: 15), // Espacio entre los campos y el botón

            // Botón de Iniciar sesión
            ElevatedButton(
              onPressed: _login,
              child: const Text('Iniciar'),
            ),

            // Botón para Registrar
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/register');
              },
              child: const Text('Registrarme'),
            ),
          ],
        ),
      ),
    );
  }
}
