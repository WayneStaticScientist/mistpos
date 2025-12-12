import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/models/token_model.dart';
import 'package:mistpos/services/url_services.dart';
import 'package:mistpos/models/response_model.dart';
import 'package:mistpos/services/auth_interceptor.dart';
import 'package:mobile_device_identifier/mobile_device_identifier.dart';

class Net {
  static Dio? _dio;
  // static const String baseUrl = "http://10.0.2.2:3001/v1";
  static const String baseUrl = "https://api.mistpos.co.zw/v1";
  static Future<ResponseModel> get(String url) async {
    if (Net._dio == null) {
      initDio();
    }
    try {
      final response = await _dio!.get(url);
      return ResponseModel(hasError: false, response: "", body: response.data);
    } on DioException catch (e) {
      log("There was error $e");
      return getError(e);
    }
  }

  static Future<void> lauchDashboardUrl() async {
    try {
      UrlLauncherService.launchUrl(
        'https://dashboard.mistpos.co.zw/auth?id=${(TokenModel.fromStorage().refreshToken)}&device=${(await MobileDeviceIdentifier().getDeviceId())}',
      );
    } catch (e) {
      Toaster.showError("Failed to launch dashboard");
    }
  }

  static Future<void> launchVerificationUrl() async {
    try {
      UrlLauncherService.launchUrl(
        'https://dashboard.mistpos.co.zw/redirect/verification?id=${(TokenModel.fromStorage().refreshToken)}&device=${(await MobileDeviceIdentifier().getDeviceId())}',
      );
    } catch (e) {
      Toaster.showError("Failed to launch dashboard");
    }
  }

  static Future<void> launchForgotPassword() async {
    try {
      UrlLauncherService.launchUrl('https://dashboard.mistpos.co.zw/reset');
    } catch (e) {
      Toaster.showError("Failed to launch password reset , try again later");
    }
  }

  static Future<void> launchSupport() async {
    try {
      UrlLauncherService.launchUrl(
        'https://dashboard.mistpos.co.zw/?query=support',
      );
    } catch (e) {
      Toaster.showError("Failed to launch support , try again later");
    }
  }

  static Future<ResponseModel> post(
    String url, {
    dynamic data,
    Options? options,
  }) async {
    if (Net._dio == null) {
      initDio();
    }
    try {
      final response = await _dio!.post(url, data: data, options: options);
      return ResponseModel(hasError: false, response: "", body: response.data);
    } on DioException catch (e) {
      return getError(e);
    }
  }

  static Future<ResponseModel> put(
    String url, {
    dynamic data,
    Options? options,
  }) async {
    if (Net._dio == null) {
      initDio();
    }
    try {
      final response = await _dio!.put(url, data: data, options: options);
      return ResponseModel(hasError: false, response: "", body: response.data);
    } on DioException catch (e) {
      return getError(e);
    }
  }

  static Future<ResponseModel> delete(
    String url, {
    dynamic data,
    Options? options,
  }) async {
    if (Net._dio == null) {
      initDio();
    }
    try {
      final response = await _dio!.delete(url, data: data, options: options);
      return ResponseModel(hasError: false, response: "", body: response.data);
    } on DioException catch (e) {
      return getError(e);
    }
  }

  static void initDio() {
    _dio = Dio(BaseOptions(baseUrl: baseUrl));
    _dio!.interceptors.add(AuthenticationInterceptor());
  }

  static Future<ResponseModel> getError(DioException e) async {
    String errorMessage = "An unknown error occurred.";
    dynamic errorBody;
    if (e.response != null) {
      final responseData = e.response?.data;
      final statusCode = e.response?.statusCode;
      errorBody = responseData;
      if (responseData is Map<String, dynamic>) {
        if (responseData.containsKey('message')) {
          errorMessage = responseData['message'].toString();
        } else if (responseData.containsKey('error')) {
          errorMessage = responseData['error'].toString();
        } else if (responseData.containsKey('errors') &&
            responseData['errors'] is List) {
          // If the error details are in a list under an 'errors' key (e.g., validation errors)
          List errorsList = responseData['errors'];
          if (errorsList.isNotEmpty) {
            // Try to get message from the first item in the list
            if (errorsList[0] is Map && errorsList[0].containsKey('message')) {
              errorMessage = errorsList[0]['message'].toString();
            } else {
              // Fallback if the list items are not maps with 'message'
              errorMessage = "Validation errors: ${errorsList.join(', ')}";
            }
          } else {
            errorMessage =
                "Server error (status: $statusCode). No specific errors found.";
          }
        } else {
          errorMessage =
              "Server error (status: $statusCode). No specific message found in JSON response.";
        }
      } else if (responseData is String) {
        try {
          final decodedData = jsonDecode(responseData);
          if (decodedData is Map<String, dynamic> &&
              decodedData.containsKey('message')) {
            errorMessage = decodedData['message'].toString();
          } else {
            errorMessage = responseData;
          }
        } catch (jsonError) {
          errorMessage = responseData;
        }
      } else if (responseData is List) {
        if (responseData.isNotEmpty) {
          if (responseData[0] is Map &&
              responseData[0].containsKey('message')) {
            errorMessage = responseData[0]['message'].toString();
          } else {
            errorMessage =
                "Server error (status: $statusCode). Response is a list: ${responseData.toString()}";
          }
        } else {
          errorMessage =
              "Server error (status: $statusCode). Empty response list.";
        }
      } else {
        errorMessage =
            "There was an error (status: ${statusCode ?? 'unknown'}). Unexpected response data type.";
      }

      if (errorMessage == "An unknown error occurred." ||
          errorMessage.isEmpty) {
        errorMessage =
            "Server responded with status: ${statusCode ?? 'unknown'}.";
      }

      return ResponseModel(
        response: errorMessage, // The extracted error message
        hasError: true,
        statusCode: statusCode,
        body: errorBody, // The full raw error response data
      );
    } else {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          return ResponseModel(
            response: 'Connection timed out',
            hasError: true,
            body: null,
            statusCode: -1,
          );
        case DioExceptionType.sendTimeout:
          return ResponseModel(
            response: 'Send timed out',
            hasError: true,
            body: null,
            statusCode: -2,
          );
        case DioExceptionType.receiveTimeout:
          return ResponseModel(
            response: 'Received timeout error',
            hasError: true,
            body: null,
          );
        case DioExceptionType.badCertificate:
          return ResponseModel(
            response: 'Error in validation of origin',
            hasError: true,
            body: null,
          );
        case DioExceptionType.connectionError:
          return ResponseModel(
            response: 'Error , There was no internet connection',
            statusCode: -100,
            hasError: true,
            body: null,
          );
        case DioExceptionType.cancel:
          return ResponseModel(
            response: 'Error the request was cancelled',
            hasError: true,
            body: null,
          );
        default:
          return ResponseModel(
            statusCode: -100,
            response: 'Unexpected Network Connection Error',
            hasError: true,
            body: null,
          );
      }
    }
  }
}
