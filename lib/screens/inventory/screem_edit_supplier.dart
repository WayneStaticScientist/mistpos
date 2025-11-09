import 'package:country_picker/country_picker.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/models/supplier_model.dart';
import 'package:mistpos/responsive/screen_sizes.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/widgets/buttons/mist_form_button.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';

class ScreenEditSupplier extends StatefulWidget {
  final SupplierModel supplierModel;
  const ScreenEditSupplier({super.key, required this.supplierModel});

  @override
  State<ScreenEditSupplier> createState() => _ScreenEditSupplierState();
}

class _ScreenEditSupplierState extends State<ScreenEditSupplier> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  late final _supplierNameController = TextEditingController(
    text: widget.supplierModel.name,
  );
  late final _supplierCityController = TextEditingController(
    text: widget.supplierModel.city,
  );
  late final _supplierNotesController = TextEditingController(
    text: widget.supplierModel.notes,
  );
  late final _supplierEmailController = TextEditingController(
    text: widget.supplierModel.email,
  );
  late final _supplierCountryController = TextEditingController(
    text: widget.supplierModel.country,
  );
  late final _supplierAddress1Controller = TextEditingController(
    text: widget.supplierModel.address1,
  );
  late final _supplierAddress2Controller = TextEditingController(
    text: widget.supplierModel.address2,
  );
  late final _inventoryController = Get.find<InventoryController>();
  late final _supplierPostalCodeController = TextEditingController(
    text: widget.supplierModel.postalCode,
  );
  late final _supplierPhoneNumberController = TextEditingController(
    text: widget.supplierModel.phoneNumber,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.supplierModel.name.text(),
        backgroundColor: Get.theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(5),
          children: [
            [
                  "Supplier Information".text(
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  14.gapHeight,
                  MistFormInput(
                    validateString: "Supplier Name is required",
                    label: "Supplier Name",
                    icon: Iconify(Bx.abacus, color: Colors.grey.withAlpha(200)),
                    underLineColor: Colors.grey.withAlpha(200),
                    controller: _supplierNameController,
                  ),
                  14.gapHeight,
                  MistFormInput(
                    label: "Phone Number",
                    icon: Iconify(Bx.phone, color: Colors.grey.withAlpha(200)),
                    underLineColor: Colors.grey.withAlpha(200),
                    controller: _supplierPhoneNumberController,
                  ),
                  14.gapHeight,
                  MistFormInput(
                    label: "Email",
                    validateString: "Email is required",
                    icon: Iconify(
                      Bx.envelope,
                      color: Colors.grey.withAlpha(200),
                    ),
                    underLineColor: Colors.grey.withAlpha(200),
                    controller: _supplierEmailController,
                  ),

                  14.gapHeight,
                  MistFormInput(
                    label: "Country",
                    enabled: false,
                    validateString: "Country is required",
                    icon: Iconify(Bx.flag, color: Colors.grey.withAlpha(200)),
                    underLineColor: Colors.grey.withAlpha(200),
                    controller: _supplierCountryController,
                  ).onTap(_selectCountry),
                  14.gapHeight,
                  MistFormInput(
                    label: "Address 1",
                    validateString: "Address is required",
                    icon: Iconify(
                      Bx.location_plus,
                      color: Colors.grey.withAlpha(200),
                    ),
                    underLineColor: Colors.grey.withAlpha(200),
                    controller: _supplierAddress1Controller,
                  ),
                  14.gapHeight,
                  MistFormInput(
                    label: "Address 2",
                    icon: Iconify(
                      Bx.location_plus,
                      color: Colors.grey.withAlpha(200),
                    ),
                    underLineColor: Colors.grey.withAlpha(200),
                    controller: _supplierAddress2Controller,
                  ),
                  14.gapHeight,
                  MistFormInput(
                    label: "City",
                    icon: Iconify(
                      Bx.bxs_city,
                      color: Colors.grey.withAlpha(200),
                    ),
                    underLineColor: Colors.grey.withAlpha(200),
                    controller: _supplierCityController,
                  ),
                  14.gapHeight,
                  MistFormInput(
                    label: "Postal Code",
                    icon: Iconify(
                      Bx.code_block,
                      color: Colors.grey.withAlpha(200),
                    ),
                    underLineColor: Colors.grey.withAlpha(200),
                    controller: _supplierPostalCodeController,
                  ),
                  14.gapHeight,
                  MistFormInput(
                    label: "Notes",
                    icon: Iconify(Bx.note, color: Colors.grey.withAlpha(200)),
                    underLineColor: Colors.grey.withAlpha(200),
                    controller: _supplierNotesController,
                  ),
                  24.gapHeight,
                  MistFormButton(
                    label: "Update supplier",
                    isLoading: _isLoading,
                    onTap: _saveItem,
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
      ).constrained(maxWidth: ScreenSizes.maxWidth).center(),
    );
  }

  void _selectCountry() {
    showCountryPicker(
      context: context,
      onSelect: (Country country) {
        setState(() {
          _supplierCountryController.text = country.name;
        });
      },
    );
  }

  void _saveItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    final supplier = SupplierModel(
      name: _supplierNameController.text,
      city: _supplierCityController.text,
      notes: _supplierNotesController.text,
      email: _supplierEmailController.text,
      country: _supplierCountryController.text,
      address1: _supplierAddress1Controller.text,
      address2: _supplierAddress2Controller.text,
      postalCode: _supplierPostalCodeController.text,
      phoneNumber: _supplierPhoneNumberController.text,
    );
    final result = await _inventoryController.updateSupplier(
      supplier.toJson(),
      widget.supplierModel.id ?? '-',
    );
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
    if (result) {
      Get.back();
      Toaster.showSuccess("Supplier updated successfully");
    }
  }
}
