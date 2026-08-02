class OtherStaffModel {
  final String id;
  final String name;
  final String role;
  final double salary;
  final String userId;
  OtherStaffModel({
    required this.id,
    required this.name,
    required this.role,
    required this.salary,
    required this.userId,
  });
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'role': role, 'salary': salary,'userId':userId};
  }

  factory OtherStaffModel.fromMap(Map<String, dynamic> map, String docId) {
    return OtherStaffModel(
      id: docId,
      name: map['name'] ?? '',
      role: map['role'] ?? '',
      salary: (map['salary'] as num?)?.toDouble() ?? 0.0,
      userId: map['userId'] ?? '',
    );
  }
}
