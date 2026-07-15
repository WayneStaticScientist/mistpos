import 'package:get_storage/get_storage.dart';
import 'package:mistpos/data/models/company_model.dart';
import 'package:mistpos/data/models/app_settings_model.dart';
import 'package:mistpos/data/models/user_model.dart';

class CurrenceConverter {
  static String getCurrenceInStrings(int amount) {
    try {
      return "\$${(amount / 100).toStringAsFixed(2)}";
    } catch (_) {
      return "\$0.00";
    }
  }

  static String getCurrenceFloatInStrings(double amount, String baseCurreny) {
    try {
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
      double calculatedAmount = amount * rate;
      return "${baseCurreny.toUpperCase()}${(calculatedAmount).toStringAsFixed(model.decimalPlaces)}";
    } catch (e) {
      print("Error in getCurrenceFloatInStrings: $e");
      return "\$${amount.toStringAsFixed(2)}";
    }
  }

  static String getCurrenceFloatk(double amount, String baseCurreny) {
    try {
      if (amount < 1000) return getCurrenceFloatInStrings(amount, baseCurreny);
      if (amount > 900 && amount < 100000) {
        return "${getCurrenceFloatInStrings(amount / 1000, baseCurreny)}K";
      }
      if (amount > 100000 && amount < 100000000) {
        return "${getCurrenceFloatInStrings(amount / 1000000, baseCurreny)}M";
      }
      return "${getCurrenceFloatInStrings(amount / 1000000000, baseCurreny)}B";
    } catch (e) {
      print("Error in getCurrenceFloatk: $e");
      return "\$${amount.toStringAsFixed(2)}";
    }
  }

  static double prevailingAmount(double amount, String? baseCurreny) {
    try {
      GetStorage storage = GetStorage();
      final user = User.fromStorage();
      baseCurreny ??= user?.baseCurrence ?? "";
      var jsonData = storage.read("company");
      if (jsonData == null) return amount;
      CompanyModel company = CompanyModel.fromJson(jsonData);
      final rate = company.exchangeRates.rates[baseCurreny] ?? 1.0;
      return amount * rate;
    } catch (e) {
      print("Error in prevailingAmount: $e");
      return amount;
    }
  }

  static double toBaseAmount(double amount, String baseCurreny) {
    try {
      GetStorage storage = GetStorage();
      var jsonData = storage.read("company");
      if (jsonData == null) return amount;
      CompanyModel company = CompanyModel.fromJson(jsonData);
      final rate = company.exchangeRates.rates[baseCurreny] ?? 1.0;
      return amount / rate;
    } catch (e) {
      print("Error in toBaseAmount: $e");
      return amount;
    }
  }

  static String selectedCurrencyInString(double amount) {
    try {
      GetStorage storage = GetStorage();
      final user = User.fromStorage();
      final model = AppSettingsModel.fromStorage();
      final baseCurreny = user?.baseCurrence ?? "";
      var jsonData = storage.read("company");
      if (jsonData == null) {
        return "\$${(amount).toStringAsFixed(model.decimalPlaces)}";
      }
      CompanyModel company = CompanyModel.fromJson(jsonData);
      final rate = company.exchangeRates.rates[baseCurreny] ?? 1.0;
      return "${baseCurreny.toUpperCase()}${(amount * rate).toStringAsFixed(model.decimalPlaces)}";
    } catch (e) {
      print("Error in selectedCurrencyInString: $e");
      return "\$${amount.toStringAsFixed(2)}";
    }
  }

  static double selectedCurrency(double amount) {
    try {
      GetStorage storage = GetStorage();
      final user = User.fromStorage();
      final baseCurreny = user?.baseCurrence ?? "";
      var jsonData = storage.read("company");
      if (jsonData == null) return amount;
      CompanyModel company = CompanyModel.fromJson(jsonData);
      final rate = company.exchangeRates.rates[baseCurreny] ?? 1.0;
      return amount * rate;
    } catch (e) {
      print("Error in selectedCurrency: $e");
      return amount;
    }
  }

  static double baseCurrency(double amount) {
    try {
      GetStorage storage = GetStorage();
      final user = User.fromStorage();
      final baseCurreny = user?.baseCurrence ?? "";
      var jsonData = storage.read("company");
      if (jsonData == null) return amount;
      CompanyModel company = CompanyModel.fromJson(jsonData);
      final rate = company.exchangeRates.rates[baseCurreny] ?? 1.0;
      return amount / rate;
    } catch (e) {
      print("Error in baseCurrency: $e");
      return amount;
    }
  }
}
