import 'package:challan_app/features/challan/data/models/workers_assignment.dart';

class ChallanItem {
  final String materialName;
  final int quantity;
  final double ratePerPiece;
  final List<WorkerAssignment> assignments;

  ChallanItem({
    required this.materialName,
    required this.quantity,
    required this.ratePerPiece,
    this.assignments = const [],
  });

  double get subtotal => quantity * ratePerPiece;
  int get assignedQuantity {
    int total = 0;
    for (var a in assignments) {
      total = total + a.quantity;
    }
    return total;
  }

  int get remainingQuantity => quantity - assignedQuantity;

  ChallanItem copyWith({
    String? materialName,
    int? quantity,
    double? ratePerPiece,
    List<WorkerAssignment>? assignments,
  }) {
    return ChallanItem(
      materialName: materialName ?? this.materialName,
      quantity: quantity ?? this.quantity,
      ratePerPiece: ratePerPiece ?? this.ratePerPiece,
      assignments: assignments ?? this.assignments,
    );
  }

  Map<String, dynamic> toMap() => {
    'materialName': materialName,
    'quantity': quantity,
    'ratePerPiece': ratePerPiece,
    'assignments': assignments.map((a) => a.toMap()).toList(),
  };

  factory ChallanItem.fromMap(Map<String, dynamic> map) => ChallanItem(
    materialName: map['materialName'],
    quantity: map['quantity'],
    ratePerPiece: (map['ratePerPiece'] as num).toDouble(),
    assignments: (map['assigments'] as List<dynamic>? ?? [])
        .map((e) => WorkerAssignment.fromMap(e))
        .toList(),
  );
}
