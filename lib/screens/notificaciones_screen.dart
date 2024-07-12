import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificacionesScreen extends StatelessWidget {
  const NotificacionesScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('alerta').snapshots(),
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
                    title: Text('${doc['area']} - ${doc['tipoAlerta']}'),
                    textColor: const Color.fromARGB(255, 75, 21, 85),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Eliminar el documento de Firebase Firestore
                        doc.reference.delete();
                      },//CODIGO POR LUIS RODOLFO SANCHEZ MUNGUÍA (LM)
                      child: const Text('Eliminar'),
                    ),
                  ),
                  const Divider(
                    color: Colors.purple,
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
