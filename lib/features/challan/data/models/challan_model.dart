// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:challan_app/features/challan/data/models/workers_assignment.dart';
import 'package:challan_app/features/challan/domain/entities/challan_entity.dart';

class ChallanModel extends Challan {
  ChallanModel({
    required super.challanNo,
    required super.date,
    required super.workersNames,
    required super.totalPiece,
    required super.classification,
    required super.isReady,
    required super.isDelivered,
    super.deliveryDate,
    required super.workerid,
    super.lotCameDate,
    required super.garmentTypes,
    required super.sethName,
    required super.design,
    required super.designer,
    required super.assignments,
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
    String? workerid,
    DateTime? lotCameDate,
    List<String>? garmentTypes,
    String? sethName,
    String? design,
    String? designer,
    List<WorkerAssignment>? assignments,
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
      workerid: workerid ?? this.workerid,
      lotCameDate: lotCameDate ?? this.lotCameDate,
      garmentTypes: garmentTypes ?? this.garmentTypes,
      sethName: sethName ?? this.sethName,
      design: design ?? this.design,
      designer: designer ?? this.designer,
      assignments: assignments ?? this.assignments,
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
      'workerid': workerid,
      'lotCameDate': lotCameDate?.millisecondsSinceEpoch,
      'garmentTypes': garmentTypes,
      'sethName': sethName,
      'design': design,
      'designer': designer,
      'assignments': assignments.map((a)=>a.toMap()).toList(),
    };
  }

  factory ChallanModel.fromMap(Map<String, dynamic> map) {
    return ChallanModel(
      workerid: map['workerid'] as String? ?? '',
      challanNo: map['challanNo'] as String? ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      workersNames: map['workersNames'] as String? ?? '',
      totalPiece: map['totalPiece'] as int? ?? 0,
      classification: map['classification'] as String? ?? '',
      isReady: map['isReady'] as String? ?? 'Pending',
      isDelivered: map['isDelivered'] as bool? ?? false,
      deliveryDate: map['deliveryDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['deliveryDate'] as int)
          : null,

      lotCameDate: map['lotCameDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lotCameDate'])
          : null,
      garmentTypes: List<String>.from(map['garmentTypes'] ?? []),
      sethName: map['sethName'] as String? ?? '',
      design: map['design'] as String? ?? '',
      designer: map['designer'] as String? ?? '',
      assignments: (map['assignments'] as List<dynamic>? ?? [])
          .map((e) => WorkerAssignment.fromMap(e))
          .toList(),
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
