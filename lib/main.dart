import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assistente de abastecimento',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const TelaInicial(),
        '/analisar-precos': (context) =>
            const MyHomePage(title: 'Assistente de abastecimento')
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  double? precoDaGasolina;
  double? precoDoEtanol;
  Veiculo? veiculo;

  double _calcularRelacaoEtanolGasolina() {
    return precoDoEtanol! / precoDaGasolina!;
  }

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
              child: Center(
                child: texto,
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

  /// Constrói uma UI com informações do veículo
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

  @override
  Widget build(BuildContext context) {
    // Obtém o veículo a partir dos argumentos da rota.
    // É necessário fazer cast.
    // Como já está no início do build(), então não usa setState()
    veiculo = ModalRoute.of(context)!.settings.arguments as Veiculo;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: <Widget>[
                _buildVeiculoCard(),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
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
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
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
                          setState(() {
                            precoDaGasolina = double.parse(value!);
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
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

  void _myShowDialog() {
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

                    // Realiza a navegação, passando o argumento (o veículo)
                    Navigator.pushNamed(context, '/analisar-precos',
                        arguments: veiculo);
                  } else {
                    _myShowDialog();
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

/// A classe Veículo contém os atributos:
/// * marca
/// * modelo
/// * ano
/// * volume do tanque
class Veiculo {
  String marca;
  String modelo;
  int ano;
  int volumeDoTanque;

  /// O construtor com parâmetros posicionais
  Veiculo(this.marca, this.modelo, this.ano, this.volumeDoTanque);

  /// Define um construtor nomeado para inicializar os atributos com valores "vazios".
  Veiculo.vazio() : this('', '', 0, 0);
}
