import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/drawer_menu.dart';
import '../models/veiculo.dart';

class TelaDetalhesDeVeiculo extends StatefulWidget {
  const TelaDetalhesDeVeiculo({Key? key}) : super(key: key);

  @override
  State<TelaDetalhesDeVeiculo> createState() => _TelaDetalhesDeVeiculoState();
}

class _TelaDetalhesDeVeiculoState extends State<TelaDetalhesDeVeiculo> {
  late Veiculo _veiculo;
  final _user = FirebaseAuth.instance.currentUser as User;
  late DocumentReference _veiculoRef;

  void _handleConfirmarExclusao() async {
    final excluir = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),
          content: const Text('Tem certeza que deseja excluir este veículo?'),
          actions: [
            TextButton(
              child: const Text("NÃO"),
              onPressed: () {
                return Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text("SIM"),
              onPressed: () {
                return Navigator.of(context).pop(true);
              },
            )
          ],
        );
      },
    );
    if (excluir) {
      await _veiculoRef.delete();
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/veiculos');
    }
  }

  @override
  Widget build(BuildContext context) {
    _veiculo = ModalRoute.of(context)!.settings.arguments as Veiculo;
    _veiculoRef = FirebaseFirestore.instance
        .doc("usuarios/${_user.uid}/veiculos/${_veiculo.id}");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do veículo'),
      ),
      drawer: MenuDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
              child: const Text('Estes são os dados do veículo'),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              leading: Icon(Icons.business),
              title: Text('Marca'),
              subtitle: Text(_veiculo.marca!),
            ),
            ListTile(
              leading: Icon(Icons.car_rental),
              title: Text('Modelo'),
              subtitle: Text(_veiculo.modelo!),
            ),
            ListTile(
              leading: Icon(Icons.calendar_month),
              title: Text('Ano'),
              subtitle: Text("${_veiculo.ano}"),
            ),
            ListTile(
              leading: Icon(Icons.fullscreen),
              title: Text('Volume do tanque'),
              subtitle: Text("${_veiculo.volumeDoTanque} litros"),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "editar",
            child: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushNamed(
                "/veiculos/editar",
                arguments: _veiculo,
              );
            },
          ),
          SizedBox(
            height: 16,
          ),
          FloatingActionButton(
            heroTag: "abastecer",
            backgroundColor: Colors.green,
            child: Icon(Icons.local_gas_station),
            onPressed: () {
              Navigator.of(context).pushNamed(
                '/escolher-posto',
                arguments: _veiculo,
              );
            },
          ),
          SizedBox(
            height: 16,
          ),
          FloatingActionButton(
            heroTag: "excluir",
            backgroundColor: Colors.red,
            child: Icon(Icons.delete),
            onPressed: _handleConfirmarExclusao,
          ),
        ],
      ),
    );
  }
}
