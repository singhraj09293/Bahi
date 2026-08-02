class WorkerModel {
  final String workerId;
  final String workerName;
  final String userId;


  WorkerModel({
    required this.workerId,
    required this.workerName,
    required this.userId,
  });

  WorkerModel copyWith({String? workerId, String? workerName, String? userId}) {
    return WorkerModel(
      workerId: workerId ?? this.workerId,
      workerName: workerName ?? this.workerName,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'workerId': workerId,
      'workerName': workerName,
      'userId': userId,
    };
  }

  factory WorkerModel.fromMap(Map<String, dynamic> map) {
    return WorkerModel(
      workerId: map['workerId'] as String,
      workerName: map['workerName'] as String,
      userId: map['userId'] as String,
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