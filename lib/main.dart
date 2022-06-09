import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import "dart:convert";
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      initialRoute: '/splash',
      routes: {
        '/': (context) => const TelaInicial(),
        '/splash': (context) => const TelaSplash(),
        '/escolher-posto': (context) => TelaEscolherPosto(),
        '/analisar-precos': (context) => const MyHomePage()
      },
    );
  }
}

class TelaSplash extends StatelessWidget {
  const TelaSplash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      padding: EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage('assets/graphics/logotipo.png'),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/");
            },
            child: Text('PROSSEGUIR'),
          ),
        ],
      ),
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
                      arguments: MyHomePageRouteParams(
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
  String id;
  String? razaoSocial;
  String? cnpj;
  String? endereco;
  String? bandeira;

  /// Construtor de [PostoDeCombustivel] utiliza abordagem de parâmetros nomeados e indica
  /// que o parâmetro [razaoSocial] é obrigatório. Os demais parâmetros são opcionais.
  PostoDeCombustivel(
      {required this.id,
      required this.razaoSocial,
      this.cnpj,
      this.endereco,
      this.bandeira});

  /// Construtor de [PostoDeCombustivel] que é utilizado para converter
  /// um mapa em que as chaves são string e os valores são dynamic. Geralmente
  /// essa representação é adotada quando os dados de um json são carregados.
  PostoDeCombustivel.fromJson(Map<String, dynamic> json)
      : this(
          id: json["CODIGOISIMP"].toString(),
          razaoSocial: json['RAZAOSOCIAL'],
          cnpj: json["CNPJ"].toString(),
          endereco: json["ENDERECO"],
          bandeira: json["BANDEIRA"],
        );

  /// Construtor de [PostoDeComsutivel] a partir de um [DocumentSnapshot].
  PostoDeCombustivel.fromDocument(DocumentSnapshot document)
      : this(
          id: document.id,
          razaoSocial: document["razao_social"],
          cnpj: document["cnpj"],
          endereco: document["endereco"],
          bandeira: document["bandeira"],
        );
}

/// Define uma classe para representar os dados de rota para a tela [MyHomePage]:
/// * posto de combustível
/// * veículo
class MyHomePageRouteParams {
  PostoDeCombustivel? posto;
  Veiculo? veiculo;

  MyHomePageRouteParams({this.posto, this.veiculo});
}
