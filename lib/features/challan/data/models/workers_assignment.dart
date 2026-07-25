class WorkerAssignment {
  final String workerId;
  final String workerName;
  final int quantity;
  final double ratePerPiece;

  WorkerAssignment({
    required this.workerId,
    required this.workerName,
    required this.quantity,
    required this.ratePerPiece,
  });

  double get amount => quantity * ratePerPiece;

  Map<String, dynamic> toMap() => {
    'workerId': workerId,
    'workerName': workerName,
    'quantity': quantity,
    'ratePerPiece': ratePerPiece,
  };

  factory WorkerAssignment.fromMap(Map<String, dynamic> map) =>
      WorkerAssignment(
        workerId: map['workerId'],
        workerName: map['workerName'],
        quantity: map['quantity'],
        ratePerPiece: (map['ratePerPiece'] as num).toDouble(),
      );
}
