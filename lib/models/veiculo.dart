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
