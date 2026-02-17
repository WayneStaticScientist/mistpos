import 'package:get_storage/get_storage.dart';
import 'package:isar_plus/isar_plus.dart';
import 'package:mistpos/main.dart';
part 'user_model.g.dart';

@collection
class User {
  late int id = IdGen.id;
  String hexId;
  final int till;
  String? password;
  int receitsCount;
  final String role;
  final String email;
  final String company;
  final String country;
  final String fullName;
  final bool pinnedInput;
  final String companyName;
  final String baseCurrence;
  final bool paynowActivated;
  final List<String> companies;
  final List<String> permissions;
  final bool allowOfflinePurchase;
  final List<String> subscriptions;
  User({
    this.password,
    this.hexId = '',
    required this.till,
    required this.role,
    required this.email,
    required this.country,
    required this.company,
    this.companyName = '',
    required this.fullName,
    this.baseCurrence = 'USD',
    this.receitsCount = 0,
    required this.companies,
    required this.subscriptions,
    required this.pinnedInput,
    this.paynowActivated = false,
    required this.permissions,
    this.allowOfflinePurchase = true,
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
      baseCurrence: (map['baseCurrence'] as String? ?? 'USD').isEmpty
          ? 'USD'
          : (map['baseCurrence'] as String? ?? "USD"),
      paynowActivated: map['paynowActivated'] as bool? ?? false,
      receitsCount: map['receitsCount'] as int? ?? 0,
      permissions: (map['permissions'] == null)
          ? []
          : (map['permissions'] as List<dynamic>)
                .map((e) => e as String)
                .toList(),
      subscriptions: (map['subscriptions'] == null)
          ? []
          : (map['subscriptions'] as List<dynamic>)
                .map((e) => e as String)
                .toList(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'till': till,
      'role': role,
      'email': email,
      "hextId": hexId,
      'company': company,
      'country': country,
      'password': password,
      'fullName': fullName,
      'companies': companies,
      'permissions': permissions,
      'companyName': companyName,
      'pinnedInput': pinnedInput,
      'receitsCount': receitsCount,
      'baseCurrence': baseCurrence,
      "subscriptions": subscriptions,
      'paynowActivated': paynowActivated,
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
      final user = User.fromMap(userData);
      user.hexId = userData['hextId'] ?? "";
      return user;
    }
    return null;
  }

  static void clearStorage() {
    GetStorage storage = GetStorage();
    storage.remove('user');
  }
}
