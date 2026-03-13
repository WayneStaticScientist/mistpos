class ReceitExtrasModel {
  // ignore: constant_identifier_names
  static const EXTRA_REPEATED = "repeat";
  // ignore: constant_identifier_names
  static const EXTRA_NORMAL = "normal";
  // ignore: constant_identifier_names
  static const EXTRA_SPACE = "space";
  // ignore: constant_identifier_names
  static const RECEIT_EXTRAS = ["normal", "repeat", "space"];
  final String key;
  final String value;
  final String align;
  final bool isBold;
  final String type;

  ReceitExtrasModel({
    required this.key,
    required this.value,
    required this.align,
    required this.isBold,
    required this.type,
  });

  factory ReceitExtrasModel.fromJSON(dynamic data) {
    return ReceitExtrasModel(
      key: data['key'],
      value: data['value'],
      align: data['align'],
      isBold: data['isBold'],
      type: data['type'],
    );
  }
  Map toJson() {
    return {
      "key": key,
      "value": value,
      "align": align,
      "isBold": isBold,
      "type": type,
    };
  }
}
