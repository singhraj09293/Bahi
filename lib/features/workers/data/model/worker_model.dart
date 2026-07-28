// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class WorkerModel {
  final String workerId;
  final String workerName;

  WorkerModel({required this.workerId, required this.workerName});

  WorkerModel copyWith({String? workerId, String? workerName}) {
    return WorkerModel(
      workerId: workerId ?? this.workerId,
      workerName: workerName ?? this.workerName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'workerId': workerId, 'workerName': workerName};
  }

  factory WorkerModel.fromMap(Map<String, dynamic> map) {
    return WorkerModel(
      workerId: map['workerId'] as String,
      workerName: map['workerName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkerModel.fromJson(String source) =>
      WorkerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'WorkerModel(workerId: $workerId, workerName: $workerName)';

  @override
  bool operator ==(covariant WorkerModel other) {
    if (identical(this, other)) return true;

    return other.workerId == workerId && other.workerName == workerName;
  }

  @override
  int get hashCode => workerId.hashCode ^ workerName.hashCode;
}
