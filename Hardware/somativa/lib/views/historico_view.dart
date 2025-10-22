import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoricoPage extends StatelessWidget {
  const HistoricoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('Usuário não logado')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de Pontos')),
      body: StreamBuilder<QuerySnapshot>(
        // Lê da subcoleção do usuário para garantir isolamento dos registros
        stream: FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .collection('registros')
            .orderBy('dataHora', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(child: Text('Nenhum ponto registrado ainda.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final ts = data['dataHora'];
              DateTime dataHora;

              // Suporta tanto Timestamp quanto String (registros antigos)
              if (ts != null) {
                if (ts is Timestamp) {
                  dataHora = ts.toDate();
                } else if (ts is String) {
                  // tentar parse de ISO-8601
                  dataHora = DateTime.tryParse(ts) ?? DateTime.now();
                } else if (ts is DateTime) {
                  dataHora = ts;
                } else {
                  dataHora = DateTime.now();
                }
              } else {
                dataHora = DateTime.now();
              }

              final latitude = data['latitude'];
              final longitude = data['longitude'];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: const Icon(Icons.location_on, color: Colors.deepPurple),
                  title: Text(
                    'Registrado em: ${dataHora.day}/${dataHora.month}/${dataHora.year} às ${dataHora.hour.toString().padLeft(2, '0')}:${dataHora.minute.toString().padLeft(2, '0')}',
                  ),
                  subtitle: Text('Lat: $latitude\nLng: $longitude'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
