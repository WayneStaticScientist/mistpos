import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/core/utils/mist_esc_pos_builder.dart';
import 'package:mistpos/core/utils/offline_printer.dart';
import 'package:mistpos/core/utils/zimra_helper.dart';
import 'package:mistpos/data/models/app_settings_model.dart';
import 'package:mistpos/data/models/company_model.dart';
import 'package:mistpos/data/models/customer_model.dart';
import 'package:mistpos/data/models/item_receit_item.dart';
import 'package:mistpos/data/models/item_receit_model.dart';
import 'package:mistpos/data/models/tax_model.dart';
import 'package:mistpos/data/models/user_model.dart';
import 'package:mistpos/core/utils/zimra_receipt_type.dart';
import 'package:get/get.dart';
import 'package:mistpos/data/models/exchange_rate_model.dart';
import 'package:mistpos/data/models/subscripiton_model.dart';
import 'package:mistpos/features/inventory/controllers/inventory_controller.dart';
import '../models/receipt_template_v2_model.dart';

enum PreviewElementType { logo, text, qr, barcode, spacer }

class PreviewElement {
  final PreviewElementType type;
  final String text;
  final String? logoPath;
  final TextAlign align;
  final bool isBold;
  final int spacerLines;

  PreviewElement({
    required this.type,
    this.text = '',
    this.logoPath,
    this.align = TextAlign.left,
    this.isBold = false,
    this.spacerLines = 1,
  });
}

class RenderedReceiptPreview {
  final List<PreviewElement> elements;
  final int paperWidth;
  RenderedReceiptPreview({required this.elements, required this.paperWidth});
}

class ReceiptTemplateV2Engine {
  /// Generate realistic mock receipt data (sample standard fiscal thermal receipt)
  static ItemReceitModel getMockReceipt() {
    return ItemReceitModel(
      items: [
        ItemReceitItem()
          ..name = 'VINUT BASIL SEED KIWI'
          ..count = 12
          ..price = 1.50
          ..addenum = 0.0
          ..cost = 1.0
          ..itemId = 'm1'
          ..originalCount = 12,
        ItemReceitItem()
          ..name = 'RHODES tropical fruit'
          ..count = 6
          ..price = 0.50
          ..addenum = 0.0
          ..cost = 0.3
          ..itemId = 'm2'
          ..originalCount = 6,
        ItemReceitItem()
          ..name = 'MINUTE M/ORANGE DLIGHT 400ML'
          ..count = 3
          ..price = 1.00
          ..addenum = 0.0
          ..cost = 0.7
          ..itemId = 'm3'
          ..originalCount = 3,
        ItemReceitItem()
          ..name = 'DENDAIRY MAAS 1L'
          ..count = 1
          ..price = 2.00
          ..addenum = 0.0
          ..cost = 1.5
          ..itemId = 'm4'
          ..originalCount = 1,
        ItemReceitItem()
          ..name = 'AQUACLEAR 500ML'
          ..count = 4
          ..price = 0.25
          ..addenum = 0.0
          ..cost = 0.15
          ..itemId = 'm5'
          ..originalCount = 4,
      ],
      total: 27.00,
      amount: 27.00,
      hexId: '17291',
      change: 0.00,
      cashier: 'Cashier 1',
      payment: 'CASH',
      createdAt: DateTime(2026, 9, 23, 14, 50),
      tax: 15.50,
      taxAmount: 2.82,
      currency: 'USD',
      fiscalized: true,
      zimraDeviceId: 10452,
      zimraFiscalDayNo: 114,
      zimraReceiptGlobalNo: 17291,
      zimraSignature: 'A1B2C3D4E5F6G7H8',
      zimraQrCodeUrl: 'https://fdms.zimra.co.zw/verify/receipt/17291',
    );
  }

  static User getMockUser() {
    return User(
      till: 1,
      role: 'cashier',
      email: 'sales@mistpos.com',
      country: 'ZW',
      fullName: 'Blessing Moyo',
      company: 'comp_1',
      companyName: 'MistPOS Retail Enterprises',
      baseCurrence: 'USD',
      companies: ['comp_1'],
      subscriptions: [],
      permissions: ['sales', 'receipts'],
      receitsCount: 17291,
      pinnedInput: false,
    );
  }

  static CustomerModel getMockCustomer() {
    return CustomerModel(
      fullName: 'Cash Sales',
      phoneNumber: '+263770000000',
      email: 'customer@example.com',
      address: 'Harare, Zimbabwe',
      city: 'Harare',
      notes: '',
      points: 0,
      visits: 1,
      company: 'comp_1',
      country: 'ZW',
      purchaseValue: 27.0,
      inboundProfit: 0.0,
      hexId: 'cust_1',
    );
  }

