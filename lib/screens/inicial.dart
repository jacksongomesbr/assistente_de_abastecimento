import 'package:flutter/material.dart';

import '../models/veiculo.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({Key? key}) : super(key: key);

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  final _formKey = GlobalKey<FormState>();
  Veiculo veiculo = Veiculo.vazio();

  /// Retorna o formulário dos dados do veículo.
  /// O formulário contém os campos:
  /// * marca
  /// * modelo
  /// * ano
  /// * volume do tanque em litros
  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
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
              veiculo.marca = value!;
            },
          ),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
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
              veiculo.modelo = value!;
            },
          ),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
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
              veiculo.ano = int.parse(value!);
            },
          ),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
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
              veiculo.volumeDoTanque = int.parse(value!);
            },
          ),
        ],
      ),
    );
  }

  void _showDialog() {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informe os dados do veículo'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
              child: const Text('Informe os dados do veículo e '
                  'depois pressione PROSSEGUIR '
                  'para avançar para a próxima tela'),
            ),
            const SizedBox(
              height: 10,
            ),
            _buildForm(context),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Navigator.pushNamed(context, '/escolher-posto',
                        arguments: veiculo);
                  } else {
                    _showDialog();
                  }
                },
                child: const Text('PROSSEGUIR'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
