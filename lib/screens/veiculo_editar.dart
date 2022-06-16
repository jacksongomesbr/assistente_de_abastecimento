import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/drawer_menu.dart';
import '../models/veiculo.dart';

class TelaEditarVeiculo extends StatefulWidget {
  const TelaEditarVeiculo({Key? key}) : super(key: key);

  @override
  State<TelaEditarVeiculo> createState() => _TelaEditarVeiculoState();
}

class _TelaEditarVeiculoState extends State<TelaEditarVeiculo> {
  late Veiculo _veiculo;
  final _formKey = GlobalKey<FormState>();
  final _user = FirebaseAuth.instance.currentUser as User;
  late DocumentReference _veiculoRef;

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            initialValue: _veiculo.marca,
            decoration: const InputDecoration(
              labelText: 'Marca',
              helperText: 'Informe o nome do fabricante ou da montadora',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe a marca do veículo';
              }
              return null;
            },
            onSaved: (value) {
              _veiculo.marca = value!;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            initialValue: _veiculo.modelo,
            decoration: const InputDecoration(
              labelText: 'Modelo',
              helperText: 'Informe o modelo',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe o modelo do veículo';
              }
              return null;
            },
            onSaved: (value) {
              _veiculo.modelo = value!;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            initialValue: "${_veiculo.ano}",
            decoration: const InputDecoration(
              labelText: 'Ano',
              helperText: 'Informe o ano',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe o ano do veículo';
              }
              try {
                var a = int.parse(value);
              } catch (e) {
                return 'Informe um número válido';
              }
              return null;
            },
            onSaved: (value) {
              _veiculo.ano = int.parse(value!);
            },
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            initialValue: "${_veiculo.volumeDoTanque}",
            decoration: const InputDecoration(
              suffix: Text('litros'),
              labelText: 'Volume do tanque',
              helperText: 'Informe o volume do tanque, em litros',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe volume do tanque do veículo';
              }
              try {
                var a = int.parse(value);
              } catch (e) {
                return 'Informe um número válido';
              }
              return null;
            },
            onSaved: (value) {
              _veiculo.volumeDoTanque = int.parse(value!);
            },
          ),
        ],
      ),
    );
  }

  /// Apresenta um dialog com erros do preenchimento do formulário
  void _showDialogErros() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Informações do veículo"),
          content:
              const Text("Há erros nos campos. Corrija-os e tente novamente."),
          actions: <Widget>[
            TextButton(
              child: const Text("FECHAR"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _veiculo = ModalRoute.of(context)!.settings.arguments as Veiculo;

    _veiculoRef = FirebaseFirestore.instance
        .doc("usuarios/${_user.uid}/veiculos/${_veiculo.id}");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar veículo'),
      ),
      drawer: MenuDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
              child: const Text('Atualize os dados do veículo'),
            ),
            const SizedBox(
              height: 10,
            ),
            _buildForm(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            await _veiculoRef.update(_veiculo.toDocument());
            if (!mounted) return;
            Navigator.of(context).pushNamed("/veiculos");
          } else {
            _showDialogErros();
          }
        },
      ),
    );
  }
}
