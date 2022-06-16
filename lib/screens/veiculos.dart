import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../components/drawer_menu.dart';
import '../models/veiculo.dart';

class TelaListaVeiculos extends StatefulWidget {
  const TelaListaVeiculos({Key? key}) : super(key: key);

  @override
  State<TelaListaVeiculos> createState() => _TelaListaVeiculosState();
}

class _TelaListaVeiculosState extends State<TelaListaVeiculos> {
  final _user = FirebaseAuth.instance.currentUser as User;
  late CollectionReference _veiculos;

  @override
  Widget build(BuildContext context) {
    _veiculos =
        FirebaseFirestore.instance.collection("usuarios/${_user.uid}/veiculos");
    return StreamBuilder(
      stream: _veiculos.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data!.docs.length);
          Widget body = Center(
            child: Text('Nenhum veículo cadastrado'),
          );
          if (snapshot.data!.docs.isNotEmpty) {
            body = ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final documentSnapshot = snapshot.data!.docs[index]
                    as DocumentSnapshot<Map<String, dynamic>>;
                final veiculo = Veiculo.fromDocument(documentSnapshot);
                return ListTile(
                  title: Text("${veiculo.marca} ${veiculo.modelo}"),
                  subtitle: Text("${veiculo.ano}"),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      "/veiculos/detalhes",
                      arguments: veiculo,
                    );
                  },
                );
              },
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('Meus veículos'),
            ),
            drawer: MenuDrawer(),
            body: body,
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed("/veiculos/cadastrar");
              },
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
