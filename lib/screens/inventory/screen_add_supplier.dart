import 'package:country_picker/country_picker.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/models/supplier_model.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/widgets/buttons/mist_form_button.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';

class ScreenAddSupplier extends StatefulWidget {
  const ScreenAddSupplier({super.key});

  @override
  State<ScreenAddSupplier> createState() => _ScreenAddSupplierState();
}

class _ScreenAddSupplierState extends State<ScreenAddSupplier> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _supplierNameController = TextEditingController();
  final _supplierCityController = TextEditingController();
  final _supplierNotesController = TextEditingController();
  final _supplierEmailController = TextEditingController();
  final _supplierCountryController = TextEditingController();
  final _supplierAddress1Controller = TextEditingController();
  final _supplierAddress2Controller = TextEditingController();
  final _inventoryController = Get.find<InventoryController>();
  final _supplierPostalCodeController = TextEditingController();
  final _supplierPhoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "New Supplier".text(),
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
                    label: "Add supplier",
                    icon: Icon(Icons.plus_one),
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
      ).constrained(maxWidth: 600).center(),
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
    final result = await _inventoryController.addSupplier(supplier.toJson());
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
    if (result) {
      Get.back();
      Toaster.showSuccess("Supplier added successfully");
    }
  }
}
