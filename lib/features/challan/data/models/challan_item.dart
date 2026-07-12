class ChallanItem {
  final String materialName;
  final int quantity;
  final double ratePerPiece;
  final int completedQuantity;

  ChallanItem({
    required this.materialName,
    required this.quantity,
    required this.ratePerPiece,
    this.completedQuantity = 0,
  });

  double get subtotal => quantity * ratePerPiece;
  double get earnedAmount => completedQuantity * ratePerPiece;
  int get remainingQuantity => quantity - completedQuantity;
  double get remainingAmount => remainingQuantity * ratePerPiece;

  ChallanItem copyWith({
    String? materialName,
    int? quantity,
    double? ratePerPiece,
    int? completedQuantity,
  }) {
    return ChallanItem(
      materialName: materialName ?? this.materialName,
      quantity: quantity ?? this.quantity,
      ratePerPiece: ratePerPiece ?? this.ratePerPiece,
      completedQuantity: completedQuantity ?? this.completedQuantity,
    );
  }

  Map<String, dynamic> toMap() => {
    'materialName': materialName,
    'quantity': quantity,
    'ratePerPiece': ratePerPiece,
    'completedQuantity': completedQuantity,
  };

  factory ChallanItem.fromMap(Map<String, dynamic> map) => ChallanItem(
    materialName: map['materialName'],
    quantity: map['quantity'],
    ratePerPiece: (map['ratePerPiece'] as num).toDouble(),
    completedQuantity: map['completedQuantity'] ?? 0,
  );
}
