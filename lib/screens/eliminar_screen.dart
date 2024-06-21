import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EliminarScreen extends StatelessWidget {
  const EliminarScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eliminar equipo')),
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
                    title: Text('${doc['area']} - ${doc['responsable']}'),
                    textColor: const Color.fromARGB(255, 75, 21, 85),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Eliminar el documento de Firebase Firestore
                        doc.reference.delete();
                      },
                      child: const Text('Eliminar'),
                    ),
                  ),
                  const Divider(
                    color: Color.fromARGB(255, 254, 1, 1),
                    thickness: 2,
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
