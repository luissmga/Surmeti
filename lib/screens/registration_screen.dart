import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Agregado para inicializar Firebase
import 'package:firebase_database/firebase_database.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key}); // Corregido el error

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  late DatabaseReference _userRef; // Referencia a la base de datos de usuarios

  @override
  void initState() {
    super.initState();
    _initializeFirebase(); // Inicializar Firebase al iniciar el estado
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
    FirebaseDatabase database = FirebaseDatabase.instance;
    _userRef = FirebaseDatabase.instance.reference().child('users');
  }

  Future<void> _registerUser() async {
    try {
      await _userRef.push().set({
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'username': _usernameController.text,
        // Puedes querer cifrar o encriptar la contraseña antes de almacenarla
        'password': _passwordController.text,
      });
      print('Usuario registrado exitosamente');
      // Navegar a la página de inicio de sesión después de registrar al usuario
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print('Error al registrar usuario: $e');
      // Manejar el error, por ejemplo, mostrar un mensaje de error al usuario
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese su nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Apellidos'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese sus apellidos';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Usuario'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese un nombre de usuario';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese una contraseña';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Registrar usuario
                    _registerUser();
                  }
                },
                child: const Text('Registrarme'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}