import 'investimento.dart';



class Risco {
  int? id;
  String? nome;
  List<dynamic>? investimentos;

  Risco(
      {this.id, this.nome, this.investimentos});

  factory Risco.fromJson(Map<String, dynamic>json){
    return Risco(
        id: json['id'],
        nome: json['nome'],
        investimentos:
        json['investimentos'].map((investimento) => Investimento.fromJson(investimento)).toList());
  }
}