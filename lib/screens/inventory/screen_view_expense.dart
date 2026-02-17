import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/utils/date_utils.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/models/expense_model.dart';
import 'package:mistpos/responsive/screen_sizes.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/screens/basic/modern_layout.dart';
import 'package:mistpos/controllers/expenses_controller.dart';
import 'package:mistpos/widgets/buttons/mist_loaded_icon_button.dart';

class ScreenViewExpense extends StatefulWidget {
  final ExpenseModel model;
  const ScreenViewExpense({super.key, required this.model});

  @override
  State<ScreenViewExpense> createState() => _ScreenViewExpenseState();
}

class _ScreenViewExpenseState extends State<ScreenViewExpense> {
  final _userController = Get.find<UserController>();
  final _expenseController = Get.find<ExpensesController>();
  bool _updatingState = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Get.theme.colorScheme.primary,
        title: "Expense Details".text(),
        actions: [
          if (widget.model.status.toLowerCase() == "pending") ...[
            MistLoadIconButton(
              label: "Reject",
              isLoading: _updatingState,
              onPressed: () => _updateState("Reject The Order", "declined"),
            ),

            MistLoadIconButton(
              label: "accept",
              onPressed: () => _updateState("Accept Expense", "accepted"),
              isLoading: _updatingState,
            ).visibleIf(widget.model.status.toLowerCase() == "pending"),
          ],
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          _buildProductSummary(),
          24.gapHeight,
          _buildSupplierInformation(),
          24.gapHeight,
          _builtAccepterInformation(),
          24.gapHeight,
          _buildProductInformation(),
        ],
      ).constrained(maxWidth: ScreenSizes.maxWidth).center(),
      floatingActionButton: widget.model.status.toLowerCase() == "draft"
          ? FloatingActionButton(
              onPressed: _editPurchaseOrder,
              child: Icon(Icons.edit, color: Colors.white),
            )
          : null,
    );
  }

  DecoratedBox _buildProductSummary() {
    return [
          "Summary ".text(style: TextStyle(fontWeight: FontWeight.bold)),
          14.gapHeight,
          ListTile(
            contentPadding: EdgeInsets.all(0),
            title: Text(
              widget.model.category['label'] ?? '-=',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            leading: Iconify(Bx.category_alt, color: AppTheme.color(context)),
            subtitle: "Category".text(),
          ),
          14.gapHeight,
          ListTile(
            contentPadding: EdgeInsets.all(0),
            title:
                (widget.model.referenceNumber.isEmpty
                        ? "No refernce "
                        : widget.model.referenceNumber)
                    .text(),
            leading: Iconify(Bx.file, color: AppTheme.color(context)),
            subtitle: "Reference Number".text(),
          ),
          12.gapHeight,
          ListTile(
            contentPadding: EdgeInsets.all(0),
            title: MistDateUtils.formatNormalDate(widget.model.date).text(),
            leading: Iconify(Bx.calendar, color: AppTheme.color(context)),
            subtitle: "Date Of Expense".text(),
          ),

          32.gapHeight,
          [
            Iconify(Bx.category_alt, color: AppTheme.color(context)),
            12.gapWidth,
            "Expense For".text(),
          ].row(),
          12.gapHeight,
          widget.model.expenseFor.text(),
          32.gapHeight,
          [
            Iconify(Bx.note, color: AppTheme.color(context)),
            12.gapWidth,
            "Notes".text(),
          ].row(),
          widget.model.notes.text(),
          32.gapHeight,
          "Status".text(
            style: TextStyle(color: Get.theme.colorScheme.secondary),
          ),
          widget.model.status
              .toUpperCase()
              .text(
                style: TextStyle(
                  color: _getColor(widget.model.status),
                  fontWeight: FontWeight.bold,
                ),
              )
              .textIconButton(
                onPressed: () {},
                icon: _getStatus(widget.model.status),
              ),
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

  MistMordernLayout _buildSupplierInformation() {
    return MistMordernLayout(
      label: "Sender Information",
      children: [
        if (widget.model.senderId != null && widget.model.senderId is Map) ...[
          ListTile(
            title: Text(widget.model.senderId['fullName'] ?? "No Name"),
            leading: Iconify(Bx.user, color: AppTheme.color(context)),
            subtitle: "Name".text(),
          ),
          12.gapHeight,
          ListTile(
            title: Text(widget.model.senderId['email'] ?? "No Email"),
            leading: Iconify(Bx.envelope, color: AppTheme.color(context)),
            subtitle: "Email".text(),
          ),
          12.gapHeight,
          ListTile(
            title: Text(
              (widget.model.senderId['role'] ?? "").toString().toUpperCase(),
            ),
            leading: Iconify(Bx.flag, color: AppTheme.color(context)),
            subtitle: "Role".text(),
          ),
          12.gapHeight,
          ListTile(
            title: Text((widget.model.senderId['till'] ?? 0).toString()),
            leading: Iconify(Bx.building, color: AppTheme.color(context)),
            subtitle: "Till".text(),
          ).visibleIf(widget.model.senderId['role'] == 'cashier'),
        ],
      ],
    );
  }

  Widget _builtAccepterInformation() {
    return MistMordernLayout(
      label: "Accepted By",
      children: [
        if (widget.model.acceptedBy != null &&
            widget.model.acceptedBy is Map) ...[
          ListTile(
            title: Text(widget.model.acceptedBy['fullName'] ?? "No Name"),
            leading: Iconify(Bx.user, color: AppTheme.color(context)),
            subtitle: "Name".text(),
          ),
          12.gapHeight,
          ListTile(
            title: Text(widget.model.acceptedBy['email'] ?? "No Email"),
            leading: Iconify(Bx.envelope, color: AppTheme.color(context)),
            subtitle: "Email".text(),
          ),
          12.gapHeight,
          ListTile(
            title: Text(
              (widget.model.acceptedBy['role'] ?? "").toString().toUpperCase(),
            ),
            leading: Iconify(Bx.flag, color: AppTheme.color(context)),
            subtitle: "Role".text(),
          ),
          12.gapHeight,
          ListTile(
            title: Text((widget.model.acceptedBy['till'] ?? 0).toString()),
            leading: Iconify(Bx.building, color: AppTheme.color(context)),
            subtitle: "Till".text(),
          ).visibleIf(widget.model.acceptedBy['role'] == 'cashier'),
        ],
      ],
    ).visibleIf(
      widget.model.acceptedBy != null && widget.model.acceptedBy is Map,
    );
  }

  MistMordernLayout _buildProductInformation() {
    return MistMordernLayout(
      label: "Cost ",
      children: [
        14.gapHeight,
        Row(
          children: [
            "Total".text(style: TextStyle(fontWeight: FontWeight.bold)),
            14.gapWidth,
            CurrenceConverter.getCurrenceFloatInStrings(
              widget.model.amount,
              _userController.user.value?.baseCurrence ?? '',
            ).text(),
          ],
        ),
      ],
    );
  }

  Widget _getStatus(String status) {
    if (status.toLowerCase() == "pending") {
      return Iconify(Bx.timer, color: Colors.orange, size: 35);
    }
    if (status.toLowerCase() == "declined") {
      return Iconify(Bx.x, color: Colors.red, size: 35);
    }
    if (status.toLowerCase() == "accepted") {
      return Iconify(Bx.check_circle, color: Colors.green, size: 35);
    }
    if (status.toLowerCase() == "partial-received") {
      return Iconify(Bx.time, color: Colors.yellow, size: 35);
    }
    return Iconify(Bx.archive, color: Colors.grey, size: 35);
  }

  Color _getColor(String status) {
    if (status.toLowerCase() == "pending") {
      return Colors.orange;
    }
    if (status.toLowerCase() == "declined") {
      return Colors.red;
    }
    if (status.toLowerCase() == "accepted") {
      return Colors.green;
    }
    if (status.toLowerCase() == "partial-received") {
      return Colors.yellow;
    }
    return Colors.grey;
  }

  void _updateState(String s, String t) {
    Get.defaultDialog(
      title: "Confirm Changes",
      content: s.text(),
      actions: [
        'close'.text().textButton(onPressed: () => Get.back()),
        'confirm'.text().textButton(
          onPressed: () {
            Get.back();
            _changeState(t);
          },
        ),
      ],
    );
  }

  void _changeState(String t) async {
    setState(() {
      _updatingState = true;
    });
    final response = t == "accepted"
        ? await _expenseController.acceptExpense(widget.model.id)
        : await _expenseController.rejectExpense(widget.model.id);
    if (!mounted) return;
    setState(() {
      _updatingState = false;
    });
    if (response) {
      if (t == "accepted") {
        setState(() {
          widget.model.status = "accepted";
        });
      } else {
        Get.back();
      }
      Toaster.showSuccess("Operation is succefully");
    }
  }

  void _editPurchaseOrder() {
    if (widget.model.status == "accepted") {
      Toaster.showError("cant edit already sent inventory object");
      return;
    }
  }
}
