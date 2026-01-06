import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/utils/date_utils.dart';
import 'package:mistpos/models/shifts_model.dart';
import 'package:mistpos/responsive/screen_sizes.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/screens/basic/modern_layout.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/screens/basic/screen_shift_view.dart';
import 'package:mistpos/widgets/buttons/mist_form_button.dart';

class ScreenShiftsScreen extends StatefulWidget {
  const ScreenShiftsScreen({super.key});

  @override
  State<ScreenShiftsScreen> createState() => _ScreenShiftsScreenState();
}

class _ScreenShiftsScreenState extends State<ScreenShiftsScreen> {
  final _itemsListController = Get.find<ItemsController>();
  final _userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((time) {
      _itemsListController.loadShifts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: "Shifts".text()),
      body:
          [
                Obx(
                  () => _itemsListController.selectedShift.value == null
                      ? MistMordernLayout(
                              label: "No shifts open",
                              children: [
                                18.gapHeight,
                                "Shifts closed".text(
                                  style: TextStyle(color: Colors.red),
                                ),
                                18.gapHeight,
                                MistFormButton(
                                  label: "Open Shift",
                                  onTap: _initiateAlertShift,
                                ),
                              ],
                            )
                            .sizedBox(width: double.infinity)
                            .visibleIf(
                              _itemsListController.selectedShift.value == null,
                            )
                      : MistMordernLayout(
                              label: "Current Shift",
                              children: [
                                18.gapHeight,
                                [
                                  "Date: ".text(),
                                  MistDateUtils.getInformalShortDate(
                                    _itemsListController
                                        .selectedShift
                                        .value!
                                        .openShiftTime,
                                  ).text(),
                                  12.gapHeight,
                                ].row(),
                                [
                                  "Start Time: ".text(),
                                  "${_itemsListController.selectedShift.value!.openShiftTime.hour.toString().padLeft(2, '0')}:${_itemsListController.selectedShift.value!.openShiftTime.minute}"
                                      .text(),
                                ].row(),
                                18.gapHeight,
                                MistFormButton(
                                  label: "Close Shift",
                                  onTap: _closeShift,
                                  fillColor: Colors.red,
                                ),
                              ],
                            )
                            .sizedBox(width: double.infinity)
                            .visibleIf(
                              _itemsListController.selectedShift.value != null,
                            ),
                ),
                14.gapHeight,
                ["Other shifts".text()].row(),
                Expanded(
                  child: Obx(
                    () => ListView.builder(
                      itemBuilder: (context, index) =>
                          _buildShift(_itemsListController.shifts[index]),
                      itemCount: _itemsListController.shifts.length,
                    ),
                  ),
                ),
              ]
              .column()
              .padding(EdgeInsets.all(14))
              .sizedBox(width: ScreenSizes.maxWidth)
              .center(),
    );
  }

  void _initiateAlertShift() {
    final shiftAmount = TextEditingController();
    if (_itemsListController.selectedShift.value != null) {
      Toaster.showError("shift already opened");
      return;
    }
    if (_userController.user.value == null) {
      Toaster.showError("User underegister");
      return;
    }
    Get.defaultDialog(
      title: "Open Shift",
      content:
          [
            "Specify Amount in drawer at start of shift".text(
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            8.gapHeight,
            MistFormInput(
              label: "Amount in drawer",
              controller: shiftAmount,
              icon: (_userController.user.value?.baseCurrence ?? 'USD').text(
                style: TextStyle(fontSize: 8, color: Colors.grey),
              ),
            ),
          ].column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
      actions: [
        "Cancel".text().textButton(onPressed: () => Get.back()),
        "open".text().textButton(
          onPressed: () {
            final amount = double.tryParse(shiftAmount.text);
            if (amount == null || amount < 0) {
              Toaster.showError("invalid number");
              return;
            }
            Get.back();
            Toaster.showSuccess("shift opened");
            _itemsListController.openShift(amount, _userController.user.value!);
          },
        ),
      ],
    );
  }

  Widget _buildShift(ShiftsModel shift) {
    return ListTile(
      onTap: () {
        if (!shift.shiftIsClosed) {
          Toaster.showError("shift is still open");
        }
        Get.to(() => ScreenShiftView(shift: shift));
      },
      trailing: !shift.synced
          ? Iconify(Bx.bx_time, color: AppTheme.color(context))
          : Iconify(Bx.check_double, color: Colors.green),
      contentPadding: EdgeInsets.all(0),
      leading: Iconify(Bx.time, color: Get.theme.colorScheme.primary),
      title: shift.shiftLabel.text(),
      subtitle: shift.shiftIsClosed
          ? "Opened ${MistDateUtils.getInformalShortDate(shift.openShiftTime)}"
                .text()
          : "Shift is still open".text(style: TextStyle(color: Colors.red)),
    );
  }

  _closeShift() {
    if (_itemsListController.selectedShift.value == null) {
      Toaster.showError("no shift selected");
      return;
    }
    final closeTime = DateTime.now();
    final cashDrawerAmount = TextEditingController();
    Get.defaultDialog(
      title: "Close shift",
      content: [
        "Close shift at ${closeTime.hour.toString().padLeft(2, '0')}:${closeTime.minute} "
            .text(),
        MistFormInput(
          label: "Amount in cash drawer",
          controller: cashDrawerAmount,
        ),
      ].column(),
      cancel: "Cancel".text().textButton(onPressed: () => Get.back()),
      confirm: "Close".text().textButton(
        onPressed: () {
          final amount = double.tryParse(cashDrawerAmount.text);
          if (amount == null || amount < 0) {
            Toaster.showError("invalid number");
            return;
          }
          Get.back();
          _itemsListController.closeShift(amount, _userController.user.value!);
          Toaster.showSuccess("shift closed");
        },
      ),
    );
  }
}
