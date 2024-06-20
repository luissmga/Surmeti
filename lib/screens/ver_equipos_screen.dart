import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:surmeti/theme/app_theme.dart';
import 'agregar_alerta_screen.dart';
import 'realizar_mantenimiento_screen.dart';
import 'realizar_validacion_screen.dart';

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
              return Column(
                children: [
                  ListTile(
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
                  ),
                  const Divider(
                    color: Colors.purple,
                    thickness: 1,
                  ),
                ],
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
  static Widget buildBox(BuildContext context, String title, Widget screen) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
        width: 130,
        height: 90,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 0, 0, 0),
          borderRadius: BorderRadius.circular(80),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: AppTheme.boxTextStyle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>? ?? {};

    return Scaffold(
      appBar: AppBar(title: const Text('Detalles del equipo')),
      body: Center(
        // padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${doc.id}', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text('Área: ${data['area']}', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            ...data.entries.map((entry) {
              return Text('${entry.key}: ${entry.value}');
            }).toList(),
            const Spacer(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildBox(context, 'Agregar alerta',  AgregarAlertaScreen()),
                buildBox(context, 'Realizar mantenimiento',  RealizarMantenimientoScreen()),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // buildBox(context, 'Agregar alerta',  AgregarAlertaScreen()),
                // buildBox(context, 'Realizar mantenimiento',  RealizarMantenimientoScreen()),
                buildBox(context, 'Realizar mantenimiento',  RealizarValidacionScreen()),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