  static CompanyModel getMockCompany() {
    try {
      if (Get.isRegistered<InventoryController>()) {
        final c = Get.find<InventoryController>().company.value;
        if (c != null) return c;
      }
      final storageCompany = CompanyModel.fromStorage();
      if (storageCompany != null) return storageCompany;
    } catch (_) {}

    return CompanyModel(
      owner: 'admin',
      email: 'info@mistpos.com',
      name: 'MistPOS Retail Enterprises',
      hexId: 'comp_mock_1',
      receitExtras: [],
      verified: true,
      showSalesCount: false,
      enableCreditSale: true,
      exchangeRates: ExchangeRateModel(name: 'USD', rates: {'USD': 1.0}),
      subscriptionType: SubscriptionModel(type: 'pro'),
      automatedSync: AutomatedSyncModel.empty(),
      weeklyAutomatedSync: AutomatedSyncModel.empty(),
      aiSubscriptions: AiSubscriptionsModel(tokens: 1000),
      resellerProps: ResellerPropsModel(
        percentage: 0.0,
        code: '',
        status: 'Not-a-Reseller',
        statusReason: '',
      ),
      zimraDeviceId: 10452,
      zimraDeviceSerialNo: 'MIST-DEV-10452',
      zimraIsTest: false,
      zimraQrUrl: 'https://fdms.zimra.co.zw/verify',
      zimraQrFiscilization: true,
      zimraFiscalDayNo: 114,
      zimraReceiptGlobalNo: 17291,
      zimraReceiptCounter: 154,
    );
  }

  /// Build tag replacement map
  static Map<String, String> buildVariableMap({
    required ItemReceitModel receipt,
    required User user,
    CustomerModel? customer,
    CompanyModel? company,
    List<TaxModel> salesTaxes = const [],
    List<String>? customWeekNames,
    List<String>? customMonthNames,
    int paperWidth = 42,
  }) {
    final currency = user.baseCurrence.isNotEmpty ? user.baseCurrence : '\$';
    final when = receipt.createdAt;

    // Week and Month name resolution
    final defaultWeeks = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final defaultMonths = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    final weekList = (customWeekNames != null && customWeekNames.length == 7)
        ? customWeekNames
        : defaultWeeks;
    final monthList = (customMonthNames != null && customMonthNames.length == 12)
        ? customMonthNames
        : defaultMonths;

    final weekName = weekList[(when.weekday - 1).clamp(0, 6)];
    final monthName = monthList[(when.month - 1).clamp(0, 11)];

    // Dates
    final dayStr = when.day.toString().padLeft(2, '0');
    final monthStr = when.month.toString().padLeft(2, '0');
    final yearStr = when.year.toString();
    final hourStr = when.hour.toString().padLeft(2, '0');
    final minStr = when.minute.toString().padLeft(2, '0');
    final secStr = when.second.toString().padLeft(2, '0');
    final formattedDate = '$dayStr-$monthStr-$yearStr';
    final formattedTime = '$hourStr:$minStr';

    // Numbers
    final totalItemsCount = receipt.items.fold<num>(0, (sum, i) => sum + i.count).toInt();
    final subtotalVal = (receipt.total - receipt.taxAmount).clamp(0.0, double.infinity);

    // ZIMRA / Fiscal
    final zimraCounter =
        '${receipt.zimraFiscalDayNo ?? ""}/${receipt.zimraReceiptGlobalNo ?? ""}';
    final verificationCode = receipt.zimraSignature != null &&
            receipt.zimraSignature!.isNotEmpty
        ? ZimraHelper.extractVerificationCode(receipt.zimraSignature!)
        : 'A1B2-C3D4';

    final qrUrl = receipt.zimraQrCodeUrl?.isNotEmpty == true
        ? receipt.zimraQrCodeUrl!
        : ZimraHelper.generateQrUrl(
            receipt,
            isTest: company?.zimraIsTest ?? false,
            qrUrlFromConfig: company?.zimraQrUrl,
          );

    return {
      // Legacy company tags (cleared so no hardcoded company details appear)
      '{company_name}': '',
      '{company_address}': '',
      '{company_phone}': '',
      '{company_email}': '',
      '{company_tin}': '',
      '{company_vat}': '',

      // Staff / Till
      '{cashier}': receipt.cashier.isNotEmpty ? receipt.cashier : user.fullName,
      '{seller}': user.fullName,
      '{role}': user.role,
      '{till}': user.till.toString(),
      '{pos_id}': user.till.toString(),
      '{device_id}': receipt.zimraDeviceId?.toString() ?? user.till.toString(),

      // Customer
      '{customer}': customer?.fullName.isNotEmpty == true ? customer!.fullName : 'Cash Sales',
      '{customer_name}': customer?.fullName.isNotEmpty == true ? customer!.fullName : 'Cash Sales',
      '{customer_phone}': customer?.phoneNumber.isNotEmpty == true ? customer!.phoneNumber : '',
      '{customer_email}': customer?.email.isNotEmpty == true ? customer!.email : '',
      '{customer_address}': customer?.address.isNotEmpty == true ? customer!.address : '',
      '{customer_tin}': '',
      '{customer_vat}': '',

      // Transaction / Receipt
      '{receipt_no}': receipt.hexId.isNotEmpty
          ? (receipt.hexId.length > 8 ? receipt.hexId.substring(0, 8) : receipt.hexId)
          : receipt.id.toString(),
      '{receipt_id}': receipt.hexId.isNotEmpty ? receipt.hexId : receipt.id.toString(),
      '{hex_id}': receipt.hexId,
      '{client_sale_id}': receipt.clientSaleId,
      '{receipt_label}': receipt.label,
      '{receipt_type}': receipt.receiptType,
      '{number_of_items}': totalItemsCount.toString(),

      // Financials
      '{currency}': currency,
      '{total}': CurrenceConverter.getCurrenceFloatInStrings(receipt.total, currency),
      '{subtotal}': CurrenceConverter.getCurrenceFloatInStrings(subtotalVal, currency),
      '{amount_charged}': CurrenceConverter.getCurrenceFloatInStrings(receipt.amount, currency),
      '{amount_paid}': CurrenceConverter.getCurrenceFloatInStrings(receipt.amount, currency),
      '{paid_amount}': CurrenceConverter.getCurrenceFloatInStrings(receipt.amount, currency),
      '{change}': CurrenceConverter.getCurrenceFloatInStrings(receipt.change, currency),
      '{tax_amount}': CurrenceConverter.getCurrenceFloatInStrings(receipt.taxAmount, currency),
      '{tax_rate}': receipt.tax > 0
          ? receipt.tax.toStringAsFixed(2)
          : (salesTaxes.isNotEmpty ? salesTaxes.first.value.toStringAsFixed(2) : '0.00'),
      '{vat_rate}': receipt.tax > 0
          ? receipt.tax.toStringAsFixed(2)
          : (salesTaxes.isNotEmpty ? salesTaxes.first.value.toStringAsFixed(2) : '0.00'),
      '{payment_method}': receipt.payment.toUpperCase(),
      '{payment}': receipt.payment.toUpperCase(),
      '{deposits}': CurrenceConverter.getCurrenceFloatInStrings(receipt.currentAmountPayed, currency),
      '{remaining_balance}': CurrenceConverter.getCurrenceFloatInStrings(
        (receipt.total - receipt.currentAmountPayed).clamp(0.0, double.infinity),
        currency,
      ),

      // Date / Time
      '{date_iso}': when.toIso8601String(),
      '{date_formatted}': formattedDate,
      '{time}': formattedTime,
      '{time_hour}': hourStr,
      '{time_minute}': minStr,
      '{time_second}': secStr,
      '{day}': dayStr,
      '{month}': monthStr,
      '{year}': yearStr,
      '{day_of_week}': when.weekday.toString(),
      '{week_name}': weekName,
      '{month_name}': monthName,

      // ZIMRA Fiscal (strictly blank if receipt is not fiscalized)
      '{zimra_header}': receipt.fiscalized ? ZimraReceiptDisplay.printHeader(receipt) : '',
      '{zimra_counter}': receipt.fiscalized ? zimraCounter : '',
      '{zimra_device_id}': receipt.fiscalized ? (receipt.zimraDeviceId?.toString() ?? '') : '',
      '{zimra_verification_code}': receipt.fiscalized ? verificationCode : '',
      '{zimra_manual_url}': receipt.fiscalized ? ZimraHelper.manualZimraUrl : '',
      '{zimra_url}': receipt.fiscalized ? qrUrl : '',

      // Column Header
      '{item_header}': getItemHeader(paperWidth),
    };
  }

