import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:mistpos/core/utils/subscriptions.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:mistpos/core/widgets/loaders/small_loader.dart';
import 'package:mistpos/features/admin/controllers/admin_controller.dart';
import 'package:mistpos/data/models/inventory_history_model.dart';
import 'package:mistpos/features/inventory/controllers/inventory_controller.dart';
import 'package:mistpos/core/widgets/layouts/subscription_alert.dart';
import 'package:mistpos/core/utils/pdfdocuments/pdf_inventory_history.dart';
import 'package:intl/intl.dart';

class NavInventoryHistory extends StatefulWidget {
  const NavInventoryHistory({super.key});

  @override
  State<NavInventoryHistory> createState() => NavInventoryHistoryState();
}

class NavInventoryHistoryState extends State<NavInventoryHistory> {
  final _userController = Get.find<UserController>();
  final _adminController = Get.find<AdminController>();
  final _inventoryController = Get.find<InventoryController>();
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_inventoryController.company.value == null ||
          MistDateUtils.getDaysDifference(
                _inventoryController
                    .company
                    .value!
                    .subscriptionType
                    .validUntil!,
              ) <
              0 ||
          !(MistSubscriptionUtils.proList.contains(
            _inventoryController.company.value!.subscriptionType.type,
          ))) {
        return;
      }
      _inventoryController.getInventoryHistory(_startDate, _endDate, page: 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Obx(() {
      if (_inventoryController.company.value == null ||
          MistDateUtils.getDaysDifference(
                _inventoryController
                    .company
                    .value!
                    .subscriptionType
                    .validUntil!,
              ) <
              0 ||
          !(MistSubscriptionUtils.proList.contains(
            _inventoryController.company.value!.subscriptionType.type,
          ))) {
        return SubscriptionAlert();
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Row: Title and Print Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Inventory History",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Track stock changes and movements",
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode
                              ? Colors.grey[400]
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _inventoryController.inventoryHistory.isEmpty
                      ? null
                      : printDocument,
                  icon: Iconify(Bx.printer, color: AppTheme.color(context)),
                  tooltip: "Print PDF Report",
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Date Range Picker Row
            InkWell(
              onTap: _changeDateRange,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Iconify(Bx.calendar, color: AppTheme.color(context)),
                    const SizedBox(width: 8),
                    Text(
                      (_startDate == null || _endDate == null)
                          ? "All Time"
                          : "From ${MistDateUtils.getInformalShortDate(_startDate!)} - ${(DateUtils.isSameDay(_endDate!, DateTime.now()) ? "Today" : MistDateUtils.getInformalShortDate(_endDate!))}",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Main Content Area
            Expanded(
              child: Obx(() {
                if (_inventoryController.loadingInventoryHistory.value &&
                    _inventoryController.inventoryHistoryPage.value == 1) {
                  return const Center(child: MistLoader1());
                }

                if (_inventoryController.inventoryHistory.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Iconify(Bx.history, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        const Text(
                          "No inventory history found",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Try selecting a different date range",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                // Group items by date
                Map<String, List<InventoryHistoryModel>> grouped = {};
                for (var item in _inventoryController.inventoryHistory) {
                  if (item.createdAt != null) {
                    String formattedDate = DateFormat(
                      'EEEE, d MMMM y',
                    ).format(item.createdAt!);
                    grouped.putIfAbsent(formattedDate, () => []).add(item);
                  }
                }

                return ListView.builder(
                  itemCount: grouped.keys.length + 1,
                  itemBuilder: (context, index) {
                    if (index == grouped.keys.length) {
                      return Obx(() {
                        final currentPage =
                            _inventoryController.inventoryHistoryPage.value;
                        final totalPages = _inventoryController
                            .inventoryHistoryTotalPages
                            .value;
                        final isLoading =
                            _inventoryController.loadingInventoryHistory.value;

                        if (currentPage < totalPages) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: isLoading
                                ? const Center(child: MistLoader1())
                                : TextButton.icon(
                                    onPressed: () {
                                      _inventoryController.getInventoryHistory(
                                        _startDate,
                                        _endDate,
                                        page: currentPage + 1,
                                      );
                                    },
                                    icon: Iconify(
                                      Bx.chevron_down,
                                      color: AppTheme.color(context),
                                    ),
                                    label: Text(
                                      "Load More History",
                                      style: TextStyle(
                                        color: AppTheme.color(context),
                                      ),
                                    ),
                                  ),
                          );
                        }
                        return const SizedBox(height: 24);
                      });
                    }

                    String dateKey = grouped.keys.elementAt(index);
                    List<InventoryHistoryModel> items = grouped[dateKey]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 16.0,
                            bottom: 8.0,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 4,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: AppTheme.color(context),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                dateKey,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...items.map((item) {
                          final change = item.quantityChange ?? 0.0;
                          final isPositive = change > 0;
                          final isZero = change == 0;
                          final displayChange = isZero
                              ? "0"
                              : "${isPositive ? '+' : ''}${change.toStringAsFixed(0)}";

                          Color badgeBg;
                          Color badgeText;
                          if (isPositive) {
                            badgeBg = isDarkMode
                                ? Colors.green[900]!.withOpacity(0.2)
                                : Colors.green[100]!;
                            badgeText = isDarkMode
                                ? Colors.green[300]!
                                : Colors.green[800]!;
                          } else if (isZero) {
                            badgeBg = isDarkMode
                                ? Colors.blue[900]!.withOpacity(0.2)
                                : Colors.blue[100]!;
                            badgeText = isDarkMode
                                ? Colors.blue[300]!
                                : Colors.blue[800]!;
                          } else {
                            badgeBg = isDarkMode
                                ? Colors.red[900]!.withOpacity(0.2)
                                : Colors.red[100]!;
                            badgeText = isDarkMode
                                ? Colors.red[300]!
                                : Colors.red[800]!;
                          }

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6.0),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: isDarkMode
                                    ? Colors.grey[850]!
                                    : Colors.grey[200]!,
                              ),
                            ),
                            color: isDarkMode
                                ? Colors.grey[900]!.withOpacity(0.5)
                                : Colors.white,
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              title: Text(
                                item.itemName ?? '-',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  item.documentType ?? '-',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                  ),
                                ),
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: badgeBg,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  displayChange,
                                  style: TextStyle(
                                    color: badgeText,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    );
                  },
                );
              }),
            ),
          ],
        ),
      );
    });
  }

  void _changeDateRange() async {
    final date = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );
    if (date == null) return;
    setState(() {
      _endDate = date.end;
      _startDate = date.start;
    });
    _inventoryController.getInventoryHistory(_startDate, _endDate, page: 1);
  }

  void printDocument() async {
    final baseCurrency = _userController.user.value?.baseCurrence ?? '';
    try {
      final pdf = await PdfInventoryHistory.generate(
        endDate: _endDate,
        startDate: _startDate,
        baseCurrence: baseCurrency,
        invHistory: _inventoryController.inventoryHistory,
      );
      await Printing.layoutPdf(
        onLayout: (format) async => pdf.save(),
        name: 'Inventory_History_Report.pdf',
      );
    } catch (e) {
      Toaster.showError("Failed to generate PDF: $e");
    }
  }
}
