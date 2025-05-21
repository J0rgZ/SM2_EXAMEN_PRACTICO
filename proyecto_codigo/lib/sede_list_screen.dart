import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'models.dart';

class SedeListScreen extends StatelessWidget {
  const SedeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sedes')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('sedes').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          final docs = snapshot.data!.docs;

          if (docs.isEmpty)
            return const Center(child: Text('No hay sedes registradas.'));

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final sede = Sede.fromMap(docs[index].id, data);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: const Icon(Icons.place),
                  title: Text(sede.name),
                  subtitle: Text(
                    '${sede.address}\nEmpleados: ${sede.empleadosCount}',
                  ),
                  isThreeLine: true,
                  trailing: Icon(
                    sede.isActive ? Icons.check_circle : Icons.cancel,
                    color: sede.isActive ? Colors.green : Colors.red,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
