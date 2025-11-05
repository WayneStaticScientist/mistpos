import 'package:get_storage/get_storage.dart';
import 'package:isar/isar.dart';
part 'user_model.g.dart';

@collection
class User {
  Id id = Isar.autoIncrement;
  String hexId;
  final int till;
  String? password;
  final String role;
  final String email;
  final String company;
  final String country;
  final String fullName;
  final bool pinnedInput;
  final String companyName;
  final String baseCurrence;
  final List<String> companies;
  final bool allowOfflinePurchase;
  User({
    this.password,
    this.hexId = '',
    required this.till,
    required this.role,
    required this.email,
    required this.country,
    required this.company,
    required this.fullName,
    this.baseCurrence = '',
    required this.pinnedInput,
    this.allowOfflinePurchase = true,
    required this.companies,
    this.companyName = '',
  });
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      companies: (map['companies'] == null)
          ? []
          : (map['companies'] as List<dynamic>)
                .map((e) => e as String)
                .toList(),
      till: map['till'] as int? ?? 1,
      email: map['email'] as String,
      company: map['company'] as String,
      country: map['country'] as String,
      hexId: map['_id'] as String? ?? '',
      fullName: map['fullName'] as String,
      role: map['role'] as String? ?? 'user',
      pinnedInput: map['pinnedInput'] as bool? ?? false,
      allowOfflinePurchase: map['allowOfflinePurchase'] as bool? ?? true,
      companyName: map['companyName'] as String? ?? '',
      baseCurrence: map['baseCurrence'] as String? ?? 'USD',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      '_id': hexId,
      'till': till,
      'role': role,
      'email': email,
      'company': company,
      'country': country,
      'password': password,
      'fullName': fullName,
      'companies': companies,
      'companyName': companyName,
      'pinnedInput': pinnedInput,
      'baseCurrence': baseCurrence,
      'allowOfflinePurchase': allowOfflinePurchase,
    };
  }

  static void saveToStorage(User user) {
    GetStorage storage = GetStorage();
    storage.write('user', user.toMap());
  }

  static User? fromStorage() {
    GetStorage storage = GetStorage();
    Map<String, dynamic>? userData = storage.read('user');
    if (userData != null) {
      return User.fromMap(userData);
    }
    return null;
  }

  static void clearStorage() {
    GetStorage storage = GetStorage();
    storage.remove('user');
  }
}
