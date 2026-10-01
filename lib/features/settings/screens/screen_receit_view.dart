import 'package:get/get.dart';
import 'package:mistpos/core/services/api/network_wrapper.dart';
import 'package:mistpos/data/models/customer_model.dart';
import 'package:mistpos/data/models/company_model.dart';
import 'package:mistpos/features/inventory/controllers/items_controller.dart';
import 'package:mistpos/features/inventory/controllers/inventory_controller.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/features/settings/screens/screen_credit_payment.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:printing/printing.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:mistpos/data/models/tax_model.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/core/responsive/screen_sizes.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/data/models/item_receit_model.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:mistpos/features/admin/controllers/admin_controller.dart';
import 'package:mistpos/core/utils/pdfdocuments/pdf_receit.dart';
import 'package:mistpos/features/devices/controllers/devices_controller.dart';
import 'package:mistpos/features/settings/screens/screen_refund_cart.dart';
import 'package:mistpos/core/utils/zimra_helper.dart';
import 'package:mistpos/core/utils/zimra_receipt_type.dart';
import 'package:isar_plus/isar_plus.dart';
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/main.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ScreenReceitView extends StatefulWidget {
  final ItemReceitModel receitModel;
  const ScreenReceitView({super.key, required this.receitModel});
  @override
  State<ScreenReceitView> createState() => _ScreenReceitViewState();
}

class _ScreenReceitViewState extends State<ScreenReceitView> {
  final _userController = Get.find<UserController>();

  CustomerModel? _customer;
  CompanyModel? _company;
  bool _isLoadingCustomer = false;
  bool _isFiscalizing = false;
  bool _isLoadingOriginal = false;

  @override
  void initState() {
    super.initState();
    _fetchCustomer();
    _refreshCompanyFromServer();
    if (widget.receitModel.hexId.isNotEmpty) {
      _hydrateReceiptFromServer();
      if (!widget.receitModel.fiscalized) {
        _pollUntilFiscalized();
      }
    }
  }

  String? get _zimraQrUrlFromCompany =>
      _effectiveCompany?.zimraQrUrl ??
      Get.find<InventoryController>().company.value?.zimraQrUrl;

  Future<void> _pollUntilFiscalized() async {
    for (var i = 0; i < 30; i++) {
      if (!mounted || widget.receitModel.fiscalized) return;
      await Future<void>.delayed(const Duration(seconds: 2));
      await _hydrateReceiptFromServer();
    }
  }

  Future<void> _hydrateReceiptFromServer() async {
    final id = widget.receitModel.hexId.trim();
    if (id.isEmpty) return;
    final response = await Net.get("/cashier/receit/$id");
    if (!mounted || response.hasError) return;
    final raw = response.body?['receipt'];
    if (raw is! Map) return;
    final fresh = ItemReceitModel.fromJson(Map<String, dynamic>.from(raw));
    setState(() {
      widget.receitModel.receiptType = fresh.receiptType;
      widget.receitModel.originalReceiptId = fresh.originalReceiptId;
      widget.receitModel.fiscalized = fresh.fiscalized;
      widget.receitModel.zimraReceiptId = fresh.zimraReceiptId;
      widget.receitModel.zimraSignature = fresh.zimraSignature;
      widget.receitModel.zimraDeviceId = fresh.zimraDeviceId;
      widget.receitModel.zimraReceiptGlobalNo = fresh.zimraReceiptGlobalNo;
      widget.receitModel.zimraFiscalDayNo = fresh.zimraFiscalDayNo;
      widget.receitModel.zimraReceiptDateQr = fresh.zimraReceiptDateQr;
      widget.receitModel.zimraQrCodeUrl = fresh.zimraQrCodeUrl;
    });
  }

  String? _parentInvoiceLabelFromAdjustment() {
    final label = widget.receitModel.label.trim();
    if (label.startsWith('CN-') || label.startsWith('DN-')) {
      return label.substring(3);
    }
    return null;
  }

  Future<ItemReceitModel?> _fetchReceiptByLabel(String label) async {
    final response = await Net.get(
      "/cashier/receit/by-label?label=${Uri.encodeComponent(label)}",
    );
    if (response.hasError || response.body?['receipt'] is! Map) {
      return null;
    }
    return ItemReceitModel.fromJson(
      Map<String, dynamic>.from(response.body['receipt'] as Map),
    );
  }

  CompanyModel? get _effectiveCompany {
    if (_company != null) return _company;
    if (Get.isRegistered<InventoryController>()) {
      return Get.find<InventoryController>().company.value;
    }
    return CompanyModel.fromStorage();
  }

