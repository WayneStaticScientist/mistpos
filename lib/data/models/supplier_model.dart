class SupplierModel {
  final String name;
  final String? city;
  final String? notes;
  final String? email;
  final String? country;
  final String? address1;
  final String? address2;
  final String? postalCode;
  final String? phoneNumber;
  final String? id;

  SupplierModel({
    required this.name,
    this.city,
    this.notes,
    this.email,
    this.country,
    this.address1,
    this.address2,
    this.postalCode,
    this.phoneNumber,
    this.id,
  });

  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      name: json['name'],
      city: json['city'],
      notes: json['notes'],
      email: json['email'],
      country: json['country'],
      address1: json['address1'],
      address2: json['address2'],
      postalCode: json['postalCode'],
      phoneNumber: json['phoneNumber'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'name': name,
      'city': city,
      'notes': notes,
      'email': email,
      'country': country,
      'address1': address1,
      'address2': address2,
      'postalCode': postalCode,
      'phoneNumber': phoneNumber,
    };
  }
}
