class ResponseModel {
  final bool hasError;
  final int? statusCode;
  final String response;
  final dynamic body;

  ResponseModel({
    required this.hasError,
    this.statusCode,
    required this.response,
    this.body,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      hasError: json['hasError'] ?? true,
      statusCode: json['statusCode'],
      response: json['response'] ?? 'Unknown error',
      body: json['body'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hasError': hasError,
      'statusCode': statusCode,
      'response': response,
      'body': body,
    };
  }
}
