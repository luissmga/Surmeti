import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:surmeti/screens/editar_equipos_screen.dart';

class EditarScreen extends StatelessWidget {
  const EditarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Equipos'),
      ),
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
//CODIGO POR LUIS RODOLFO SANCHEZ MUNGUÍA (LM)
          return ListView.separated(
            itemCount: snapshot.data!.docs.length,
            separatorBuilder: (context, index) => const Divider(
              color: Color.fromARGB(255, 92, 22, 105),
              thickness: 2,
            ),
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              return ListTile(
                title: Text('${doc['area']}'),
                textColor: const Color.fromARGB(255, 75, 21, 85),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditarEquipoScreen(docId: doc.id, data: doc.data() as Map<String, dynamic>),
                      ),
                    );
                  },
                  child: const Text('Editar'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
