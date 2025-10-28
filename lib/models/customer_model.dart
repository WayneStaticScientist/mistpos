import 'package:isar/isar.dart';
part 'customer_model.g.dart';

@collection
class CustomerModel {
  Id id = Isar.autoIncrement;
  final String email;
  final String city;
  final String notes;
  final int points;
  final int visits;
  final String company;
  final String country;
  final String address;
  final String fullName;
  final String phoneNumber;
  final double purchaseValue;
  final double inboundProfit;
  final String hexId;
  CustomerModel({
    required this.email,
    required this.city,
    required this.notes,
    required this.points,
    required this.visits,
    required this.company,
    required this.country,
    required this.address,
    required this.fullName,
    required this.phoneNumber,
    required this.purchaseValue,
    required this.inboundProfit,
    required this.hexId,
  });
  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "city": city,
      "notes": notes,
      "country": country,
      "address": address,
      "fullName": fullName,
      "phoneNumber": phoneNumber,
    };
  }

  factory CustomerModel.fromJson(Map<String, dynamic> data) {
    return CustomerModel(
      email: data['email'],
      city: data['city'] ?? '',
      notes: data['notes'] ?? '',
      points: data['points'] ?? 0,
      visits: data['visits'] ?? 0,
      company: data['company'],
      country: data['country'] ?? 0,
      address: data['address'] ?? '',
      fullName: data['fullName'],
      phoneNumber: data['phoneNumber'] ?? '',
      purchaseValue: (['purchaseValue'] as num?)?.toDouble() ?? 0.0,
      inboundProfit: (['inboundProfit'] as num?)?.toDouble() ?? 0.0,
      hexId: data['_id'],
    );
  }
}
