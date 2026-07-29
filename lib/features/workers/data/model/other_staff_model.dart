class OtherStaffModel {
  final String id;
  final String name;
  final String role;
  final double salary; // Expense per month/period

  OtherStaffModel({
    required this.id,
    required this.name,
    required this.role,
    required this.salary,
  });
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'role': role, 'salary': salary};
  }

  factory OtherStaffModel.fromMap(Map<String, dynamic> map, String docId) {
    return OtherStaffModel(
      id: docId,
      name: map['name'] ?? '',
      role: map['role'] ?? '',
      salary: (map['salary'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
