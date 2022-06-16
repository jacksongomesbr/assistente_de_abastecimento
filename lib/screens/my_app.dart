import 'package:assistente_de_abastecimento/screens/veiculo_detalhes.dart';
import 'package:assistente_de_abastecimento/screens/veiculo_editar.dart';
import 'package:assistente_de_abastecimento/screens/veiculos.dart';
import 'package:assistente_de_abastecimento/screens/veiculos_novo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'escolher_posto.dart';
import 'calcular_relacao_etanol_gasolina.dart';
import 'splash.dart';

/// A classe [MyApp] representa o ponto-de-partida do aplicativo, ou seja,
/// é o widget de mais alto nível na árvore de widget do aplicativo.
/// As rotas são:
/// /: a rota raiz, associada ao widget [TelaInicial]
/// /posto: associada ao widget [TelaEscolherPosto]
/// /analisar-precos: associada ao widget [TelaCalcularRelacaoEtanolGasolina]
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  /// O método [build] retorna uma instância de [MaterialApp]
  /// para representar a estrutura padrão do aplicativo ao utilizar
  /// o Material Design.
  ///
  /// Este método também define as rotas e indica que a rota inicial
  /// é a associada a [TelaInicial].
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assistente de abastecimento',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/splash' : '/veiculos',
      routes: {
        '/splash': (context) => const TelaSplash(),
        '/escolher-posto': (context) => TelaEscolherPosto(),
        '/analisar-precos': (context) => const TelaCalcularRelacaoEtanolGasolina(),
        '/veiculos': (context) => const TelaListaVeiculos(),
        '/veiculos/cadastrar': (context) => const TelaCadastrarVeiculo(),
        '/veiculos/detalhes': (context) => const TelaDetalhesDeVeiculo(),
        '/veiculos/editar': (context) => const TelaEditarVeiculo(),
      },
    );
  }
}
