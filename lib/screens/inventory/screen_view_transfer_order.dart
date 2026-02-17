import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/models/user_model.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:mistpos/utils/date_utils.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/responsive/screen_sizes.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/screens/basic/modern_layout.dart';
import 'package:mistpos/models/transfer_order_model.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';

class ScreenViewTransferOrder extends StatefulWidget {
  final TransferOrderModel model;
  const ScreenViewTransferOrder({super.key, required this.model});

  @override
  State<ScreenViewTransferOrder> createState() =>
      _ScreenViewTransferOrderState();
}

class _ScreenViewTransferOrderState extends State<ScreenViewTransferOrder> {
  bool _loading = true;
  String _error = "";
  User? sender;
  final _userController = Get.find<UserController>();
  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Get.theme.colorScheme.primary,
        title: "Transfer Order".text(),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          _buildInventorySummary(),
          24.gapHeight,
          _buildSupplierInformation(),
          24.gapHeight,
          _buildProductInformation(),
        ],
      ).constrained(maxWidth: ScreenSizes.maxWidth).center(),
    );
  }

  MistMordernLayout _buildInventorySummary() {
    return MistMordernLayout(
      label: "Summary",
      children: [
        12.gapHeight,
        widget.model.label.text(style: TextStyle(fontSize: 18)),
        15.gapHeight,

        [
          "Date Created: ".text(style: TextStyle(fontWeight: FontWeight.bold)),
          if (widget.model.createdAt != null)
            MistDateUtils.getInformalDate(widget.model.createdAt!).text(),
        ].row(),
      ],
    );
  }

  DecoratedBox _buildSupplierInformation() {
    return [
          "Sender Information".text(
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          if (_loading) MistLoader1(),
          18.gapHeight,
          if (_error.isNotEmpty)
            "There was error fetching the supplier details ".text(
              style: TextStyle(color: Colors.red),
            ),
          if (sender != null) ...[
            ExpansionTile(
              shape: RoundedRectangleBorder(),
              title: "Sender Info ".text(),
              children: [
                ListTile(
                  title: sender!.fullName.text(),
                  leading: Iconify(Bx.user, color: Colors.white),
                  subtitle: "Name".text(),
                ),
                12.gapHeight,
                ListTile(
                  title: sender!.email.text(),
                  leading: Iconify(Bx.envelope, color: Colors.white),
                  subtitle: "Email".text(),
                ),
                12.gapHeight,
                ListTile(
                  title: sender!.country.text(),
                  leading: Iconify(Bx.flag, color: Colors.white),
                  subtitle: "Country".text(),
                ),

                12.gapHeight,
                ListTile(
                  title: sender!.role.text(),
                  leading: Iconify(Bx.arrow_to_top, color: Colors.white),
                  subtitle: "Role".text(),
                ),
              ],
            ),
          ],
        ]
        .column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
        )
        .padding(EdgeInsets.all(8))
        .decoratedBox(
          decoration: BoxDecoration(color: AppTheme.surface(context)),
        );
  }

  DecoratedBox _buildProductInformation() {
    return [
          "Items Information ".text(
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: Iconify(Bx.check, color: Colors.green),
            title: "It means items are transferred".text(),
          ),
          ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: Iconify(Bx.x, color: Colors.red),
            title: "It means items are not transferred".text(),
          ),
          18.gapHeight,
          _makeTable(),
        ]
        .column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
        )
        .padding(EdgeInsets.all(8))
        .decoratedBox(
          decoration: BoxDecoration(color: AppTheme.surface(context)),
        );
  }

  Widget _makeTable() {
    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: ScreenSizes.maxWidth,
      columns: [
        DataColumn2(label: Text('Item Name'), size: ColumnSize.S), // Has flex
        DataColumn2(label: Text('Stock Quantity'), size: ColumnSize.S),
        DataColumn2(label: Text('Status'), size: ColumnSize.S),
      ],
      rows: widget.model.inventoryItems
          .map(
            (e) => DataRow(
              cells: <DataCell>[
                DataCell(e.name.text()),
                DataCell(e.quantity.toString().text()),
                DataCell(
                  e.updated
                      ? Iconify(Bx.check, color: Colors.green)
                      : Iconify(Bx.x, color: Colors.red),
                ),
              ],
            ),
          )
          .toList(),
    ).constrained(maxWidth: ScreenSizes.maxWidth, maxHeight: 10000);
  }
}
