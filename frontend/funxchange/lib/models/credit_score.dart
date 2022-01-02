import 'dart:convert';

class CreditScore {
  final int creditScore;
  final int creditOnHold;

  CreditScore(this.creditScore, this.creditOnHold);

  Map<String, dynamic> toMap() {
    return {
      'credit': creditScore,
      'creditOnHold': creditOnHold,
    };
  }

  factory CreditScore.fromMap(Map<String, dynamic> map) {
    return CreditScore(
      map['credit']?.toInt() ?? 0,
      map['creditOnHold']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreditScore.fromJson(String source) => CreditScore.fromMap(json.decode(source));
}
