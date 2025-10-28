import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/screens/inventory/screen_select_supplier.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';

class ScreenAddPurchaseOrder extends StatefulWidget {
  const ScreenAddPurchaseOrder({super.key});

  @override
  State<ScreenAddPurchaseOrder> createState() => _ScreenAddPurchaseOrderState();
}

class _ScreenAddPurchaseOrderState extends State<ScreenAddPurchaseOrder> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  final _inventory = Get.find<InventoryController>();
  DateTime? _expectDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "New Purchase Order".text(),
        backgroundColor: Get.theme.colorScheme.primary,
        foregroundColor: Get.theme.colorScheme.onPrimary,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(5),
          children: [
            [
                  "Purchase Order Information".text(
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  14.gapHeight,
                  Obx(
                    () => MistFormInput(
                      enabled: false,
                      validateString: "Supplier  is required",
                      label: "Supplier",
                      icon: Iconify(
                        Bx.abacus,
                        color: Colors.grey.withAlpha(200),
                      ),
                      underLineColor: Colors.grey.withAlpha(200),
                      controller: TextEditingController(
                        text: _inventory.selectedSupplier.value?.name ?? "",
                      ),
                    ).onTap(() => Get.to(() => ScreenSelectSupplier())),
                  ),
                  14.gapHeight,
                  MistFormInput(
                    enabled: false,
                    validateString: "Expected date is required",
                    label: "Expected On",
                    icon: Iconify(
                      Bx.calendar,
                      color: Colors.grey.withAlpha(200),
                    ),
                    underLineColor: Colors.grey.withAlpha(200),
                    controller: TextEditingController(
                      text: _expectDate != null ? _expectDate.toString() : "",
                    ),
                  ).onTap(_pickDate),
                  14.gapHeight,
                  MistFormInput(
                    label: "Notes",
                    icon: Iconify(Bx.note, color: Colors.grey.withAlpha(200)),
                    underLineColor: Colors.grey.withAlpha(200),
                    controller: _notesController,
                  ),
                ]
                .column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                )
                .padding(EdgeInsets.all(12))
                .decoratedBox(
                  decoration: BoxDecoration(
                    color: Get.theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
          ],
        ),
      ).constrained(maxWidth: 600).center(),
    );
  }

  void _saveItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      helpText: 'Select Expected Date',
      cancelText: 'Cancel',
      confirmText: 'OK',
    );

    setState(() {
      _expectDate = pickedDate;
    });
  }
}
