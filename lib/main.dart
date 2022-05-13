import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// A classe [MyApp] representa o ponto-de-partida do aplicativo, ou seja,
/// é o widget de mais alto nível na árvore de widget do aplicativo.
/// As rotas são:
/// /: a rota raiz, associada ao widget [TelaInicial]
/// /posto: associada ao widget [TelaEscolherPosto]
/// /analisar-precos: associada ao widget [MyHomePage]
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const TelaInicial(),
        '/escolher-posto': (context) => TelaEscolherPosto(),
        '/analisar-precos': (context) => const MyHomePage()
      },
    );
  }
}

/// A classe [MyHomePage] fornece a tela que entre a funcionalidade
/// de calcular a relação entre o preço do etanol e da gasolina, além
/// de indicar, com base nesta relação, com qual dos dois tipos de
/// combustível compensa mais realizar o abastecimento.
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/// A classe [MyHomePageState] representa o state de [MyHomePage].
///
/// Mais especificamente, os campos que podem alterar o state são:
/// * [precoDaGasolina]
/// * [precoDoEtanol]
class _MyHomePageState extends State<MyHomePage> {
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
    MyHomePageRouteParams params =
        ModalRoute.of(context)!.settings.arguments as MyHomePageRouteParams;
    veiculo = params.veiculo;
    posto = params.posto;

