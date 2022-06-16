import 'package:cloud_firestore/cloud_firestore.dart';

/// Define uma classe para representar dados de veículo:
/// * marca
/// * modelo
/// * ano
/// * volume do tanque de combustível
class Veiculo {
  String id;
  String? marca;
  String? modelo;
  int? ano;
  int? volumeDoTanque;

  Veiculo({
    required this.id,
    this.marca,
    this.modelo,
    this.ano,
    this.volumeDoTanque,
  });

  factory Veiculo.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return Veiculo(
        id: snapshot.id,
        marca: data?["marca"],
        modelo: data?["modelo"],
        ano: data?["ano"],
        volumeDoTanque: data?["volume_do_tanque"]);
  }

  Map<String, dynamic> toDocument() {
    return {
      if (marca != null) "marca": marca,
      if (modelo != null) "modelo": modelo,
      if (ano != null) "ano": ano,
      if (volumeDoTanque != null) "volume_do_tanque": volumeDoTanque
    };
  }

  /// Este construtor cria uma instância cujos atributos possuem
  /// valores padrão (ex.: string '', int 0)
  Veiculo.vazio()
      : this(id: '', marca: '', modelo: '', ano: 0, volumeDoTanque: 0);
}
