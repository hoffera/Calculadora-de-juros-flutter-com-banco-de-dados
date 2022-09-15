import 'package:biblioteca_flutter/entities/risco.dart';

class Investimento {
  int? id;
  double? rentabilidade;
  String? pmt;
  Risco? risco;
  String? investimento;

  Investimento({this.id, this.rentabilidade, this.investimento, this.pmt, this.risco});

  factory Investimento.fromJson(Map<String, dynamic> json) {
    return Investimento(
      id: json['id'],
      rentabilidade: json['rentabilidade'],
      pmt: json['pmt'],
      investimento: json['investimento'],
       risco: Risco.fromJson(json['risco'])
    );
  }
}