    return Scaffold(
      appBar: AppBar(
        title: Text('Assistente de abastecimento'),
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

class TelaEscolherPosto extends StatelessWidget {
  TelaEscolherPosto({Key? key}) : super(key: key);

  Veiculo veiculo = Veiculo.vazio();

  @override
  Widget build(BuildContext context) {
    veiculo = ModalRoute.of(context)!.settings.arguments as Veiculo;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escolha o posto de combustível'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          ListTile(
            title: Text('AUTO POSTO LEAL E LEAL LTDA'),
            subtitle: Text('506 NORTE AVENIDA NS 8, S/N'),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/analisar-precos',
                arguments: MyHomePageRouteParams(
                  veiculo: veiculo,
                  posto: PostoDeCombustivel(
                    razaoSocial: 'AUTO POSTO LEAL E LEAL LTDA',
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: Text('AUTO POSTO MASP ARNE LTDA'),
            subtitle: Text('QUADRA 406 NORTE AVENIDA NS 6 - P.A.C., S/N'),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/analisar-precos',
                arguments: MyHomePageRouteParams(
                  veiculo: veiculo,
                  posto: PostoDeCombustivel(
                    razaoSocial: 'AUTO POSTO MASP ARNE LTDA',
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: Text('PETROSHOP - COM. DE COMBUSTIVEIS LTDA - ME.'),
            subtitle:
                Text('Q 412 NORTE, ROD. TO-010, (ASRNE55, CONJ. PAC-02),  S/N'),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/analisar-precos',
                arguments: MyHomePageRouteParams(
                  veiculo: veiculo,
                  posto: PostoDeCombustivel(
                    razaoSocial: 'PETROSHOP - COM. DE COMBUSTIVEIS LTDA - ME.',
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: Text('RIBEIRO COMERCIO VAREJISTA DE COMBUSTIVEIS LTDA'),
            subtitle: Text('QUADRA 406 NORTE AVENIDA NS 6 - P.A.C., S/N'),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/analisar-precos',
                arguments: MyHomePageRouteParams(
                  veiculo: veiculo,
                  posto: PostoDeCombustivel(
                    razaoSocial:
                        'RIBEIRO COMERCIO VAREJISTA DE COMBUSTIVEIS LTDA',
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: Text('POSTO DE COMBUSTIVEIS 32 LTDA'),
            subtitle: Text('QUADRA 305 NORTE AV. NS 05 PAC LOTE 01,  SN'),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/analisar-precos',
                arguments: MyHomePageRouteParams(
                  veiculo: veiculo,
                  posto: PostoDeCombustivel(
                    razaoSocial: 'POSTO DE COMBUSTIVEIS 32 LTDA',
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: Text('AUTO POSTO SHALOM LTDA'),
            subtitle: Text('QUADRA ARNE 51 AVENIDA NS 02,  S/N'),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/analisar-precos',
                arguments: MyHomePageRouteParams(
                  veiculo: veiculo,
                  posto: PostoDeCombustivel(
                    razaoSocial: 'AUTO POSTO SHALOM LTDA',
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: Text('PETRO - POSTOS DE ABASTECIMENTO LTDA.'),
            subtitle: Text('AVENIDA NS - 1,  S/N'),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/analisar-precos',
                arguments: MyHomePageRouteParams(
                  veiculo: veiculo,
                  posto: PostoDeCombustivel(
                    razaoSocial: 'PETRO - POSTOS DE ABASTECIMENTO LTDA.',
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: Text('STAR COMERCIO DE COMBUSTIVEL LTDA'),
            subtitle: Text('AVENIDA NS 02 ARSE 61,  SN'),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/analisar-precos',
                arguments: MyHomePageRouteParams(
                  veiculo: veiculo,
                  posto: PostoDeCombustivel(
                    razaoSocial: 'STAR COMERCIO DE COMBUSTIVEL LTDA',
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: Text('SOUZA & VITAL LTDA'),
            subtitle: Text('QUADRA 206 SUL AV. NS 04 PAC LOTE 13-A,  SN'),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/analisar-precos',
                arguments: MyHomePageRouteParams(
                  veiculo: veiculo,
                  posto: PostoDeCombustivel(
                    razaoSocial: 'SOUZA & VITAL LTDA',
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: Text('AUTO POSTO DISBRAVA LTDA'),
            subtitle: Text('QUADRA QD 405  NORTE  ALAMEDA 07  QC 05,  01B'),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/analisar-precos',
                arguments: MyHomePageRouteParams(
                  veiculo: veiculo,
                  posto: PostoDeCombustivel(
                    razaoSocial: 'AUTO POSTO DISBRAVA LTDA',
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: Text('AUTO POSTO G2 LTDA'),
            subtitle: Text('QUADRA 101 NORTE AVENIDA NS 1,  1'),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/analisar-precos',
                arguments: MyHomePageRouteParams(
                  veiculo: veiculo,
                  posto: PostoDeCombustivel(
                    razaoSocial: 'AUTO POSTO G2 LTDA',
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: Text('ALCANTARA & FARIA LTDA'),
            subtitle: Text('QUADRA 712 SUL, QI 08, LOTE 01 PAC 01,  S/N'),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/analisar-precos',
                arguments: MyHomePageRouteParams(
                  veiculo: veiculo,
                  posto: PostoDeCombustivel(
                    razaoSocial: 'ALCANTARA & FARIA LTDA',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Define uma classe para representar dados de veículo:
/// * marca
/// * modelo
/// * ano
/// * volume do tanque de combustível
class Veiculo {
  String marca;
  String modelo;
  int ano;
  int volumeDoTanque;

  Veiculo(this.marca, this.modelo, this.ano, this.volumeDoTanque);

  /// Este construtor cria uma instância cujos atributos possuem
  /// valores padrão (ex.: string '', int 0)
  Veiculo.vazio() : this('', '', 0, 0);
}

/// Define uma classe para representar dados de um posto de combustível:
/// * razão social
/// * CNPJ
/// * endereço
/// * bandeira
class PostoDeCombustivel {
  String? razaoSocial;
  String? cnpj;
  String? endereco;
  String? bandeira;

  /// Construtor de [PostoDeCombustivel] utiliza abordagem de parâmetros nomeados e indica
  /// que o parâmetro [razaoSocial] é obrigatório. Os demais parâmetros são opcionais.
  PostoDeCombustivel(
      {required this.razaoSocial, this.cnpj, this.endereco, this.bandeira});
}

/// Define uma classe para representar os dados de rota para a tela [MyHomePage]:
/// * posto de combustível
/// * veículo
class MyHomePageRouteParams {
  PostoDeCombustivel? posto;
  Veiculo? veiculo;

  MyHomePageRouteParams({this.posto, this.veiculo});
}
