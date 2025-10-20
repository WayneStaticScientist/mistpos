class CurrenceConverter {
  static String getCurrenceInStrings(int amount) {
    return "\$${(amount / 100).toStringAsFixed(2)}";
  }

  static String getCurrenceFloatInStrings(double amount) {
    return "\$${(amount).toStringAsFixed(2)}";
  }
}
