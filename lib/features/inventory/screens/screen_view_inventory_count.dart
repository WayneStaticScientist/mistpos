import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:mistpos/data/models/user_model.dart';
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:mistpos/core/responsive/screen_sizes.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:mistpos/features/settings/screens/modern_layout.dart';
import 'package:mistpos/data/models/inventory_count_model.dart';
import 'package:mistpos/core/widgets/loaders/small_loader.dart';
import 'package:mistpos/features/inventory/controllers/inventory_controller.dart';
import 'package:mistpos/core/widgets/buttons/mist_loaded_icon_button.dart';
import 'package:mistpos/features/inventory/screens/screen_inventory_count.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:mistpos/core/utils/pdfdocuments/pdf_inventory_count.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:mistpos/data/models/inventory_child_count.dart';

class ScreenViewInventoryCount extends StatefulWidget {
  final InventoryCountModel model;
  const ScreenViewInventoryCount({super.key, required this.model});

  @override
  State<ScreenViewInventoryCount> createState() =>
      _ScreenViewInventoryCountState();
}

class _ScreenViewInventoryCountState extends State<ScreenViewInventoryCount> {
  final _inventory = Get.find<InventoryController>();
  final _userController = Get.find<UserController>();

  void _printDocument() async {
    Toaster.showSuccess("Preparing document, please wait...");
    final baseCurrency = _userController.user.value?.baseCurrence ?? '';
    
    final itemsList = widget.model.status.toLowerCase() == "pending"
        ? List<InventoryChildCount>.from(_inventory.inventoryCountItems)
        : widget.model.inventoryItems;

    final tempModel = InventoryCountModel(
      id: widget.model.id,
      notes: widget.model.notes,
      status: widget.model.status,
      company: widget.model.company,
      senderId: widget.model.senderId,
      totalDifference: widget.model.status.toLowerCase() == "pending"
          ? _inventory.inventoryCountItems
              .map((e) => e.difference)
              .fold(0.0, (val, el) => val + el)
          : widget.model.totalDifference,
      countBasedOn: widget.model.countBasedOn,
      inventoryItems: itemsList,
      totalCostDifference: widget.model.status.toLowerCase() == "pending"
          ? _inventory.inventoryCountItems
              .map((e) => e.costDifference)
              .fold(0.0, (val, el) => val + el)
          : widget.model.totalCostDifference,
      createdAt: widget.model.createdAt,
      updatedAt: widget.model.updatedAt,
      label: widget.model.label,
    );

    try {
      final pdf = await PdfInventoryCount.generate(
        model: tempModel,
        baseCurrency: baseCurrency,
      );
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: 'Inventory_Count_Report.pdf',
      );
    } catch (e) {
      Toaster.showError("Failed to generate PDF: $e");
    }
  }

  User? sender;
  String _error = "";
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    if (widget.model.status == "pending") {
      _inventory.loadInventoryCountItems(
        widget.model.countBasedOn,
        widget.model.inventoryItems.map((e) => e.id).toList(),
      );
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final response = await _userController.getUserById(widget.model.senderId);
      if (mounted) {
        setState(() {
          sender = response.user;
          _loading = false;
          _error = response.error;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Get.theme.colorScheme.primary,
        title: "Inventory Count Details".text(),
        actions: [
          IconButton(
            icon: const Icon(Icons.print, color: Colors.white),
            onPressed: _printDocument,
            tooltip: "Print to PDF",
          ),
          if (widget.model.status.toLowerCase() == "pending")
            MistLoadIconButton(label: "count", onPressed: _countPage),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        children: [
          _buildHeaderCard(isDark),
          20.gapHeight,
          _buildMetricsGrid(isDark),
          if (widget.model.status.toLowerCase() != "pending") 20.gapHeight,
          _buildSenderCard(isDark),
          20.gapHeight,
          _buildProductInformation(isDark),
        ],
      ).constrained(maxWidth: ScreenSizes.maxWidth).center(),
    );
  }

  Widget _buildStatusBadge(String status, bool isDark) {
    final isPending = status.toLowerCase() == "pending";
    final label = isPending ? "Pending" : "Completed";
    final color = isPending ? Colors.amber[800]! : Colors.green[700]!;
    final bgColor = isPending
        ? Colors.amber.withValues(alpha: isDark ? 0.15 : 0.08)
        : Colors.green.withValues(alpha: isDark ? 0.15 : 0.08);
    final icon = isPending ? Icons.access_time_rounded : Icons.check_circle_outline_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          6.gapWidth,
          label.text(
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Get.theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusBadge(widget.model.status, isDark),
              Icon(
                Icons.inventory_2_outlined,
                size: 20,
                color: Get.theme.colorScheme.primary.withValues(alpha: 0.6),
              ),
            ],
          ),
          16.gapHeight,
          widget.model.label.text(
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          16.gapHeight,
          Divider(
            color: Get.theme.colorScheme.outline.withValues(alpha: 0.1),
            height: 1,
          ),
          16.gapHeight,
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Created".text(
                      style: TextStyle(
                        fontSize: 11,
                        color: Get.theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    4.gapHeight,
                    MistDateUtils.getInformalDate(widget.model.createdAt!).text(
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.model.status.toLowerCase() != 'pending')
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      "Completed".text(
                        style: TextStyle(
                          fontSize: 11,
                          color: Get.theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      4.gapHeight,
                      MistDateUtils.getInformalDate(widget.model.updatedAt!).text(
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(bool isDark) {
    if (widget.model.status.toLowerCase() == "pending") return const SizedBox.shrink();

    final costDiff = widget.model.inventoryItems
        .map((e) => e.costDifference)
        .fold(0.0, (val, el) => val + el);
        
    final costColor = costDiff >= 0 ? Colors.green : Colors.red;
    final costBgColor = costColor.withValues(alpha: isDark ? 0.12 : 0.06);

    final itemDiff = widget.model.inventoryItems
        .map((e) => e.difference)
        .fold(0.0, (val, el) => val + el);
        
    final itemColor = itemDiff >= 0 ? Colors.green : Colors.red;
    final itemBgColor = itemColor.withValues(alpha: isDark ? 0.12 : 0.06);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double cardWidth = (constraints.maxWidth - 16) / 2;
        return Row(
          children: [
            SizedBox(
              width: cardWidth,
              height: 100,
              child: _buildMetricCard(
                title: "Cost Difference",
                value: CurrenceConverter.getCurrenceFloatInStrings(
                  costDiff,
                  _userController.user.value?.baseCurrence ?? '',
                ),
                icon: Bx.dollar,
                color: costColor,
                bgColor: costBgColor,
              ),
            ),
            16.gapWidth,
            SizedBox(
              width: cardWidth,
              height: 100,
              child: _buildMetricCard(
                title: "Item Difference",
                value: itemDiff > 0 ? "+$itemDiff" : "$itemDiff",
                icon: Bx.adjust,
                color: itemColor,
                bgColor: itemBgColor,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Get.theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              title.text(
                style: TextStyle(
                  fontSize: 12,
                  color: Get.theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Iconify(icon, color: color, size: 16),
              ),
            ],
          ),
          value.text(
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSenderCard(bool isDark) {
    if (_loading) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Get.theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
        child: const Center(child: MistLoader1()),
      );
    }

    if (_error.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.red.withValues(alpha: 0.2),
          ),
        ),
        child: "Error loading sender details".text(
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (sender == null) return const SizedBox.shrink();

    final initials = sender!.fullName.isNotEmpty
        ? sender!.fullName.trim().split(' ').where((e) => e.isNotEmpty).map((e) => e[0]).take(2).join().toUpperCase()
        : "?";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Get.theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          "Counted By".text(
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Get.theme.colorScheme.onSurface.withValues(alpha: 0.5),
              letterSpacing: 0.5,
            ),
          ),
          12.gapHeight,
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Get.theme.colorScheme.primary.withValues(alpha: 0.1),
                child: initials.text(
                  style: TextStyle(
                    color: Get.theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              12.gapWidth,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sender!.fullName.text(
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    2.gapHeight,
                    Row(
                      children: [
                        Iconify(Bx.envelope, size: 12, color: Get.theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                        6.gapWidth,
                        Expanded(
                          child: sender!.email.text(
                            style: TextStyle(
                              fontSize: 11,
                              color: Get.theme.colorScheme.onSurface.withValues(alpha: 0.6),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: sender!.role.toUpperCase().text(
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Get.theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductInformation(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Get.theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              "Items Information".text(
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Obx(() {
                final count = _inventory.inventoryCountItems.length;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Get.theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: "$count items".text(
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Get.theme.colorScheme.primary,
                    ),
                  ),
                );
              }),
            ],
          ),
          16.gapHeight,
          Obx(
            () => MistLoader1().visibleIf(
              _inventory.loadingInventoryCountItems.value,
            ),
          ),
          "There was error fetching items : ${_inventory.inventoryCountItemsError.value}"
              .text(style: const TextStyle(color: Colors.red))
              .visibleIf(_inventory.inventoryCountItemsError.isNotEmpty),
          Obx(
            () => "No items"
                .text(style: const TextStyle(color: Colors.red))
                .visibleIf(
                  _inventory.inventoryCountItems.isEmpty &&
                      !_inventory.inventoryCountItemsError.isNotEmpty &&
                      !_inventory.inventoryCountsLoading.value &&
                      widget.model.status == "pending",
                ),
          ),
          Obx(() {
            if (_inventory.loadingInventoryCountItems.value) return const SizedBox.shrink();
            return Column(
              children: _inventory.inventoryCountItems.map((e) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Get.theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Get.theme.colorScheme.outline.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Get.theme.colorScheme.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.inventory_2_outlined, color: Get.theme.colorScheme.primary, size: 18),
                      ),
                      12.gapWidth,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            e.name.text(
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            4.gapHeight,
                            "Expected: ${e.count}".text(
                              style: TextStyle(
                                fontSize: 11,
                                color: Get.theme.colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      CurrenceConverter.getCurrenceFloatInStrings(
                        e.cost,
                        _userController.user.value?.baseCurrence ?? '',
                      ).text(
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }).visibleIf(widget.model.status == "pending"),
          if (widget.model.status == "completed") _makeTable(),
        ],
      ),
    );
  }

  Future<void> _countPage() async {
    final result = await Get.to(
      () => ScreenInventoryCount(model: widget.model),
    );
    if (result == null) return;
    setState(() {
      widget.model.inventoryItems = result.inventoryItems;
      widget.model.status = result.status;
      widget.model.updatedAt = result.updatedAt;
    });
  }

  Widget _makeTable() {
    final isDark = Get.isDarkMode;
    final rowBgColor = WidgetStateProperty.resolveWith<Color?>((states) {
      return null;
    });

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Get.theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: ScreenSizes.maxWidth - 64),
          child: DataTable(
            columnSpacing: 16,
            horizontalMargin: 16,
            headingRowColor: WidgetStateProperty.all(
              Get.theme.colorScheme.primary.withValues(alpha: 0.06),
            ),
            dataRowColor: rowBgColor,
            headingTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Get.theme.colorScheme.onSurface,
              fontSize: 13,
            ),
            columns: const [
              DataColumn(label: Text('Item Name')),
              DataColumn(label: Text('Expected')),
              DataColumn(label: Text('Counted')),
              DataColumn(label: Text('Diff')),
              DataColumn(label: Text('Cost'), numeric: true),
              DataColumn(label: Text('Cost Diff'), numeric: true),
            ],
            rows: widget.model.inventoryItems
                .map(
                  (e) {
                    final diffColor = e.difference == 0
                        ? Get.theme.colorScheme.onSurface
                        : (e.difference > 0 ? Colors.green : Colors.red);
                    
                    final costDiffColor = e.costDifference == 0
                        ? Get.theme.colorScheme.onSurface
                        : (e.costDifference > 0 ? Colors.green : Colors.red);

                    return DataRow(
                      cells: <DataCell>[
                        DataCell(
                          e.name.text(
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        DataCell(e.count.toString().text()),
                        DataCell(e.counted.toString().text()),
                        DataCell(
                          (e.difference > 0 ? "+${e.difference}" : "${e.difference}").text(
                            style: TextStyle(color: diffColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataCell(
                          CurrenceConverter.getCurrenceFloatInStrings(
                            e.cost,
                            _userController.user.value?.baseCurrence ?? '',
                          ).text(),
                        ),
                        DataCell(
                          CurrenceConverter.getCurrenceFloatInStrings(
                            e.costDifference,
                            _userController.user.value?.baseCurrence ?? '',
                          ).text(
                            style: TextStyle(color: costDiffColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    );
                  },
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
