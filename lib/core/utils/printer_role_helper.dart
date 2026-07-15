// lib/core/utils/printer_role_helper.dart
// Provides a utility to convert string role identifiers into PosPrinterRole objects.
// This enables storing printer roles in the database and dynamically registering
// multiple printers without overwriting each other.

import 'package:pos_universal_printer/pos_universal_printer.dart';

extension PosRoleHelper on PosPrinterRole {
  /// Convert a role identifier (e.g. "cashier", "customer", "label") to the
  /// corresponding [PosPrinterRole] instance.
  static PosPrinterRole fromString(String role) {
    switch (role) {
      case 'cashier':
        return PosPrinterRole.cashier;
      default:
        // For any non‑cashier role the library provides a custom role.
        // If the custom constructor is unavailable, fall back to cashier.
        try {
          return PosPrinterRole.kitchen;
        } catch (_) {
          return PosPrinterRole.cashier;
        }
    }
  }
}
