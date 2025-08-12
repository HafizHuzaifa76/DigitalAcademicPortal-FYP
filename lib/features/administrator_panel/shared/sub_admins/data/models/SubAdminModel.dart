import '../../domain/entities/SubAdmin.dart';

class SubAdminModel extends SubAdmin {
  SubAdminModel({
    required String id,
    required String email,
    required String name,
    required String department,
  }) : super(id: id, email: email, name: name, department: department);

  factory SubAdminModel.fromMap(String id, Map<String, dynamic> map) {
    return SubAdminModel(
      id: id,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      department: map['department'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'department': department,
    };
  }
}
