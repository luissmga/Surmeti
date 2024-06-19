import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:surmeti/screens/agregar_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ver Equipos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const VerEquiposScreen(),
    );
  }
}

class VerEquiposScreen extends StatelessWidget {
  const VerEquiposScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ver equipos')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('equipos').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los datos'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay datos disponibles'));
          }
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return ListTile(
                title: Text('${doc.id} - ${doc['area']}'),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetallesEquipoScreen(doc: doc),
                      ),
                    );
                  },
                  child: const Text('Ver'),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class DetallesEquipoScreen extends StatelessWidget {
  final DocumentSnapshot doc;

  const DetallesEquipoScreen({Key? key, required this.doc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return Scaffold(
      appBar: AppBar(title: const Text('Detalles del equipo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${doc.id}', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text('area: ${data['area']}', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            ...data.entries.map((entry) {
              return Text('${entry.key}: ${entry.value}');
            }).toList(),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Navegar a la página de agregar alerta
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AgregarScreen()),
                );
              },
              child: const Text('Agregar Alerta'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navegar a la página de realizar mantenimiento
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RealizarMantenimientoScreen()),
                );
              },
              child: const Text('Realizar Mantenimiento'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navegar a la página de realizar validación
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RealizarValidacionScreen()),
                );
              },
              child: const Text('Realizar Validación'),
            ),
          ],
        ),
      ),
    );
  }
}

class constAgregarAlertaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Alerta')),
      body: const Center(child: Text('Página de Agregar Alerta')),
    );
  }
}

class RealizarMantenimientoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Realizar Mantenimiento')),
      body: const Center(child: Text('Página de Realizar Mantenimiento')),
    );
  }
}

class RealizarValidacionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Realizar Validación')),
      body: const Center(child: Text('Página de Realizar Validación')),
    );
  }
}
