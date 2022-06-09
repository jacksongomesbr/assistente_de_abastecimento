import 'posto_de_combustivel.dart';
import 'veiculo.dart';

/// Define uma classe para representar os dados de rota para a tela [MyHomePage]:
/// * posto de combustível
/// * veículo
class MyHomePageRouteParams {
  PostoDeCombustivel? posto;
  Veiculo? veiculo;

  MyHomePageRouteParams({this.posto, this.veiculo});
}
