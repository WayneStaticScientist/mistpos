class EmployeeModel {
  final String fullName;
  final String email;
  final String id;
  final String role;
  final String phone;
  final int till;
  EmployeeModel({
    required this.fullName,
    required this.email,
    required this.id,
    required this.role,
    required this.phone,
    required this.till,
  });
  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      fullName: json['fullName'],
      email: json['email'],
      id: json['_id'],
      role: json['role'],
      phone: json['phone'] ?? "",
      till: json['till'] ?? 0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "email": email,
      "_id": id,
      "role": role,
      "phone": phone,
      "till": till,
    };
  }
}
