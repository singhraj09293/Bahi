// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SethModel {
  final String masterId;
  final String masterName;

  SethModel({required this.masterId, required this.masterName});

  SethModel copyWith({String? masterId, String? masterName}) {
    return SethModel(
      masterId: masterId ?? this.masterId,
      masterName: masterName ?? this.masterName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'masterId': masterId, 'masterName': masterName};
  }

  factory SethModel.fromMap(Map<String, dynamic> map) {
    return SethModel(
      masterId: map['masterId'] as String,
      masterName: map['masterName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SethModel.fromJson(String source) =>
      SethModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SethModel(masterId: $masterId, masterName: $masterName)';

  @override
  bool operator ==(covariant SethModel other) {
    if (identical(this, other)) return true;

    return other.masterId == masterId && other.masterName == masterName;
  }

  @override
  int get hashCode => masterId.hashCode ^ masterName.hashCode;
}
