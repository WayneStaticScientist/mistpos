import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/screens/basic/screen_refund_cart.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/models/item_receit_model.dart';

class ScreenReceitView extends StatefulWidget {
  final ItemReceitModel receitModel;
  const ScreenReceitView({super.key, required this.receitModel});
  @override
  State<ScreenReceitView> createState() => _ScreenReceitViewState();
}

class _ScreenReceitViewState extends State<ScreenReceitView> {
  final _userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Receit ${widget.receitModel.id}"),
        actions: [
          "refund".text().textIconButton(
            onPressed: () => Get.off(
              () => ScreenRefundCart(receitModel: widget.receitModel),
            ),
            icon: Iconify(Bx.recycle, color: Colors.red),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: [
            CurrenceConverter.getCurrenceFloatInStrings(
              widget.receitModel.total,
              _userController.user.value?.baseCurrence ?? '',
            ).text(style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            "Total".text(),
            18.gapHeight,
            Divider(color: Colors.grey, thickness: 1),
            [
                  18.gapHeight,
                  ListTile(
                    title: "Employee : ${widget.receitModel.cashier}".text(),
                    subtitle: "POS : pos 1".text(),
                  ),

                  18.gapHeight,
                  Divider(color: Colors.grey, thickness: 1),
                  18.gapHeight,
                  ...widget.receitModel.items.map(
                    (e) => ListTile(
                      subtitle:
                          "${e.count.toString()} x ${CurrenceConverter.getCurrenceFloatInStrings(e.price + e.addenum, _userController.user.value?.baseCurrence ?? '')}"
                              .text(),
                      title: e.name.text(),
                      tileColor: e.refunded ? Colors.red.withAlpha(100) : null,
                      trailing: CurrenceConverter.getCurrenceFloatInStrings(
                        (e.price + e.addenum) * e.count,
                        _userController.user.value?.baseCurrence ?? '',
                      ).text(),
                    ),
                  ),
                  18.gapHeight,
                  Divider(color: Colors.grey, thickness: 1),
                  18.gapHeight,
                  ListTile(
                    title: 'Total'.text(),
                    trailing: CurrenceConverter.getCurrenceFloatInStrings(
                      widget.receitModel.total,
                      _userController.user.value?.baseCurrence ?? '',
                    ).text(),
                  ),
                  ListTile(
                    title: widget.receitModel.payment.text(),
                    trailing: CurrenceConverter.getCurrenceFloatInStrings(
                      widget.receitModel.amount,
                      _userController.user.value?.baseCurrence ?? '',
                    ).text(),
                  ),
                  ListTile(
                    title: 'Change'.text(),
                    tileColor: Colors.green,
                    textColor: Colors.white,
                    trailing: CurrenceConverter.getCurrenceFloatInStrings(
                      widget.receitModel.amount - widget.receitModel.total,
                      _userController.user.value?.baseCurrence ?? '',
                    ).text(style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  18.gapHeight,
                ]
                .column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                )
                .sizedBox(width: double.infinity),
          ].column(crossAxisAlignment: CrossAxisAlignment.center),
        ),
      ).padding(EdgeInsets.all(20)),
    );
  }
}
