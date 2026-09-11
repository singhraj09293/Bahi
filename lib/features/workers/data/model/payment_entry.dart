// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PaymentEntry {
  final double amount;
  final DateTime date;
  final String? note;

  PaymentEntry({required this.amount, required this.date, this.note});

  PaymentEntry copyWith({double? amount, DateTime? date, String? note}) {
    return PaymentEntry(
      amount: amount ?? this.amount,
      date: date ?? this.date,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'amount': amount,
      'date': date.millisecondsSinceEpoch,
      'note': note,
    };
  }

  factory PaymentEntry.fromMap(Map<String, dynamic> map) {
    return PaymentEntry(
      amount: map['amount'] as double,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      note: map['note'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentEntry.fromJson(String source) =>
      PaymentEntry.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'PaymentEntry(amount: $amount, date: $date, note: $note)';

  @override
  bool operator ==(covariant PaymentEntry other) {
    if (identical(this, other)) return true;

    return other.amount == amount && other.date == date && other.note == note;
  }

  @override
  int get hashCode => amount.hashCode ^ date.hashCode ^ note.hashCode;
}
