import 'dart:convert';

class WalletModel {
  final String id;
  final String idBuyer;
  final String datePay;
  final String money;
  final String pathSlip;
  final String status;

  WalletModel(this.id, this.idBuyer, this.datePay, this.money, this.pathSlip,
      this.status);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idBuyer': idBuyer,
      'datePay': datePay,
      'money': money,
      'pathSlip': pathSlip,
      'status': status,
    };
  }

  factory WalletModel.fromMap(Map<String, dynamic> map) {
    return WalletModel(
      map['id'] ?? '',
      map['idBuyer'] ?? '',
      map['datePay'] ?? '',
      map['money'] ?? '',
      map['pathSlip'] ?? '',
      map['status'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory WalletModel.fromJson(String source) =>
      WalletModel.fromMap(json.decode(source));
}
