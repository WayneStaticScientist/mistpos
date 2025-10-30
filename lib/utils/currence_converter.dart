class CurrenceConverter {
  static String getCurrenceInStrings(int amount) {
    return "\$${(amount / 100).toStringAsFixed(2)}";
  }

  static String getCurrenceFloatInStrings(double amount) {
    return "\$${(amount).toStringAsFixed(2)}";
  }

  static String getCurrenceFloatk(double amount) {
    if (amount < 1000) return getCurrenceFloatInStrings(amount);
    if (amount > 900 && amount < 100000) {
      return "${getCurrenceFloatInStrings(amount / 1000)}K";
    }
    if (amount > 100000 && amount < 100000000) {
      return "${getCurrenceFloatInStrings(amount / 1000000)}M";
    }
    return "${getCurrenceFloatInStrings(amount / 1000000000)}B";
  }
}
