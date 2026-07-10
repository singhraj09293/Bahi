
class ChallanItem {
  final String materialName;
  final int quantity;
  final double ratePerPiece;

  ChallanItem({
    required this.materialName,
    required this.quantity,
    required this.ratePerPiece,
  });

  double get subtotal => quantity * ratePerPiece;

  Map<String, dynamic> toMap() => {
    'materialName': materialName,
    'quantity': quantity,
    'ratePerPiece': ratePerPiece,
  };

  factory ChallanItem.fromMap(Map<String, dynamic> map) => ChallanItem(
    materialName: map['materialName'],
    quantity: map['quantity'],
    ratePerPiece: (map['ratePerPiece'] as num).toDouble(),
  );
}