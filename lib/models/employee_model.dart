class EmployeeModel {
  final String fullName;
  final String email;
  final String id;
  final String role;
  final String phone;
  EmployeeModel({
    required this.fullName,
    required this.email,
    required this.id,
    required this.role,
    required this.phone,
  });
  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      fullName: json['fullName'],
      email: json['email'],
      id: json['_id'],
      role: json['role'],
      phone: json['phone'] ?? "",
    );
  }
}
