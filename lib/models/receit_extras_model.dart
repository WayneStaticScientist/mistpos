class ReceitExtrasModel {
  // ignore: constant_identifier_names
  static const EXTRA_REPEATED = "repeat";
  // ignore: constant_identifier_names
  static const EXTRA_NORMAL = "normal";
  // ignore: constant_identifier_names
  static const EXTRA_SPACE = "space";
  // ignore: constant_identifier_names
  static const RECEIT_EXTRAS = [
    "normal",
    'normal-spaced',
    'comment',
    "repeat",
    "space",
  ];
  bool enabled;
  final String key;
  final String value;
  final String align;
  final bool isBold;
  final String type;

  ReceitExtrasModel({
    this.enabled = true,
    required this.key,
    required this.value,
    required this.align,
    required this.isBold,
    required this.type,
  });

  factory ReceitExtrasModel.fromJSON(dynamic data) {
    return ReceitExtrasModel(
      key: data['key'],
      enabled: data['enabled'] ?? true,
      value: data['value'],
      align: data['align'],
      isBold: data['isBold'],
      type: data['rtype'],
    );
  }
  Map toJson() {
    return {
      'enabled': enabled,
      "key": key,
      "value": value,
      "align": align,
      "isBold": isBold,
      "rtype": type,
    };
  }
}
