import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:surmeti/main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class CodeUserScreen extends StatefulWidget {
  const CodeUserScreen({super.key});

  @override
  _CodeUserScreenState createState() => _CodeUserScreenState();
}

class _CodeUserScreenState extends State<CodeUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  Future<void> _submitData() async {
    if (_formKey.currentState?.validate() ?? false) {
      String name = _nameController.text.trim();
      String code = _codeController.text.trim();

      await FirebaseFirestore.instance.collection('administrativos').doc(name).set({
        'codigo': code,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data saved successfully')),
      );

      _nameController.clear();
      _codeController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo administrativo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
            const SizedBox(height: 5), // Espacio entre el AppBar y la imagen
            // Imagen
            Image.asset(
              'assets/surmeti.png',
              height: 200, // Ajuste del tamaño de la imagen
            ),
            const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },//CODIGO POR LUIS RODOLFO SANCHEZ MUNGUÍA (LM)
              ),
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(labelText: 'Firma de 6 digitos'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.length != 6) {
                    return 'Ingrese firma de 6 digitos';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitData,
                child: const Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
