import 'package:dio/dio.dart';
import 'package:mistpos/models/user_model.dart';
import 'package:mistpos/models/token_model.dart';
import 'package:mistpos/models/response_model.dart';
import 'package:mistpos/services/network_wrapper.dart';
import 'package:mobile_device_identifier/mobile_device_identifier.dart';

class AuthenticationInterceptor extends Interceptor {
  static Dio dio = Dio();
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers["Authorization"] =
        TokenModel.fromStorage().accessTokenHeader;
    options.headers["device"] = await MobileDeviceIdentifier().getDeviceId();
    options.headers['User-Agent'] = 'Mistpos';
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        final response = await requestToken();
        if (!response.hasError) {
          err.requestOptions.headers["Authorization"] =
              TokenModel.fromStorage().accessTokenHeader;
          err.requestOptions.headers["device"] = await MobileDeviceIdentifier()
              .getDeviceId();
          final retryResponse = await dio.fetch(err.requestOptions);

          return handler.resolve(retryResponse);
        }
      } on DioException catch (e) {
        return handler.next(e);
      }
    }
    return handler.next(err);
  }

  static Future<ResponseModel> requestToken() async {
    final mobileDeviceIdentifier = await MobileDeviceIdentifier().getDeviceId();
    try {
      final response = await dio.post(
        "${Net.baseUrl}/user/tokens",
        data: User.fromStorage()?.toMap() ?? {},
        options: Options(
          headers: {
            "device": mobileDeviceIdentifier,
            "Authorization": TokenModel.fromStorage().refreshTokenHeader,
          },
        ),
      );

      final model = TokenModel(
        accessToken: response.data['tokens']['accessToken'],
        refreshToken: response.data['tokens']['refreshToken'],
      );
      model.saveToStorage();
      return ResponseModel(
        body: response.data,
        hasError: false,
        statusCode: 200,
        response: "Success",
      );
    } on DioException catch (e) {
      final response = await Net.getError(e);
      if (response.statusCode == 401) {
        User.clearStorage();
        TokenModel.clearStorage();
      }
      return response;
    }
  }
}
