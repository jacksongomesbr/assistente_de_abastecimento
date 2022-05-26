import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// O widget MyApp é utilizado no topo da hierarquia de widgets do app.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  /// O método build retorna um MaterialApp com a estrutura do aplicativo. Além
  /// disso determina as rotas e a rota inicial:
  ///
  /// rotas e widgets:
  /// * / => widget TelaInicial
  /// * /analisar-precos => widget MyHomePage
  ///
  /// A rota inicial é /.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assistente de abastecimento',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => TelaInicial(),
        '/analisar-precos': (context) =>
            MyHomePage(title: 'Assistente de abastecimento')
      },
    );
  }
}

/// O widget MyHomePage define a tela que fornece a funcionalidade
/// de calcular a relação entre os preços do etanol e da gasolina e
/// indicar com qual dos dois compensa mais abastecer.
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/// O state MyHomePageState define o state do widget MyHomePage.
class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  double? precoDaGasolina;
  double? precoDoEtanol;

  /// Método que calcula a relação entre o preço do etanol e o preço da gasolina.
  double _calcularRelacaoEtanolGasolina() {
    return precoDoEtanol! / precoDaGasolina!;
  }

  /// Método que retorna uma interface para indicar com qual dos dois
  /// combustíveis compensa mais abastecer.
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

  /// O método build retorna um Scaffold.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text('Forneça o preço do etanol e da gasolina e, '
                  'em seguida, pressione o botão CALCULAR.'),
              SizedBox(
                height: 30,
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
    );
  }
}

/// O widget TelaInicial representa a tela inicial do aplicativo. É apresentado
/// primeiro porque está associado à rota inicial.
class TelaInicial extends StatefulWidget {
  const TelaInicial({Key? key}) : super(key: key);

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

/// O state do widget [TelaInicial].
class _TelaInicialState extends State<TelaInicial> {
  final _formKey = GlobalKey<FormState>();
  String? marca;
  String? modelo;
  int? ano;
  int? volumeDoTanque;

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
              marca = value;
            },
          ),
          SizedBox(
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
              modelo = value;
            },
          ),
          SizedBox(
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
              ano = int.parse(value!);
            },
          ),
          SizedBox(
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
              volumeDoTanque = int.parse(value!);
            },
          ),
        ],
      ),
    );
  }

  /// Este método apresenta um [AlertDialog] para indicar que há
  /// erros de preenchimento que precisam da atenção do usuário.
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
        title: Text('Informe os dados do veículo'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
              child: Text('Informe os dados do veículo e '
                  'depois pressione PROSSEGUIR '
                  'para avançar para a próxima tela'),
            ),
            SizedBox(
              height: 10,
            ),
            _buildForm(context),
            SizedBox(
              height: 30,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Se o form estiver válido, então após salvar o state
                    // do form, realiza a navegação para a rota [/analisar-precos].
                    Navigator.pushNamed(context, '/analisar-precos');
                  } else {
                    // Se o form não estiver válido, apresenta a mensagem
                    // indicando para o usuário preencher os campos
                    // corretamente.
                    _showDialog();
                  }
                },
                child: Text('PROSSEGUIR'),
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
