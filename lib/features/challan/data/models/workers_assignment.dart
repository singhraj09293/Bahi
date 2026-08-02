class WorkerAssignment {
  final String workerId;
  final String workerName;
  final int quantity;
  final double ratePerPiece;
  final bool isComplete;
  final String varient;

  WorkerAssignment({
    required this.workerId,
    required this.workerName,
    required this.quantity,
    required this.ratePerPiece,
    this.isComplete = false, required this.varient,
  });

  double get amount => quantity * ratePerPiece;

  WorkerAssignment copyWith({
    String? workerId,
    String? workerName,
    int? quantity,
    double? ratePerPiece,
    bool? isComplete,
    String? varient,
  }) {
    return WorkerAssignment(
      workerId: workerId ?? this.workerId,
      workerName: workerName ?? this.workerName,
      quantity: quantity ?? this.quantity,
      ratePerPiece: ratePerPiece ?? this.ratePerPiece,
      isComplete: isComplete ?? this.isComplete,
      varient: varient ?? this.varient
    );
  }

  Map<String, dynamic> toMap() => {
    'workerId': workerId,
    'workerName': workerName,
    'quantity': quantity,
    'ratePerPiece': ratePerPiece,
    'isComplete': isComplete,
    'varient':varient,
  };

  factory WorkerAssignment.fromMap(Map<String, dynamic> map) =>
      WorkerAssignment(
        workerId: map['workerId'],
        workerName: map['workerName'],
        quantity: map['quantity'],
        ratePerPiece: (map['ratePerPiece'] as num).toDouble(),
        isComplete: map['isComplete'] as bool? ?? false,
        varient: map['varient'] as String? ?? '',
      );
}
