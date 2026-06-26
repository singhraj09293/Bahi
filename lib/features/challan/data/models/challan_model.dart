// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChallanModel {
  final String challanNo;
  final DateTime date;
  final String workersNames;
  final int totalPiece;
  final String classification;
  final String isReady;
  final bool isDelivered;
  final DateTime? deliveryDate;

  ChallanModel({
    required this.challanNo,
    required this.date,
    required this.workersNames,
    required this.totalPiece,
    required this.classification,
    required this.isReady,
    required this.isDelivered,
    this.deliveryDate,
  });

  ChallanModel copyWith({
    String? challanNo,
    DateTime? date,
    String? workersNames,
    int? totalPiece,
    String? classification,
    String? isReady,
    bool? isDelivered,
    DateTime? deliveryDate,
  }) {
    return ChallanModel(
      challanNo: challanNo ?? this.challanNo,
      date: date ?? this.date,
      workersNames: workersNames ?? this.workersNames,
      totalPiece: totalPiece ?? this.totalPiece,
      classification: classification ?? this.classification,
      isReady: isReady ?? this.isReady,
      isDelivered: isDelivered ?? this.isDelivered,
      deliveryDate: deliveryDate ?? this.deliveryDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'challanNo': challanNo,
      'date': date.millisecondsSinceEpoch,
      'workersNames': workersNames,
      'totalPiece': totalPiece,
      'classification': classification,
      'isReady': isReady,
      'isDelivered': isDelivered,
      'deliveryDate': deliveryDate?.millisecondsSinceEpoch,
    };
  }

  factory ChallanModel.fromMap(Map<String, dynamic> map) {
    return ChallanModel(
      challanNo: map['challanNo'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      workersNames: map['workersNames'] as String,
      totalPiece: map['totalPiece'] as int,
      classification: map['classification'] as String,
      isReady: map['isReady'] as String,
      isDelivered: map['isDelivered'] as bool,
      deliveryDate: map['deliveryData'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['deliveryDate'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChallanModel.fromJson(String source) =>
      ChallanModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChallanModel(challanNo: $challanNo, date: $date, workersNames: $workersNames, totalPiece: $totalPiece, classification: $classification, isReady: $isReady, isDelivered: $isDelivered, deliveryDate: $deliveryDate)';
  }

  @override
  bool operator ==(covariant ChallanModel other) {
    if (identical(this, other)) return true;

    return other.challanNo == challanNo &&
        other.date == date &&
        other.workersNames == workersNames &&
        other.totalPiece == totalPiece &&
        other.classification == classification &&
        other.isReady == isReady &&
        other.isDelivered == isDelivered &&
        other.deliveryDate == deliveryDate;
  }

  @override
  int get hashCode {
    return challanNo.hashCode ^
        date.hashCode ^
        workersNames.hashCode ^
        totalPiece.hashCode ^
        classification.hashCode ^
        isReady.hashCode ^
        isDelivered.hashCode ^
        deliveryDate.hashCode;
  }
}
