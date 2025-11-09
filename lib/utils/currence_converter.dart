import 'package:get_storage/get_storage.dart';
import 'package:mistpos/models/company_model.dart';
import 'package:mistpos/models/app_settings_model.dart';

class CurrenceConverter {
  static String getCurrenceInStrings(int amount) {
    return "\$${(amount / 100).toStringAsFixed(2)}";
  }

  static String getCurrenceFloatInStrings(double amount, String baseCurreny) {
    GetStorage storage = GetStorage();
    var jsonData = storage.read("company");
    final model = AppSettingsModel.fromStorage();

    if (jsonData == null) {
      return "\$${(amount).toStringAsFixed(model.decimalPlaces)}";
    }
    CompanyModel company = CompanyModel.fromJson(jsonData);
    final rate = company.exchangeRates.rates[baseCurreny];
    if (rate == null) {
      return "\$${(amount).toStringAsFixed(model.decimalPlaces)}";
    }
    amount = amount * rate;
    return "${baseCurreny.toUpperCase()}${(amount).toStringAsFixed(model.decimalPlaces)}";
  }

  static String getCurrenceFloatk(double amount, String baseCurreny) {
    if (amount < 1000) return getCurrenceFloatInStrings(amount, baseCurreny);
    if (amount > 900 && amount < 100000) {
      return "${getCurrenceFloatInStrings(amount / 1000, baseCurreny)}K";
    }
    if (amount > 100000 && amount < 100000000) {
      return "${getCurrenceFloatInStrings(amount / 1000000, baseCurreny)}M";
    }
    return "${getCurrenceFloatInStrings(amount / 1000000000, baseCurreny)}B";
  }

  static double prevailingAmount(double amount, String baseCurreny) {
    GetStorage storage = GetStorage();
    var jsonData = storage.read("company");
    if (jsonData == null) return amount;
    CompanyModel company = CompanyModel.fromJson(jsonData);
    final rate = company.exchangeRates.rates[baseCurreny] ?? 1.0;
    return amount * rate;
  }

  static double toBaseAmount(double amount, String baseCurreny) {
    GetStorage storage = GetStorage();
    var jsonData = storage.read("company");
    if (jsonData == null) return amount;
    CompanyModel company = CompanyModel.fromJson(jsonData);
    final rate = company.exchangeRates.rates[baseCurreny] ?? 1.0;
    return amount / rate;
  }
}
