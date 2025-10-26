import 'package:get_storage/get_storage.dart';

class TokenModel {
  final String accessToken;
  final String refreshToken;
  TokenModel({required this.accessToken, required this.refreshToken});
  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
  Map<String, dynamic> toJson() {
    return {'accessToken': accessToken, 'refreshToken': refreshToken};
  }

  String get accessTokenHeader => 'Bearer $accessToken';
  String get refreshTokenHeader => 'Bearer $refreshToken';

  factory TokenModel.fromStorage() {
    final storage = GetStorage();
    final accessToken = storage.read('accessToken') ?? "";
    final refreshToken = storage.read('refreshToken') ?? "";
    return TokenModel(accessToken: accessToken, refreshToken: refreshToken);
  }

  void saveToStorage() {
    final storage = GetStorage();
    storage.write('accessToken', accessToken);
    storage.write('refreshToken', refreshToken);
  }

  static void clearStorage() {
    final storage = GetStorage();
    storage.remove('accessToken');
    storage.remove('refreshToken');
  }
}
