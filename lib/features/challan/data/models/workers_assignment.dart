class WorkerAssignment {
  final String workerId;
  final String workerName;
  final int quantity;

  WorkerAssignment({
    required this.workerId,
    required this.workerName,
    required this.quantity,
  });

  Map<String, dynamic> toMap() => {
    'workerId': workerId,
    'workerName': workerName,
    'quantity': quantity,
  };

  factory WorkerAssignment.fromMap(Map<String, dynamic> map) => WorkerAssignment(
    workerId: map['workerId'],
    workerName: map['workerName'],
    quantity: map['quantity'],
  );
}