  bool _isZimraDeviceRegistered(CompanyModel? company) {
    if (company == null) return false;
    final cert = company.zimraCertificate;
    return (cert != null && cert.isNotEmpty) || company.zimraDeviceId != null;
  }

  Future<void> _refreshCompanyFromServer() async {
    try {
      final inv = Get.find<InventoryController>();
      await inv.loadCompany();
      if (mounted) {
        setState(() {
          _company = inv.company.value;
        });
      }
    } catch (_) {
      try {
        _company = Get.find<InventoryController>().company.value;
      } catch (_) {}
    }
  }

  Future<void> _fetchCustomer() async {
    if (widget.receitModel.customerId == null) return;

    if (Get.isRegistered<ItemsController>()) {
      try {
        _customer = Get.find<ItemsController>().customers.firstWhere(
          (c) => c.hexId == widget.receitModel.customerId,
        );
      } catch (_) {}
    }

    if (_customer == null) {
      setState(() => _isLoadingCustomer = true);
      try {
        final response = await Net.get(
          "/cashier/customer/${widget.receitModel.customerId}",
        );
        if (!response.hasError && response.body['customer'] != null) {
          _customer = CustomerModel.fromJson(response.body['customer']);
        }
      } catch (_) {}
      if (mounted) setState(() => _isLoadingCustomer = false);
    } else {
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;
    final company = _effectiveCompany;
    final hasServerReceiptId = widget.receitModel.hexId.trim().isNotEmpty;
    final showZimraSubmit = !widget.receitModel.fiscalized &&
        _isZimraDeviceRegistered(company) &&
        (widget.receitModel.synced || hasServerReceiptId);
    final zimraKind = ZimraReceiptDisplay.kindOf(widget.receitModel);
    final docColor = ZimraReceiptDisplay.accentColor(zimraKind);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          ZimraReceiptDisplay.appBarTitle(widget.receitModel),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _printReceit,
            icon: Iconify(Bx.printer, color: AppTheme.color(context)),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Main Receipt Card
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.surface(context),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withAlpha(10)
                          : Colors.grey.withAlpha(25),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Header Section
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: primary.withAlpha(15),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                        child: Column(
                          children: [
                            if (!widget.receitModel.synced)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.red.withAlpha(40),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.cloud_off,
                                      color: Colors.red,
                                      size: 14,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      "Not Synced",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (ZimraReceiptDisplay.isAdjustment(
                              widget.receitModel,
                            )) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: docColor.withAlpha(40),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.description_outlined,
                                        color: docColor, size: 14),
                                    const SizedBox(width: 6),
                                    Text(
                                      ZimraReceiptDisplay.documentTitle(
                                        widget.receitModel,
                                      ).toUpperCase(),
                                      style: TextStyle(
                                        color: docColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 12),
                                  child: FilledButton.tonalIcon(
                                    onPressed: _isLoadingOriginal
                                        ? null
                                        : _openOriginalInvoice,
                                    icon: _isLoadingOriginal
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Icon(Icons.receipt_long,
                                            size: 18),
                                    label: const Text(
                                      "View original fiscal invoice",
                                    ),
                                  ),
                                ),
                            ],
                            if (widget.receitModel.fiscalized)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.green.withAlpha(40),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.verified,
                                      color: Colors.green,
                                      size: 14,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      "ZIMRA Fiscalized",
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: primary.withAlpha(30),
                                shape: BoxShape.circle,
                              ),
                              child: Iconify(
                                Bx.receipt,
                                color: primary,
                                size: 36,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              CurrenceConverter.getCurrenceFloatInStrings(
                                widget.receitModel.total,
                                _userController.user.value?.baseCurrence ?? '',
                              ),
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                color: widget.receitModel.creditSale
                                    ? Colors.red.shade400
                                    : AppTheme.color(context),
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              ZimraReceiptDisplay.isCreditNote(
                                    widget.receitModel,
                                  )
                                  ? "REFUND (CREDIT NOTE)"
                                  : ZimraReceiptDisplay.isDebitNote(
                                      widget.receitModel,
                                    )
                                  ? "ADDITIONAL CHARGE (DEBIT NOTE)"
                                  : widget.receitModel.creditSale
                                  ? "CREDIT INVOICE"
                                  : "PAID IN FULL",
                              style: TextStyle(
                                color: ZimraReceiptDisplay.isAdjustment(
                                      widget.receitModel,
                                    )
                                    ? docColor
                                    : widget.receitModel.creditSale
                                    ? Colors.red.shade400
                                    : Colors.green,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Metadata Section
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildInfoBlock(
                                  "Cashier",
                                  widget.receitModel.cashier,
                                  Icons.person_outline,
                                ),
                                _buildInfoBlock(
                                  "Date",
                                  MistDateUtils.getInformalShortDate(
                                    widget.receitModel.createdAt,
                                  ),
                                  Icons.calendar_today,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                ),
                              ],
                            ),
                            if (widget.receitModel.fiscalized) ...[
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildInfoBlock(
                                    "Document type",
                                    ZimraReceiptDisplay.documentTitle(
                                      widget.receitModel,
                                    ),
                                    Icons.article_outlined,
                                  ),
                                  _buildInfoBlock(
                                    "Receipt Counter",
                                    "${widget.receitModel.zimraFiscalDayNo ?? ""}/${widget.receitModel.zimraReceiptGlobalNo ?? ""}",
                                    Icons.receipt_long_outlined,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  _buildInfoBlock(
                                    "Fiscal Device Id",
                                    "${widget.receitModel.zimraDeviceId ?? ""}",
                                    Icons.devices_outlined,
                                  ),
                                ],
                              ),
                            ],
                            if (_customer != null || _isLoadingCustomer) ...[
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (_customer != null)
                                    _buildInfoBlock(
                                      "Customer",
                                      _customer!.fullName,
                                      Icons.person,
                                    )
                                  else if (_isLoadingCustomer)
                                    const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  const SizedBox(), // Empty spacer to keep layout balanced
                                ],
                              ),
                            ],
                            const SizedBox(height: 24),
                            _buildDashedDivider(isDark),
                            const SizedBox(height: 24),

                            // Items List
                            ...widget.receitModel.items.map((e) {
                              double totalPrice =
                                  (e.price + e.addenum) * e.count;
                              if (e.discountId != null &&
                                  e.discountId!.isNotEmpty) {
                                if (e.percentageDiscount) {
                                  totalPrice =
                                      totalPrice * (1 - e.discount / 100);
                                } else {
                                  totalPrice = totalPrice - e.discount;
                                }
                              }
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (e.refunded)
                                      const Padding(
                                        padding: EdgeInsets.only(
                                          right: 12,
                                          top: 2,
                                        ),
                                        child: Iconify(
                                          Bx.refresh,
                                          color: Colors.red,
                                          size: 18,
                                        ),
                                      ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            e.name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              decoration: e.refunded
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                              color: e.refunded
                                                  ? Colors.red.shade400
                                                  : AppTheme.color(context),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Text(
                                                "${e.count} x ${CurrenceConverter.getCurrenceFloatInStrings(e.price + e.addenum, _userController.user.value?.baseCurrence ?? '')}",
                                                style: TextStyle(
                                                  color: Colors.grey.shade500,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              if (e.refunded)
                                                Text(
                                                  "  (Ref: ${e.originalCount} -> ${e.count})",
                                                  style: TextStyle(
                                                    color: Colors.red.shade300,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                            ],
                                          ),
                                          if (e.discountId != null &&
                                              e.discountId!.isNotEmpty)
                                            Container(
                                              margin: const EdgeInsets.only(
                                                top: 4,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.orange.withAlpha(
                                                  30,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                e.percentageDiscount
                                                    ? "Discount: ${e.discount}% off"
                                                    : "Discount: \$${CurrenceConverter.getCurrenceFloatInStrings(e.discount, _userController.user.value?.baseCurrence ?? '')}",
                                                style: TextStyle(
                                                  color: Colors.orange.shade700,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      CurrenceConverter.getCurrenceFloatInStrings(
                                        totalPrice,
                                        _userController
                                                .user
                                                .value
                                                ?.baseCurrence ??
                                            '',
                                      ),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: AppTheme.color(context),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),

                            const SizedBox(height: 8),
                            _buildDashedDivider(isDark),
                            const SizedBox(height: 24),

                            // Financial Summary
                            if (widget.receitModel.discounts.isNotEmpty) ...[
                              ...widget.receitModel.discounts.map(
                                (e) => _buildSummaryRow(
                                  e.name ?? "Discount",
                                  (e.percentageDiscount == true)
                                      ? "-${e.discount}%"
                                      : "-\$${CurrenceConverter.getCurrenceFloatInStrings(e.discount ?? 0, _userController.user.value?.baseCurrence ?? '')}",
                                  accentColor: Colors.orange.shade600,
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                            if (widget.receitModel.miniTax.isNotEmpty) ...[
                              ...widget.receitModel.miniTax.map(
                                (e) => _buildSummaryRow(e.label, "${e.value}%"),
                              ),
                              const SizedBox(height: 8),
                            ],

                            _buildSummaryRow(
                              "Total",
                              CurrenceConverter.getCurrenceFloatInStrings(
                                widget.receitModel.total,
                                _userController.user.value?.baseCurrence ?? '',
                              ),
                              isBold: true,
                              isLarge: true,
                            ),
                            const SizedBox(height: 16),

                            // Payment Status Block
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: widget.receitModel.creditSale
                                    ? Colors.red.withAlpha(15)
                                    : Colors.green.withAlpha(15),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: widget.receitModel.creditSale
                                      ? Colors.red.withAlpha(30)
                                      : Colors.green.withAlpha(30),
                                ),
                              ),
                              child: Column(
                                children: [
                                  if (widget.receitModel.creditSale) ...[
                                    _buildSummaryRow(
                                      "Paid via Deposits",
                                      CurrenceConverter.getCurrenceFloatInStrings(
                                        widget.receitModel.currentAmountPayed,
                                        _userController
                                                .user
                                                .value
                                                ?.baseCurrence ??
                                            '',
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Divider(height: 1),
                                    ),
                                    _buildSummaryRow(
                                      "Remaining Balance",
                                      CurrenceConverter.getCurrenceFloatInStrings(
                                        (widget.receitModel.total -
                                                widget
                                                    .receitModel
                                                    .currentAmountPayed)
                                            .clamp(0.0, double.infinity),
                                        _userController
                                                .user
                                                .value
                                                ?.baseCurrence ??
                                            '',
                                      ),
                                      isBold: true,
                                      isLarge: true,
                                      accentColor: Colors.red.shade600,
                                    ),
                                  ] else ...[
                                    _buildSummaryRow(
                                      "Amount Tendered",
                                      CurrenceConverter.getCurrenceFloatInStrings(
                                        widget.receitModel.amount,
                                        _userController
                                                .user
                                                .value
                                                ?.baseCurrence ??
                                            '',
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Divider(height: 1),
                                    ),
                                    _buildSummaryRow(
                                      "Change Given",
                                      CurrenceConverter.getCurrenceFloatInStrings(
                                        (widget.receitModel.amount -
                                                widget.receitModel.total)
                                            .clamp(0.0, double.infinity),
                                        _userController
                                                .user
                                                .value
                                                ?.baseCurrence ??
                                            '',
                                      ),
                                      isBold: true,
                                      isLarge: true,
                                      accentColor: Colors.green.shade600,
                                    ),
                                  ],
                                ],
                              ),
                            ),

                            if (company?.zimraQrFiscilization == true &&
                                widget.receitModel.fiscalized &&
                                widget.receitModel.zimraReceiptGlobalNo !=
                                    null &&
                                (widget.receitModel.zimraSignature?.isNotEmpty ??
                                    false)) ...[
                              const SizedBox(height: 24),
                              _buildDashedDivider(isDark),
                              const SizedBox(height: 24),
                              Center(
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: QrImageView(
                                        data: ZimraHelper.generateQrUrl(
                                          widget.receitModel,
                                          isTest:
                                              Get.find<InventoryController>()
                                                  .company
                                                  .value
                                                  ?.zimraIsTest ??
                                              true,
                                          qrUrlFromConfig: _zimraQrUrlFromCompany,
                                        ),
                                        version: QrVersions.auto,
                                        size: 150.0,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    if (widget.receitModel.zimraSignature !=
                                        null)
                                      Text(
                                        "Verification code:\n${ZimraHelper.extractVerificationCode(widget.receitModel.zimraSignature!)}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.color(context),
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "You can verify this receipt manually at\n${ZimraHelper.manualZimraUrl}",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade500,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],

                            const SizedBox(height: 24),

                            // Bottom Action Buttons
                            if (showZimraSubmit &&
                                company != null &&
                                !company.isZimraSubscriptionActive)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  "If submit fails, refresh company in Settings → ZIMRA and confirm fiscalization subscription is active.",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            if (showZimraSubmit)
                              SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: ElevatedButton.icon(
                                    onPressed: _isFiscalizing
                                        ? null
                                        : _fiscalizeReceipt,
                                    icon: _isFiscalizing
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.cloud_upload_rounded,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                    label: Text(
                                      _isFiscalizing
                                          ? "Submitting..."
                                          : "Submit to ZIMRA",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      backgroundColor: Colors.green.shade700,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (!widget.receitModel.creditSale &&
                                !ZimraReceiptDisplay.isAdjustment(
                                  widget.receitModel,
                                ))
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () async {
                                    final result = await Get.to(
                                      () => ScreenRefundCart(
                                        receitModel: widget.receitModel,
                                      ),
                                      arguments: widget.receitModel,
                                    );
                                    if (result != null) {
                                      setState(() {
                                        widget.receitModel.items = result.items;
                                        widget.receitModel.total = result.total;
                                        widget.receitModel.amount =
                                            result.amount;
                                      });
                                    }
                                  },
                                  icon: const Iconify(
                                    Bx.recycle,
                                    color: Colors.red,
                                    size: 18,
                                  ),
                                  label: const Text("Process Refund"),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    foregroundColor: Colors.red,
                                    side: BorderSide(
                                      color: Colors.red.withAlpha(50),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ),
                            if (widget.receitModel.fiscalized &&
                                !ZimraReceiptDisplay.isAdjustment(
                                  widget.receitModel,
                                ) &&
                                !widget.receitModel.creditSale)
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: _showDebitNoteDialog,
                                    icon: Icon(Icons.add_circle_outline,
                                        color: Colors.indigo.shade700, size: 18),
                                    label: const Text("Issue debit note (ZIMRA)"),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      foregroundColor: Colors.indigo.shade700,
                                      side: BorderSide(
                                        color: Colors.indigo.withAlpha(80),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (widget.receitModel.creditSale)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final result = await Get.to(
                                      () => ScreenCreditPayment(
                                        receitModel: widget.receitModel,
                                      ),
                                      arguments: widget.receitModel,
                                    );
                                    if (result != null) {
                                      setState(() {
                                        widget.receitModel.creditSale =
                                            result.creditSale;
                                        widget.receitModel.total = result.total;
                                        widget.receitModel.currentAmountPayed =
                                            result.currentAmountPayed;
                                      });
                                    }
                                  },
                                  icon: const Iconify(
                                    Bx.coin,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  label: const Text(
                                    "Make Payment",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    backgroundColor: primary,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBlock(
    String label,
    String value,
    IconData icon, {
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (crossAxisAlignment == CrossAxisAlignment.start) ...[
          Icon(icon, size: 16, color: Colors.grey.shade400),
          const SizedBox(width: 8),
        ],
        Column(
          crossAxisAlignment: crossAxisAlignment,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppTheme.color(context),
              ),
            ),
          ],
        ),
        if (crossAxisAlignment == CrossAxisAlignment.end) ...[
          const SizedBox(width: 8),
          Icon(icon, size: 16, color: Colors.grey.shade400),
        ],
      ],
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isBold = false,
    bool isLarge = false,
    Color? accentColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isLarge ? 16 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: accentColor ?? Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isLarge ? 18 : 15,
              fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
              color: accentColor ?? AppTheme.color(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashedDivider(bool isDark) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 6.0;
        const dashHeight = 1.5;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withAlpha(30)
                      : Colors.black.withAlpha(20),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Future<void> _openOriginalInvoice() async {
    setState(() => _isLoadingOriginal = true);
    ItemReceitModel? original;
    try {
      var id = widget.receitModel.originalReceiptId?.trim();
      final isar = IsarStatic.getInstance();

      if (id != null && id.isNotEmpty) {
        if (isar != null) {
          original =
              isar.itemReceitModels.where().hexIdEqualTo(id).findFirst();
        }
        if (original == null && Get.isRegistered<ItemsController>()) {
          for (final r in Get.find<ItemsController>().receits) {
            if (r.hexId == id) {
              original = r;
              break;
            }
          }
        }
        if (original == null) {
          final response = await Net.get("/cashier/receit/$id");
          if (!response.hasError && response.body?['receipt'] is Map) {
            original = ItemReceitModel.fromJson(
              Map<String, dynamic>.from(response.body['receipt'] as Map),
            );
          } else if (response.hasError) {
            Toaster.showError(
              response.body?['error']?.toString() ?? response.response,
            );
          }
        }
      }

      if (original == null) {
        final parentLabel = _parentInvoiceLabelFromAdjustment();
        if (parentLabel != null && parentLabel.isNotEmpty) {
          original = await _fetchReceiptByLabel(parentLabel);
        }
      }

      if (original != null && isar != null) {
        await isar.write((isar) async {
          isar.itemReceitModels.put(original!);
        });
      }
    } finally {
      if (mounted) setState(() => _isLoadingOriginal = false);
    }

    if (original == null) {
      Toaster.showError(
        "Could not find the original invoice. Pull to refresh Sales, then try again.",
      );
      return;
    }
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ScreenReceitView(receitModel: original!),
      ),
    );
  }

  Future<void> _showDebitNoteDialog() async {
    if (widget.receitModel.hexId.isEmpty) {
      Toaster.showError("Sync this receipt before issuing a debit note.");
      return;
    }
    final amountController = TextEditingController();
    final noteController = TextEditingController(
      text: "Additional charge",
    );
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Issue debit note"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Use when you must charge extra on an already fiscalized invoice (ZIMRA debit note).",
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: "Amount",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Create"),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final amount = double.tryParse(amountController.text.trim());
    if (amount == null || amount <= 0) {
      Toaster.showError("Enter a valid amount greater than zero.");
      return;
    }

    final response = await Net.post(
      "/cashier/debit-note",
      data: {
        "receiptId": widget.receitModel.hexId,
        "amount": amount,
        "note": noteController.text.trim(),
      },
    );
    if (response.hasError) {
      Toaster.showError(
        response.body?['error']?.toString() ?? response.response,
      );
      return;
    }
    final dn = response.body?['debitNote'];
    if (dn is Map && Get.isRegistered<ItemsController>()) {
      final dnModel = ItemReceitModel.fromJson(
        Map<String, dynamic>.from(dn),
      );
      final isar = IsarStatic.getInstance();
      if (isar != null) {
        await isar.write((isar) async {
          isar.itemReceitModels.put(dnModel);
        });
      }
      Get.find<ItemsController>().receits.insert(0, dnModel);
      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => ScreenReceitView(receitModel: dnModel),
        ),
      );
      return;
    }
    Toaster.showSuccess(
      response.body?['message']?.toString() ??
          "Debit note created.",
    );
  }

  void _printReceit() async {
    DevicesController.printReceitToBackround(
      widget.receitModel,
      _userController.user.value!,
      null,
      widget.receitModel.miniTax
          .map(
            (e) => TaxModel(
              label: e.label,
              value: e.value,
              activated: true,
              selectedIds: [],
            ),
          )
          .toList(),
    );
    final baseCurrency = _userController.user.value?.baseCurrence ?? '';
    try {
      await Printing.layoutPdf(
        onLayout: (format) async {
          final pdf = await PdfReceit.generate(
            widget.receitModel,
            baseCurrency,
            _userController.user.value,
            format: format,
          );
          return pdf.save();
        },
        name: 'Receipt_${widget.receitModel.label}',
      );
    } catch (e) {
      Toaster.showError("Failed to generate PDF: $e");
    }
  }

  void _fiscalizeReceipt() async {
    setState(() => _isFiscalizing = true);
    await _refreshCompanyFromServer();
    final company = _effectiveCompany;
    if (company != null && !company.isZimraSubscriptionActive) {
      setState(() => _isFiscalizing = false);
      Toaster.showError(
        "ZIMRA fiscalization subscription is not active on the server. Open Settings → ZIMRA Fiscalization, subscribe or refresh, then try again.",
      );
      return;
    }
    final receiptId = widget.receitModel.hexId.trim();
    if (receiptId.isEmpty) {
      setState(() => _isFiscalizing = false);
      Toaster.showError(
        "This receipt has no server ID yet. Sync or complete checkout online first.",
      );
      return;
    }
    final response = await Net.post(
      "/cashier/fiscalize-receipt",
      data: {"receiptId": receiptId},
    );
    setState(() => _isFiscalizing = false);

    if (!response.hasError) {
      Toaster.showSuccess("Receipt fiscalized successfully");
      final receiptPayload = response.body?['receipt'];
      if (receiptPayload is Map) {
        widget.receitModel.applyZimraFiscalizationFrom(
          Map<String, dynamic>.from(receiptPayload),
        );
        final isar = IsarStatic.getInstance();
        if (isar != null) {
          await isar.write((isar) async {
            isar.itemReceitModels.put(widget.receitModel);
          });
        }
      } else {
        setState(() {
          widget.receitModel.fiscalized = true;
        });
      }
      if (mounted) setState(() {});
      Get.find<ItemsController>().updateUnsyncedReceits();
    } else {
      Toaster.showError("Failed to fiscalize: ${response.response}");
    }
  }
}
