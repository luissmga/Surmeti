import 'package:flutter/material.dart';

class EliminarScreen extends StatelessWidget {
  const EliminarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eliminar')),
      body: const Center(child: Text('Pagina para eliminación')),
    );
  }
}
