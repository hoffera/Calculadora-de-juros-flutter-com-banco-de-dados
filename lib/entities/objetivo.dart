import 'package:biblioteca_flutter/entities/usuario.dart';
import 'package:biblioteca_flutter/entities/investimento.dart';

import 'investimento.dart';

class Objetivo {
  int? id;
  String? nome;
  String? tempoConclusao;
  String? valorEstimado;
  String? valorEntrada;
  String? valorMensal;
  Usuario? usuario;
  Investimento? investimento;

  Objetivo(
      {this.id,
      this.nome,
      this.tempoConclusao,
      this.valorEntrada,
      this.valorEstimado,
      this.valorMensal,
      this.usuario,
      this.investimento});

  factory Objetivo.fromJson(Map<String, dynamic> json) {
    return Objetivo(
      id: json['id'],
      nome: json['nome'],
      tempoConclusao: json['tempoConclusao'],
      valorEntrada: json['valorEntrada'],
      valorEstimado: json['valorEstimado'],
      valorMensal: json['valorMensal'],
      usuario: Usuario.fromJson(json['usuario']),
      investimento: Investimento.fromJson(json['investimento']),
    );
  }
}
