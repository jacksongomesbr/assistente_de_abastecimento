import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/posto_veiculo_route_params.dart';
import '../models/posto_de_combustivel.dart';
import '../models/veiculo.dart';

/// O widget [TelaEscolherPosto] representa uma interface que permite
/// ao usuário escolher um posto de combustível dentre uma lista de opções
/// disponíveis.
///
/// As opções da lista (os postos de combustíveis) são obtidas a partir de
/// um arquivo json (`postos-de-combustivel.json`) que está nos assets
/// do aplicativo.
///
/// Como a forma de carregar os dados do arquivo é assíncrona, o código
/// deste widget utiliza um [FutureBuilder] para executar um código
/// quando os dados forem devidamente carregados pelo [DefaultAssetBundle].
class TelaEscolherPosto extends StatelessWidget {
  TelaEscolherPosto({Key? key}) : super(key: key);

  Veiculo veiculo = Veiculo.vazio();
  final CollectionReference _postos =
      FirebaseFirestore.instance.collection('postos');

  @override
  Widget build(BuildContext context) {
    veiculo = ModalRoute.of(context)!.settings.arguments as Veiculo;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escolha o posto de combustível'),
      ),
      body: StreamBuilder(
        stream: _postos.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // o objeto snapshot permite saber se a future já terminou
          // de executar (tem dados ou não).
          // se tiver dados, então constroi o ListView, caso contrário
          // apresenta um CircularProgressIndicator
          if (snapshot.hasData) {
            // constroi e retorna o ListView utilizando o construtor builder,
            // que tem o parâmetro itemCount (tem o tamanho da lista postos)
            // e index, que está associado a cada índice da lista postos
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                final DocumentSnapshot documentSnapshot =
                    snapshot.data!.docs[index];
                final PostoDeCombustivel posto =
                    PostoDeCombustivel.fromDocument(documentSnapshot);
                return ListTile(
                  title: Text(posto.razaoSocial!),
                  subtitle: Text(posto.endereco!),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/analisar-precos',
                      arguments: PostoVeiculoRouteParams(
                        veiculo: veiculo,
                        posto: posto,
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
