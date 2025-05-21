import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'models.dart'; // Asegúrate de importar tu modelo aquí

class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Empleados')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('empleados').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          final docs = snapshot.data!.docs;

          if (docs.isEmpty) return const Center(child: Text('No hay empleados.'));

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final employee = Employee.fromMap(docs[index].id, data);

              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(employee.fullName),
                subtitle: Text('DNI: ${employee.dni} - ${employee.sede}'),
                trailing: Icon(
                  employee.isActive ? Icons.check_circle : Icons.cancel,
                  color: employee.isActive ? Colors.green : Colors.red,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