  /// Get the standard 4-column header aligned to any custom paper character width
  static String getItemHeader(int paperWidth) {
    final qtyColWidth = paperWidth <= 32 ? 4 : (paperWidth >= 48 ? 7 : 6);
    final priceColWidth = paperWidth <= 32 ? 7 : (paperWidth >= 48 ? 10 : 9);
    final totalColWidth = paperWidth <= 32 ? 8 : (paperWidth >= 48 ? 10 : 9);
    final itemColWidth = (paperWidth - (qtyColWidth + priceColWidth + totalColWidth)).clamp(8, 80);

    final itemHeader = 'ITEM'.padRight(itemColWidth);
    final qtyHeader = 'QTY'.padLeft(qtyColWidth);
    final priceHeader = 'PRICE'.padLeft(priceColWidth);
    final totalHeader = 'TOTAL'.padLeft(totalColWidth);

    return '$itemHeader$qtyHeader$priceHeader$totalHeader';
  }

  /// Generate aligned 4-column item row with smart name wrapping:
  /// Line 1: ITEM_NAME (first N chars, padded) + QTY (right) + PRICE (right) + TOTAL (right)
  /// Line 2+: Remaining item name wrapped to next line(s)
  static String formatItemRow({
    required String name,
    required double count,
    required double unitPrice,
    required double totalPrice,
    required String currency,
    required int paperWidth,
  }) {
    final qtyColWidth = paperWidth <= 32 ? 4 : (paperWidth >= 48 ? 7 : 6);
    final priceColWidth = paperWidth <= 32 ? 7 : (paperWidth >= 48 ? 10 : 9);
    final totalColWidth = paperWidth <= 32 ? 8 : (paperWidth >= 48 ? 10 : 9);
    final itemColWidth = (paperWidth - (qtyColWidth + priceColWidth + totalColWidth)).clamp(8, 80);

    final qtyStr = count % 1 == 0 ? count.toInt().toString() : count.toString();
    final priceStr = CurrenceConverter.getCurrenceFloatInStrings(unitPrice, currency);
    final totalStr = CurrenceConverter.getCurrenceFloatInStrings(totalPrice, currency);

    final qtyPadded = qtyStr.length > qtyColWidth ? qtyStr : qtyStr.padLeft(qtyColWidth);
    final pricePadded = priceStr.length > priceColWidth ? priceStr : priceStr.padLeft(priceColWidth);
    final totalPadded = totalStr.length > totalColWidth ? totalStr : totalStr.padLeft(totalColWidth);

    final numbersPart = '$qtyPadded$pricePadded$totalPadded';

    // Normalize input name: clean multiple spaces and strip rogue mid-word dots ('..')
    // from legacy/mock data so dots never leak into wrapped lines
    var cleanName = name
        .replaceAll(RegExp(r'\.{2,}'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    if (cleanName.length <= itemColWidth) {
      return '${cleanName.padRight(itemColWidth)}$numbersPart';
    }

    // Name is longer than column width - determine line 1 and remaining
    String line1Name;
    String remainingName;

    final cutLen = itemColWidth - 2;

    if (cleanName.length > itemColWidth && cleanName[itemColWidth] == ' ') {
      // Natural word break right at column boundary
      line1Name = cleanName.substring(0, itemColWidth);
      remainingName = cleanName.substring(itemColWidth + 1).trim();
    } else if (cleanName.length > itemColWidth && cleanName[itemColWidth - 1] == ' ') {
      // Natural word break right before column boundary
      line1Name = cleanName.substring(0, itemColWidth - 1).padRight(itemColWidth);
      remainingName = cleanName.substring(itemColWidth).trim();
    } else if (cutLen > 0 && cleanName.length > cutLen && cleanName[cutLen] == ' ') {
      // Natural word break right at (itemColWidth - 2)
      line1Name = cleanName.substring(0, cutLen).padRight(itemColWidth);
      remainingName = cleanName.substring(cutLen + 1).trim();
    } else if (cutLen > 0 && cleanName.substring(0, cutLen).endsWith(' ')) {
      // Word ended right before (itemColWidth - 2)
      line1Name = cleanName.substring(0, cutLen).trimRight().padRight(itemColWidth);
      remainingName = cleanName.substring(cutLen).trimLeft();
    } else {
      // Word is cut mid-word: line 1 ends with '..' and line 2 cleanly starts with the remainder
      // e.g. 'sugarc..' on line 1, and 'ane' on line 2 (never 'a..ne' on line 2)
      final safeCutLen = cutLen.clamp(1, cleanName.length);
      line1Name = '${cleanName.substring(0, safeCutLen)}..';
      remainingName = cleanName.substring(safeCutLen).trimLeft();
    }

    final lines = <String>['$line1Name$numbersPart'];
    var currentRemainder = remainingName;
    while (currentRemainder.isNotEmpty) {
      if (currentRemainder.length <= itemColWidth) {
        lines.add(currentRemainder);
        break;
      } else {
        int nextBreak = itemColWidth;
        final space = currentRemainder.substring(0, itemColWidth).lastIndexOf(' ');
        if (space > itemColWidth ~/ 2) {
          nextBreak = space;
          lines.add(currentRemainder.substring(0, nextBreak).trimRight());
          currentRemainder = currentRemainder.substring(nextBreak).trimLeft();
        } else {
          lines.add(currentRemainder.substring(0, nextBreak));
          currentRemainder = currentRemainder.substring(nextBreak).trimLeft();
        }
      }
    }

    return lines.join('\n');
  }

  /// Process item list loop `{list} ... {/list}`
  static String processItemListLoop({
    required String templateContent,
    required ItemReceitModel receipt,
    required String currency,
    required int paperWidth,
  }) {
    final listRegex = RegExp(r'\{list\}([\s\S]*?)\{/list\}', caseSensitive: false);

    return templateContent.replaceAllMapped(listRegex, (match) {
      final itemTemplate = match.group(1) ?? '';
      final buffer = StringBuffer();

      final hasItemRowTag = itemTemplate.contains('{item_row}');
      final isOldSpacedPreset = itemTemplate.contains('{itemname}') &&
          (itemTemplate.contains('{itemcount}') || itemTemplate.contains('{qty}')) &&
          (itemTemplate.contains('{itemprice}') || itemTemplate.contains('{price}')) &&
          (itemTemplate.contains('{itemtotal}') || itemTemplate.contains('{total}'));

      for (int i = 0; i < receipt.items.length; i++) {
        final item = receipt.items[i];
        final unitPrice = item.price + item.addenum;
        final totalItemPrice = unitPrice * item.count;

        if (hasItemRowTag) {
          final formatted = formatItemRow(
            name: item.name,
            count: item.count,
            unitPrice: unitPrice,
            totalPrice: totalItemPrice,
            currency: currency,
            paperWidth: paperWidth,
          );
          buffer.write(itemTemplate.replaceAll('{item_row}', formatted).trimRight());
        } else if (isOldSpacedPreset && itemTemplate.contains('\n')) {
          // Automatically upgrade old multiline spaced preset to clean 4-column layout
          final formatted = formatItemRow(
            name: item.name,
            count: item.count,
            unitPrice: unitPrice,
            totalPrice: totalItemPrice,
            currency: currency,
            paperWidth: paperWidth,
          );
          buffer.write(formatted);
        } else {
          final itemMap = {
            '{itemname}': item.name,
            '{item_name}': item.name,
            '{itemcount}': item.count % 1 == 0 ? item.count.toInt().toString() : item.count.toString(),
            '{item_qty}': item.count % 1 == 0 ? item.count.toInt().toString() : item.count.toString(),
            '{qty}': item.count % 1 == 0 ? item.count.toInt().toString() : item.count.toString(),
            '{itemprice}': CurrenceConverter.getCurrenceFloatInStrings(unitPrice, currency),
            '{item_unit_price}': CurrenceConverter.getCurrenceFloatInStrings(unitPrice, currency),
            '{price}': CurrenceConverter.getCurrenceFloatInStrings(unitPrice, currency),
            '{itemtotal}': CurrenceConverter.getCurrenceFloatInStrings(totalItemPrice, currency),
            '{item_total}': CurrenceConverter.getCurrenceFloatInStrings(totalItemPrice, currency),
            '{itemcode}': item.itemId,
            '{itembarcode}': item.itemId,
            '{itemdiscount}': item.discount > 0
                ? (item.percentageDiscount
                    ? '${item.discount}%'
                    : CurrenceConverter.getCurrenceFloatInStrings(item.discount, currency))
                : '',
            '{itemrefund}': item.refunded ? 'refund: ${item.originalCount}->${item.count}' : '',
          };

          var rowText = itemTemplate;
          itemMap.forEach((k, v) {
            rowText = rowText.replaceAll(k, v);
          });

          buffer.write(rowText.trimRight());
        }

        if (i < receipt.items.length - 1) {
          buffer.write('\n');
        }
      }

      return buffer.toString();
    });
  }

  /// Render the template into a list of preview elements for Flutter UI
  static RenderedReceiptPreview renderForPreview({
    required ReceiptTemplateV2Model template,
    ItemReceitModel? receipt,
    User? user,
    CustomerModel? customer,
    CompanyModel? company,
    List<TaxModel> salesTaxes = const [],
    AppSettingsModel? appSettings,
  }) {
    final effectiveReceipt = receipt ?? getMockReceipt();
    final effectiveUser = user ?? getMockUser();
    final effectiveCustomer = customer ?? getMockCustomer();
    final effectiveCompany = company ?? getMockCompany();

    final varMap = buildVariableMap(
      receipt: effectiveReceipt,
      user: effectiveUser,
      customer: effectiveCustomer,
      company: effectiveCompany,
      salesTaxes: salesTaxes,
      customWeekNames: template.customWeekNames,
      customMonthNames: template.customMonthNames,
      paperWidth: template.paperWidth,
    );

    // 1. Process List Loop (strip any legacy company details first)
    var processed = processItemListLoop(
      templateContent: ReceiptTemplateV2Model.stripCompanyDetails(template.templateContent),
      receipt: effectiveReceipt,
      currency: effectiveUser.baseCurrence,
      paperWidth: template.paperWidth,
    );

    // Pre-normalize header if it was using older spaced headers
    processed = processed.replaceAll(
      RegExp(r'ITEM\s+QTY\s+(?:UNIT\s+)?PRICE\s+TOTAL', caseSensitive: false),
      getItemHeader(template.paperWidth),
    );

    // 2. Replace all basic tags
    varMap.forEach((k, v) {
      processed = processed.replaceAll(k, v);
    });

    final isFiscalized = effectiveReceipt.fiscalized;
    final hasTax = effectiveReceipt.tax > 0 ||
        effectiveReceipt.taxAmount > 0 ||
        (salesTaxes.isNotEmpty && salesTaxes.any((t) => t.value > 0));

    final lines = processed.split('\n');
    final elements = <PreviewElement>[];

    for (var rawLine in lines) {
      var line = rawLine;

      // When receipt is not fiscalized, suppress all ZIMRA QR & fiscal codes
      if (!isFiscalized) {
        if (line.contains('{zimra_qr}') ||
            line.contains('{zimra_verification_code}') ||
            line.contains('{zimra_counter}') ||
            line.contains('{zimra_device_id}') ||
            line.contains('{zimra_manual_url}') ||
            line.contains('{zimra_header}') ||
            line.contains('Verification code:') ||
            line.contains('Verification code') ||
            line.contains('verify this receipt manually') ||
            line.contains('fdms.zimra.co.zw')) {
          continue;
        }
        line = line.replaceAll('FISCAL RECEIPT', 'RECEIPT');
      }

      // When receipt has no tax, suppress tax / VAT lines completely
      if (!hasTax) {
        final lower = line.toLowerCase();
        if (lower.contains('vat (standard)') ||
            lower.contains('sales tax') ||
            (lower.contains('tax:') && !lower.contains('tin:')) ||
            line.contains('{vat_rate}') ||
            line.contains('{tax_rate}') ||
            line.contains('{tax_amount}')) {
          continue;
        }
      }

      // Suppress empty optional customer/company lines like "Phone: ", "Email: ", "N/A"
      final cleanTrimmed = line
          .replaceAll(RegExp(r'\{align:(?:left|center|right)\}', caseSensitive: false), '')
          .replaceAll(RegExp(r'\{/?bold\}', caseSensitive: false), '')
          .trim();
      if (cleanTrimmed == 'Phone:' ||
          cleanTrimmed == 'Tel:' ||
          cleanTrimmed == 'Email:' ||
          cleanTrimmed == 'TIN:' ||
          cleanTrimmed == 'VAT:' ||
          cleanTrimmed == 'N/A' ||
          cleanTrimmed == 'Phone: N/A' ||
          cleanTrimmed == 'Email: N/A' ||
          cleanTrimmed == '***  ***' ||
          ReceiptTemplateV2Model.isCompanyLine(line)) {
        continue;
      }

      // Check feed/spacer
      final feedMatch = RegExp(r'\{feed:(\d+)\}').firstMatch(line);
      if (feedMatch != null) {
        final count = int.tryParse(feedMatch.group(1) ?? '1') ?? 1;
        elements.add(PreviewElement(type: PreviewElementType.spacer, spacerLines: count));
        continue;
      }

      // Check Logo block
      if (line.contains('{logo}')) {
        final settings = appSettings ?? AppSettingsModel.fromStorage();
        TextAlign logoAlign = TextAlign.center;
        if (line.contains('{align:left}')) logoAlign = TextAlign.left;
        if (line.contains('{align:right}')) logoAlign = TextAlign.right;
        elements.add(
          PreviewElement(
            type: PreviewElementType.logo,
            logoPath: settings.receitLogoPath,
            align: logoAlign,
          ),
        );
        continue;
      }

      // Check ZIMRA QR
      if (line.contains('{zimra_qr}')) {
        if (!isFiscalized) continue;
        TextAlign qrAlign = TextAlign.center;
        if (line.contains('{align:left}')) qrAlign = TextAlign.left;
        if (line.contains('{align:right}')) qrAlign = TextAlign.right;
        elements.add(
          PreviewElement(
            type: PreviewElementType.qr,
            text: varMap['{zimra_url}']?.isNotEmpty == true
                ? varMap['{zimra_url}']!
                : 'https://fdms.zimra.co.zw',
            align: qrAlign,
          ),
        );
        continue;
      }

      // Check custom QR Code
      final qrMatch = RegExp(r'\{qrcode(?::([^}]+))?\}').firstMatch(line);
      if (qrMatch != null) {
        final qrData = qrMatch.group(1)?.trim();
        final finalData = (qrData != null && qrData.isNotEmpty)
            ? qrData
            : (varMap['{zimra_url}']?.isNotEmpty == true
                ? varMap['{zimra_url}']!
                : (effectiveReceipt.hexId.isNotEmpty ? effectiveReceipt.hexId : '17291'));
        TextAlign qrAlign = TextAlign.center;
        if (line.contains('{align:left}')) qrAlign = TextAlign.left;
        if (line.contains('{align:right}')) qrAlign = TextAlign.right;
        elements.add(
          PreviewElement(
            type: PreviewElementType.qr,
            text: finalData,
            align: qrAlign,
          ),
        );
        continue;
      }

      // Check barcode
      final barcodeMatch = RegExp(r'\{barcode(?::([^}]+))?\}').firstMatch(line);
      if (barcodeMatch != null) {
        final bData = barcodeMatch.group(1)?.trim();
        final finalCode = (bData != null && bData.isNotEmpty)
            ? bData
            : (effectiveReceipt.hexId.isNotEmpty ? effectiveReceipt.hexId : '17291');
        TextAlign barAlign = TextAlign.center;
        if (line.contains('{align:left}')) barAlign = TextAlign.left;
        if (line.contains('{align:right}')) barAlign = TextAlign.right;
        elements.add(
          PreviewElement(
            type: PreviewElementType.barcode,
            text: finalCode,
            align: barAlign,
          ),
        );
        continue;
      }

      // Check Lines / Dividers
      final lineMatch = RegExp(r'\{line(?::([^}]+))?\}').firstMatch(line);
      if (lineMatch != null) {
        final arg = lineMatch.group(1)?.trim() ?? '-';
        String char = '-';
        int length = template.paperWidth;

        if (arg == 'half') {
          length = (template.paperWidth / 2).toInt();
        } else if (arg.length == 1) {
          char = arg;
        } else if (int.tryParse(arg) != null) {
          length = int.parse(arg);
        }

        elements.add(
          PreviewElement(
            type: PreviewElementType.text,
            text: char * length,
            align: TextAlign.center,
          ),
        );
        continue;
      }

      // Check repeat
      final repeatMatch = RegExp(r'\{repeat:([^} ]+)(?: +(\d+|half|full))?\}').firstMatch(line);
      if (repeatMatch != null) {
        final char = repeatMatch.group(1) ?? '-';
        final lenArg = repeatMatch.group(2) ?? 'full';
        int length = template.paperWidth;
        if (lenArg == 'half') {
          length = (template.paperWidth / 2).toInt();
        } else if (int.tryParse(lenArg) != null) {
          length = int.parse(lenArg);
        }

        elements.add(
          PreviewElement(
            type: PreviewElementType.text,
            text: char * length,
            align: TextAlign.center,
          ),
        );
        continue;
      }

      // Check Alignment & Bold modifiers
      TextAlign align = TextAlign.left;
      if (line.contains('{align:center}')) {
        align = TextAlign.center;
        line = line.replaceAll('{align:center}', '');
      } else if (line.contains('{align:right}')) {
        align = TextAlign.right;
        line = line.replaceAll('{align:right}', '');
      } else if (line.contains('{align:left}')) {
        align = TextAlign.left;
        line = line.replaceAll('{align:left}', '');
      }

      bool isBold = false;
      if (line.contains('{bold}')) {
        isBold = true;
        line = line.replaceAll('{bold}', '').replaceAll('{/bold}', '');
      }

      elements.add(
        PreviewElement(
          type: PreviewElementType.text,
          text: line,
          align: align,
          isBold: isBold,
        ),
      );
    }

    return RenderedReceiptPreview(elements: elements, paperWidth: template.paperWidth);
  }

  /// Execute printing via EscPosBuilder for thermal receipt printer
  static void printToEscPosBuilder({
    required EscPosBuilder b,
    required ReceiptTemplateV2Model template,
    required ItemReceitModel itemReceitModel,
    required User user,
    CustomerModel? customer,
    CompanyModel? company,
    List<TaxModel> salesTaxes = const [],
    AppSettingsModel? appSettings,
  }) {
    b.init();

    final varMap = buildVariableMap(
      receipt: itemReceitModel,
      user: user,
      customer: customer,
      company: company,
      salesTaxes: salesTaxes,
      customWeekNames: template.customWeekNames,
      customMonthNames: template.customMonthNames,
      paperWidth: template.paperWidth,
    );

    // 1. Process list loop (strip any legacy company details first)
    var processed = processItemListLoop(
      templateContent: ReceiptTemplateV2Model.stripCompanyDetails(template.templateContent),
      receipt: itemReceitModel,
      currency: user.baseCurrence,
      paperWidth: template.paperWidth,
    );

    // Pre-normalize header if it was using older spaced headers
    processed = processed.replaceAll(
      RegExp(r'ITEM\s+QTY\s+(?:UNIT\s+)?PRICE\s+TOTAL', caseSensitive: false),
      getItemHeader(template.paperWidth),
    );

    // 2. Replace tags
    varMap.forEach((k, v) {
      processed = processed.replaceAll(k, v);
    });

    final isFiscalized = itemReceitModel.fiscalized;
    final hasTax = itemReceitModel.tax > 0 ||
        itemReceitModel.taxAmount > 0 ||
        (salesTaxes.isNotEmpty && salesTaxes.any((t) => t.value > 0));

    final lines = processed.split('\n');

    for (var rawLine in lines) {
      var line = rawLine;

      // When receipt is not fiscalized, suppress all ZIMRA QR & fiscal codes
      if (!isFiscalized) {
        if (line.contains('{zimra_qr}') ||
            line.contains('{zimra_verification_code}') ||
            line.contains('{zimra_counter}') ||
            line.contains('{zimra_device_id}') ||
            line.contains('{zimra_manual_url}') ||
            line.contains('{zimra_header}') ||
            line.contains('Verification code:') ||
            line.contains('Verification code') ||
            line.contains('verify this receipt manually') ||
            line.contains('fdms.zimra.co.zw')) {
          continue;
        }
        line = line.replaceAll('FISCAL RECEIPT', 'RECEIPT');
      }

      // When receipt has no tax, suppress tax / VAT lines completely
      if (!hasTax) {
        final lower = line.toLowerCase();
        if (lower.contains('vat (standard)') ||
            lower.contains('sales tax') ||
            (lower.contains('tax:') && !lower.contains('tin:')) ||
            line.contains('{vat_rate}') ||
            line.contains('{tax_rate}') ||
            line.contains('{tax_amount}')) {
          continue;
        }
      }

      // Suppress empty optional customer/company lines
      final cleanTrimmed = line
          .replaceAll(RegExp(r'\{align:(?:left|center|right)\}', caseSensitive: false), '')
          .replaceAll(RegExp(r'\{/?bold\}', caseSensitive: false), '')
          .trim();
      if (cleanTrimmed == 'Phone:' ||
          cleanTrimmed == 'Tel:' ||
          cleanTrimmed == 'Email:' ||
          cleanTrimmed == 'TIN:' ||
          cleanTrimmed == 'VAT:' ||
          cleanTrimmed == 'N/A' ||
          cleanTrimmed == 'Phone: N/A' ||
          cleanTrimmed == 'Email: N/A' ||
          cleanTrimmed == '***  ***' ||
          ReceiptTemplateV2Model.isCompanyLine(line)) {
        continue;
      }

      // Feed / spacer
      final feedMatch = RegExp(r'\{feed:(\d+)\}').firstMatch(line);
      if (feedMatch != null) {
        final count = int.tryParse(feedMatch.group(1) ?? '1') ?? 1;
        b.feed(count);
        continue;
      }

      // Logo printing via thermal raster
      if (line.contains('{logo}')) {
        final settings = appSettings ?? AppSettingsModel.fromStorage();
        if (settings.receitLogoPath.isNotEmpty && File(settings.receitLogoPath).existsSync()) {
          final rasterImage = OfflinePrinter.getRasterImage(settings.receitLogoPath);
          if (rasterImage != null) {
            PosAlign logoAlign = PosAlign.center;
            if (line.contains('{align:left}')) logoAlign = PosAlign.left;
            if (line.contains('{align:right}')) logoAlign = PosAlign.right;
            b.setAlign(logoAlign);
            b.feed(1);
            b.raster(rasterImage);
            b.feed(1);
            b.setAlign(PosAlign.left);
          }
        }
        continue;
      }

      // ZIMRA QR
      if (line.contains('{zimra_qr}')) {
        if (!isFiscalized) continue;
        final qrUrl = varMap['{zimra_url}']?.isNotEmpty == true
            ? varMap['{zimra_url}']!
            : 'https://fdms.zimra.co.zw';
        PosAlign qrAlign = PosAlign.center;
        if (line.contains('{align:left}')) qrAlign = PosAlign.left;
        if (line.contains('{align:right}')) qrAlign = PosAlign.right;
        b.feed(1);
        b.qrCode(qrUrl, align: qrAlign);
        b.feed(1);
        continue;
      }

      // Generic QR Code
      final qrMatch = RegExp(r'\{qrcode(?::([^}]+))?\}').firstMatch(line);
      if (qrMatch != null) {
        final qrData = qrMatch.group(1)?.trim();
        final finalData = (qrData != null && qrData.isNotEmpty)
            ? qrData
            : (varMap['{zimra_url}']?.isNotEmpty == true
                ? varMap['{zimra_url}']!
                : (itemReceitModel.hexId.isNotEmpty ? itemReceitModel.hexId : '17291'));
        PosAlign qrAlign = PosAlign.center;
        if (line.contains('{align:left}')) qrAlign = PosAlign.left;
        if (line.contains('{align:right}')) qrAlign = PosAlign.right;
        b.feed(1);
        b.qrCode(finalData, align: qrAlign);
        b.feed(1);
        continue;
      }

      // Barcode
      final barcodeMatch = RegExp(r'\{barcode(?::([^}]+))?\}').firstMatch(line);
      if (barcodeMatch != null) {
        final bData = barcodeMatch.group(1)?.trim();
        final finalCode = (bData != null && bData.isNotEmpty)
            ? bData
            : (itemReceitModel.hexId.isNotEmpty ? itemReceitModel.hexId : '17291');
        PosAlign barAlign = PosAlign.center;
        if (line.contains('{align:left}')) barAlign = PosAlign.left;
        if (line.contains('{align:right}')) barAlign = PosAlign.right;
        b.feed(1);
        b.barcode(finalCode, align: barAlign);
        b.feed(1);
        continue;
      }

      // Line divider
      final lineMatch = RegExp(r'\{line(?::([^}]+))?\}').firstMatch(line);
      if (lineMatch != null) {
        final arg = lineMatch.group(1)?.trim() ?? '-';
        String char = '-';
        int length = template.paperWidth;

        if (arg == 'half') {
          length = (template.paperWidth / 2).toInt();
        } else if (arg.length == 1) {
          char = arg;
        } else if (int.tryParse(arg) != null) {
          length = int.parse(arg);
        }

        b.text(char * length, align: PosAlign.center);
        continue;
      }

      // Repeat character
      final repeatMatch = RegExp(r'\{repeat:([^} ]+)(?: +(\d+|half|full))?\}').firstMatch(line);
      if (repeatMatch != null) {
        final char = repeatMatch.group(1) ?? '-';
        final lenArg = repeatMatch.group(2) ?? 'full';
        int length = template.paperWidth;
        if (lenArg == 'half') {
          length = (template.paperWidth / 2).toInt();
        } else if (int.tryParse(lenArg) != null) {
          length = int.parse(lenArg);
        }

        b.text(char * length, align: PosAlign.center);
        continue;
      }

      // Text Alignment & Bold modifiers
      PosAlign align = PosAlign.left;
      if (line.contains('{align:center}')) {
        align = PosAlign.center;
        line = line.replaceAll('{align:center}', '');
      } else if (line.contains('{align:right}')) {
        align = PosAlign.right;
        line = line.replaceAll('{align:right}', '');
      } else if (line.contains('{align:left}')) {
        align = PosAlign.left;
        line = line.replaceAll('{align:left}', '');
      }

      bool isBold = false;
      if (line.contains('{bold}')) {
        isBold = true;
        line = line.replaceAll('{bold}', '').replaceAll('{/bold}', '');
      }

      b.text(line, align: align, bold: isBold);
    }

    b.cut();
  }
}
