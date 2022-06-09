import 'package:cloud_firestore/cloud_firestore.dart';

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
