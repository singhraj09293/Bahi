import 'package:challan_app/features/workers/data/model/payment_entry.dart';

class WorkerModel {
  final String workerId;
  final String workerName;
  final String userId;
  final List<PaymentEntry> payments;

  WorkerModel({
    required this.workerId,
    required this.workerName,
    required this.userId,
    this.payments = const [],
  });

  WorkerModel copyWith({
    String? workerId,
    String? workerName,
    String? userId,
    List<PaymentEntry>? payments,
  }) {
    return WorkerModel(
      workerId: workerId ?? this.workerId,
      workerName: workerName ?? this.workerName,
      userId: userId ?? this.userId,
      payments: payments ?? this.payments,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'workerId': workerId,
      'workerName': workerName,
      'userId': userId,
      'payments': payments.map((p) => p.toMap()).toList(),
    };
  }

  factory WorkerModel.fromMap(Map<String, dynamic> map) {
    return WorkerModel(
      workerId: map['workerId'] as String,
      workerName: map['workerName'] as String,
      userId: map['userId'] as String,
      payments: (map['payments'] as List<dynamic>? ?? [])
          .map((e) => PaymentEntry.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  String toString() =>
      'WorkerModel(workerId: $workerId, workerName: $workerName, userId: $userId)';

  @override
  bool operator ==(covariant WorkerModel other) {
    if (identical(this, other)) return true;
    return other.workerId == workerId &&
        other.workerName == workerName &&
        other.userId == userId;
  }

  @override
  int get hashCode => workerId.hashCode ^ workerName.hashCode ^ userId.hashCode;
}
