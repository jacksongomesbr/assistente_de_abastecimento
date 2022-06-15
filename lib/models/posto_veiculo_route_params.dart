import 'posto_de_combustivel.dart';
import 'veiculo.dart';

/// Define uma classe para representar os dados de rota para a tela [MyHomePage]:
/// * posto de combustível
/// * veículo
class PostoVeiculoRouteParams {
  PostoDeCombustivel? posto;
  Veiculo? veiculo;

  PostoVeiculoRouteParams({this.posto, this.veiculo});
}
