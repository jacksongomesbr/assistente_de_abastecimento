import 'package:flutter/material.dart';

import '../models/posto_veiculo_route_params.dart';
import '../models/posto_de_combustivel.dart';
import '../models/veiculo.dart';

/// A classe [TelaCalcularRelacaoEtanolGasolina] fornece a tela que entre a funcionalidade
/// de calcular a relação entre o preço do etanol e da gasolina, além
/// de indicar, com base nesta relação, com qual dos dois tipos de
/// combustível compensa mais realizar o abastecimento.
class TelaCalcularRelacaoEtanolGasolina extends StatefulWidget {
  const TelaCalcularRelacaoEtanolGasolina({Key? key}) : super(key: key);

  @override
  State<TelaCalcularRelacaoEtanolGasolina> createState() =>
      _TelaCalcularRelacaoEtanolGasolinaState();
}

/// A classe [MyHomePageState] representa o state de [TelaCalcularRelacaoEtanolGasolina].
///
/// Mais especificamente, os campos que podem alterar o state são:
/// * [precoDaGasolina]
/// * [precoDoEtanol]
class _TelaCalcularRelacaoEtanolGasolinaState
    extends State<TelaCalcularRelacaoEtanolGasolina> {
  final _formKey = GlobalKey<FormState>();
  double? precoDaGasolina;
  double? precoDoEtanol;
  Veiculo? veiculo;
  PostoDeCombustivel? posto;

  /// O método [calcularRelacaoEtanolGasolina] é responsável por realizar
  /// o cálculo matemático que fornece a relação entre o preço do etanol
  /// e o preço da gasolina
  double _calcularRelacaoEtanolGasolina() {
    return precoDoEtanol! / precoDaGasolina!;
  }

  double _calcularPrecoComEtanol() {
    return precoDoEtanol! * (veiculo?.volumeDoTanque ?? 0);
  }

  double _calcularPrecoComGasolina() {
    return precoDaGasolina! * (veiculo?.volumeDoTanque ?? 0);
  }

  /// O método [buildResultado] é responsável por gerar a apresentação
  /// da mensagem que indica com qual dos dois tipos de combustível
  /// é melhor abastecer.
  _buildResultado(BuildContext context) {
    var estiloDoTexto = Theme.of(context)
        .textTheme
        .titleLarge
        ?.merge(TextStyle(color: Colors.white));
    if (precoDoEtanol != null && precoDaGasolina != null) {
      double relacao = _calcularRelacaoEtanolGasolina();
      var texto;
      var cor;
      if (relacao <= 0.7) {
        texto = Text(
          'É melhor abastecer com etanol',
          style: estiloDoTexto,
        );
        cor = Colors.green;
      } else {
        texto = Text(
          'É melhor abastecer com gasolina',
          style: estiloDoTexto,
        );
        cor = Colors.blueGrey;
      }
      var caixa = Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cor,
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: texto,
                    flex: 6,
                  ),
                  Expanded(
                    child: SizedBox(),
                    flex: 1,
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Text(
                          "R\$ ${_calcularPrecoComEtanol().toStringAsFixed(2)}",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Com etanol",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(),
                    flex: 1,
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Text(
                          "R\$ ${_calcularPrecoComGasolina().toStringAsFixed(2)}",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Com gasolina",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
      return caixa;
    } else {
      return Container();
    }
  }

  /// O método [buildVeiculoCard] é responsávle por gerar a apresentação
  /// das informações do veículo, o que é realizado por meio de um [Card].
  ///
  /// Outros widgets utilizados são:
  /// * [ListTitle]
  /// * [CircleAvatar]
  /// * [Text]
  _buildVeiculoCard() {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.lightBlueAccent,
          foregroundColor: Colors.white,
          child: Icon(Icons.car_rental),
        ),
        title: Text('${veiculo?.marca} - ${veiculo?.modelo}'),
        subtitle: Text(
            'Ano: ${veiculo?.ano}. Tanque de ${veiculo?.volumeDoTanque} litros'),
      ),
    );
  }

  /// O método [buildPostoDeCombustivelCard] é responsável por gerar a
  /// apresentação das informações do posto de combustível.
  _buildPostoDeCombustivelCard() {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
          child: Icon(Icons.add_location),
        ),
        title: Text('${posto?.razaoSocial}'),
        subtitle: Text(posto!.endereco ?? ''),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    PostoVeiculoRouteParams params =
        ModalRoute.of(context)!.settings.arguments as PostoVeiculoRouteParams;
    veiculo = params.veiculo;
    posto = params.posto;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assistente de abastecimento'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: <Widget>[
                _buildPostoDeCombustivelCard(),
                const SizedBox(
                  height: 10,
                ),
                _buildVeiculoCard(),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          prefix: Text('R\$ '),
                          suffix: Text('/litro'),
                          labelText: 'Preço do etanol',
                          helperText: 'Informe o preço do etanol',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe o preço do etanol';
                          }
                          try {
                            var a = double.parse(value);
                          } catch (e) {
                            return 'Informe um número válido';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            precoDoEtanol = double.parse(value!);
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          prefix: Text('R\$ '),
                          suffix: Text('/litro'),
                          labelText: 'Preço da gasolina',
                          helperText: 'Informe o preço da gasolina',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe o preço da gasolina';
                          }
                          try {
                            var a = double.parse(value);
                          } catch (e) {
                            return 'Informe um número válido';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          precoDaGasolina = double.parse(value!);
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                } else {
                                  setState(() {
                                    precoDoEtanol = null;
                                    precoDaGasolina = null;
                                  });
                                }
                              },
                              child: const Text('CALCULAR'),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(40),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: OutlinedButton(
                              child: Text('LIMPAR'),
                              onPressed: () {
                                _formKey.currentState!.reset();
                                setState(() {
                                  precoDoEtanol = null;
                                  precoDaGasolina = null;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _buildResultado(context),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
