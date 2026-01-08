import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/controllers/devices_controller.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/utils/date_utils.dart';
import 'package:mistpos/models/shifts_model.dart';
import 'package:mistpos/responsive/screen_sizes.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/screens/basic/modern_layout.dart';

class ScreenShiftView extends StatefulWidget {
  final ShiftsModel shift;
  const ScreenShiftView({super.key, required this.shift});

  @override
  State<ScreenShiftView> createState() => _ScreenShiftViewState();
}

class _ScreenShiftViewState extends State<ScreenShiftView> {
  final _userController = Get.find<UserController>();
  String get baseCurreny => _userController.user.value?.baseCurrence ?? 'USD';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.shift.shiftLabel.text(),
        actions: [
          Obx(
            () => _userController.user.value != null
                ? IconButton(
                    onPressed: () => DevicesController.printShift(
                      widget.shift,
                      _userController.user.value!,
                    ),
                    icon: Iconify(Bx.printer, color: AppTheme.color(context)),
                  )
                : SizedBox(),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          MistMordernLayout(
            label: "Shift",
            children: [
              24.gapHeight,
              "${widget.shift.closeShiftTime.difference(widget.shift.openShiftTime).inHours.toString()} Hours of shift"
                  .text(style: TextStyle(fontSize: 24)),
              [
                "Shift Date : ".text(),
                MistDateUtils.formatNormalDate(
                  widget.shift.openShiftTime,
                ).text(),
              ].row(),
              16.gapHeight,
              [
                "Start Time : ".text(),
                "${widget.shift.openShiftTime.hour.toString().padLeft(2, '0')}:${widget.shift.openShiftTime.minute}"
                    .text(),
              ].row(),
              16.gapHeight,
              [
                "End Time : ".text(),
                "${widget.shift.closeShiftTime.hour.toString().padLeft(2, '0')}:${widget.shift.closeShiftTime.minute}"
                    .text(),
              ].row(),
              32.gapHeight,
              "POS".text(),
              16.gapHeight,

              [
                "Number of Customers:  ".text(),
                "${widget.shift.totalCustomers}".text(),
              ].row(),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: "Amount in Drawer in Open Shift".text(),
                subtitle: CurrenceConverter.getCurrenceFloatInStrings(
                  widget.shift.cashDrawerStart,
                  baseCurreny,
                ).text(style: TextStyle(color: Colors.green)),
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: "Amount in Drawer After Shift".text(),
                subtitle: CurrenceConverter.getCurrenceFloatInStrings(
                  widget.shift.cashDrawerEnd,
                  baseCurreny,
                ).text(style: TextStyle(color: Colors.green)),
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: "Shift Total Sales".text(),
                subtitle: CurrenceConverter.getCurrenceFloatInStrings(
                  widget.shift.totalSales,
                  baseCurreny,
                ).text(style: TextStyle(color: Colors.green)),
              ),
            ],
          ),
        ],
      ).constrained(maxWidth: ScreenSizes.maxWidth).center(),
    );
  }
}
