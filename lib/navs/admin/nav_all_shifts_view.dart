import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/screens/basic/screen_shift_view.dart';
import 'package:mistpos/utils/date_utils.dart';
import 'package:mistpos/models/shifts_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/controllers/admin_controller.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';

class NavAllShiftsView extends StatefulWidget {
  const NavAllShiftsView({super.key});

  @override
  State<NavAllShiftsView> createState() => _NavAllShiftsViewState();
}

class _NavAllShiftsViewState extends State<NavAllShiftsView> {
  final _refreshController = RefreshController();
  final _adminController = Get.find<AdminController>();
  final _userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _adminController.loadAllShifts(page: 1);
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      enablePullUp: true,
      onRefresh: () async {
        await _adminController.loadAllShifts(page: 1);
        _refreshController.refreshCompleted();
        _refreshController.loadComplete();
      },
      onLoading: () async {
        if (_adminController.allShiftsPage.value <
            _adminController.allShiftsTotalPages.value) {
          await _adminController.loadAllShifts(
            page: _adminController.allShiftsPage.value + 1,
          );
          _refreshController.loadComplete();
        } else {
          _refreshController.loadNoData();
        }
      },
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          "System Shift Logs".text(
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          16.gapHeight,
          Obx(() {
            if (_adminController.allShifts.isEmpty &&
                _adminController.loadingAllShifts.value) {
              return MistLoader1().center();
            }
            if (_adminController.allShifts.isEmpty &&
                !_adminController.loadingAllShifts.value) {
              return "No Raw Shift Records Found".text().center().padding(
                EdgeInsets.all(32),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _adminController.allShifts.length,
              itemBuilder: (context, index) {
                return _buildShiftCard(_adminController.allShifts[index]);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildShiftCard(ShiftsModel model) {
    final baseCurrency = _userController.user.value?.baseCurrence ?? '';
    final bool isClosed = model.shiftIsClosed;

    return InkWell(
      onTap: () => Get.to(() => ScreenShiftView(shift: model)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface(context),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Iconify(
                        isClosed ? Bx.lock : Bx.lock_open,
                        color: isClosed ? Colors.grey : Colors.green,
                        size: 20,
                      ),
                      8.gapWidth,
                      Expanded(
                        child: Text(
                          model.shiftLabel.isNotEmpty
                              ? model.shiftLabel
                              : "Standard Shift",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                12.gapWidth,
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isClosed
                        ? Colors.grey.withAlpha(30)
                        : Colors.green.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isClosed ? "CLOSED" : "ACTIVE",
                    style: TextStyle(
                      color: isClosed ? Colors.grey : Colors.green,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            12.gapHeight,
            Divider(color: Colors.grey.withAlpha(40), thickness: 1),
            12.gapHeight,
            Wrap(
              spacing: 24,
              runSpacing: 12,
              children: [
                _buildShiftStat(
                  "Total Sales",
                  CurrenceConverter.getCurrenceFloatInStrings(
                    model.totalSales,
                    baseCurrency,
                  ),
                ),
                _buildShiftStat(
                  "Drawer Start",
                  CurrenceConverter.getCurrenceFloatInStrings(
                    model.cashDrawerStart,
                    baseCurrency,
                  ),
                ),
                if (isClosed)
                  _buildShiftStat(
                    "Drawer End",
                    CurrenceConverter.getCurrenceFloatInStrings(
                      model.cashDrawerEnd,
                      baseCurrency,
                    ),
                  ),
                _buildShiftStat("Items Sold", "${model.salesQuantity}"),
                _buildShiftStat("Customers", "${model.totalCustomers}"),
              ],
            ),
            16.gapHeight,
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.grey),
                6.gapWidth,
                Text(
                  "Opened: ${MistDateUtils.getInformalShortDate(model.openShiftTime)}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                if (isClosed) ...[
                  const Spacer(),
                  Icon(Icons.access_time_filled, size: 14, color: Colors.grey),
                  6.gapWidth,
                  Text(
                    "Closed: ${MistDateUtils.getInformalShortDate(model.closeShiftTime)}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShiftStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        4.gapHeight,
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
